module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q ); 

    integer i;
    
    always @(posedge clk) begin
        if (load)
            q <= data;
        else begin
            for (i = 510; i > 0; i--)
                q[i] <= q[i-1] ^ q[i+1];
            q[511] <= q[510] ^ 0;           //imaginary q[512] = 0
            q[0] <= q[1] ^ 0;               //imaginary q[-1] = 0
        end
    end
    
endmodule