//A single-output digital system with four inputs (a,b,c,d) 
//generates a logic-1 when 2, 7, or 15 appears on the inputs, 
//and a logic-0 when 0, 1, 4, 5, 6, 9, 10, 13, or 14 appears. 
//The input conditions for the numbers 3, 8, 11, and 12 never occur in this system.

//Minimized POS = c(b'+d)(a'+b)
//Minimized SOP = a'b'c + cd

module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
); 
    assign out_sop = (~a & ~b & c) | (c & d);
    assign out_pos = c & (~b | d) & (~a | b);
    
endmodule