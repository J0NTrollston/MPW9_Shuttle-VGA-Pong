`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 04:09:42 PM
// Design Name: 
// Module Name: vga_tb
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

module vga_tb();

// Testbench signals
    reg clk;
    reg reset;
    wire h_sync;
    wire v_sync;
//    wire blank;
    wire r;
    wire g;
    wire b;
    
    
    vga vga(
        .clk(clk),
        .reset(reset),
        .h_sync(h_sync),
        .v_sync(v_sync),
//        .blank(blank),
        .r(r),
        .g(g),
        .b(b));
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end
    
    
    initial begin
        reset = 1;
        
        #100 reset = 0;
        
        #5000
        
        $finish;
    
    end
    
// Monitor signals
    initial begin
        $monitor("At time %t, clk = %b, reset = %b, h_sync = %b, v_sync = %b, r = %b, g = %b, b = %b",
                  $time, clk, reset, h_sync, v_sync, r, g, b);
    end

endmodule
