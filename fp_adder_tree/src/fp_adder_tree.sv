module fp_adder_tree #(
    parameter int unsigned N = 8
) (
    input clk,
    
    input [31:0] fp_in[0:N-1],
    
    output [31:0] out
);

localparam EXP_W = 8;
localparam EXP_BIAS = 127;
localparam MANT_W = 23;

// 1) Bit field separation
logic [N-1:0] in_sign;
logic signed [EXP_W-1:0] in_exp[0:N-1];
logic unsigned [MANT_W-1:0] in_mant[0:N-1];
logic unsigned [MANT_W:0] in_mant_all[0:N-1];
logic [N-1:0] is_normal;

// 2) Get exp max & normalize
logic signed [EXP_W-1:0] exp_max;
logic unsigned [2*MANT_W:0] mant_shift[0:N-1];

// 3) Adder tree
logic signed [2*MANT_W+1:0] mant_shift_sign[0:N-1];
logic signed [2*MANT_W+2:0] reduction_4 [0:3];
logic signed [2*MANT_W+3:0] reduction_2 [0:1];
logic signed [2*MANT_W+4:0] fixed_adder_out;

// 1) Bit field separation
int i;
always_comb begin
    for(i=0;i<N;i=i+1) begin
        in_sign[i] = fp_in[i][EXP_W+MANT_W];
        is_normal[i] = fp_in[i][EXP_W+MANT_W-1:MANT_W] != {EXP_W{1'b0}};
        in_exp[i] = is_normal[i] ? {1'b0, fp_in[i][EXP_W+MANT_W-1:MANT_W]}-EXP_BIAS: -EXP_BIAS+1;
        in_mant[i] = fp_in[i][MANT_W-1:0];
        in_mant_all[i] = {is_normal[i], in_mant[i]}; //implicit 1 added
    end
end

// 2) Get exp max & normalize
normalizer #(.N(N), .EXP_W(EXP_W), .MANT_W(MANT_W)) normalizer_inst (
    .clk (clk),
    
    .exp (in_exp),
    .mant (in_mant_all),
    
    .exp_max (exp_max),
    .out (mant_shift)
);

// 3) Adder tree
// 3-1) Sign
int j;
always_comb begin
    for(j=0;j<N;j=j+1) begin
        if (in_sign[j]) begin
            mant_shift_sign[j] <= ~{1'b0, mant_shift[j]}+1;
        end else begin
            mant_shift_sign[j] <= {1'b0, mant_shift[j]};
        end
    end
end

// 3-2) Adder tree (This is not parameterized...)
fixed_adder_arr #(.ARRAY_IN_WIDTH(8), .DATA_WIDTH(2*MANT_W+2)) l1(
    clk, mant_shift_sign, reduction_4
);

fixed_adder_arr #(.ARRAY_IN_WIDTH(4), .DATA_WIDTH(2*MANT_W+3)) l2(
    clk, reduction_4, reduction_2
);
    
fixed_adder_arr_out_1d #(.DATA_WIDTH(2*MANT_W+4)) l3(
    clk, reduction_2, fixed_adder_out
);

// 4) Convert to FP32
fp32_converter #(
    .DATA_WIDTH (2*MANT_W+5),
    .FIXED_POINT (2*MANT_W)
) fp32_converter_inst (
    .in_fixed (fixed_adder_out),
    .exp (exp_max),
    .fp32 (out)
);

endmodule
