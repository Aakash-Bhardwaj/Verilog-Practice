module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
);

    wire [3:0] unit, tens, hndrds;
    
    //units counter increments every clock cycle
    assign c_enable[0] = 1'b1;
    //tens counter increments when units roll over
    assign c_enable[1] = (unit == 4'd9);
    //hundreds counter increments when both tens, and units roll over
    assign c_enable[2] = (unit == 4'd9) && (tens == 4'd9);
    //High every 1000 cycles
    assign OneHertz = (unit == 4'd9) && (tens == 4'd9) && (hndrds == 4'd9);
    
    bcdcount counter0 (clk, reset, c_enable[0], unit);
    bcdcount counter1 (clk, reset, c_enable[1], tens);
    bcdcount counter2 (clk, reset, c_enable[2], hndrds);

endmodule

module bcdcount (
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