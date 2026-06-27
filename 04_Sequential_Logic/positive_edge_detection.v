module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);
	
    reg [7:0] prev;
    
    always @(posedge clk) begin
        pedge <= ~prev & in;    //high only if previous is 0 and current is 1
        prev <= in;             //stores present in for next cycle
    end
    
endmodule