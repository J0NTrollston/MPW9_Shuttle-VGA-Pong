`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 03:17:06 PM
// Design Name: 
// Module Name: vga
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


module vga(
    input wire clk,
    input wire reset_n,
    
//    input wire switch,
//    output wire led,
    
    output wire h_sync,
    output wire v_sync,
    output wire r,
    output wire g,
    output wire b,
    
    input wire [9:0] leftPaddle,
    input wire [9:0] rightPaddle,
    
    input wire [9:0] ball_center_x,
    input wire [9:0] ball_center_y
    );


wire col_roll; //End of horizontal line and inc row counter
wire [9:0] column_s, row_s;
wire r_s, g_s, b_s;
wire blank;


Counter #(.countLimit(799)) Column_Counter(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl(2'b01),
    .roll(col_roll),
    .Q(column_s));
    
Counter #(.countLimit(524)) Row_Counter(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl({1'b0,col_roll}),
    .Q(row_s));
    
display display(
    .column(column_s),
    .row(row_s),
    .r(r_s),
    .g(g_s),
    .b(b_s),
    
    .leftPaddle(leftPaddle),
    .rightPaddle(rightPaddle),
    
    .ball_center_x(ball_center_x),
    .ball_center_y(ball_center_y));
    
assign h_sync = ((column_s >= 655) && (column_s < 751)) ? 1'b0 : 1'b1;
assign v_sync = ((row_s >= 489) && (row_s < 491)) ? 1'b0 : 1'b1;
assign blank = ((column_s > 639) ||  (row_s > 479)) ? 1'b1 : 1'b0;

assign r = blank ? 1'b0 : r_s;
assign g = blank ? 1'b0 : g_s;
assign b = blank ? 1'b0 : b_s;

//assign led = switch;

endmodule