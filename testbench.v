
`timescale 1ns/1ps
module testbench;
    reg clk = 0;
    reg reset = 1;
    reg emergency_NS = 0;
    reg emergency_EW = 0;
    wire [2:0] lights_NS;
    wire [2:0] lights_EW;

    traffic_controller uut (
        .clk(clk),
        .reset(reset),
        .emergency_NS(emergency_NS),
        .emergency_EW(emergency_EW),
        .lights_NS(lights_NS),
        .lights_EW(lights_EW)
    );

    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | NS=%b | EW=%b", $time, lights_NS, lights_EW);
        #10 reset = 0;
        #150 emergency_EW = 1;
        #30 emergency_EW = 0;
        #200 emergency_NS = 1;
        #30 emergency_NS = 0;
        #500 $finish;
    end
endmodule
