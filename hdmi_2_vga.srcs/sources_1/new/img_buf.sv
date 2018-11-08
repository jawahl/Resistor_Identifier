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


  // line and frame pulses
  logic [1:0] ln_sft = '0;
  logic [1:0] fm_sft = '0;

  always_ff @ (posedge clk) ln_sft <= (ln_sft << 1) | hsync;
  always_ff @ (posedge clk) fm_sft <= (fm_sft << 1) | vsync;

  wire ln_sync = ln_sft[1] & (~ln_sft[0]);
  wire fm_sync = fm_sft[1] & (~fm_sft[0]);


  // one hot ram chip select
  logic [2:0] ram_sel = 1;

  // circular shift with each complete line
  always_ff @ (posedge clk) begin
    if (ln_sync)
      ram_sel <= (ram_sel << 1) | ram_sel[2];
  end


  // WRITE LOGIC
  logic [14:0] waddr = '0;            // bram write address
  wire         we    = pvld & en;     // bram write enable

  always_ff @ (posedge clk) begin
    if      (ln_sync) waddr <= '0;
    else if (we)      waddr <= waddr + 1;
  end


  // READ LOGIC
  enum {
    IDLE,
    READ
  } rfsm = IDLE, rfsm_d;

  logic [14:0] raddr = '0;            // bram read address
  wire  [23:0] rdata [3];             // bram read data

  always_ff @ (posedge clk) raddr <= (rfsm == READ) ? raddr + 1 : '0;

  always_ff @ (posedge clk) rfsm <= rfsm_d;

  always_comb begin
    case (rfsm)
      IDLE    : rfsm_d = (ram_sel[2]) ? READ : IDLE;
      READ    : rfsm_d = (ln_sync)    ? IDLE : READ;
      default : rfsm_d = IDLE;
    endcase
  end


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
