//active high reset
module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev;
    
    always @(posedge clk) begin
        prev <= in;                       //stores present value for next cycle
        if(reset)
            out <= 0;                     //output is reset
        else
            out <= out | (prev & ~in);    //if output is high then unchanged, if low then changes in negaitve edge
    end
    
endmodule