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
    1. ja[0] in 
    2. ja[1] out
    3. ja[2] out
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
    
    inout wire [2:0] NES_Controller_Left,
    inout wire [2:0] NES_Controller_Right
//    input wire ja0_data,
//    output wire [1:0] ja12_clk_latch   
    );
    
wire [9:0] cw_NESController_Left;
wire [1:0] sw_NESController_Left;

wire [9:0] cw_NESController_Right;
wire [1:0] sw_NESController_Right;
    
datapath datapath(
    .clk(clk),
    .reset_n(reset_n),
    
    .led(led),
    
    .h_sync(h_sync),
    .v_sync(v_sync),
    .r(r),
    .g(g),
    .b(b),
    .cw_NESController_Left(cw_NESController_Left),
    .sw_NESController_Left(sw_NESController_Left),
    .cw_NESController_Right(cw_NESController_Right),
    .sw_NESController_Right(sw_NESController_Right),
    
    .NES_Controller_Left(NES_Controller_Left),
    .NES_Controller_Right(NES_Controller_Right)
//    .ja0_data(ja0_data),
//    .ja12_clk_latch(ja12_clk_latch)
    );

    
control_unit control_unit(
    .clk(clk),
    .reset_n(reset_n),
    
    .cw_NESController_Left(cw_NESController_Left),
    .sw_NESController_Left(sw_NESController_Left),
    
    .cw_NESController_Right(cw_NESController_Right),
    .sw_NESController_Right(sw_NESController_Right)
    );
    
endmodule