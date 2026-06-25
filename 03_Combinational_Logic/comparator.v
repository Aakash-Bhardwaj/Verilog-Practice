module comp (
    input a, b,
    output a_gt_b, a_lt_b, a_eq_b
);

    assign a_gt_b = a & ~b;    //a > b
    assign a_lt_b = ~a & b;    //a < b
    assign a_eq_b = ~(a ^ b);  //a = b

endmodule