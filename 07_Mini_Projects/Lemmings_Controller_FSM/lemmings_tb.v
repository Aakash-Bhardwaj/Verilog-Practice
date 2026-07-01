//================================================
// Testbench
// Lemmings
//
// Tests:
// 1. Reset
// 2. Falling
// 3. Digging
// 4. Walking
// 5. Splatter
// 6. Direction change
//================================================
`timescale 1ns/1ps
module lemmings_tb;

    // Configuration & trackers
    parameter debug = 0;   // 1 to enable monitor output, 2 for only pass/fail
    
    integer test_num = 0; 
    integer error_count = 0;
    reg [30:0] state_names;

    // Signal declarations
    reg clk;
    reg areset;
    reg bump_left, bump_right, ground, dig;

    wire walk_left, walk_right, aaah, digging;

    // DUT instantiation
    lemmings dut(
        .clk(clk),
        .areset(areset),
        .bump_left(bump_left),
        .bump_right(bump_right),
        .ground(ground),
        .dig(dig),
        .walk_left(walk_left),
        .walk_right(walk_right),
        .aaah(aaah),
        .digging(digging)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Numeric state to readable
    always @(*) begin
        case (dut.state)
        3'd0: state_names = " L ";
        3'd1: state_names = " R ";
        3'd2: state_names = "F_L";
        3'd3: state_names = "F_R";
        3'd4: state_names = "D_L";
        3'd5: state_names = "D_R";
        3'd6: state_names = "DeD";
        endcase
    end

    // Waveform generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, lemmings_tb);
    end

    // Task to avoid race condition
    task chk;
    begin
        @(posedge clk);
        #1;
    end
    endtask

    // Task to avoid race condition
    task drv;
    begin
        @(negedge clk);
    end
    endtask

    // Monitor
    initial begin
        if (debug) begin
        $monitor("Time=%0t | rst=%b gnd=%b bL=%b bR=%b | state=%s | wL=%b wR=%b aaah=%b dig=%b", 
                 $time, areset, ground, bump_left, bump_right, state_names, walk_left, walk_right, aaah, digging);
        end
    end

    // Self checking verification
    task verify;
        input [3:0] expected;
        begin
            test_num = test_num + 1;

            if ({walk_left, walk_right, aaah, digging} != expected) begin
                $display("FAIL! Test=%0d | Time=%0t | Expected=%b | Actual=%b | State=%s",
                            test_num, $time, expected, {walk_left, walk_right, aaah, digging}, state_names);
                error_count = error_count + 1;
            end
            else begin
                $display("PASS! Test=%0d | Time=%0t | State=%s",
                            test_num, $time, state_names);
            end
        end
    endtask

    // Test stimulus
    initial begin
        $display ("---------------------");
        $display ("----Testing Start----");
        $display ("---------------------");
        
        //-- Reset & Basic Movement --
        areset = 1; bump_left = 0; bump_right = 0; ground = 1; dig = 0;
        #20; areset = 0;

        #5;  verify(4'b1000); //expected LEFT

        drv(); bump_left = 1;
        drv(); bump_left = 0;
        chk(); verify(4'b0100); //expected RIGHT

        drv(); bump_right = 1;
        drv(); bump_right = 0;
        chk(); verify(4'b1000); //expected LEFT

        //-- Digging --
        test_num = 99;

        drv(); dig = 1;
        drv(); dig = 0;
        chk(); verify(4'b0001); //expected DIG_LEFT

        repeat(4) @(posedge clk);
        chk(); verify(4'b0001); //expected same as last

        repeat(4) @(posedge clk);
        drv(); ground = 0;
        chk(); verify(4'b0010); //expected FALL_LEFT

        repeat(7) @(posedge clk); 
        drv(); ground = 1;
        chk(); verify(4'b1000); //expected LEFT

        drv(); bump_left = 1;
        drv(); bump_left = 0;
        chk(); verify(4'b0100); //expected RIGHT

        drv(); dig = 1;
        drv(); dig = 0;
        chk(); verify(4'b0001); //expected DIG_RIGHT

        repeat(6) @(posedge clk);
        chk(); verify(4'b0001); //expected same as last

        drv(); ground = 0;
        chk(); verify(4'b0010); //expected FALL_RIGHT

        drv(); ground = 1;
        chk(); verify(4'b0100); //expected RIGHT

        //-- Fall (<20 cycles) --
        test_num = 199;

        drv();  ground = 0;
        repeat(16) @(posedge clk);
        drv();  ground = 1;      //fall for 16 cycles
        chk();  verify(4'b0100); //expected RIGHT (Survival)

        drv();  ground = 0;
        repeat(2) @(posedge clk);
        drv();  dig = 1;
        repeat(3) @(posedge clk);
        drv();  dig = 0;
        chk();  verify(4'b0010); //expected FALL_RIGHT
        repeat(7) @(posedge clk);
        drv();  ground = 1;      //fall for ~13 cycles
        chk();  verify(4'b0100); //expected RIGHT (Survival)

        drv();  ground = 0;
        drv();  bump_right = 1;
        drv();  bump_right = 0;
        chk();  verify(4'b0010);  //expected FALL_RIGHT
        repeat(14) @(posedge clk);
        drv();  ground = 1;       //fall for <20 cycles
        chk();  verify(4'b0100);  //expected RIGHT (Survival)

        //-- Fall (20 cycles) --
        test_num = 299;

        drv(); ground = 0;
        repeat(20) @(posedge clk);
        drv(); ground = 1;      //fall for 20 cycles
        chk(); verify(4'b0100); //expected RIGHT (Survival)

        //-- Death (21 cycles) --
        test_num = 399;

        drv(); ground = 0;
        repeat(21) @(posedge clk);
        drv(); ground = 1;      //fall for 21 cycles
        chk(); verify(4'b0000); //expected DEAD

        drv(); bump_right = 1;
        drv(); bump_right = 0;
        chk(); verify(4'b0000); //expected DEAD

        drv(); dig = 1;
        drv(); dig = 0;
        chk(); verify(4'b0000); //expected DEAD

        //-- Resurrection --
        test_num = 499;

        drv(); areset = 1;
        drv(); areset = 0;
        chk();  verify(4'b1000); //expected LEFT

        drv(); ground = 0;
        repeat(42) @(posedge clk);
        drv(); ground = 1;      //fall for 42 cycles
        chk(); verify(4'b0000); //expected DEAD

        $display("-----------------------");
        if(error_count == 0)
            $display ("SUCCESS! No Errors.");
        else
            $display ("FAILED!! %0d Errors.", error_count);
        $display("-----------------------");

        $finish;

    end

endmodule