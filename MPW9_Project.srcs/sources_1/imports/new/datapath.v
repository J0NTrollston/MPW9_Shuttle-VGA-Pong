`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 05:32:46 PM
// Design Name: 
// Module Name: Pong_dp
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


module datapath(
    input wire clk,
    input wire reset_n,
    
    // for testing light 
//    input wire switch, 
    output wire [7:0] led,
    
    //VGA timing and picture
    output wire h_sync,
    output wire v_sync,
    output wire r,
    output wire g,
    output wire b,
    
    input wire [9:0] cw_NESController,
    output wire [1:0] sw_NESController,
    
//    inout wire [7:0] ja
    input wire ja0_data,
    output wire [1:0] ja12_clk_latch  
    );
    


//wire roll;
reg [7:0] NES_activity, old_NES;
reg [7:0] NES_wire;
reg [9:0] leftPaddle;


video video(
    .clk(clk),
    .reset_n(reset_n),
    
//    .switch(switch),
//    .led(led),
    
    .h_sync(h_sync),
    .v_sync(v_sync),
    .r(r),
    .g(g),
    .b(b),
    .leftPaddle(leftPaddle));
    
    
//If using Artix-7 FPGA then counter should be 601 to delay for 6us otherwise 152 when setting up the ASIC
Counter #(.countLimit(601)) NES_counter(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl(cw_NESController[1:0]),
    .roll(sw_NESController[0]));
    
//assign sw_NESController[1] = roll;


//If using Artix-7 FPGA then counter should be 1666666 to delay for 60Hz otherwise 419583 when setting up the ASIC
Counter #(.countLimit(1666666)) NES_delay_counter(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl(cw_NESController[9:8]),
    .roll(sw_NESController[1]));


always @(posedge clk) begin
    if(reset_n == 1'b0)
        NES_wire <= 8'b0;
    else begin
        case(cw_NESController[7:4])
            4'b0001 : NES_wire[7] <= ja0_data;
            4'b0010 : NES_wire[6] <= ja0_data;
            4'b0011 : NES_wire[5] <= ja0_data;
            4'b0100 : NES_wire[4] <= ja0_data;
            4'b0101 : NES_wire[3] <= ja0_data;
            4'b0110 : NES_wire[2] <= ja0_data;
            4'b0111 : NES_wire[1] <= ja0_data;
            4'b1000 : NES_wire[0] <= ja0_data;
            default: NES_wire <= 8'b11111111;
        endcase
    end
end

    
always @(posedge clk) begin
    NES_activity <= (old_NES ^ (~NES_wire) ) & ~NES_wire;
    if(reset_n == 1'b0) begin
        old_NES <= 8'd0;
        leftPaddle <= 10'd220;
    end

    if(NES_activity[6] == 1'b1) begin //reset
        leftPaddle <= 10'd220;
        NES_activity <= 8'd0;
        old_NES <= 8'd0;
    end else if(NES_activity[3] == 1'b1) begin
        if(leftPaddle - 4'd10 >= 45)
            leftPaddle <= leftPaddle - 4'd10;
    end else if(NES_activity[2] == 1'b1) begin
        if(leftPaddle + 4'd10 <= 395)
            leftPaddle <= leftPaddle + 4'd10;
    end
    
    old_NES <= ~NES_wire;
end



	
//NES communication logic            
//assign ja[2] = (cw_NESController[3] == 1'b1) ? 1'b1 : 1'b0; 
//assign ja12_clk_latch[1] = (cw_NESController[3] == 1'b1) ? 1'b1 : 1'b0; 
assign ja12_clk_latch[1] = cw_NESController[3];
//assign ja[1] = (cw_NESController[2] == 1'b1) ? 1'b1 : 1'b0; 
//assign ja12_clk_latch[0] = (cw_NESController[2] == 1'b1) ? 1'b1 : 1'b0;
assign ja12_clk_latch[0] = cw_NESController[2];
   
//assign NES_wire[7] = (cw_NESController[7:4] == 4'b0001) ? ja[0] : 1'b1; //--Directional Pad A
//assign NES_wire[6] = (cw_NESController[7:4] == 4'b0010) ? ja[0] : 1'b1; //--Directional Pad B
//assign NES_wire[5] = (cw_NESController[7:4] == 4'b0011) ? ja[0] : 1'b1; //--Directional Pad Select
//assign NES_wire[4] = (cw_NESController[7:4] == 4'b0100) ? ja[0] : 1'b1; //--Directional Pad Start
//assign NES_wire[3] = (cw_NESController[7:4] == 4'b0101) ? ja[0] : 1'b1; //--Directional Pad Up
//assign NES_wire[2] = (cw_NESController[7:4] == 4'b0110) ? ja[0] : 1'b1; //--Directional Pad Down
//assign NES_wire[1] = (cw_NESController[7:4] == 4'b0111) ? ja[0] : 1'b1; //--Directional Pad Left
//assign NES_wire[0] = (cw_NESController[7:4] == 4'b1000) ? ja[0] : 1'b1; //--Directional Pad Right    
    
assign led = ~NES_wire;
endmodule