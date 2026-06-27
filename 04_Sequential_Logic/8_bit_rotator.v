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
                2'b00: begin                        //1 bit left rotate
                    for (i = 0; i < 63; i++)
                        q[i] <= q[i+1];
                    q[63] <= q[0];
                end
                2'b01: begin
                    for (i = 0; i < 64-8; i++)      //8 bit left rotate 
                        q[i] <= q[i+8];
                    for (i= 0; i < 8; i++)
                        q[63-i] <= q[7-i];
                end
                2'b10: begin                        //1 bit right rotate
                    for (i = 63; i > 0; i--)
                        q[i] <= q[i-1];
                    q[0] <= q[63];
                end
                2'b11: begin                        //8 bit right rotate
                    for (i = 63; i > 7; i--)
                        q[i] <= q[i-8];
                    for (i= 0; i < 8; i++)
                        q[0+i] <= q[63-7+i];
                end
            endcase
    end
    
endmodule