module gray_counter #(
    parameter N = 4 
)(
    input clk,
    input reset,
    output reg [N-1:0] grey_out, bin_out
);

    wire [N-1:0] next_bin;
    assign next_bin = bin_out + 1'b1;

    always @(posedge clk) begin
        if (reset)begin
            bin_out <= {N{1'b0}};
            grey_out <= {N{1'b0}};
        end
        else begin
            bin_out <= next_bin;
            grey_out <= next_bin ^ (next_bin >> 1);
        end

    end

endmodule