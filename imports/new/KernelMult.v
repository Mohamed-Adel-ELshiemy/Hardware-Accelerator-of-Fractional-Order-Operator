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
      output reg pixWriteFlag,
      input  [(FILT_WIDTH*FILT_WIDTH)*8-1:0]  FilterBuffer 
      );
      
      reg signed [10:0] sum;
      reg signed [7:0] kernel[0:FILT_WIDTH*FILT_WIDTH-1];
      reg signed [8:0] temp1,temp2, temp3;
      reg signed [16:0] temp4,temp5;
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
        if (rst) begin
        
        pixelOut =0;
        sum =0;
        pixWriteFlag =0;
        end else if(enable ) begin
        pixWriteFlag =0;
           $display("Image Segment:\n");
           $display("%d %d  %d\n", $unsigned(FilterBuffer[(8)*8+7 -:8]),$unsigned(FilterBuffer[(7)*8+7 -:8]),$unsigned(FilterBuffer[(6)*8+7 -:8]));
           $display("%d %d  %d\n", $unsigned(FilterBuffer[(5)*8+7 -:8]),$unsigned(FilterBuffer[(4)*8+7 -:8]),$unsigned(FilterBuffer[(3)*8+7 -:8]));
           $display("%d %d  %d\n", $unsigned(FilterBuffer[(2)*8+7 -:8]), $unsigned(FilterBuffer[(1)*8+7 -:8]), $unsigned(FilterBuffer[(0)*8+7 -:8]));
            
           temp1 = FilterBuffer[8*8+7 -:8] ;
           sum =temp1 * kernel[0];
           sum = sum+FilterBuffer[2*8+7 -:8] * kernel[6];
           ///////////
           temp2 =  FilterBuffer[7*8+7 -:8] ;
           temp4 = temp2* kernel[1];
           sum = sum+temp4;
           sum = sum+  FilterBuffer[1*8+7 -:8] * kernel[7];
           //////////
           temp3 =  FilterBuffer[6*8+7 -:8];
           temp5 = temp3 *  kernel[2];
           sum = sum +temp5;
           sum = sum+FilterBuffer[0*8+7 -:8] * kernel[8];
           ///////////////////////////////////////////////
           sum = sum+ FilterBuffer[5*8+7 -:8] * kernel[3];
           sum = sum+ FilterBuffer[4*8+7 -:8] * kernel[4];
           sum = sum+ FilterBuffer[3*8+7 -:8] * kernel[5];
           ///////////////////////////////////////////////
            if (sum > 255) begin
                    pixelOut = 255;
           end else if  (sum<0 ) begin
                 pixelOut =0;
           end else begin
                  pixelOut =sum;
                  
            end
        pixWriteFlag =1;
        end      
 
    end
      
      
      
      

endmodule
