

module Deform_Frac(

input             clk_100HZ, Rst_n,
input      [31:0] Signal_i,
output reg [31:0] Output_o,
output reg        OutInd_o
);

reg signed [63:0] temp0_reg;
reg signed [31:0] temp1_reg;
reg signed [31:0] temp2_reg;
reg signed [31:0] Prev_Sig_reg;
/*Conestant needed values*/    
integer STEP_BETA = 16861102;
integer ALPHA = 8388608; // .5 *2^24
integer STEP =   167770; // .01 *2^24
integer BETA = 8388608; // (1- ALPHA)


initial 
begin
Prev_Sig_reg = 0;
OutInd_o = 0;

end
always @ (posedge clk_100HZ)
begin
    if (!Rst_n)
    begin
        //        temp0_reg = (2^24) * BETA;
//        temp1_reg = temp0_reg[55:24];
        temp2_reg = Signal_i - Prev_Sig_reg;
        temp0_reg = temp2_reg * ALPHA;
        temp2_reg = temp0_reg[55:24];
        temp2_reg = temp2_reg + Signal_i;
        temp0_reg = temp2_reg * STEP_BETA;
        temp1_reg = temp0_reg[55:24];
        temp2_reg = temp1_reg - Signal_i;
        temp0_reg = temp2_reg * 100;
        Output_o = temp0_reg[31:0];
        Prev_Sig_reg = Signal_i;
//        temp0_reg = temp1_reg << 24;
//        Output_o = temp0_reg / STEP;      
        OutInd_o = ~OutInd_o;  
        if ((Output_o) == -49028  )
        begin
         $display("Out: %d \n",$signed(Output_o));
        end
        
    end
end

endmodule
