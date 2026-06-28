module programmable_counter #(
    parameter N = 8
)(
    input clk,                   
    input reset,                //resets counter to 0, target to max
    input load,                 //Priority for out: reset > load > enable
    input enable,               //Priority for target: reset > t_load
    input t_load,               //high to load target
    input up_down,              //high for up, low for down
    input clr_alrm,             //reset alarm
    input [N-1:0] data,         //initial value of counter, before counting begins
    input [N-1:0] target,       //target value of counter
    output reg [N-1:0] out,     //counter value
    output tc,                  //high when counter is equal to target
    output reg alrm             //alarm when counter crosses the target, high until reset
);

    reg [N-1:0] target_str;
    
    //target register
    always @(posedge clk) begin
        if (reset)
            target_str <= {N{1'b1}};
        else if (t_load)
            target_str <= target;
    end

    //counter logic
    always @(posedge clk) begin
        if (reset)
            out <= {N{1'b0}};
        else if (load)
            out <= data;
        else if (enable) begin
            if (up_down)
                out <= out + 1'b1;
            else
                out <= out - 1'b1; 
        end 
    end

    assign tc = (out == target_str);
    
    //alarm logic
    always @(posedge clk) begin
        if (reset)
            alrm <= 1'b0;
        else if (clr_alrm)
            alrm <= 1'b0; 
        else if (enable)
            if ((out >= target_str && up_down) || (out <= target_str && ~up_down))
                alrm <= 1'b1;
    end

endmodule