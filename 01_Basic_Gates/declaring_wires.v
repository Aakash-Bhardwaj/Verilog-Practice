module top_module(
    input a, b, c, d,
    output out, out_n
); 

wire a1, a2; //declaring wires
    
assign a1 = a & b;
assign a2 = c & d;
assign out = a1 | a2;
assign out_n = ~out;
    
endmodule