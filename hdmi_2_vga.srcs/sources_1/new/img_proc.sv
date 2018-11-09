module img_proc (
  input  wire         clk,

  input  wire  [23:0] data_i,
  input  wire         vde_i,
  input  wire         hsync_i,
  input  wire         vsync_i,

  output logic [23:0] data_o,
  output logic        vde_o,
  output logic        hsync_o,
  output logic        vsync_o
);

  /*axis_if #( .DATA_TYPE (pixel_pkg::chunk_t) ) axis_i ();
  axis_if #( .DATA_TYPE (pixel_pkg::chunk_t) ) axis_o ();

  conv conv_i1 (
    .clk (clk),
    .rst (  0),
  );*/

  always_ff @ (posedge clk) begin
    data_o  <= data_i;
    vde_o   <= vde_i;
    hsync_o <= hsync_i;
    vsync_o <= vsync_i;
  end

endmodule
