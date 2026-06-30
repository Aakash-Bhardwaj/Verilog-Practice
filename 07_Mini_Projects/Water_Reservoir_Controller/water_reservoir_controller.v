module water_reservoir_controller (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
); 

    localparam  LOW = 3'd1,             // Below S1 
                MID1_RISE = 3'd2,       // Rising between S1 and S2
                MID1_FALL = 3'd3,       // Falling between S1 and S2
                MID2_RISE = 3'd4,       // Rising between S2 and S3
                MID2_FALL = 3'd5,       // Falling between S2 and S3
                HIGH = 3'd6;            // Above S3
    reg [3:1] next_state, state;
    
    // State transition logic
    always @(*) begin
        case (state)
            LOW: begin
                case (s)
                    3'b001: next_state = MID1_RISE;
                    default: next_state = LOW;
                endcase
            end
            MID1_RISE: begin
                case (s)
                    3'b000: next_state = LOW;
                    3'b011: next_state = MID2_RISE;
                    default: next_state = MID1_RISE;
                endcase
            end
            MID1_FALL: begin
                case (s)
                    3'b000: next_state = LOW;
                    3'b011: next_state = MID2_RISE;
                    default: next_state = MID1_FALL;
                endcase
            end
            MID2_RISE: begin
                case (s)
                    3'b001: next_state = MID1_FALL;
                    3'b111: next_state = HIGH;
                    default: next_state = MID2_RISE;
                endcase
            end
            MID2_FALL: begin
                case (s)
                    3'b001: next_state = MID1_FALL;
                    3'b111: next_state = HIGH;
                    default: next_state = MID2_FALL;
                endcase
            end
            HIGH: begin
                case (s)
                    3'b011: next_state = MID2_FALL;
                    default: next_state = HIGH;
                endcase
            end
            default: next_state = LOW;
        endcase
    end
    
    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= LOW;
        else
            state <= next_state;
    end
    
    // Output logic
    always @(*) begin
        case (state)
            LOW: {fr1, fr2, fr3, dfr} = 4'b1111;
            MID1_RISE: {fr1, fr2, fr3, dfr} = 4'b1100;
            MID1_FALL: {fr1, fr2, fr3, dfr} = 4'b1101;
            MID2_RISE: {fr1, fr2, fr3, dfr} = 4'b1000;
            MID2_FALL: {fr1, fr2, fr3, dfr} = 4'b1001;
            HIGH: {fr1, fr2, fr3, dfr} = 4'b0000;
            default: {fr1, fr2, fr3, dfr} = 4'b1111;
        endcase
    end
    
endmodule