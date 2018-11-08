`include "axi.svh"

module conv #(
  parameter logic [7:0] KERNEL[3][3] = '{
    {0, 0, 0},
    {0, 1, 0},
    {0, 0, 0}
  }
) (
  input wire clk,
  input wire rst,

  axis_if.slave  axis_i,   // slave  -- input  chunk data
  axis_if.master axis_o    // master -- output pixel data
);

  pixel_pkg::chunk_t chunk_mul = '{default : '0};
  pixel_pkg::pixel_t pixel_add = '{default : '0};

  logic [15:0] mul_red;
  logic [15:0] mul_grn;
  logic [15:0] mul_blu;

  always_comb begin
    int i, j;

    for (i = 0; i < 3; i = i + 1) begin
      for (j = 0; j < 3; j = j + 1) begin
        mul_red = axis_i.data[i][j].red * KERNEL[i][j];
        mul_grn = axis_i.data[i][j].grn * KERNEL[i][j];
        mul_blu = axis_i.data[i][j].blu * KERNEL[i][j];

        // TODO (carson): check that this works with negative values
        chunk_mul[i][j].red = (mul_red & 16'hff00) ? 8'hff : mul_red;
        chunk_mul[i][j].grn = (mul_grn & 16'hff00) ? 8'hff : mul_grn;
        chunk_mul[i][j].blu = (mul_blu & 16'hff00) ? 8'hff : mul_blu;
      end
    end
  end


  pixel_pkg::chunk_t chunk_tmp = '{default : '0};

  always_ff @ (posedge clk) begin
    if (axis_i.ok)
      chunk_tmp <= chunk_mul;
  end

  logic vld_tmp = 0;

  // propagate signal if data was consumed to act as output valid
  always_ff @ (posedge clk) begin
    vld_tmp <= axis_i.ok;
  end

  // request data only when output module is requesting data
  always_comb axis_i.rdy = axis_o.rdy;


  // sum the values
  always_comb begin
    int i, j;

    pixel_add = '{default : '0};

    // TODO (carson): break into tree structure for speed boost
    for (i = 0; i < 3; i = i + 1) begin
      for (j = 0; j < 3; j = j + 1) begin
        pixel_add.red = pixel_add.red + chunk_tmp[i][j].red;
        pixel_add.grn = pixel_add.grn + chunk_tmp[i][j].grn;
        pixel_add.blu = pixel_add.blu + chunk_tmp[i][j].blu;
      end
    end
  end

  // output data and valid
  always_ff @ (posedge clk) begin
    axis_o.data       <= chunk_tmp;
    axis_o.data[1][1] <= pixel_add;
    axis_o.vld        <= vld_tmp;
  end

endmodule
