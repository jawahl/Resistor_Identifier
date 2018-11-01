`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CPE 439
// Engineer: Jake Wahl and Carson Robles
// 
// Create Date: 10/31/2018 04:55:49 PM
// Design Name: 
// Module Name: img_proc
// Project Name: 
// Target Devices: Zybo Zynq SoC
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module img_proc(

input wire clk,

input wire [23:0] data_i,
input wire        vde_i,
input wire        hsync_i,
input wire        vsync_i,

output logic [23:0] data_o,
output logic        vde_o,
output logic        hsync_o,
output logic        vsync_o
);

  always_ff @ (posedge clk) begin
    data_o  <= data_i;
    vde_o   <= vde_i;
    hsync_o <= hsync_i;
    vsync_o <= vsync_i;
  end

endmodule
