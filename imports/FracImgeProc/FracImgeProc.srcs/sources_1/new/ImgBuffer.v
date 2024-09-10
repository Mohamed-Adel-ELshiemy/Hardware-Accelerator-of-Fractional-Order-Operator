`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2022 11:41:21 AM
// Design Name: 
// Module Name: ImgBuffer
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


module ImgBuffer #(
    parameter WIDTH = 256,
    HIGHT = 256,
    IMGFILE = "Lena.mem",
    FILT_WIDTH =3
    )
    ( input clk, rst, enable,
     input [7:0] dataIn,
     output reg [7:0] FilterBuffer [FILT_WIDTH*FILT_WIDTH-1:0]
     );
     
     
     reg [7:0] PixelBuffer [(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1:0];
     reg [15:0] pixelCounter;
     reg [3:0] Index;
     integer i,j;
     always @ (posedge clk, negedge rst ) begin
        if ( rst == 0 ) begin
            for (i=0; i<= (FILT_WIDTH*FILT_WIDTH-1); i= i+1) begin
                FilterBuffer[i] = 0;
            end
            for (i=0; i<=(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1; i= i+1) begin
                PixelBuffer[i] = 0;
            end
     
        end else if (enable) begin
            
            // Fill The top row of FilterBuffer
            for (j=(FILT_WIDTH*FILT_WIDTH)-1; j>(2*FILT_WIDTH); j=j-1) begin
                 FilterBuffer[j] =  FilterBuffer[j-1];
            end
            FilterBuffer[j] =PixelBuffer[(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1];
            // Fill the inbetween pixel buffer
                //Ex//i=(4-3)*(3-1)-1=1 >>>>>>>>>>>>  i<(4-3)*(3-1)-1-(4-3)
            for (i=(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1; i>((WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1-(WIDTH-FILT_WIDTH)); i=i-1) begin
                PixelBuffer[i] =  PixelBuffer[i-1];
            end
             PixelBuffer[i] = FilterBuffer[j-1];
             // Fill The middle row of FilterBuffer
             for (j=j; j>(FILT_WIDTH); j=j-1) begin
                  FilterBuffer[j] =  FilterBuffer[j-1];
             end
             FilterBuffer[j] =PixelBuffer[(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1-(WIDTH-FILT_WIDTH)];
             // Fill the inbetween pixel buffer
             for (i=i; i>0; i=i-1) begin
                 PixelBuffer[i] =  PixelBuffer[i-1];
             end
                PixelBuffer[i] = FilterBuffer[j-1];
              // Fill The botom row of FilterBuffer
            for (j=j; j>0; j=j-1) begin
                 FilterBuffer[j] =  FilterBuffer[j-1];
            end
            FilterBuffer[0] =dataIn;
        end
        
        
     end
   
endmodule
