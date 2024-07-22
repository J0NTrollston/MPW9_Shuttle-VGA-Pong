`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 08:46:47 PM
// Design Name: 
// Module Name: display
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


module display(
    input wire [9:0] column,
    input wire [9:0] row,
    
    output wire r,
    output wire g,
    output wire b,
    
    input wire [9:0] leftPaddle

    );
    
wire inside_border, verticle_lines, horizontal_lines;
wire white; //colors

//temp
wire leftPaddleEn;
//wire leftPaddle = 220;
    
//Make sure all pixels are drawn in the border
assign inside_border = ((column>=20 && column<=620) || (row>=20 && row <=460)) ? 1'b1 : 1'b0;

//verticle border lines
assign verticle_lines = ((row >= 20) && (row <= 420) && (column == 20)) 
    || ((row >= 20) && (row <= 420) && (column == 620)) ? 1'b1 : 1'b0;  
    
//horizontal border lines
assign horizontal_lines = ((column >= 20) && (column <= 620) && (row == 20)) 
                            || ((column >= 20) && (column <= 620) && (row == 420)) ? 1'b1 : 1'b0;
                            
//This is where on the screen the left pong paddle will be drawn 
//size is 3 x 51(w x l)
assign leftPaddleEn = ((column >=40 && column <= 43) 
    && (row >= (leftPaddle-25) && row <= (leftPaddle+25))) ? 1'b1 : 1'b0;
    
assign r = ((inside_border == 1'b1) && (white == 1'b1)) ? 1'b1 : 1'b0;
assign g = ((inside_border == 1'b1) && (white == 1'b1)) ? 1'b1 : 1'b0;
assign b = ((inside_border == 1'b1) && (white == 1'b1)) ? 1'b1 : 1'b0;

assign white = verticle_lines || horizontal_lines || leftPaddleEn;
    
endmodule
