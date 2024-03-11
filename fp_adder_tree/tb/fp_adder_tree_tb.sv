module fp_adder_tree_tb(
);

localparam N = 8;

logic clk;
logic rstn;

// Variables to read .txt file
logic [31:0] fp_in[0:N-1];
logic [31:0] out;

// Module instantiation
fp_adder_tree #(.N(N)) fp_adder_tree_inst (
    .clk (clk),
    
    .fp_in (fp_in),
    
    .out (out)
);
    
// Clock setting
initial forever
    #5 clk <= ~clk;
    
initial begin
    clk <= 1;
    rstn <= 1;
        
    // Read input
    #10
    $readmemb("fp_add_input.txt", fp_in);

    #10
    rstn <= 0;
        
    #20
    rstn <= 1;
    
    // Check result
    #200
    if (out == 32'b00111111111010001010110011010110) begin
        $display("\n\n**********************************");
        $display("Result correct!");
        $display("**********************************\n\n");
    end
    else begin
        $display("\n\n**********************************");
        $display("Result wrong...");
        $display("**********************************\n\n");
    end
    
    #20
    $finish;
    end
endmodule
