`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2022 01:13:17 PM
// Design Name: 
// Module Name: ImageRead
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


module ImageRead #(
        parameter     WIDTH  = 256,   // Image width
        HEIGHT  = 256,   // Image height
        INFILE  = "Lena.mem" // image file
    )  
    (
    input clk,rst,
    output reg led
    );
    reg signed [9:0] sum;
    integer i,j,k,u;
    parameter Maskwidth = 3;
    parameter sizeOfWidth = 8;   // data width
    parameter sizeOfLengthReal = WIDTH*HEIGHT;   // image data : 1179648 bytes: 512 * 768 *3 
    parameter BufferLenght = (Maskwidth-1)*WIDTH+Maskwidth;
    reg signed [8:0] Buffer [BufferLenght-1:0];
    reg signed [7:0] kernel[0:Maskwidth*Maskwidth-1];
    reg [7 : 0]   total_memory [0 : sizeOfLengthReal-1];// memory to store  8-bit data image
    reg [7 : 0] outputImg [0 : sizeOfLengthReal-WIDTH*2-5];// memory to store  8-bit data image
    reg start;

    // begin by loading the image from pc to memory
    initial begin
        $readmemh(INFILE,total_memory,0,sizeOfLengthReal-1); // read image from INFILE to memory
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
    
    
always @ (clk) begin
   
    // Fill the Buffer for the first time
    if ( i < BufferLenght) begin
         Buffer[i] = total_memory[i];
         // If the  buffer done filling
    end
    else begin

       // shift the data in the buffer and remove the last one
        for (j=1;j<BufferLenght;j=j+1) begin
              Buffer[j-1] = Buffer[j];
        end
         // Update the file with the new pixel
        Buffer[BufferLenght-1] =  total_memory[i];
    end
    
         
   if (i >= (((Maskwidth/2)+1)*WIDTH+(Maskwidth/2)+1) ) begin
        $display("Image Segment:\n");
        $display("%d %d  %d\n", $unsigned(Buffer[0]),$unsigned(Buffer[1]),$unsigned(Buffer[2]));
        $display("%d %d  %d\n", $unsigned(Buffer[WIDTH]),$unsigned(Buffer[WIDTH+1]),$unsigned(Buffer[WIDTH+2]));
        $display("%d %d  %d\n", $unsigned(Buffer[BufferLenght-3]), $unsigned(Buffer[BufferLenght-2]), $unsigned(Buffer[BufferLenght-1]));
        sum = Buffer[0] * kernel[0];
        sum = sum+ Buffer[BufferLenght-3] * kernel[6];
        sum = sum+ Buffer[1] * kernel[1];
        sum = sum+ Buffer[BufferLenght-2] * kernel[7]; 
        sum = sum+ Buffer[2] * kernel[2];
        sum = sum+ Buffer[BufferLenght-1] * kernel[8];
        //////////////////////
        sum = sum+ Buffer[WIDTH-1] * kernel[3];
        sum = sum+ Buffer[WIDTH] * kernel[4];
        sum = sum+ Buffer[WIDTH+1] * kernel[5];
        //////////////////////
        
        outputImg[u] = sum;
        u = u+1;
    end

    i =i+1;
    //        led = total_memory[0][0:0];
end
    
   
endmodule
