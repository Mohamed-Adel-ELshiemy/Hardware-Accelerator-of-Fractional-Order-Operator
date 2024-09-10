`timescale 1ns / 1ps

module wrapper(
input clk,
input rst,
output led, OutInd, SigInd, clkOut,
output [3:0]JA
   );
wire [11:0] counter2;
 reg  [11:0] DACInput;
wire clk_div;
wire clk_div2;
wire clk_div3;
wire [31:0] Output;
wire [31:0] Signal;
reg [11:0] temp ;
reg [11:0] temp2; 
wire [11:0] Out;
wire [11:0] Sig;

integer HardwareOutput,DACInp,SignalOutput;
integer  count;



 // GL Clk
    clock_divider #(
        .max_count(50)
    ) clk_div1er (
        .clk(clk), 
        .rst(rst), 
        .clk_div(clk_div)
    );
    // DAC Clk
    clock_divider #(
        .max_count(3)
    )clk_div2er(
        .clk(clk), 
        .rst(rst), 
        .clk_div(clk_div2)
    );
    
	 // Start DAC
    clock_divider #(
        .max_count(40)
    )clk_div3er(
        .clk(clk), 
        .rst(rst), 
        .clk_div(clk_div3)
    );

	SignalLUT signal(
		.control(clk_div),
		.rst(rst),
		.Signal(Signal),
		.SigInd(SigInd)
		 );



	RL_Int RL_Block(
		.clk(clk_div),
		.rst(rst),
		.Signal(Signal),
		.Output(Output),
		.OutInd(OutInd)
		 );
	 
assign Out = Output[25:14]+2048;
assign Sig = Signal[25:14]+2048;
assign clkOut =clk;

DA2RefComp refComp1 (
    .CLK(clk_div2), 
    .RST(rst), 
    .D1(JA[1]), 
    .D2(JA[2]), 
    .CLK_OUT(JA[3]), 
    .nSYNC(JA[0]), 
	 //Output signal
    .DATA1(Out), 
    .DATA2(Sig), 
    .START(clk_div3), 
    .DONE(led)
    );
	 
	 
	 
	 
	 
	 

   
	 


initial 
	begin
	temp = 0;
	temp2 = 0;
	count =16;
	SignalOutput = $fopen("F:\\Alaa\\RA\\Vivado\\RL\\RL_Inregral\\Signal.txt","w") ;
	DACInp = $fopen("F:\\Alaa\\RA\\Vivado\\RL\\RL_Inregral\\DAC.txt") ;
	HardwareOutput = $fopen("F:\\Alaa\\RA\\Vivado\\RL\\RL_Inregral\\HardwareSign.txt","w") ;

	end
	
	
	
	always @( Output)
begin
		$fwrite(HardwareOutput,"%d \n" , $signed(Output) ) ;
		$display("Out: %d \n",$signed(Output));
end
always @(  negedge JA[3] )
begin
			
	if ( JA[0] ==0 )
	begin 
		count = count-1;
		if (count<12)
			begin
				temp = {temp[10:0],JA[1]};
				temp2 = {temp2[10:0],JA[2]};
			
			end
		//{JA[2],temp[12:12+counter],temp[11:11-counter], JA[1],zeors[10-counter,]}

		
		
		if (count == 0) 
		begin
		
			count =16;
			$fwrite(DACInp,"%d \n" , (temp) ) ;
			$fwrite(SignalOutput,"%d \n" , (temp2) ) ;
			$display("Out: %d \n",(temp));
			
			temp =0;
			temp2 =0;

		end
	

	end
end


endmodule
