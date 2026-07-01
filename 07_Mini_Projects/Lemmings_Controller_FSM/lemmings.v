module lemmings (
    input clk,
    input areset,        // Freshly brainwashed Lemmings walk left.
    input bump_left,     // High if obstacle on left
    input bump_right,    // High if obstacle on right
    input ground,        // High if walking on ground
    input dig,           // Digging command
    output walk_left,    // Lemmings walk left
    output walk_right,   // Lemmings walk right
    output aaah,         // Lemmings falling
    output digging );    // Lemmings digging
    
    localparam  LEFT = 3'd0,        // Walking left
    			RIGHT = 3'd1,       // Walking right
    			FALL_LEFT = 3'd2,   // Falling (previously walking left)
    			FALL_RIGHT = 3'd3,  // Falling (previously walking right)
    			DIG_LEFT = 3'd4,    // Digging (previously walking left)
    			DIG_RIGHT = 3'd5,   // Digging (previously walking right)
    			DEAD = 3'd6;        // Lemmings have splattered
    
    reg [2:0] state, next_state;
    reg [4:0] counter;
    
    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (dig)
                    next_state = DIG_LEFT;
                else if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
               if (!ground)
                    next_state = FALL_RIGHT;
                else if (dig)
                    next_state = DIG_RIGHT;
                else if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            FALL_LEFT: begin
                if (ground && counter >= 5'd20)
                    next_state = DEAD;
                else if (ground)
                    next_state = LEFT;
                else
                    next_state = FALL_LEFT;
            end
            FALL_RIGHT: begin
                if (ground && counter >= 5'd20)
                    next_state = DEAD;
                else if (ground)
                    next_state = RIGHT;
                else
                    next_state = FALL_RIGHT;
            end
            DIG_LEFT: begin
                if (ground)
                    next_state = DIG_LEFT;
                else
                    next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (ground)
                    next_state = DIG_RIGHT;
                else
                    next_state = FALL_RIGHT;
            end
            DEAD: next_state = DEAD;
            default: next_state = LEFT;
        endcase
    end
    
    // Counting clock cycles when falling
    always @(posedge clk, posedge areset) begin
        if (areset)
            counter <= 5'd0;
        else if ((state == FALL_LEFT) || (state == FALL_RIGHT))
            counter <= (counter < 5'd21) ? counter + 1'b1 : 5'd31;
        else
            counter <= 5'd0;
    end
    
    // State register with Asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end
    
    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_LEFT) | (state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT) | (state == DIG_RIGHT);

endmodule
