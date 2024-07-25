`timescale 1ns / 1ps
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
    
    //VGA timing and picture
    output wire h_sync,
    output wire v_sync,
    output wire r,
    output wire g,
    output wire b,
    
    //NES Controller input for left/right
    inout wire [2:0] NES_Controller_Left,
    inout wire [2:0] NES_Controller_Right
    );
endmodule
