module top_module (
    input [7:0] in,
    output [31:0] out 
);

assign out = {{24{in[7]}}, in}; 
//replicating the msb of in vector 24 times 
//then concatenating with in vector
    
endmodule