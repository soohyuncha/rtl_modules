// fixed input size 32
module fixed_adder_tree #(
    parameter int unsigned DATA_WIDTH = 32

)(
    input clk,
    input signed [DATA_WIDTH-1:0] in[0:31],

    output logic signed [DATA_WIDTH+4:0] out
);

    logic signed [DATA_WIDTH:0] layer_1 [0:15];
    logic signed [DATA_WIDTH+1:0] layer_2 [0:7];
    logic signed [DATA_WIDTH+2:0] layer_3 [0:3];
    logic signed [DATA_WIDTH+3:0] layer_4 [0:1];

    fixed_adder_arr #(.ARRAY_IN_WIDTH(32), .DATA_WIDTH(DATA_WIDTH)) l1(clk, in, layer_1);
    fixed_adder_arr #(.ARRAY_IN_WIDTH(16), .DATA_WIDTH(DATA_WIDTH+1)) l2(clk, layer_1, layer_2);
    fixed_adder_arr #(.ARRAY_IN_WIDTH(8), .DATA_WIDTH(DATA_WIDTH+2)) l3(clk, layer_2, layer_3);
    fixed_adder_arr #(.ARRAY_IN_WIDTH(4), .DATA_WIDTH(DATA_WIDTH+3)) l4(clk, layer_3, layer_4);
    fixed_adder_arr_out_1d #(.DATA_WIDTH(DATA_WIDTH+4)) l5(clk, layer_4, out);

endmodule


module fixed_adder_arr #(
  parameter int unsigned ARRAY_IN_WIDTH=64,
  parameter int unsigned ARRAY_OUT_WIDTH=ARRAY_IN_WIDTH/2,
  parameter int unsigned DATA_WIDTH=32
)(
    input clk,
    input signed [DATA_WIDTH-1:0] in [0:ARRAY_IN_WIDTH-1],

    output logic signed [DATA_WIDTH:0] out [0:ARRAY_OUT_WIDTH-1]
);

int i;
always_ff @(posedge clk) begin
    for (i=0; i<ARRAY_OUT_WIDTH; i=i+1) begin: add_arr
        out[i] = in[2*i] + in[2*i+1];
    end
end

endmodule


module fixed_adder_arr_out_1d #(
  parameter int unsigned DATA_WIDTH=32
)(
    input clk,
    input signed [DATA_WIDTH-1:0] in [0:1],

    output logic signed [DATA_WIDTH:0] out
);

always_ff @(posedge clk) begin
    out = in[0] + in[1];
end

endmodule

