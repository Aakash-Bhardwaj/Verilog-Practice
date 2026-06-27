module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output reg [31:0] q
); 
    
    reg [31:0] qn;
    
    always @(*) begin
        qn = q >> 1;
        //tap at bit positions 32,22,2,1
        qn[31] = q[0] ^ 0;
        qn[21] = q[22] ^ q[0];
        qn[1] = q[2] ^ q[0];
        qn[0] = q[1] ^ q[0];
    end
    
    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= qn;
    end

endmodule