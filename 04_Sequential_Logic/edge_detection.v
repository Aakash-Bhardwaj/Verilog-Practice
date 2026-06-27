module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    
    reg [7:0] prev;
    
    always @(posedge clk) begin
        anyedge <= prev ^ in;    //high whenever in changes
        prev <= in;              //stores present value for next cycle
    end

endmodule