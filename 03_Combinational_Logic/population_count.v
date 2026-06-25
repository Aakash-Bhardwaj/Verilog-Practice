module top_module( 
    input [254:0] in,
    output reg [7:0] out );

    integer i;
    
    always @(*) begin
        out = 8'd0;
        for (i = 0; i < 255; i++)
            out = out + in[i];      //returns number of 1s in input
    end
        
endmodule
