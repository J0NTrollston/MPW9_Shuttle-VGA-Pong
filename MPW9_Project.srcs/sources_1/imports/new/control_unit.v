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
    output wire [9:0]cw_NESController_Right,
    
    input wire [3:0] sw_ballMovement,
    output wire [3:0] cw_ballMovement
    );

//FSM states for the ball movement
localparam [2:0]Reset = 5'd0,
                UpRight = 5'd1,
                UpLeft = 5'd2,
                DownRight = 5'd3,
                DownLeft = 5'd4;
reg [2:0]state_ballMovement;



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


// sw: 0001 - hit right paddle
//     0010 - hit left paddle
//     0100 - hit top border
//     1000 - hit bottom border

always @(posedge clk) begin
    if(reset_n == 1'b0)
        state_ballMovement <= UpLeft;
    else begin
    
    end
       
end
state_process_ballMovement: process(clk, reset_n)
begin
    if(rising_edge(clk)) then
        if(reset_n = '0') then
            state_ballMovement <= UpLeft;
        else
            case state_ballMovement is
            
                when Reset =>
                     state_ballMovement <= UpLeft;
                    
                when UpRight =>
                     if(sw_ballMovement = "0001") then 
                        state_ballMovement <= UpLeft; 
                     elsif(sw_ballMovement = "0011") then
                        state_ballMovement <= DownRight;
                     elsif(sw_ballMovement = "0101") then
                        state_ballMovement <= Reset;
                     else
                        state_ballMovement <= UpRight;
                    end if;
                    
                when UpLeft =>
                     if(sw_ballMovement = "0010") then 
                        state_ballMovement <= UpRight; 
                     elsif(sw_ballMovement = "0011") then
                        state_ballMovement <= DownLeft;
                     elsif(sw_ballMovement = "0101") then
                        state_ballMovement <= Reset;
                     else
                        state_ballMovement <= UpLeft;
                    end if;    
                    
                when DownLeft =>
                     if(sw_ballMovement = "0010") then 
                        state_ballMovement <= DownRight; 
                     elsif(sw_ballMovement = "0100") then
                        state_ballMovement <= UpLeft;
                     elsif(sw_ballMovement = "0101") then
                        state_ballMovement <= Reset;
                     else
                        state_ballMovement <= DownLeft;
                    end if;
                    
                when DownRight =>
                     if(sw_ballMovement = "0001") then 
                        state_ballMovement <= DownLeft; 
                     elsif(sw_ballMovement = "0100") then
                        state_ballMovement <= UpRight;
                     elsif(sw_ballMovement = "0101") then
                        state_ballMovement <= Reset;
                     else
                        state_ballMovement <= DownRight;
                    end if;
                                          
            end case;
        end if;
    end if;
end process;
endmodule
