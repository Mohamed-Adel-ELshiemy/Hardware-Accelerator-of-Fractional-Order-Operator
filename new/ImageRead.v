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
        HIGHT  = 256,   // Image height
        INFILE  = "Lena.mem", // image file
        FILT_WIDTH = 3 
    )  
    (
    input clk_n,clk_p,rst,enable,
    
    output [7:0] filterdPixel
    );
    reg enableBuff =0;
    reg [7:0] pixelOut;
    wire [(FILT_WIDTH*FILT_WIDTH)*8-1:0] buff ;
    wire pixclk,FilterEnable,pixWriteFlag;
    wire clk200,clk100,clk25;
    integer i;
    parameter sizeOfWidth = 8;   // data width
    parameter sizeOfLengthReal = WIDTH*HIGHT;   // image data : 1179648 bytes: 512 * 768 *3 
    reg [7 : 0]   total_memory [0 : sizeOfLengthReal-1];// memory to store  8-bit data image
    reg start;
    integer FilterdImg;
    wire [7:0] red, green, blue;
    // begin by loading the image from pc to memory
    initial begin
        $readmemh(INFILE,total_memory,0,sizeOfLengthReal-1); // read image from INFILE to memory
    i=0;
    FilterdImg = $fopen("F:\\OneDrive\\FractionalImplementationJournal\\VivadoFiles\\FracImgeProc\\FilterdOut.mem") ;
    end


IBUFGDS ibufg_inst (.I(clk_p), .IB(clk_n), .O(pixclk));
// clk_wiz_0 inst
//  (
//  // Clock out ports  
//  .clk_out1(pixclk),
//  // Status and control signals               
// // Clock in ports
//  .clk_in1_p(clk_p),
//  .clk_in1_n(clk_n)
//  );


always @ (posedge pixclk) begin 
    if (rst) begin
        i =0;
        enableBuff=0;
    end else begin
    if (i>(WIDTH*HIGHT)+WIDTH+1) begin
        enableBuff = 0;
         i = 0;
    end else   if (i>WIDTH*HIGHT) begin
        i = i+1;
    end else begin
         enableBuff = 1;
         pixelOut =  total_memory[i];
          i = i+1;
    end
       
       
      
    end
end

 ImgBuffer #(
    .WIDTH(WIDTH),
    .HIGHT(HIGHT),
    .IMGFILE("Lena.mem"),
    .FILT_WIDTH(3)
    )
    imgBuff( 
        .clk(pixclk), 
        .rst(rst), 
        .enable(enableBuff),
        .dataIn(pixelOut),
        .FilterBuffer(buff),
        .FilterFlag(FilterEnable)
     );
     
  KernelMult #(
        .FILT_WIDTH(3)
      )
      kernle( 
       .clk(pixclk),
       .rst(rst),
       .pixWriteFlag(pixWriteFlag),
       .pixelOut(filterdPixel),
       .FilterBuffer(buff),
       .enable(FilterEnable)
       );
    always @(posedge pixclk ) begin
    if (FilterEnable ) begin


        $fwrite(FilterdImg,"%d \n" , $unsigned(filterdPixel) ) ;
       
    end
    end
    
   
endmodule





////////////////////////////////////////////////////////////////////////