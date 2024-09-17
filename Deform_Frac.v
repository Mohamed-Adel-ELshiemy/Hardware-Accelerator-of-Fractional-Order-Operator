

module Deform_Frac(

input clk, Rst_n,
input  [31:0] Signal,
output reg [31:0] Output,
output reg OutInd
);

reg signed [63:0] temp;
reg signed [31:0] temp1;
reg signed [31:0] temp2;
reg signed [31:0] Prev_Sig;
integer Step_Beta = 16861102;
integer alpha = 8388608; // .5 *2^24
integer step =   167770; // .01 *2^24
integer beta = 8388608; // (1- alpha)


initial 
begin
Prev_Sig = 0;
OutInd = 0;

end
always @ (posedge clk)
begin
    if (!Rst_n)
    begin
//        temp = (2^24)*beta;
//        temp1 = temp[55:24];
        temp2 = Signal - Prev_Sig;
        temp = temp2 *alpha;
        temp2 = temp[55:24];
        temp2 = temp2 + Signal;
        temp = temp2*Step_Beta;
        temp1 = temp[55:24];
        temp2 = temp1-Signal;
        temp = temp2*100;
        Output = temp[31:0];
        Prev_Sig = Signal;
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
