//=========================================================
// Testbench
// Water Reservoir Controller
//
// Tests:
// 1. Reset
// 2. Rising water
// 3. Falling water
// 4. Direction reversal
// 5. Variable sensor timing
//=========================================================
module water_reservoir_controller_tb;

    // Signal Declarations
    reg clk;
    reg reset;
    reg [3:1] s;

    wire fr1;
    wire fr2;
    wire fr3;
    wire dfr;

    // DUT instantiation
    water_reservoir_controller dut(
        .clk(clk),
        .reset(reset),
        .s(s),
        .fr3(fr3),
        .fr2(fr2),
        .fr1(fr1),
        .dfr(dfr)
    );

    // Clock generation
    initial begin 
        clk = 0;
    end
    always #5 clk = ~clk;

    // Waveform generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, water_reservoir_controller_tb);
    end

    // Monitor
    initial begin
    $monitor(
        "Time=%0t reset=%b s=%b state=%0d fr1=%b fr2=%b fr3=%b dfr=%b",
        $time,
        reset,
        s,
        dut.state,
        fr1,
        fr2,
        fr3,
        dfr
    );
    end

    // Test stimulus
    initial begin
        reset = 1'b1;
        s = 3'b000;

        #20;
        reset = 1'b0;

        #10;
        s = 3'b001;
        #10;
        s = 3'b011;
        #10;
        s = 3'b111;
        #10;
        s = 3'b011;
        #10;
        s = 3'b001;
        #10;
        s = 3'b000;
        #10;
        s = 3'b001;
        #10;
        s = 3'b000;
        #10;
        s = 3'b001;
        #10;
        s = 3'b011;
        #10;
        s = 3'b001;
        #10;
        s = 3'b011;
        #10;
        s = 3'b111;
        #10;
        s = 3'b011;
        #10;
        s = 3'b111;
        #10;
        s = 3'b011;
        #10;
        s = 3'b001;
        #10;
        s = 3'b011;
        #10;
        s = 3'b111;
        #13;
        s = 3'b011;
        #11;
        s = 3'b001;
        #9;
        s = 3'b000;
        #17;
        s = 3'b001;
        #14;
        s = 3'b000;
        #15;
        s = 3'b001;
        #16;
        s = 3'b011;
        #6;
        s = 3'b111;
        #30;
        $finish;
    end

endmodule