module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q); 

    integer i;
    
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            case (ena)
                2'b10: begin                   //right rotate
                    for (i = 99; i > 0; i--)
                        q[i] <= q[i-1];
                    q[0] <= q[99];
                end
                2'b01: begin                   //left rotate
                    for (i = 0; i < 99; i++)
                        q[i] <= q[i+1];
                    q[99] <= q[0];
                end
                default: q <= q;
            endcase
    end
    
endmodule