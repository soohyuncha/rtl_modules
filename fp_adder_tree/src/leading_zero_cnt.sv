module first_set_bit64(
  input logic [63:0] x,
  output logic [5:0] q,
  output logic aOut
);
logic [4:0] z0,z1;
logic [1:0] a;

first_set_bit32 lzc0(x[31:0],z0,a[0]);
first_set_bit32 lzc1(x[63:32],z1,a[1]);

assign aOut = a[1] && a[0];
assign q = (a[1]) ? {1'b0,z0} : {1'b1,z1};
endmodule


module first_set_bit32(
  input logic [31:0] x,
  output logic [4:0] q,
  output logic aOut
);
logic [3:0] z0,z1;
logic [1:0] a;

first_set_bit16 lzc0(x[15:0],z0,a[0]);
first_set_bit16 lzc1(x[31:16],z1,a[1]);

assign aOut = a[1] && a[0];
assign q = (a[1]) ? {1'b0,z0} : {1'b1,z1};
endmodule


module first_set_bit16(
  input logic [15:0] x,
  output logic [3:0] q,
  output logic aOut
);
logic [2:0] z0,z1;
logic [1:0] a;

first_set_bit8 lzc0(x[7:0],z0,a[0]);
first_set_bit8 lzc1(x[15:8],z1,a[1]);

assign aOut = a[1] && a[0];
assign q = (a[1]) ? {1'b0,z0} : {1'b1,z1};
endmodule


module first_set_bit8(
  input logic [7:0] x,
  output logic [2:0] q,
  output logic aOut
);
logic [1:0] z0,z1;
logic [1:0] a;

first_set_bit4 lzc0(x[3:0],z0,a[0]);
first_set_bit4 lzc1(x[7:4],z1,a[1]);

assign aOut = a[1] && a[0];
assign q = (a[1]) ? {1'b0,z0} : {1'b1,z1};
endmodule


//Leading zero count
//https://digitalsystemdesign.in/leading-zero-counter/
module first_set_bit4(
  input logic [3:0] x,
  output logic [1:0] q,
  output logic a
);
assign a = ~x[3] && ~x[2] && ~x[1] && ~x[0]; 
assign q = 2'b11 - {~(x[3] || x[2]),(~x[3] && x[2]) || (~x[3] && ~x[1])};

endmodule