`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:00:39 09/20/2021
// Design Name:   RL_Int
// Module Name:   D:/Alaa/RA/ISE/RL/RL_Integral/Simulat.v
// Project Name:  RL_Integral
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RL_Int
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Simulat;

	// Inputs
	reg clk;
	reg rst;

	wire led,led2;
	// Outputs
	wire [3:0] JA;
	wire OutInd;
	wire SigInd;

	// Instantiate the Unit Under Test (UUT)
	wrapper uut (
		.clk(clk), 
		.rst(rst), 
		.led(led),
		.OutInd(OutInd),
		.SigInd(SigInd),
		.JA(JA)
	);
	

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#20;
		rst = 0;
		
        
		// Add stimulus here

	end
	always
	begin

	forever #10 clk = ~clk;
	end
      
endmodule

