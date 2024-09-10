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
    (   input clk, rst, enable,
        input [7:0] dataIn,
        output reg  [(FILT_WIDTH*FILT_WIDTH)*8-1:0]  FilterBuffer ,
        output reg FilterFlag
     );
     
    
     reg [7:0] PixelBuffer [(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1:0];
     reg [15:0] pixelCounter;
     reg [3:0] Index;
     reg DoneBuffering;
     integer i,j,k;
     initial begin
         for (i=0; i<= (FILT_WIDTH*FILT_WIDTH-1); i= i+1) begin
                 FilterBuffer[i*8+7 -:8] = 0;
         end
         for (i=0; i<=(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1; i= i+1) begin
             PixelBuffer[i] = 0;
         end
         FilterFlag =0;
         k =0;
         DoneBuffering = 0;
     end
     always @ (posedge clk, posedge rst ) begin
        if ( rst == 1 ) begin
            for (i=0; i<= (FILT_WIDTH*FILT_WIDTH-1); i= i+1) begin
                FilterBuffer[i*8+7 -:8] = 0;
            end
            for (i=0; i<=(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1; i= i+1) begin
                PixelBuffer[i] = 0;
            end
            k=0;
            FilterFlag =0;
            
     
        end else if (enable) begin
        if (DoneBuffering ==0) begin
           
            // Fill The top row of FilterBuffer
            for (j=(FILT_WIDTH*FILT_WIDTH)-1; j>(2*FILT_WIDTH); j=j-1) begin
                 FilterBuffer[j*8+7 -:8] =  FilterBuffer[(j-1)*8+7 -:8];
            end
            FilterBuffer[j*8+7 -:8] =PixelBuffer[(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1];//ex FilterBuffer[6] = PixelBuffer[(4-3)*(3-1)-1] >>>>PixelBuffer(1)<<<<
            // Fill the inbetween pixel buffer
                //Ex//i=(4-3)*(3-1)-1=1 >>>>>>>>>>>>  i<(4-3)*(3-1)-1-(4-3)
            for (i=(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1; i>((WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1-(WIDTH-FILT_WIDTH-1)); i=i-1) begin
                PixelBuffer[i] =  PixelBuffer[i-1];
            end
             PixelBuffer[i] = FilterBuffer[(j-1)*8+7 -:8]; //PixelBuffer[1] = FilterBuffer(5*8+7:0)>>>FilterBuffer(5)<<<
             // Fill The middle row of FilterBuffer
             for (j=j-1; j>(FILT_WIDTH); j=j-1) begin
                 FilterBuffer[j*8+7 -:8] =  FilterBuffer[(j-1)*8+7 -:8];
             end
             FilterBuffer[j*8+7 -:8]  =PixelBuffer[(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1)-1-(WIDTH-FILT_WIDTH)]; // FilterBuffer(3) = PixelBuffer(0)
             // Fill the inbetween pixel buffer
             for (i=i-1; i>0; i=i-1) begin
                 PixelBuffer[i] =  PixelBuffer[i-1];
             end
                PixelBuffer[i] = FilterBuffer[(j-1)*8+7 -:8]; // PixelBuffer(0) = FilterBuffer(2)
              // Fill The botom row of FilterBuffer
            for (j=j-1; j>0; j=j-1) begin
                FilterBuffer[j*8+7 -:8] =  FilterBuffer[(j-1)*8+7 -:8];
            end
          
            if (k >= WIDTH*(FILT_WIDTH/2)+(FILT_WIDTH/2)) begin //Ex:     4*(3/2) + (3/2) = 4*1+1 = 5
                FilterFlag = 1;
            end
            k = k+1;
            if( k >= (WIDTH*HIGHT +WIDTH+(FILT_WIDTH/2)))  begin
                           DoneBuffering=1;
             end else if ( k > WIDTH*HIGHT) begin
                
                FilterBuffer[7:0] =0; //FilterBuffer(0) = dataIn
                       
             end else begin
              FilterBuffer[7:0] =dataIn; //FilterBuffer(0) = dataIn
                    // If the buffer is filled with enough pixels to begin processing
            end
            
        end else begin
            DoneBuffering = 0;
            k =0;
            FilterFlag=0;
            FilterBuffer = 0;
            for (i = 0; i<(WIDTH-FILT_WIDTH)*(FILT_WIDTH-1); i=i+1) begin
                PixelBuffer[i] = 0; 
            end
        end
        end
     end
   
endmodule
