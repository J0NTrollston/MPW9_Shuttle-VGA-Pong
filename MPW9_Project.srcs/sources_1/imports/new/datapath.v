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
    
    input wire [9:0] cw_NESController_Left,
    output wire [1:0] sw_NESController_Left,
    
    input wire [9:0] cw_NESController_Right,
    output wire [1:0] sw_NESController_Right,
    
//    inout wire [7:0] ja
//    input wire ja0_data,
//    output wire [1:0] ja12_clk_latch 
    inout wire [2:0] NES_Controller_Left,
    inout wire [2:0] NES_Controller_Right,
    
    output wire [3:0] sw_ballMovement,
    input wire [3:0] cw_ballMovement
    );
    


//wire roll;
reg [7:0] NES_activity_Left, old_NES_Left;
reg [7:0] NES_wire_Left;
reg [9:0] leftPaddle;

reg [7:0] NES_activity_Right, old_NES_Right;
reg [7:0] NES_wire_Right;
reg [9:0] rightPaddle;

wire [9:0] ball_center_x, ball_center_y;
reg [3:0] sw_ballMovement_reg;
reg ballReset;
wire ballClk;


video video(
    .clk(clk),
    .reset_n(reset_n),

    .h_sync(h_sync),
    .v_sync(v_sync),
    .r(r),
    .g(g),
    .b(b),
    
    .leftPaddle(leftPaddle),
    .rightPaddle(rightPaddle),
    
    .ball_center_x(ball_center_x),
    .ball_center_y(ball_center_y)
    );
    
    
//If using Artix-7 FPGA then counter should be 601 to delay for 6us otherwise 152 when setting up the ASIC
Counter #(.countLimit(601)) NES_counter(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl(cw_NESController_Left[1:0]),
    .roll(sw_NESController_Left[0]));
    
Counter #(.countLimit(601)) NES_counter_right(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl(cw_NESController_Right[1:0]),
    .roll(sw_NESController_Right[0]));
    
//assign sw_NESController[1] = roll;


//If using Artix-7 FPGA then counter should be 1666666 to delay for 60Hz otherwise 419583 when setting up the ASIC
Counter #(.countLimit(1666666)) NES_delay_counter(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl(cw_NESController_Left[9:8]),
    .roll(sw_NESController_Left[1]));
    
Counter #(.countLimit(1666666)) NES_delay_counter_right(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl(cw_NESController_Right[9:8]),
    .roll(sw_NESController_Right[1]));
    
Counter #(.countLimit(400000)) temp(
    .clk(clk),
    .reset_n(reset_n),
    .ctrl(2'b01),
    .roll(ballClk));
    
ballFunction ballFunction(
    .clk(ballClk), //60hz
    .reset_n(ballReset),
    .cw_ballMovement(cw_ballMovement),
    .ball_center_x(ball_center_x),
    .ball_center_y(ball_center_y));


always @(posedge clk) begin
    if(reset_n == 1'b0)
        NES_wire_Left <= 8'b0;
    else begin
        case(cw_NESController_Left[7:4])
            4'b0001 : NES_wire_Left[7] <= NES_Controller_Left[0];
            4'b0010 : NES_wire_Left[6] <= NES_Controller_Left[0];
            4'b0011 : NES_wire_Left[5] <= NES_Controller_Left[0];
            4'b0100 : NES_wire_Left[4] <= NES_Controller_Left[0];
            4'b0101 : NES_wire_Left[3] <= NES_Controller_Left[0];
            4'b0110 : NES_wire_Left[2] <= NES_Controller_Left[0];
            4'b0111 : NES_wire_Left[1] <= NES_Controller_Left[0];
            4'b1000 : NES_wire_Left[0] <= NES_Controller_Left[0];
            default: NES_wire_Left <= 8'b11111111;
        endcase
    end
end

always @(posedge clk) begin
    if(reset_n == 1'b0)
        NES_wire_Right <= 8'b0;
    else begin
        case(cw_NESController_Left[7:4])
            4'b0001 : NES_wire_Right[7] <= NES_Controller_Right[0];
            4'b0010 : NES_wire_Right[6] <= NES_Controller_Right[0];
            4'b0011 : NES_wire_Right[5] <= NES_Controller_Right[0];
            4'b0100 : NES_wire_Right[4] <= NES_Controller_Right[0];
            4'b0101 : NES_wire_Right[3] <= NES_Controller_Right[0];
            4'b0110 : NES_wire_Right[2] <= NES_Controller_Right[0];
            4'b0111 : NES_wire_Right[1] <= NES_Controller_Right[0];
            4'b1000 : NES_wire_Right[0] <= NES_Controller_Right[0];
            default: NES_wire_Right <= 8'b11111111;
        endcase
    end
end

    
always @(posedge clk) begin
    NES_activity_Left <= (old_NES_Left ^ (~NES_wire_Left) ) & ~NES_wire_Left;
    
    if(reset_n == 1'b0) begin
        old_NES_Left <= 8'd0;
        leftPaddle <= 10'd220;
        ballReset <= 1'b1;
    end

    if(NES_activity_Left[6] == 1'b1) begin //reset
        leftPaddle <= 10'd220;
        NES_activity_Left <= 8'd0;
        old_NES_Left <= 8'd0;
    end else if(NES_activity_Left[5] == 1'b1) begin
        ballReset <= 1'b0;
    end else if(NES_activity_Left[4] == 1'b1) begin
        ballReset <= 1'b1;
    end else if(NES_activity_Left[3] == 1'b1) begin
        if(leftPaddle - 4'd5 >= 45)
            leftPaddle <= leftPaddle - 4'd5;
    end else if(NES_activity_Left[2] == 1'b1) begin
        if(leftPaddle + 4'd5 <= 395)
            leftPaddle <= leftPaddle + 4'd5;
    end
    
//    ballReset <= 1'b0;
    old_NES_Left <= ~NES_wire_Left;
end

always @(posedge clk) begin
    NES_activity_Right <= (old_NES_Right ^ (~NES_wire_Right) ) & ~NES_wire_Right;
    if(reset_n == 1'b0) begin
        old_NES_Right <= 8'd0;
        rightPaddle <= 10'd220;
    end

    if(NES_activity_Right[6] == 1'b1) begin //reset
        rightPaddle <= 10'd220;
        NES_activity_Right <= 8'd0;
        old_NES_Right <= 8'd0;
    end else if(NES_activity_Right[3] == 1'b1) begin
        if(rightPaddle - 4'd5 >= 45)
            rightPaddle <= rightPaddle - 4'd5;
    end else if(NES_activity_Right[2] == 1'b1) begin
        if(rightPaddle + 4'd5 <= 395)
            rightPaddle <= rightPaddle + 4'd5;
    end
    
    old_NES_Right <= ~NES_wire_Right;
end

always @(posedge ballClk) begin
    if(ball_center_y <= 25)
        sw_ballMovement_reg <= 4'b0011;
    else if(ball_center_y == 416)
        sw_ballMovement_reg <= 4'b0100;
    else if(ball_center_x == 593 && (ball_center_y > rightPaddle - 30 && ball_center_y < rightPaddle + 30))
        sw_ballMovement_reg <= 4'b0001;
    else if(ball_center_x == 47 && (ball_center_y > leftPaddle - 30 && ball_center_y < leftPaddle + 30))
        sw_ballMovement_reg <= 4'b0010;
    else if(ball_center_x >= 616 || ball_center_x <= 24) begin
        sw_ballMovement_reg <= 4'b0101;
//        ballReset <= 1'b1;
    end else
        sw_ballMovement_reg <= 4'b0000;
end
//pRight) ? 4'b0100 :
//                         (state_ballMovement == UpLeft) ? 4'b0010 :
//                         (state_ballMovement == DownLeft) ? 4'b0011 :
//                         (state_ballMovement == Reset) ? 4'b0101 :
//                         4'b0001; //downright




	
//NES communication logic            
assign NES_Controller_Left[1] = cw_NESController_Left[2];
assign NES_Controller_Left[2] = cw_NESController_Left[3];

assign NES_Controller_Right[1] = cw_NESController_Right[2];
assign NES_Controller_Right[2] = cw_NESController_Right[3];
   
assign sw_ballMovement = sw_ballMovement_reg;
  
    
endmodule