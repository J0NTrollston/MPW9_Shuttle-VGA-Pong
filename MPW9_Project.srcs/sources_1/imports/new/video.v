`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 09:34:48 PM
// Design Name: 
// Module Name: video
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


module video(
    input wire clk,
    input wire reset_n,
    
//    input wire switch, // for testing light 
//    output wire led,
    
    output wire h_sync,
    output wire v_sync,
    output wire r,
    output wire g,
    output wire b,
    input wire [9:0] leftPaddle,
    input wire [9:0] rightPaddle);
    
    
wire reset = !reset_n; //clock wizzard reset is active high
wire pixel_clk;
    
/*
Temp pixel clock to run the VGA at 60Hz 
pixel_clk: 25.175MHz
Resolution: 640x480 @60Hz
*/
clk_wiz_0 clk_wiz_0(
    .clk_in1(clk),
    .reset(reset),
    .clk_out1(pixel_clk));
    
    
vga vga(
    .clk(pixel_clk),
    .reset_n(reset_n),
//    .switch(switch),
//    .led(led),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .r(r),
    .g(g),
    .b(b),
    .leftPaddle(leftPaddle),
    .rightPaddle(rightPaddle));
    
endmodule