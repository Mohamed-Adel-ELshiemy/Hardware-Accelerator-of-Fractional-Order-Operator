`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2022 12:28:53 PM
// Design Name: 
// Module Name: KernelMult
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


module KernelMult #(
       parameter  FILT_WIDTH =3
     )
     ( input clk, rst, enable,
      output reg [7:0] pixelOut,
      input  [7:0] FilterBuffer [FILT_WIDTH*FILT_WIDTH-1:0]
      );
      reg [10:0] sum;
      reg signed [7:0] kernel[0:FILT_WIDTH*FILT_WIDTH-1];
      integer i;
      
        initial begin
            i=0;
            kernel[0] = -1;
            kernel[1] = -2;
            kernel[2] = -1;
            
            kernel[3] = 0;
            kernel[4] = 0;
            kernel[5] = 0;
            
            kernel[6] = 1;
            kernel[7] = 2;
            kernel[8] = 1;
        end
        
    always @ (posedge clk, negedge rst) begin
        if (!rst) begin
        
        pixelOut =0;
        sum =0;
        end else begin
           $display("Image Segment:\n");
           $display("%d %d  %d\n", $unsigned(FilterBuffer[8]),$unsigned(FilterBuffer[7]),$unsigned(FilterBuffer[6]));
           $display("%d %d  %d\n", $unsigned(FilterBuffer[5]),$unsigned(FilterBuffer[4]),$unsigned(FilterBuffer[3]));
           $display("%d %d  %d\n", $unsigned(FilterBuffer[2]), $unsigned(FilterBuffer[1]), $unsigned(FilterBuffer[0]));
           sum = FilterBuffer[8] * kernel[0];
           sum = sum+ FilterBuffer[2] * kernel[6];
           sum = sum+ FilterBuffer[7] * kernel[1];
           sum = sum+ FilterBuffer[1] * kernel[7]; 
           sum = sum+ FilterBuffer[6] * kernel[2];
           sum = sum+ FilterBuffer[0] * kernel[8];
           //////////////////////
           sum = sum+ FilterBuffer[5] * kernel[3];
           sum = sum+ FilterBuffer[4] * kernel[4];
           sum = sum+ FilterBuffer[3] * kernel[5];
           //////////////////////
          
            pixelOut = sum;
 
        end      
 
    end
      
      
      
      

endmodule
