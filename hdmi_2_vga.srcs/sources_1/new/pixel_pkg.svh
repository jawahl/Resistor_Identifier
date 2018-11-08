`ifndef PIXEL_SVH
`define PIXEL_SVH

package pixel_pkg;

  typedef struct {
    logic [7:0] red;
    logic [7:0] grn;
    logic [7:0] blu;
  } pixel_t;

  typedef pixel_t chunk_t [3][3];

endpackage

`endif
