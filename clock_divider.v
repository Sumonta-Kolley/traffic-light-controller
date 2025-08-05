
module clock_divider(
    input clk,
    output reg slow_clk
);
    reg [24:0] count = 0;
    parameter DIVISOR = 25000000; // For 1Hz from 50MHz

    always @(posedge clk) begin
        if (count == DIVISOR) begin
            count <= 0;
            slow_clk <= ~slow_clk;
        end else begin
            count <= count + 1;
        end
    end
endmodule
