
module traffic_controller(
    input clk,
    input reset,
    input emergency_NS,
    input emergency_EW,
    output reg [2:0] lights_NS, // [Red, Yellow, Green]
    output reg [2:0] lights_EW
);

    reg [3:0] timer;
    reg [2:0] state;

    localparam NS_GREEN   = 3'b000,
               NS_YELLOW  = 3'b001,
               EW_GREEN   = 3'b010,
               EW_YELLOW  = 3'b011,
               EMERGENCY_NS = 3'b100,
               EMERGENCY_EW = 3'b101;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= NS_GREEN;
            timer <= 0;
        end else begin
            case (state)
                NS_GREEN: begin
                    if (emergency_EW) state <= EMERGENCY_EW;
                    else if (timer < 10) timer <= timer + 1;
                    else begin
                        timer <= 0;
                        state <= NS_YELLOW;
                    end
                end
                NS_YELLOW: begin
                    if (timer < 2) timer <= timer + 1;
                    else begin
                        timer <= 0;
                        state <= EW_GREEN;
                    end
                end
                EW_GREEN: begin
                    if (emergency_NS) state <= EMERGENCY_NS;
                    else if (timer < 10) timer <= timer + 1;
                    else begin
                        timer <= 0;
                        state <= EW_YELLOW;
                    end
                end
                EW_YELLOW: begin
                    if (timer < 2) timer <= timer + 1;
                    else begin
                        timer <= 0;
                        state <= NS_GREEN;
                    end
                end
                EMERGENCY_NS: begin
                    if (!emergency_NS) begin
                        timer <= 0;
                        state <= NS_GREEN;
                    end
                end
                EMERGENCY_EW: begin
                    if (!emergency_EW) begin
                        timer <= 0;
                        state <= EW_GREEN;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        lights_NS = 3'b100; // Default RED
        lights_EW = 3'b100;
        case (state)
            NS_GREEN:  lights_NS = 3'b001; // GREEN
            NS_YELLOW: lights_NS = 3'b010; // YELLOW
            EW_GREEN:  lights_EW = 3'b001;
            EW_YELLOW: lights_EW = 3'b010;
            EMERGENCY_NS: lights_NS = 3'b001;
            EMERGENCY_EW: lights_EW = 3'b001;
        endcase
    end

endmodule
