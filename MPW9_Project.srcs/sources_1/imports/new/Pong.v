`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TinyTapeout 8
// Engineer: Brandon S. Ramos
// 
// Create Date: 07/15/2024 08:21:31 PM
// Design Name: 
// Module Name: Pong
// Project Name: VGA 2 player Pong using NES controller and button input
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

/*
Input:
    1. 
    2.
    3. 
    4. 
    5. 
    6.
    7.
    8.
Output:
    1. h_sync
    2. v_sync
    3. r
    4. g
    5. b
    6.
    7.
    8.
Bidirectional:
    1. ja[0]
    2. ja[1]
    3. ja[2]
    4. 
    5. 
    6.
    7.
    8.
*/

module Pong(
    input wire clk,
    input wire reset_n, //A7 FPGA uses active low reset signal
    
    // for testing light 
//    input wire switch, 
    output wire [7:0] led,
    
    //VGA timing and picture
    output wire h_sync,
    output wire v_sync,
    output wire r,
    output wire g,
    output wire b,
    
    input wire ja0_data,
    output wire [1:0] ja12_clk_latch   
    );
    
wire [9:0] cw_NESController;
wire [1:0] sw_NESController;
    
datapath datapath(
    .clk(clk),
    .reset_n(reset_n),
    
    .led(led),
    
    .h_sync(h_sync),
    .v_sync(v_sync),
    .r(r),
    .g(g),
    .b(b),
    .cw_NESController(cw_NESController),
    .sw_NESController(sw_NESController),
    .ja0_data(ja0_data),
    .ja12_clk_latch(ja12_clk_latch));

    
control_unit control_unit(
    .clk(clk),
    .reset_n(reset_n),
    .cw_NESController(cw_NESController),
    .sw_NESController(sw_NESController));
    
endmodule