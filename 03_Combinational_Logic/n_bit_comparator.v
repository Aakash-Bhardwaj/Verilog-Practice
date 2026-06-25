module n_bit_comp #(
    parameter N = 4  
)(
    input [N-1:0] a, b,
    output reg a_gt_b, a_lt_b, a_eq_b
);

    always @(*) begin
        a_gt_b = 1'b0;
        a_lt_b = 1'b0;
        a_eq_b = 1'b0;

        if (a > b)
            a_gt_b = 1'b1;
        else if (a < b)
            a_lt_b = 1'b1;
        else
            a_eq_b = 1'b1;
    end

endmodule