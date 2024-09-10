`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 09:21:18 AM
// Design Name: 
// Module Name: FIRFrac
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


module FIRFrac(
    input [31:0] Sig,
    input clk,
    input  rst,
    output reg [31:0] Out
    );
    parameter Order =3;
    reg signed [31:0] Coff [0:Order-1];
    
    reg signed [63:0] tempProd;
    reg signed [63:0] tempProd1;
    reg signed [63:0] tempProd2;
   reg signed [31:0] Reg1;
   reg signed [31:0] Reg2;
   reg signed [31:0] Sum;
    
    initial begin
    
    
        Reg1 =0;
        Reg2 = 0;
        Sum = 0;
        Coff[0] = 16777216.00;		
        Coff[1] = -11601444.86;
        Coff[2] = -1078774.99;
    end
    
    always @(clk)
    begin
        tempProd    <= Sig*Coff[0];
        tempProd1   <=Reg1*Coff[1];
        tempProd2   <=Reg2*Coff[2];
        Sum         <= tempProd[55:24]+tempProd1[55:24]+tempProd2[55:24];
        Out         <= Sum;
    end
    
    
endmodule
