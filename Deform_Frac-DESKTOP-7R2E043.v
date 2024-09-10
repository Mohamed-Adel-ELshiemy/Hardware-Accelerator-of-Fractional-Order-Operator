

module Deform_Frac(

input clk, rst,
input  [31:0] Signal,
output reg [31:0] Output,
output reg OutInd
);

reg signed [63:0] temp;
reg signed [31:0] temp1;
reg signed [31:0] temp2;
reg signed [31:0] PrevSig;
integer StepBeta = 16861102;
integer alpha = 8388608; // .5 *2^24
integer step =   167770; // .01 *2^24
integer beta = 8388608; // (1- alpha)


initial 
begin
PrevSig = 0;
OutInd = 0;

end
always @ (posedge clk)
begin
    if (!rst)
    begin
//        temp = (2^24)*beta;
//        temp1 = temp[55:24];
        temp2 = Signal - PrevSig;
        temp = temp2 *alpha;
        temp2 = temp[55:24];
        temp2 = temp2 +Signal;
        temp = temp2*StepBeta;
        temp1 = temp[55:24];
        temp2 = temp1-Signal;
        temp = temp2*100;
        Output = temp[31:0];
        PrevSig = Signal;
//        temp = temp1<<24;
//        Output = temp/step;      
        OutInd = ~OutInd;  
        if ((Output) == -49028  )
        begin
         $display("Out: %d \n",$signed(Output));
        end
        
    end
end

endmodule