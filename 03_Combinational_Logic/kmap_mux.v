//For the following Karnaugh map, give the circuit implementation using 
//one 4-to-1 multiplexer and as many 2-to-1 multiplexers as required, 
//but using as few as possible. You are not allowed to use any other 
//logic gate. You must use a and b as the 4-to-1 multiplexer selector inputs.

//Canonical SOP,
//Y(a, b, c, d) = Σ m(1, 2, 3, 8, 10, 15)

module top_module(
    input a, b, c, d,
    output y
);

    wire [3:0] in;
    _2to1mux in0 (.in0(d), .in1(1'b1), .sel(c), .out(in[0]));
    assign in[1] = 0;
    _2to1mux in2 (.in0(1'b1), .in1(1'b0), .sel(d), .out(in[2]));
    _2to1mux in3 (.in0(1'b0), .in1(d), .sel(c), .out(in[3]));

    wire [1:0] sel;
    assign sel = {a, b};

    _4to1mux op (.in(in), .sel(sel), .out(y));

endmodule

module _2to1mux (
    input in0, in1, sel,
    output out
);

    assign out = sel ? in1 : in0;

endmodule

module _4to1mux (
    input [3:0] in, 
    input [1:0] sel,
    output reg out
);

    always @(*) begin
        case (sel)
            2'b00: out = in[0];
            2'b01: out = in[1];
            2'b10: out = in[2];
            2'b11: out = in[3];
            default: out = 1'b0;
        endcase
    end

endmodule