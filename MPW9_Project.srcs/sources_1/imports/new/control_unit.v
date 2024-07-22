`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 08:20:09 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input wire clk,
    input wire reset_n,
    
    input wire [1:0] sw_NESController_Left,
    output wire [9:0]cw_NESController_Left,
    
    input wire [1:0] sw_NESController_Right,
    output wire [9:0]cw_NESController_Right
    );


NES_Controller_FSM NES_Controller_Left(
    .clk(clk),
    .reset_n(reset_n),
    .sw_NESController(sw_NESController_Left),
    .cw_NESController(cw_NESController_Left)
    
);

NES_Controller_FSM NES_Controller_Right(
    .clk(clk),
    .reset_n(reset_n),
    .sw_NESController(sw_NESController_Right),
    .cw_NESController(cw_NESController_Right)
    
);
endmodule
