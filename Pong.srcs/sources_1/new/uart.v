`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 09:59:35 PM
// Design Name: 
// Module Name: uart
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

module uart(
    input clk,
    input RsRx,
    output RsTx,
    output [3:0] ws85l
    );
    
    reg en, last_rec;
    reg [7:0] data_in;
    reg [3:0] movement = 4'b0000; // 1st player up/down, 2nd player up/down
    wire [7:0] data_out;
    wire sent, received, baud;
    
    assign ws85l = {movement}; // assign movement and l to ws85l
    
    baudrate_gen baudrate_gen(clk, baud); // generate baud rate
    uart_rx receiver(baud, RsRx, received, data_out); // encode data to 8 bits
    uart_tx transmitter(baud, data_in, en, sent, RsTx); // check if input is valid
    
    always @(posedge baud) begin
        if (en) en = 0;
        if (~last_rec & received) begin
            data_in = data_out;
            if (data_in == 8'h77 || data_in == 8'h73 // w,s,8,5,l keys
            || data_in == 8'h38 || data_in == 8'h35) en = 1; // recieve only w,s,8,5,l keys
        end
        if (last_rec & received) begin
            data_in = 0;
        end
        last_rec = received;
    end
    
    always @(posedge baud) begin
        if (sent) begin
            case (data_in)
                8'h77: movement[3:2] = 2'b10; // w 1st player up
                8'h73: movement[3:2] = 2'b01; // s 1st player down
                8'h38: movement[1:0] = 2'b10; // 8 2nd player up
                8'h35: movement[1:0] = 2'b01; // 5 2nd player down
                default: movement[3:0] = 4'b0000;
            endcase
        end
    end
   
    
endmodule
