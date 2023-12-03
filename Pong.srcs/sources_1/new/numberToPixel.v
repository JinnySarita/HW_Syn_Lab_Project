`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Thanat Wongsamut
// 
// Create Date: 11/07/2023 00:33:00 PM
// Design Name: Convert 4 bits BCD to 8x8 pixels
// Module Name: numberToPixel
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

module numberToPixel(
  input [3:0] number,
  input [2:0] rowNum,
  input [2:0] colNum,
  output reg pixel
);
  reg [7:0] pixels;

  always @(*) begin
    case ({number, rowNum})
      7'b0000000: pixels = 8'b11111110; // XXXXXXX 
      7'b0000001: pixels = 8'b11000110; // XX   XX 
      7'b0000010: pixels = 8'b11000110; // XX   XX 
      7'b0000011: pixels = 8'b11000110; // XX   XX 
      7'b0000100: pixels = 8'b11000110; // XX   XX 
      7'b0000101: pixels = 8'b11000110; // XX   XX 
      7'b0000110: pixels = 8'b11111110; // XXXXXXX  
      7'b0000111: pixels = 8'b00000000; //         

      7'b0001000: pixels = 8'b00000110; //      XX
      7'b0001001: pixels = 8'b00000110; //      XX    
      7'b0001010: pixels = 8'b00000110; //      XX    
      7'b0001011: pixels = 8'b00000110; //      XX    
      7'b0001100: pixels = 8'b00000110; //      XX    
      7'b0001101: pixels = 8'b00000110; //      XX    
      7'b0001110: pixels = 8'b00000110; //      XX  
      7'b0001111: pixels = 8'b00000000; //         

      7'b0010000: pixels = 8'b11111110; // XXXXXXX
      7'b0010001: pixels = 8'b00000110; //      XX  
      7'b0010010: pixels = 8'b00000110; //      XX 
      7'b0010011: pixels = 8'b11111110; // XXXXXXX   
      7'b0010100: pixels = 8'b11000000; // XX     
      7'b0010101: pixels = 8'b11000000; // XX    
      7'b0010110: pixels = 8'b11111110; // XXXXXXX  
      7'b0010111: pixels = 8'b00000000; //         

      7'b0011000: pixels = 8'b11111110; // XXXXXXX  
      7'b0011001: pixels = 8'b00000110; //      XX  
      7'b0011010: pixels = 8'b00000110; //      XX  
      7'b0011011: pixels = 8'b11111110; // XXXXXXX   
      7'b0011100: pixels = 8'b00000110; //      XX  
      7'b0011101: pixels = 8'b00000110; //      XX  
      7'b0011110: pixels = 8'b11111110; // XXXXXXX   
      7'b0011111: pixels = 8'b00000000; //         

      7'b0100000: pixels = 8'b11000110; // XX   XX  
      7'b0100001: pixels = 8'b11000110; // XX   XX  
      7'b0100010: pixels = 8'b11000110; // XX   XX  
      7'b0100011: pixels = 8'b11111110; // XXXXXXX  
      7'b0100100: pixels = 8'b00000110; //      XX 
      7'b0100101: pixels = 8'b00000110; //      XX  
      7'b0100110: pixels = 8'b00000110; //      XX 
      7'b0100111: pixels = 8'b00000000; //         

      7'b0101000: pixels = 8'b11111110; // XXXXXXX  
      7'b0101001: pixels = 8'b11000000; // XX      
      7'b0101010: pixels = 8'b11000000; // XX   
      7'b0101011: pixels = 8'b11111110; // XXXXXXX  
      7'b0101100: pixels = 8'b00000110; //      XX  
      7'b0101101: pixels = 8'b00000110; //      XX  
      7'b0101110: pixels = 8'b11111110; // XXXXXXX   
      7'b0101111: pixels = 8'b00000000; //         

      7'b0110000: pixels = 8'b11111110; // XXXXXXX   
      7'b0110001: pixels = 8'b11000000; // XX     
      7'b0110010: pixels = 8'b11000000; // XX      
      7'b0110011: pixels = 8'b11111110; // XXXXXXX   
      7'b0110100: pixels = 8'b11000110; // XX   XX  
      7'b0110101: pixels = 8'b11000110; // XX   XX  
      7'b0110110: pixels = 8'b11111110; // XXXXXXX   
      7'b0110111: pixels = 8'b00000000; //         

      7'b0111000: pixels = 8'b11111110; // XXXXXXX  
      7'b0111001: pixels = 8'b00000110; //      XX  
      7'b0111010: pixels = 8'b00000110; //      XX  
      7'b0111011: pixels = 8'b00000110; //      XX   
      7'b0111100: pixels = 8'b00000110; //      XX    
      7'b0111101: pixels = 8'b00000110; //      XX    
      7'b0111110: pixels = 8'b00000110; //      XX    
      7'b0111111: pixels = 8'b00000000; //         

      7'b1000000: pixels = 8'b11111110; // XXXXXXX 
      7'b1000001: pixels = 8'b11000110; // XX   XX  
      7'b1000010: pixels = 8'b11000110; // XX   XX  
      7'b1000011: pixels = 8'b11111110; // XXXXXXX 
      7'b1000100: pixels = 8'b11000110; // XX   XX  
      7'b1000101: pixels = 8'b11000110; // XX   XX  
      7'b1000110: pixels = 8'b11111110; // XXXXXXX 
      7'b1000111: pixels = 8'b00000000; //         

      7'b1001000: pixels = 8'b11111110; // XXXXXXX   
      7'b1001001: pixels = 8'b11000110; // XX   XX  
      7'b1001010: pixels = 8'b11000110; // XX   XX  
      7'b1001011: pixels = 8'b11111110; // XXXXXXX  
      7'b1001100: pixels = 8'b00000110; //      XX  
      7'b1001101: pixels = 8'b00000110; //      XX   
      7'b1001110: pixels = 8'b11111110; // XXXXXXX    
      7'b1001111: pixels = 8'b00000000; //                       
    
      default: pixels = 8'b00000000;
    endcase

    pixel = pixels[7 - colNum];
  end

endmodule