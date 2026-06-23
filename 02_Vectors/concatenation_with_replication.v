module top_module (
    input a, b, c, d, e,
    output [24:0] out 
);
	
//Simultaneous replication and concatenation
//1st concatenation = aaaaabbbbb....eeeee
//2nd concatenation = abcdeabcde....abcde
assign out = ~{{5{a}},{5{b}},{5{c}},{5{d}},{5{e}}} ^ {5{{a,b,c,d,e}}};
    
endmodule
