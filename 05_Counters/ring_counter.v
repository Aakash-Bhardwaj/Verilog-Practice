module ring_counter #(
    parameter N = 6)(
        input clk,
        input reset,
        input lr,            //direction of the ring, high for left, low for right
        output reg [N-1:0] q
    );

    always @(posedge clk) begin
        if (reset)
            q <= {1'b1,{(N-1){1'b0}}};
        else if (lr)
            q <= {q[N-2:0],q[N-1]};
        else
            q <= {q[0],q[N-1:1]};
    end

endmodule