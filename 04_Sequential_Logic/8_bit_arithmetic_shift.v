module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q); 

    integer i;
    
    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            case (amount)
                2'b00: begin                       //arithmetic left shift
                    for (i = 63; i > 0; i--)
                        q[i] <= q[i-1];
                    q[0] <= 1'b0;
                end
                2'b01: begin                       //8 bit arithmetic left shift
                    for (i = 63; i > 7; i--)
                        q[i] <= q[i-8];
                    q[7:0] <= 8'b0;
                end
                2'b10: begin                       //arithmetic right shift
                    for (i = 0; i < 63; i++)
                        q[i] <= q[i+1];
                    q[63] <= q[63];
                end
                2'b11: begin                       //8 bit arithmetic right shift
                    for (i = 0; i < 56; i++)
                        q[i] <= q[i+8];
                    q[63:56] <= {8{q[63]}};
                end
            endcase
    end
    
endmodule