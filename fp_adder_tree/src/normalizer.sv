module normalizer #(
    parameter N = 8,
    parameter EXP_W = 8,
    parameter MANT_W = 23
) (
    input clk,
    
    input signed [EXP_W-1:0] exp[0:N-1],
    input unsigned [MANT_W:0] mant[0:N-1],
    
    output logic signed [EXP_W-1:0] exp_max,
    output logic unsigned [2*MANT_W:0] out[0:N-1]
);

// Exp max
logic unsigned [EXP_W-1:0] exp_diff[0:N-1];


// Get max (This is not parameterized...)
max_8 #(.DATA_WIDTH (EXP_W)) max_inst (
    .clk (clk),
    .in (exp),
    .out (exp_max)
);

// Subtract from exp_max
int j;
always_comb begin
    for(j=0;j<N;j=j+1) begin
        exp_diff[j] = exp_max - exp[j];
    end
end

// Right shift with amount of exp_diff
int k;
always_comb begin
    for(k=0;k<N;k=k+1) begin
        out[k] = {mant[k], {MANT_W{1'b0}}} >>> exp_diff[k];
    end
end
endmodule
