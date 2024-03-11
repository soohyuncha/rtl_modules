module fp32_converter #(
    parameter int unsigned DATA_WIDTH = 51,       // N = 8
    parameter int unsigned FIXED_POINT = 46       // MANT_W = 23
) (
    input [DATA_WIDTH-1:0] in_fixed,
    input [7:0]            exp,

    output [31:0]          fp32
);

logic sign;
logic [DATA_WIDTH-1:0] abs_fixed;
logic [63:0] abs_fixed_64;
logic [5:0] first_set_bit;
logic [7:0] exp_out;

logic [DATA_WIDTH-1:0] shifted_fixed;
logic [5:0] shamt;
logic [22:0] mantissa;

// Sign
assign sign = in_fixed[DATA_WIDTH-1];
assign abs_fixed = sign ? (~in_fixed)+1: in_fixed;
assign abs_fixed_64 = abs_fixed;

// Exp
first_set_bit64 first_set_bit64_inst(
    .x (abs_fixed_64), 
    .q (first_set_bit),
    .aOut ()
);
assign exp_out = exp + first_set_bit - FIXED_POINT + 8'b01111111;

// Mant
assign shamt = first_set_bit - 23;
assign shifted_fixed = abs_fixed >> shamt;
assign mantissa = shifted_fixed[22:0]; 

// Combine all
assign fp32 = {sign, exp_out, mantissa};

endmodule
