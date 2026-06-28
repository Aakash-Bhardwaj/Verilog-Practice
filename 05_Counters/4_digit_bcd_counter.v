module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q
);
    
    //enable chain for cascading BCD counters
    assign ena[1] = (q[3:0] == 4'd9);
    assign ena[2] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9);
    assign ena[3] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9);
    
    bcdcounter units (clk, reset, 1'b1, q[3:0]);
    bcdcounter tens (clk, reset, ena[1], q[7:4]);
    bcdcounter hndrds (clk, reset, ena[2], q[11:8]);
    bcdcounter thsnds (clk, reset, ena[3], q[15:12]);

endmodule

module bcdcounter (
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);
    
    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (enable) begin
            if (q == 4'd9)
                q <= 4'd0;
            else
                q <= q + 1;
        end
        else
            q <= q;
    end
endmodule