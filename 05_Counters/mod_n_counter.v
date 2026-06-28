module mod_n_counter #(
    parameter mod_n = 21,
    parameter log2n = $clog2(mod_n)
)(
    input clk, reset, enable, load,      //Priority: reset > load > enable
    input [log2n-1:0] data,
    output reg [log2n-1:0] out,
    output tc                            //High when out equals or exceeds (mod_n - 1)
);

    always @(posedge clk) begin
        if (reset)
            out <= {log2n{1'b0}};
        else if (load)
            out <= data;
        else if (enable) begin
            if (out >= mod_n - 1)
                out <= {log2n{1'b0}};
            else
                out <= out + 1'b1; 
        end 
    end

    assign tc = (out >= mod_n - 1);

endmodule