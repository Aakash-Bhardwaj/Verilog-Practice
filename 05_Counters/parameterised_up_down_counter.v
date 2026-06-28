//Priority order:
//reset > enable > load > count
module advanced_counter #(
    parameter N = 8
)(
    input clk,
    input areset_n,        //Active low asynchronous reset
    input enable,
    input up_down,         //high for up, low for down
    input load,
    input [N-1:0] data,
    output reg [N-1:0] out,
    output tc              //high if counting up after max, or counting down after min, as reminder to terminate
);

    always @(posedge clk, negedge areset_n) begin
        if (~areset_n)
            out <= {N{1'b0}};
        else if (enable) begin
            if (load)
                out <= data;
            else if (up_down)
                out <= out + 1'b1;
            else
                out <= out - 1'b1;
        end
    end

    assign tc = (enable && up_down && out == {N{1'b1}}) || (enable && ~up_down && out == {N{1'b0}});


endmodule