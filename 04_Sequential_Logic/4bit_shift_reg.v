//active high reset
//priority order:
//reset > load > enable
module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
); 

    integer i;
    
    always @(posedge clk, posedge areset) begin
        if (areset)
            q <= 0;
        else if (load)
            q <= data;
        else if (ena) begin
            for(i = 0; i < 3; i++)
                q[i] <= q[i+1];
            q[3] <= 0;
        end
        else
            q <= q;
    end
    
endmodule