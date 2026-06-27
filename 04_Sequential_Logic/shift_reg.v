//4 flipflops b/w i/p, and o/p
module top_module (
    input clk,
    input resetn,   //Active-low synchronous reset
    input in,
    output reg out);
    
    reg [2:0] q;
    
    always @(posedge clk) begin
        if (~resetn) begin
            out <= 1'b0;
            q <= 3'b0;
        end
        else begin
            q[0] <= in;
            q[1] <= q[0];
            q[2] <= q[1];
            out <= q[2];
        end
    end 

endmodule