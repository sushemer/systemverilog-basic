// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.4 – FSM: traffic light + sequence lock
//
// General idea:
//   - Two state machines in the same design:
//       1) Simple traffic light (R → G → Y → R) with configurable timing.
//       2) Button-sequence lock (A-B-A-B) that turns on an LED.
//
//   - Traffic light states advance using slow_clock (~1 Hz).
//   - The lock detects edges on two keys: key[4] ("A") and key[5] ("B").
//   - LEDs:
//       led[2] = red
//       led[1] = yellow
//       led[0] = green
//       led[7] = lock (correct sequence)
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used in this lab)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used in this lab)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // We do not use 7-segment, LCD nor GPIO in this lab.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is controlled by the board wrapper.

    // =========================================================================
    // 1) Traffic light FSM
    // =========================================================================

    // Traffic light states
    typedef enum logic [1:0]
    {
        TRAFFIC_RED    = 2'd0,
        TRAFFIC_GREEN  = 2'd1,
        TRAFFIC_YELLOW = 2'd2
    } traffic_state_t;

    traffic_state_t traffic_state;

    // Timing (in slow_clock ticks)
    localparam int T_RED    = 3;  // ~3 s (if slow_clock ~1 Hz)
    localparam int T_GREEN  = 3;  // ~3 s
    localparam int T_YELLOW = 1;  // ~1 s

    logic [3:0] traffic_timer;  // enough to count up to 7

    // FSM + timing using slow_clock
    always_ff @(posedge slow_clock or posedge reset)
        if (reset)
        begin
            traffic_state  <= TRAFFIC_RED;
            traffic_timer  <= 4'd0;
        end
        else
        begin
            unique case (traffic_state)
                TRAFFIC_RED:
                begin
                    if (traffic_timer == T_RED - 1)
                    begin
                        traffic_state <= TRAFFIC_GREEN;
                        traffic_timer <= 4'd0;
                    end
                    else
                        traffic_timer <= traffic_timer + 4'd1;
                end

                TRAFFIC_GREEN:
                begin
                    if (traffic_timer == T_GREEN - 1)
                    begin
                        traffic_state <= TRAFFIC_YELLOW;
                        traffic_timer <= 4'd0;
                    end
                    else
                        traffic_timer <= traffic_timer + 4'd1;
                end

                TRAFFIC_YELLOW:
                begin
                    if (traffic_timer == T_YELLOW - 1)
                    begin
                        traffic_state <= TRAFFIC_RED;
                        traffic_timer <= 4'd0;
                    end
                    else
                        traffic_timer <= traffic_timer + 4'd1;
                end

                default:
                begin
                    traffic_state <= TRAFFIC_RED;
                    traffic_timer <= 4'd0;
                end
            endcase
        end

    // Traffic light outputs
    logic red_on;
    logic yellow_on;
    logic green_on;

    always_comb
    begin
        red_on    = 1'b0;
        yellow_on = 1'b0;
        green_on  = 1'b0;

        unique case (traffic_state)
            TRAFFIC_RED:
                red_on = 1'b1;

            TRAFFIC_GREEN:
                green_on = 1'b1;

            TRAFFIC_YELLOW:
                yellow_on = 1'b1;

            default: ; // nothing
        endcase
    end

    // =========================================================================
    // 2) A-B-A-B sequence lock FSM
    // =========================================================================

    // Button mapping
    //   key[4] -> button A
    //   key[5] -> button B
    logic btnA;
    logic btnB;

    assign btnA = key[4];
    assign btnB = key[5];

    // Edge-detection registers (in slow_clock domain)
    logic btnA_q;
    logic btnB_q;

    always_ff @(posedge slow_clock or posedge reset)
        if (reset)
        begin
            btnA_q <= 1'b0;
            btnB_q <= 1'b0;
        end
        else
        begin
            btnA_q <= btnA;
            btnB_q <= btnB;
        end

    wire pulseA = btnA & ~btnA_q;  // rising edge on A
    wire pulseB = btnB & ~btnB_q;  // rising edge on B

    // Lock FSM states
    typedef enum logic [2:0]
    {
        LOCK_IDLE      = 3'd0, // waiting for first A
        LOCK_A1        = 3'd1, // A detected
        LOCK_A1B2      = 3'd2, // A,B detected
        LOCK_A1B2A3    = 3'd3, // A,B,A detected
        LOCK_OPEN      = 3'd4  // A,B,A,B complete
    } lock_state_t;

    lock_state_t lock_state;

    always_ff @(posedge slow_clock or posedge reset)
        if (reset)
        begin
            lock_state <= LOCK_IDLE;
        end
        else
        begin
            unique case (lock_state)

                // Waiting for A
                LOCK_IDLE:
                begin
                    if (pulseA)
                        lock_state <= LOCK_A1;
                    else if (pulseB)
                        lock_state <= LOCK_IDLE; // error → stay in idle
                end

                // Saw A, now expecting B
                LOCK_A1:
                begin
                    if (pulseB)
                        lock_state <= LOCK_A1B2;
                    else if (pulseA)
                        lock_state <= LOCK_IDLE; // error → reset
                end

                // Saw A,B; now expecting A
                LOCK_A1B2:
                begin
                    if (pulseA)
                        lock_state <= LOCK_A1B2A3;
                    else if (pulseB)
                        lock_state <= LOCK_IDLE; // error → reset
                end

                // Saw A,B,A; now expecting final B
                LOCK_A1B2A3:
                begin
                    if (pulseB)
                        lock_state <= LOCK_OPEN;
                    else if (pulseA)
                        lock_state <= LOCK_IDLE; // error → reset
                end

                // Lock open (remains here until reset)
                LOCK_OPEN:
                begin
                    lock_state <= LOCK_OPEN;
                end

                default:
                    lock_state <= LOCK_IDLE;
            endcase
        end

    // Lock LED ON only in LOCK_OPEN
    logic lock_led;
    assign lock_led = (lock_state == LOCK_OPEN);

    // =========================================================================
    // 3) Final LED mapping
    // =========================================================================

    always_comb
    begin
        led = 8'b0000_0000;

        // Traffic light
        led[0] = green_on;   // green
        led[1] = yellow_on;  // yellow
        led[2] = red_on;     // red

        // Lock
        led[7] = lock_led;

        // Others remain 0 by simplicity.
    end

endmodule
