module t_ff (
    input clk,
    input toggle,
    output reg q
);

    always @(posedge clk) begin
        if (toggle)
            q <= ~q;
        else
            q <= q;
    end

endmodule