//100 bit ripple carry adder generated using 100 full adders
module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum 
    );

    fadd ins (a[0], b[0], cin, sum[0], cout[0]);
    
    generate
        genvar i;
        for (i = 1; i < 100; i++) begin: adder
            fadd ins1 (a[i], b[i], cout[i-1], sum[i], cout[i]);
        end
    endgenerate
                        
endmodule

//module to generate full adder
module fadd(
    input a, b, cin,
    output sum, cout
);
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    
endmodule