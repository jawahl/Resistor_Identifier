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

  axis_if #( .DATA_TYPE (pixel_pkg::chunk_t) ) axis_buf ();
  axis_if #( .DATA_TYPE (pixel_pkg::chunk_t) ) axis_conv ();

  img_buf img_buf_i (
    .clk    (clk),
    .en     (1),
    .pdata  (data_i),
    .pvld   (vde_i),
    .hsync  (hsync),
    .vsync  (vsync),
    .axis_o (axis_buf)
  );

  conv conv_i (
    .clk    (clk),
    .rst    (0),
    .axis_i (axis_buf),
    .axis_o (axis_conv)
  );

  always_comb data_o 

endmodule
