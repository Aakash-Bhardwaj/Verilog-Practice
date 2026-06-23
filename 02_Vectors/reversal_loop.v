module top_module( 
    input [7:0] in,
    output [7:0] out
);

generate                                    //used to generate conditional blocks
	genvar i;                               //creating the control variable
	for (i=0; i<8; i = i+1) begin: reverse  //loop block called reverse
		assign out[i] = in[8-i-1];          //reversing 
	end
endgenerate
    
endmodule
