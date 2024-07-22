`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 12:46:07 PM
// Design Name: 
// Module Name: counter_t
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

module counter_t();
    
// Testbench signals
    reg clk;
    reg reset;
    reg [1:0] ctrl;
    wire roll;
    wire [3:0] Q;

    // Instantiate the Unit Under Test (UUT)
    Counter #(
        .countLimit(10)) 
    counter(
        .clk(clk),
        .reset_n(reset),
        .ctrl(ctrl),
        .roll(roll),
        .Q(Q));

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        reset = 0;
        ctrl = 00;

        // Apply reset
        #50 reset = 1;

        // Test count sequence
        #50 ctrl = 01;
        

        // Finish simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("At time %t, clk = %b, reset = %b, ctrl = %b, roll = %b, Q = %d",
                  $time, clk, reset, ctrl, roll, Q);
    end

    
endmodule

