`include "axi.svh"
`include "pixel_pkg.svh"

module img_buf (
  input  wire        clk,
  input  wire        en,

  input  wire [23:0] pdata,   // pixel data and sync signals
  input  wire        pvld,
  input  wire        hsync,
  input  wire        vsync,

  axis_if.master     axis_o   // chunk of pixels out
);

  //****************************************
  // SYNCHRONIZATION SIGNALS
  //
  logic [1:0] ln_sft = '0;
  logic [1:0] fm_sft = '0;

  always_ff @ (posedge clk) ln_sft <= (ln_sft << 1) | hsync;
  always_ff @ (posedge clk) fm_sft <= (fm_sft << 1) | vsync;

  wire ln_sync = ln_sft[1] & (~ln_sft[0]);
  wire fm_sync = fm_sft[1] & (~fm_sft[0]);


  //****************************************
  // RAM SELECT LOGIC
  //
  logic [2:0] ram_sel = 1;    // one hot ram chip select

  // circular shift with each complete line
  always_ff @ (posedge clk) begin
    if (ln_sync)
      ram_sel <= (ram_sel << 1) | ram_sel[2];
  end


  //****************************************
  // RAM WRITE LOGIC
  //
  logic [14:0] waddr = '0;            // bram write address
  wire         we    = pvld & en;     // bram write enable

  always_ff @ (posedge clk) begin
    if      (ln_sync) waddr <= '0;
    else if (we)      waddr <= waddr + 1;
  end


  //****************************************
  // RAM READ LOGIC
  //
  enum {
    IDLE,
    READ
  } rfsm = IDLE, rfsm_d;

  logic [14:0] raddr = '0;            // bram read address

  always_ff @ (posedge clk) raddr <= (rfsm == READ) ? raddr + 1 : '0;

  // read fsm
  always_ff @ (posedge clk) rfsm <= rfsm_d;

  always_comb begin
    case (rfsm)
      IDLE    : rfsm_d = (ram_sel[2] & we) ? READ : IDLE;
      READ    : rfsm_d = (ln_sync)         ? IDLE : READ;
      default : rfsm_d = IDLE;
    endcase
  end

  // BRAM read valid
  logic [1:0] vld_sft = '0;
  wire        vld_rd  = &vld_sft;

  always_ff @ (posedge clk) vld_sft <= (vld_sft << 1) | (rfsm == READ);

  wire [23:0] rdata   [3];    // BRAM read output
  wire [23:0] rdata_v [3];    // valid only BRAM read output

  assign rdata_v[0] = (vld_rd) ? rdata[0] : 'hx;
  assign rdata_v[1] = (vld_rd) ? rdata[1] : 'hx;
  assign rdata_v[2] = (vld_rd) ? rdata[2] : 'hx;

  pixel_pkg::pixel_t pix [3];

  always_comb begin
    int i;
    for (i = 0; i < 3; i++) begin
      pix[i].red = rdata[i][23:16];
      pix[i].grn = rdata[i][15: 8];
      pix[i].blu = rdata[i][ 7: 0];
    end
  end


  //****************************************
  // RAM OUTPUT BUFFER LOGIC
  //
  logic [1:0] col_cnt = '0;

  always_ff @ (posedge clk) begin
    if (rfsm == IDLE) col_cnt <= '0;
    else              col_cnt <= (col_cnt == 2) ? 2 : col_cnt + vld_rd;
  end

  pixel_pkg::chunk_t chunk = '{default : '0};

  // shift 3 new pixels into matrix
  always_ff @ (posedge clk) begin
    int i;
    for (i = 0; i < 3; i++) begin
      if (vld_rd) begin
        chunk[i][2] <= pix[i];
        chunk[i][1] <= chunk[i][2];
        chunk[i][0] <= chunk[i][1];
      end
    end
  end

  axis_if #( .DATA_TYPE (pixel_pkg::chunk_t) ) axis_bram_out ();
  axis_if #( .DATA_TYPE (pixel_pkg::chunk_t) ) axis_fifo_out ();

  always_comb               axis_bram_out.data = chunk;
  always_ff @ (posedge clk) axis_bram_out.vld <= (col_cnt == 2);

  syn_fifo #(
    .DATA_TYPE  (pixel_pkg::chunk_t),
    .FIFO_DEPTH (256)
  ) ram_out_fifo (
    .clk    (clk),
    .rst    (0),
    .full   ( ),
    .empty  ( ),
    .axis_i (axis_bram_out),
    .axis_o (axis_fifo_out)
  );

  always_comb begin
    axis_o.data = axis_fifo_out.data;
    axis_o.vld  = axis_fifo_out.vld;
    axis_fifo_out.rdy = axis_o.rdy;
  end


  //****************************************
  // BRAM INSTANTIATIONS
  //
  blk_mem_gen_0 bram0 (
    .clka  (clk),         // PORT A -- WRITE
    .ena   (ram_sel[0]),  // enable port a with ram select
    .wea   (we),          // shared write enable
    .addra (waddr),       // shared write address
    .dina  (pdata),       // incoming pixel data
    .douta ( ),           // no need for read port

    .clkb  (clk),         // PORT B -- READ
    .enb   (en),          // read port enabled with module
    .web   (0),           // never write on this port
    .addrb (raddr),       // shared read address
    .dinb  (0),           // no need for write data
    .doutb (rdata[0])     // read data out
  );

  blk_mem_gen_0 bram1 (
    .clka  (clk),         // PORT A -- WRITE
    .ena   (ram_sel[1]),  // enable port a with ram select
    .wea   (we),          // shared write enable
    .addra (waddr),       // shared write address
    .dina  (pdata),       // incoming pixel data
    .douta ( ),           // no need for read port

    .clkb  (clk),         // PORT B -- READ
    .enb   (en),          // read port enabled with module
    .web   (0),           // never write on this port
    .addrb (raddr),       // shared read address
    .dinb  (0),           // no need for write data
    .doutb (rdata[1])     // read data out
  );

  blk_mem_gen_0 bram2 (
    .clka  (clk),         // PORT A -- WRITE
    .ena   (ram_sel[2]),  // enable port a with ram select
    .wea   (we),          // shared write enable
    .addra (waddr),       // shared write address
    .dina  (pdata),       // incoming pixel data
    .douta ( ),           // no need for read port

    .clkb  (clk),         // PORT B -- READ
    .enb   (en),          // read port enabled with module
    .web   (0),           // never write on this port
    .addrb (raddr),       // shared read address
    .dinb  (0),           // no need for write data
    .doutb (rdata[2])     // read data out
  );

endmodule
