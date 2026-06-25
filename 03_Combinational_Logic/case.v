module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up  
    ); 

    //checks and returns true if any arrow key pressed
    always @(*) begin
        left  = 1'b0;
        right = 1'b0;
        up    = 1'b0;
        down  = 1'b0;
        case (scancode)
            16'he06b: left  = 1'b1;   //hex code for left arrow
            16'he072: down  = 1'b1;   //hex code for down arrow
            16'he074: right = 1'b1;   //hex code for right arrow
            16'he075: up    = 1'b1;   //hex code for up arrow
        endcase
    end
    
endmodule