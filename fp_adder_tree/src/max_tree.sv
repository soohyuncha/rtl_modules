// valid input after 2 posedge 
module max_32 #(
  parameter int unsigned DATA_WIDTH=9
)(
    input clk,
    input signed [DATA_WIDTH-1:0] in [0:31],
    output logic signed [DATA_WIDTH-1:0] out
);
    logic signed [DATA_WIDTH-1:0] max1;
    logic signed [DATA_WIDTH-1:0] max2;
    logic signed [DATA_WIDTH-1:0] max;

    max_16 #(DATA_WIDTH) mx1(.clk(clk), .in(in[0:15]), .out(max1));
    max_16 #(DATA_WIDTH) mx2(.clk(clk), .in(in[16:31]), .out(max2));

    assign max = max1 > max2 ? max1 : max2;

    always_ff @(posedge clk) begin
        out <= max;
    end
endmodule


module max_16 #(
  parameter int unsigned DATA_WIDTH=9
)(
    input clk,
    input signed [DATA_WIDTH-1:0] in [0:15],
    output signed [DATA_WIDTH-1:0] out
);
logic signed [DATA_WIDTH-1:0] max1;
logic signed [DATA_WIDTH-1:0] max2;
logic signed [DATA_WIDTH-1:0] max;

max_8 #(DATA_WIDTH) mx1(.clk(clk), .in(in[0:7]), .out(max1));
max_8 #(DATA_WIDTH) mx2(.clk(clk), .in(in[8:15]), .out(max2));

assign out = max1 > max2 ? max1 : max2;

endmodule


module max_8 #(
  parameter int unsigned DATA_WIDTH=9
)(
    input clk,
    input signed [DATA_WIDTH-1:0] in [0:7],
    output logic signed [DATA_WIDTH-1:0] out
);

logic signed [DATA_WIDTH-1:0] max1;
logic signed [DATA_WIDTH-1:0] max2;
logic signed [DATA_WIDTH-1:0] max;

max_4 #(DATA_WIDTH) mx1(.in(in[0:3]), .out(max1));
max_4 #(DATA_WIDTH) mx2(.in(in[4:7]), .out(max2));

assign max = max1 > max2 ? max1 : max2;

always_ff @(posedge clk) begin
    out <= max;
end


endmodule


module max_4 #(
  parameter int unsigned DATA_WIDTH=9
)(
    input signed [DATA_WIDTH-1:0] in [0:3],
    output signed [DATA_WIDTH-1:0] out
);

logic signed [DATA_WIDTH-1:0] max;

always_comb begin
    max = in[0];
    if (in[1] > max)begin
        max = in[1];
    end
    if (in[2] > max)begin
        max = in[2];
    end
    if (in[3] > max)begin
        max = in[3];
    end
end

assign out = max;


endmodule
