`timescale 1ns/1ps

module Deform_Frac(
                    input                     clk_100HZ, 
                    input                     Rst_n,
                    input       signed [31:0] Signal_i,
                    output  reg signed [31:0] Output_o,
                    output  reg signed        OutInd_o
                   );

// Internal registers
reg signed [63:0] temp0_comb;
reg signed [31:0] temp1_comb;
reg signed [31:0] temp2_comb;
reg signed [31:0] Prev_Sig_reg;
reg               OutInd_o_reg;

// Constant values as parameters (for synthesis purposes)
localparam STEP_BETA = 16861102;
localparam ALPHA     = 8388608;  // .5 *2^24
localparam STEP      = 167770;   // .01 *2^24
localparam BETA      = 8388608;  // (1 - ALPHA)


// Always block for combinational logic  
always @ (*)
begin
 // Perform the main calculation when reset is deasserted
        temp2_comb = Signal_i - Prev_Sig_reg;
        temp0_comb = temp2_comb * ALPHA;
        temp2_comb = temp0_comb[55:24];
        temp2_comb = temp2_comb + Signal_i;
        temp0_comb = temp2_comb * STEP_BETA;
        temp1_comb = temp0_comb[55:24];
        temp2_comb = temp1_comb - Signal_i;
        temp0_comb = temp2_comb * 100;
        Output_o = temp0_comb[31:0];
        Prev_Sig_reg = Signal_i;      
        OutInd_o = OutInd_o_reg;  
end

// Always block for sequential logic with reset
always @(posedge clk_100HZ or negedge Rst_n) begin
    if (!Rst_n) begin
        // Reset all registers when reset is low
        Prev_Sig_reg <= 0;
        OutInd_o_reg <= 0;
    end
    else begin
        // Assign final output
        Prev_Sig_reg <= Signal_i;  // Update previous signal
        OutInd_o_reg <= ~OutInd_o;  // Toggle output indicator
    end
end

// Simulation-only block (not synthesizable)
// This block will not be synthesized but can be used during simulation
`ifdef SIMULATION
always @(posedge clk_100HZ) begin
    if (Output_o == -49028) begin
        $display("Out: %d \n", $signed(Output_o));  // Display for debugging in simulation
    end
end
`endif

endmodule
