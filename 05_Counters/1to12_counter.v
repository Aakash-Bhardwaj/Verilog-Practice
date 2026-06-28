module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
);

    assign c_enable = enable;
    assign c_load = reset | (enable && (Q == 4'b1100));
    assign c_d = 4'b0001;
    
    count4 the_counter(clk, c_enable, c_load, c_d, Q);

endmodule

module count4 (
    input clk,
    input enable, load,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= d;
        else if (enable)
            q <= q + 1;
        else
            q <= q;
    end

endmodule