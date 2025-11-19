// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
/*
Activity 4.5 – Counters and LED shift patterns

General idea:
  - Use the main clock to generate a slow "step" signal (step_en).
  - Implement at least two patterns in an 8-LED vector:
      * Pattern 1: binary counter (free-running counter).
      * Pattern 2: shifting bit (shift register / “running light”).
  - Extension: a "ping-pong" pattern that bounces from one end to the other.
  - Select the pattern using some keys (key).
*/

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used in this activity)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used in this activity)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // In this activity we don’t use the display, LCD or GPIO.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is handled by the board wrapper

    // -------------------------------------------------------------------------
    // Frequency divider to generate slow "steps"
    // -------------------------------------------------------------------------
    //
    // The FPGA runs at ~27 MHz. A 24-bit counter takes ~2^24 cycles
    // to overflow. This produces a "step_en" pulse we can use as a tick
    // to advance the LED patterns.

    localparam int W_DIV = 24;

    logic [W_DIV-1:0] div_cnt;
    logic             step_en;

    always_ff @(posedge clock or posedge reset)
        if (reset)
            div_cnt <= '0;
        else
            div_cnt <= div_cnt + 1'b1;

    // Enable pulse when the counter overflows
    assign step_en = (div_cnt == '0);

    // -------------------------------------------------------------------------
    // Display mode selected through keys
    // -------------------------------------------------------------------------
    //
    //   key[1:0] → pattern mode:
    //     00: binary counter
    //     01: circular shift
    //     10: ping-pong (bounce)
    //     11: XOR mix of counter and circular shift

    logic [1:0] mode;
    assign mode = key[1:0];

    // -------------------------------------------------------------------------
    // LED Patterns
    // -------------------------------------------------------------------------

    // Pattern 1: 8-bit binary counter.
    logic [7:0] counter_pattern;

    // Pattern 2: circular shift register (running light).
    logic [7:0] shift_pattern;

    // Pattern 3: ping-pong (bit bouncing between extremes).
    logic [7:0] pingpong_pattern;
    logic       pingpong_dir; // 0 = to the left, 1 = to the right

    // Initialization and pattern update
    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            counter_pattern  <= 8'd0;
            shift_pattern    <= 8'b0000_0001;  // Start with one bit on
            pingpong_pattern <= 8'b0000_0001;  // Also begin at bit 0
            pingpong_dir     <= 1'b0;          // 0 = moving left (towards MSB)
        end
        else if (step_en)
        begin
            // Pattern 1: free-running counter
            counter_pattern <= counter_pattern + 8'd1;

            // Pattern 2: circular left shift
            shift_pattern <= { shift_pattern[6:0], shift_pattern[7] };

            // Pattern 3: ping-pong (bounce between 0000_0001 and 1000_0000)
            if (!pingpong_dir)
            begin
                // Moving left (towards MSB)
                if (pingpong_pattern == 8'b1000_0000)
                begin
                    // Reached left limit → change direction
                    pingpong_dir     <= 1'b1;
                    pingpong_pattern <= 8'b0100_0000;
                end
                else
                    pingpong_pattern <= pingpong_pattern << 1;
            end
            else
            begin
                // Moving right (towards LSB)
                if (pingpong_pattern == 8'b0000_0001)
                begin
                    // Reached right limit → change direction
                    pingpong_dir     <= 1'b0;
                    pingpong_pattern <= 8'b0000_0010;
                end
                else
                    pingpong_pattern <= pingpong_pattern >> 1;
            end
        end

    // -------------------------------------------------------------------------
    // Pattern selection for the LEDs
    // -------------------------------------------------------------------------

    logic [7:0] leds_next;

    always_comb
    begin
        // Default value
        leds_next = counter_pattern;

        unique case (mode)
            2'b00: leds_next = counter_pattern;                  // Mode 0: counter
            2'b01: leds_next = shift_pattern;                    // Mode 1: circular
            2'b10: leds_next = pingpong_pattern;                 // Mode 2: ping-pong
            2'b11: leds_next = counter_pattern ^ shift_pattern;  // Mode 3: XOR mix
            default: leds_next = counter_pattern;
        endcase
    end

    assign led = leds_next;

endmodule
