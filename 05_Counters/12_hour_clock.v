//12 hour clock
//Clock initialises at 12:00:00 AM
//Hours count from 01 to 12 (No 00:00:00)
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,          //low for AM, high for PM
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

    wire ss_t_en, mm_u_en, mm_t_en, hh_en;
    
    assign ss_t_en = ena && (ss[3:0] == 4'd9);                    //enable for ss tens digit increment
    assign mm_u_en = ena && (ss == 8'h59);                        //enable for mm units digit increment
    assign mm_t_en = ena && (mm[3:0] == 4'd9) && (ss == 8'h59);   //enable for mm tens digit increment
    assign hh_en = ena && (mm == 8'h59) && (ss == 8'h59);         //enable for hh increment
        
    bcdcounter ss_units (.clk(clk), .reset(reset), .enable(ena), .res_v(4'd9), .q(ss[3:0]));
    bcdcounter ss_tens (.clk(clk), .reset(reset), .enable(ss_t_en), .res_v(4'd5), .q(ss[7:4]));
    bcdcounter mm_units (.clk(clk), .reset(reset), .enable(mm_u_en), .res_v(4'd9), .q(mm[3:0]));
    bcdcounter mm_tens (.clk(clk), .reset(reset), .enable(mm_t_en), .res_v(4'd5), .q(mm[7:4]));
    hour_pm_calc hh_pm (.clk(clk), .reset(reset), .enable(hh_en), .pm(pm), .out(hh));
        
endmodule

//used to implement seconds and minutes
//reusable
module bcdcounter (
    input clk,
    input reset,
    input enable, 
    input [3:0] res_v,
    output reg [3:0] q
);
    
    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (enable) begin
            if (q == res_v)
                q <= 4'd0;
            else
                q <= q + 1;
        end
        else
            q <= q;
    end
    
endmodule

//used to implement the special cases (hours, and pm)
module hour_pm_calc(
	input clk,
    input reset,
    input enable,
    output reg pm,
    output reg [7:0] out
);
    
    always @(posedge clk) begin
        if (reset) begin
            out <= 8'h12;
            pm <= 1'b0;
        end
        else if (enable) begin
            case (out)
                8'h01: out <= 8'h02;
                8'h02: out <= 8'h03;
                8'h03: out <= 8'h04;
                8'h04: out <= 8'h05;
                8'h05: out <= 8'h06;
                8'h06: out <= 8'h07;
                8'h07: out <= 8'h08;
                8'h08: out <= 8'h09;
                8'h09: out <= 8'h10;
                8'h10: out <= 8'h11;
                8'h11: begin 
                    out <= 8'h12;
                    pm <= ~pm;           //toggles when hh transitions from 11 to 12
                end
                8'h12: out <= 8'h01;
                default: out <= 8'h12;
            endcase
        end
        else
            out <= out;
    end
    
endmodule