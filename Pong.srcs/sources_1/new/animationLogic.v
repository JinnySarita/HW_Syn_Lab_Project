`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Thanat Wongsamut
// 
// Create Date: 11/06/2023 09:43:00 PM
// Design Name: Animation Logic
// Module Name: animationLogic
// Project Name: Pong
// Target Devices: BASYS3
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


module animationLogic(
    input clk,
    input reset,
    input [9:0] x,
    input [9:0] y,
    input videoOn,
    input player1Up,
    input player1Down,
    input player2Up,
    input player2Down,
    input throwBall,
    input [7:0] totalscorePlayer1,
    input [7:0] totalscorePlayer2,
    output wire [11:0] rgb,
    output wire scorePlayer1,
    output wire scorePlayer2
);

    reg scoreCheckerPlayer1;
    reg scoreCheckerPlayer2;
    reg scorer; 
    reg scorerNext;

    // Parameter
    parameter paddleWidth = 10; // width of the paddle
    parameter paddleHeight = 120; // height of the paddle
    parameter paddleVelocity = 5; // velocity of the paddle
    
    parameter ballDefaultX = 300; // default value of the distance between the ball and left side of the screen
    parameter ballDefaultY = 300; // default value of the distance between the ball and top side of the screen
    parameter ballRadius = 8; // radius of the ball
    parameter velocityX = 2; // Horizontal velocity of the ball
    parameter velocityY = 2; // Vertical velocity of the ball

    // Player 1
    integer leftPaddleY; // the distance between paddle and top side of screen
    integer leftPaddleNextY; // the distance between paddle and top side of screen
    parameter leftPaddleX = 20; // the distance between bar and left side of screen
    wire displayLeftPaddle; // to display player 1's paddle in vga
    wire[11:0] rgbLeftPaddle; // player 1's paddle color

    // Player 1' score
    wire displayPlayer1Score; // to display player 1's score
    wire player1FirstDigit; // output player 1's first digit from convertor
    wire player1SecondDigit; // output player 1's second digit from convertor
    wire[11:0] rgbPlayer1Score; // player 1's score color

    // Player 2
    integer rightPaddleY; // the distance between paddle and top side of screen
    integer rightPaddleNextY; // the distance between paddle and top side of screen
    parameter rightPaddleX = 610; // the distance between bar and left side of screen
    wire displayRightPaddle; // to display player 2's paddle in vga
    wire[11:0] rgbRightPaddle; // player 2's paddle color

    // Player 2' score
    wire displayPlayer2Score; // to display player 2's score
    wire player2FirstDigit; // output player 2's first digit from convertor
    wire player2SecondDigit; // output player 2's second digit from convertor
    wire[11:0] rgbPlayer2Score; // player 2's score color

    // Ball
    integer ballX; // the distance between the ball and left side of the screen
    integer ballNextX; // the distance between the ball and left side of the screen
    integer ballY; // the distance between the ball and top side of the screen
    integer ballNextY; // the distance between the ball and top side of the screen
    integer velocityXReg; // current horizontal velocity of the ball
    integer velocityXNext; // next horizontal velocity of the ball
    integer velocityYReg; // current vertical velocity of the ball
    integer velocityYNext; // next vertical velocity of the ball
    wire displayBall; // to display ball in vga
    wire[11:0] rgbBall; // ball color

    // Refresh the display
    reg [19:0] refreshReg;
    wire [19:0] refreshNext;
    parameter refreshConstant = 830000;
    wire refreshRate;

    // Mux to display
    wire[5:0] outputMux;

    // RGB buffer
    reg[11:0] rgbReg; 
    wire[11:0] rgbNext; 

    // Initialize
    initial begin
        velocityYReg = 0;
        velocityYNext = 0;
        velocityXReg = 0;
        velocityXNext = 0;
        ballX = 300;
        ballNextX = 300;
        ballY = 300;
        ballNextY = 300;

        leftPaddleY = 380;
        leftPaddleNextY = 380;

        rightPaddleY = 380;
        rightPaddleNextY = 380;
    end

    // Refreshing
    always @(posedge clk) begin
        refreshReg <= refreshNext;   
    end

    // Assign refresh logics
    assign refreshNext = refreshReg === refreshConstant ? 0 : refreshReg + 1; 
    assign refreshRate = refreshReg === 0 ? 1'b1 : 1'b0; 

    // Register part
    always @(posedge clk or posedge reset) begin
        if (reset === 1'b1) begin
            // to reset the game
            ballX <= ballDefaultX;
            ballY <= ballDefaultY;
            leftPaddleY <= 380;
            rightPaddleY <= 380;
            velocityXReg <= 0;
            velocityYReg <= 0;
        end
        else begin
            velocityXReg <= velocityXNext; // assigns horizontal velocity
            velocityYReg <= velocityYNext; // assigns vertical velocity

            if (throwBall === 1'b1) begin
                // throw the ball

                if (scorer === 1'b0) begin
                    // if scorer is player 2 throw the ball to player 1.
            
                    velocityXReg <= -velocityX;
//                    velocityYReg <= -velocityY;
                    velocityYReg <= 1;
                end
                else begin
                    // if scorer is player 1 throw the ball to player 2.
                    velocityXReg <= velocityX;
//                    velocityYReg <= velocityY;
                    velocityYReg <= 1;
                end
            end

            ballX <= ballNextX; // assigns the next value of the ball's location from the left side of the screen to it's location.
            ballY <= ballNextY; // assigns the next value of the ball's location from the top side of the screen to it's location.  
            leftPaddleY <= leftPaddleNextY; // assigns the next value of the left paddle's location from the top side of the screen to it's location.
            rightPaddleY <= rightPaddleNextY; // assigns the next value of the right paddle's location from the top side of the screen to it's location.
            scorer <= scorerNext;
        end
    end


    // Player 1 animation
    always @(leftPaddleY or refreshRate or player1Up or player1Down) begin
        leftPaddleNextY <= leftPaddleY; // assign leftPaddleY to it's next value   
        if (refreshRate === 1'b1) begin
            // every refreshRate's posedge

            if (player1Up === 1'b1 & leftPaddleY - paddleHeight > paddleVelocity) begin 
                // up button is pressed and paddle can move to up, which mean paddle is not on the top side of the screen.
                leftPaddleNextY <= leftPaddleY - paddleVelocity; // move paddle to the up   
            end

            else if (player1Down === 1'b1 & leftPaddleY < 500) begin
                // down button is pressed and paddle can move down, which mean paddle is not on the bottom side of the screen
                leftPaddleNextY <= leftPaddleY + paddleVelocity;   // move paddle to the down.
            end

            else begin
                leftPaddleNextY <= leftPaddleY;   
            end
        end
    end

    // Player 2 animation
    always @(rightPaddleY or refreshRate or player2Up or player2Down) begin
        rightPaddleNextY <= rightPaddleY; // assign rightPaddleY to it's next value   
        if (refreshRate === 1'b1) begin
            // every refreshRate's posedge

            if (player2Up === 1'b1 & rightPaddleY - paddleHeight > paddleVelocity) begin 
                // up button is pressed and paddle can move to up, which mean paddle is not on the top side of the screen.
                rightPaddleNextY <= rightPaddleY - paddleVelocity; // move paddle to the up   
            end

            else if (player2Down === 1'b1 & rightPaddleY < 500) begin
                // down button is pressed and paddle can move down, which mean paddle is not on the bottom side of the screen
                rightPaddleNextY <= rightPaddleY + paddleVelocity;   // move paddle to the down.
            end

            else begin
                rightPaddleNextY <= rightPaddleY;   
            end
        end
    end

    // Ball animation
    always @(refreshRate or ballX or ballY or velocityXReg or velocityYReg) begin
        ballNextX <= ballX;
        ballNextY <= ballY;

        velocityXNext <= velocityXReg;
        velocityYNext <= velocityYReg;

        scorerNext <= scorer;
        scoreCheckerPlayer1 <= 1'b0; // player 1 did not scored, default value
        scoreCheckerPlayer2 <= 1'b0; // player 2 did not scored, default value

        if (refreshRate === 1'b1) begin
            // every refreshRate's posedge

            if (ballY <= leftPaddleY & ballY >= leftPaddleY - paddleHeight & ballX <= leftPaddleX + paddleWidth + ballRadius & ballX > leftPaddleX + ballRadius) begin
                // if ball hits the left paddle
                velocityXNext <= velocityX; // set the direction of horizontal velocity positive
            end

            if (ballY <= rightPaddleY & ballY >= rightPaddleY - paddleHeight & ballX >= rightPaddleX - ballRadius & ballX < rightPaddleX + paddleWidth - ballRadius) begin
                // if ball hits the right paddle
                velocityXNext <= -velocityX; // set the direction of horizontal velocity negative
            end

            if (ballY < 9) begin
                // if ball hits the top side of the screen
                velocityYNext <= velocityY; // set the direction of vertical velocity positive
            end

            if (ballY > 471) begin
                // if ball hits the top side of the screen
                velocityYNext <= -velocityY; // set the direction of vertical velocity negative
            end
            
            ballNextX <= ballX + velocityXReg; // move the ball's horizontal location   
            ballNextY <= ballY + velocityYReg; // move the ball's vertical location.

            
            
            
            if (ballX >= 630) begin
                // if player 1 scores, ball passes through the horizontal location of right paddle.
                
                //reset the ball's location to its default
                ballNextX <= ballDefaultX;
                ballNextY <= ballDefaultY;

                // stop the ball
                velocityXNext <= 0;
                velocityYNext <= 0;

                // player 1 scored
                scorerNext <= 1'b0;
                scoreCheckerPlayer1 <= 1'b1;
            end
            else begin
                scoreCheckerPlayer1 <= 1'b0;   
            end

            if (ballX <= 8) begin
                // if player 2 scores, ball passes through the horizontal location of left paddle.
                
                //reset the ball's location to its default
                ballNextX <= ballDefaultX;
                ballNextY <= ballDefaultY;

                // stop the ball
                velocityXNext <= 0;
                velocityYNext <= 0;

                // player 1 scored
                scorerNext <= 1'b1;
                scoreCheckerPlayer2 <= 1'b1;
            end
            else begin
                scoreCheckerPlayer2 <= 1'b0;   
            end
        end
    end

    // display left paddle object on the screen
    assign displayLeftPaddle = y < leftPaddleY & y > leftPaddleY - paddleHeight & x > leftPaddleX & x < leftPaddleX + paddleWidth ? 1'b1 : 1'b0; 
    assign rgbLeftPaddle = 12'b111111001001; // color of left paddle

    // display right paddle object on the screen
    assign displayRightPaddle = y < rightPaddleY & y > rightPaddleY - paddleHeight & x > rightPaddleX & x < rightPaddleX + paddleWidth ? 1'b1 : 1'b0; 
    assign rgbRightPaddle = 12'b100111001011; // color of left paddle

    // display ball object on the screen
    assign displayBall = (x - ballX) * (x - ballX) + (y - ballY) * (y - ballY) <= ballRadius * ballRadius ? 1'b1 : 1'b0; 
    assign rgbBall = 12'b100010110100; // color of ball

    // display player 1 score on the screen
    assign displayPlayer1Score = x >= 204 & x < 220 & y >= 80 & y < 88; 
    numberToPixel player1FirstDigitConvertor(totalscorePlayer1[7:4], y - 80, x - 204, player1FirstDigit);
    numberToPixel player1SecondDigitConvertor(totalscorePlayer1[3:0], y - 80, x - 212, player1SecondDigit);
    assign rgbPlayer1Score = x >= 212 ? player1SecondDigit ? 12'b111111111111 : 12'b000000000000
                                    : player1FirstDigit ? 12'b111111111111 : 12'b000000000000; // color of score: white if that area contain number

    // display player 2 score on the screen
    assign displayPlayer2Score = x >= 420 & x < 436 & y >= 80 & y < 88; 
    numberToPixel player2FirstDigitConvertor(totalscorePlayer2[7:4], y - 80, x - 420, player2FirstDigit);
    numberToPixel player2SecondDigitConvertor(totalscorePlayer2[3:0], y - 80, x - 428, player2SecondDigit);
    assign rgbPlayer2Score = x >= 428 ? player2SecondDigit ? 12'b111111111111 : 12'b000000000000
                                    : player2FirstDigit ? 12'b111111111111 : 12'b000000000000; // color of score: white if that area contain number

    always @(posedge clk) begin 
        rgbReg <= rgbNext;   
    end

    // mux
    assign outputMux = {videoOn, displayLeftPaddle, displayRightPaddle, displayBall, displayPlayer1Score, displayPlayer2Score}; 

    // assign rgbNext from outputMux.
    assign rgbNext = outputMux === 6'b100000 ? 12'b000000000000: 
                    outputMux === 6'b110000 ? rgbLeftPaddle: 
                    outputMux === 6'b110100 ? rgbLeftPaddle: 
                    outputMux === 6'b101000 ? rgbRightPaddle: 
                    outputMux === 6'b101100 ? rgbRightPaddle: 
                    outputMux === 6'b100100 ? rgbBall:
                    outputMux === 6'b100101 ? rgbBall:
                    outputMux === 6'b100110 ? rgbBall:
                    outputMux === 6'b100010 ? rgbPlayer1Score:
                    outputMux === 6'b100001 ? rgbPlayer2Score:
                    12'b000000000000;
 
    // output part
    assign rgb = rgbReg; 
    assign scorePlayer1 = scoreCheckerPlayer1; 
    assign scorePlayer2 = scoreCheckerPlayer2; 

endmodule