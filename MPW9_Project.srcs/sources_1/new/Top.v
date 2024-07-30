//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2024 01:52:13 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
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

module Top(
    input wire clk,
    input wire reset_n, //A7 FPGA uses active low reset signal
    output wire [4:0] out,
    inout wire [5:0] bidir
    );
    
//wire reset = ~reset_n;
wire pixel_clk;
    
Pong Pong(
    .clk(pixel_clk),
    .reset_n(reset_n), //A7 FPGA uses active low reset signal
    
    .out(out),
    .bidir(bidir)
    );
    
/*
Temp pixel clock to run the VGA at 60Hz 
pixel_clk: 25.175MHz
Resolution: 640x480 @60Hz
*/
clk_wiz_0 clk_wiz_0(
    .clk_in1(clk),
    .reset(1'b0), //no reset otherwise the reset in other modules will not work.
    .clk_out1(pixel_clk)
    );
    
endmodule