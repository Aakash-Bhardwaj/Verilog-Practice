//imaginary q[512], and q[-1] are off
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
); 

    integer i;
    
    always @(posedge clk) begin
        if(load)
            q <= data;
        else begin
            for (i = 510; i > 0; i--)
                q[i] <= (q[i] | q[i-1]) & (~q[i+1] | ~q[i] | ~q[i-1]);
            q[511] <= (q[511] | q[510]);                                //The assumption q[512] is off simplifies the equation
            q[0] <= (q[0] | 0);                                         //The assumption q[ -1] is off simplifies the equation
        end
    end
    
endmodule