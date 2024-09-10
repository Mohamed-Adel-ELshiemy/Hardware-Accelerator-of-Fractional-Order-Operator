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
        parameter     WIDTH  = 512,   // Image width
        HIGHT  = 5126,   // Image height
        INFILE  = "Lena.mem", // image file
        FILT_WIDTH = 3 
    )  
    (
    input clk_n,clk_p,rst,enable,
    
    output [2:0] TMDSp, TMDSn,
     output TMDSp_clock, TMDSn_clock
    );
    reg enableBuff =0;
    reg [7:0] pixelOut;
    wire  [7:0] filterdPixel;
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
  // Counter for image pixels
reg [9:0] CounterX, CounterY;
// Important image control signals and information, DrawArea defines the size of image
reg hSync, vSync, DrawArea;
// Update draw area based on the values of x and y counters
always @(posedge pixclk) DrawArea <= (CounterX<640) && (CounterY<480);
always @(posedge pixclk) CounterX <= (CounterX==799) ? 0 : CounterX+1;
always @(posedge pixclk) if(CounterX==799) CounterY <= (CounterY==524) ? 0 : CounterY+1;

always @(posedge pixclk) hSync <= (CounterX>=656) && (CounterX<752);
always @(posedge pixclk) vSync <= (CounterY>=490) && (CounterY<492);

assign red = filterdPixel;
assign green = filterdPixel;
assign blue = filterdPixel;

////////////////////////////////////////////////////////////////////////
wire [9:0] TMDS_red, TMDS_green, TMDS_blue;
TMDS_encoder encode_R(.clk(pixclk), .VD(red  ), .CD(2'b00)        , .VDE(DrawArea), .TMDS(TMDS_red));
TMDS_encoder encode_G(.clk(pixclk), .VD(green), .CD(2'b00)        , .VDE(DrawArea), .TMDS(TMDS_green));
TMDS_encoder encode_B(.clk(pixclk), .VD(blue ), .CD({vSync,hSync}), .VDE(DrawArea), .TMDS(TMDS_blue));
////////////////////////////////////////////////////////////////////////
wire clk_TMDS, DCM_TMDS_CLKFX;  // 25MHz x 10 = 250MHz
DCM_SP #(.CLKFX_MULTIPLY(10)) DCM_TMDS_inst(.CLKIN(pixclk), .CLKFX(DCM_TMDS_CLKFX), .RST(1'b0));
BUFG BUFG_TMDSp(.I(DCM_TMDS_CLKFX), .O(clk_TMDS));

////////////////////////////////////////////////////////////////////////
reg [3:0] TMDS_mod10=0;  // modulus 10 counter
reg [9:0] TMDS_shift_red=0, TMDS_shift_green=0, TMDS_shift_blue=0;
reg TMDS_shift_load=0;
always @(posedge clk_TMDS) TMDS_shift_load <= (TMDS_mod10==4'd9);

always @(posedge clk_TMDS)
begin
	TMDS_shift_red   <= TMDS_shift_load ? TMDS_red   : TMDS_shift_red  [9:1];
	TMDS_shift_green <= TMDS_shift_load ? TMDS_green : TMDS_shift_green[9:1];
	TMDS_shift_blue  <= TMDS_shift_load ? TMDS_blue  : TMDS_shift_blue [9:1];	
	TMDS_mod10 <= (TMDS_mod10==4'd9) ? 4'd0 : TMDS_mod10+4'd1;
end

OBUFDS OBUFDS_red  (.I(TMDS_shift_red  [0]), .O(TMDSp[2]), .OB(TMDSn[2]));
OBUFDS OBUFDS_green(.I(TMDS_shift_green[0]), .O(TMDSp[1]), .OB(TMDSn[1]));
OBUFDS OBUFDS_blue (.I(TMDS_shift_blue [0]), .O(TMDSp[0]), .OB(TMDSn[0]));
OBUFDS OBUFDS_clock(.I(pixclk), .O(TMDSp_clock), .OB(TMDSn_clock));
///////////////////////////////////////////////////////////////////

  clk_wiz_0 clk_wiz_inst
  (
  // Clock out ports  
  .clk20(pixclk),
//  .clk100(clk100),
//  .clk25(pixclk),
  // Status and control signals               
//  .reset(reset), 
//  .locked(locked),
 // Clock in ports
  .clk_in1_p(clk_p),
  .clk_in1_n(clk_n)
  );


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
module TMDS_encoder(
	input clk,
	input [7:0] VD,  // video data (red, green or blue)
	input [1:0] CD,  // control data
	input VDE,  // video data enable, to choose between CD (when VDE=0) and VD (when VDE=1)
	output reg [9:0] TMDS = 0
);

wire [3:0] Nb1s = VD[0] + VD[1] + VD[2] + VD[3] + VD[4] + VD[5] + VD[6] + VD[7];
wire XNOR = (Nb1s>4'd4) || (Nb1s==4'd4 && VD[0]==1'b0);
wire [8:0] q_m = {~XNOR, q_m[6:0] ^ VD[7:1] ^ {7{XNOR}}, VD[0]};

reg [3:0] balance_acc = 0;
wire [3:0] balance = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7] - 4'd4;
wire balance_sign_eq = (balance[3] == balance_acc[3]);
wire invert_q_m = (balance==0 || balance_acc==0) ? ~q_m[8] : balance_sign_eq;
wire [3:0] balance_acc_inc = balance - ({q_m[8] ^ ~balance_sign_eq} & ~(balance==0 || balance_acc==0));
wire [3:0] balance_acc_new = invert_q_m ? balance_acc-balance_acc_inc : balance_acc+balance_acc_inc;
wire [9:0] TMDS_data = {invert_q_m, q_m[8], q_m[7:0] ^ {8{invert_q_m}}};
wire [9:0] TMDS_code = CD[1] ? (CD[0] ? 10'b1010101011 : 10'b0101010100) : (CD[0] ? 10'b0010101011 : 10'b1101010100);

always @(posedge clk) TMDS <= VDE ? TMDS_data : TMDS_code;
always @(posedge clk) balance_acc <= VDE ? balance_acc_new : 4'h0;
endmodule


////////////////////////////////////////////////////////////////////////