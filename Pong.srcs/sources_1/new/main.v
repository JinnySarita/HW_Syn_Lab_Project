`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2023 09:23:51 PM
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input RsRx,
    input btnU,
    input btnD,
    output RsTx,
    output [6:0] seg,
    output [3:0] an,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire Hsync,
    output wire Vsync,
    output wire [3:0] ws85l
    );
    
    reg [7:0] player1Score;
    reg [7:0] player2Score;

    wire [9:0] x,y;
    wire player1Up, player1Down, player2Up, player2Down;
    wire [3:0] ps11, ps12, ps21, ps22;
    wire [3:0] ws85l;
    wire [19:0] clk_div;
    wire [11:0] rgb_out;
    wire scorePlayer1Count;
    wire scorePlayer2Count;
    
    assign clk_div[0] = clk; // assign clk to clk_div[0]
    assign ps11 = player1Score[7:4]; // player1 score 1st digit
    assign ps12 = player1Score[3:0]; // player1 score 2nd digit
    assign ps21 = player2Score[7:4]; // player2 score 1st digit
    assign ps22 = player2Score[3:0]; // player2 score 2nd digit

    assign {player1Up,player1Down,player2Up,player2Down} = ws85l; // assign ws85l to player1Up, player1Down, player2Up, player2Down, throwBall
    assign vgaBlue = {rgb_out[3],rgb_out[2],rgb_out[1],rgb_out[0]}; // assign rgb_out to vgaBlue, vgaGreen, vgaRed
    assign vgaGreen = {rgb_out[7],rgb_out[6],rgb_out[5],rgb_out[4]};
    assign vgaRed = {rgb_out[11],rgb_out[10],rgb_out[9],rgb_out[8]};
    
    generate for(genvar i = 0;i<19;i = i+1) begin // divine clock by 2^19 for 7 segment display
        clock_divider div1(clk_div[i],clk_div[i+1]);
    end endgenerate
    
    uart keyboardInput(clk, RsRx, RsTx, ws85l); // keyboard input
    animationLogic animeLogic( // main game logic and animation logic
        clk,
        btnU,// reset
        x,// position x
        y,// position y
        1, //videoOn show video where the value is 1
        player1Up,// player1 up control
        player1Down,// player1 down control
        player2Up,// player2 up control
        player2Down,// player2 up control
        {btnD}, // throwBall ball game after player get score (afk handle)
        player1Score, // player1 score
        player2Score, // player2 score
        rgb_out, // rgb output of the position x y
        scorePlayer1Count, // Adding score of player1
        scorePlayer2Count // Adding score of player2
    );
    vga vga_render(.clk(clk), .reset(reset), .hsync(Hsync), .vsync(Vsync),
                                .video_on(video_on), .p_tick(), .x(x), .y(y)); // vga render
    
    always @(posedge clk)
    begin
        if(btnU == 1) begin 
            player1Score = 8'd0; // reset score player1
            player2Score = 8'd0; // reset score player2
        end
        else if (scorePlayer1Count == 1) begin // if player1 score count is 1 then add player1 score
            if(player1Score[3:0] < 4'd9) player1Score[3:0] = player1Score[3:0] + 1;
            else begin
                if(player1Score[7:4] < 4'd9) // If player1 1's unit digit score is 9, then add 1 to the tens and set 1s to 0
                begin
                    player1Score[3:0] = 4'd0;
                    player1Score[7:4] = player1Score[7:4] + 1;
                end
            end
        end
        else if (scorePlayer2Count == 1) begin // if player2 score count is 1 then add player2 score
            if(player2Score[3:0] < 4'd9) player2Score[3:0] = player2Score[3:0] + 1;
            else begin
                if(player2Score[7:4] < 4'd9) // If player2 1's unit digit score is 9, then add 1 to the tens and set 1s to 0
                begin
                    player2Score[3:0] = 4'd0;
                    player2Score[7:4] = player2Score[7:4] + 1;
                end
            end
        end
    end
    
    seven_segment_tdm segment_controller(clk_div[19],ps11,ps12,ps21,ps22,seg,an,1); // show score on 7 segment display
endmodule