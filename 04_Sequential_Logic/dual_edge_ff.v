module top_module (
    input clk,
    input d,
    output q
);
    
    reg q_fall, q_rise;
    
    //rising edge triggered flipflop
    always @(posedge clk)
        q_rise <= d;                     
    
    //falling edge triggered fliflop
    always @(negedge clk)
        q_fall <= d;
    
    //updating output on each edge
    assign q = clk ? q_rise : q_fall;

endmodule