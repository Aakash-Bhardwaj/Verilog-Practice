module top_module ( 
    input wire [2:0] vec, //vector declaration
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0  ); 

assign outv = vec;
assign o2 = vec[2]; //part select 1 bit of the vector
assign o1 = vec[1];
assign o0 = vec[0];
    
endmodule