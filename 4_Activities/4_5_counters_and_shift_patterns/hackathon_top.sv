// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.5 – Counters and shift patterns on LEDs
//
// General idea:
//   - Use the main clock to generate a slow “step” (step_en).
//   - Implement at least two patterns in an 8-LED vector:
//       * Pattern 1: binary counter (free-running counter).
//       * Pattern 2: moving bit (shift register / “running light”).
//   - Select the pattern using some keys (key).
//
// NOTE: This file is an ACTIVITY TEMPLATE.
//       You must complete and/or modify the sections marked as TODO.
//

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

    // In this activity we do not use display, LCD, or GPIO.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is handled by the board wrapper

    // -------------------------------------------------------------------------
    // Frequency divider to generate “slow” steps
    // -------------------------------------------------------------------------
    //
    // The FPGA runs at ~27 MHz. A 24-bit counter takes ~2^24 cycles
    // to overflow. This produces a “step_en” pulse that we can use as a tick
    // to advance the LED patterns.

    localparam int W_DIV = 24;

    logic [W_DIV-1:0] div_cnt;
    logic             step_en;

    always_ff @(posedge clock or posedge reset)
        if (reset)
            div_cnt <= '0;
        else
            div_cnt <= div_cnt + 1'b1;

    assign step_en = (div_cnt == '0);

    // TODO (optional):
    // - You can change W_DIV or the step_en condition to speed up or
    //   slow down the animation.

    // -------------------------------------------------------------------------
    // LED patterns
    // -------------------------------------------------------------------------

    // Display mode selected by keys:
    //   key[1:0] → pattern mode.
    logic [1:0] mode;
    assign mode = key[1:0];

    // Pattern 1: 8-bit binary counter.
    logic [7:0] counter_pattern;

    // Pattern 2: shift register (running light / KITT).
    logic [7:0] shift_pattern;

    // (Optional) Pattern 3: you may create a “ping-pong” or mixed pattern.
    // logic [7:0] pingpong_pattern;

    // Initialization and update of patterns
    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            counter_pattern <= 8'd0;
            shift_pattern   <= 8'b0000_0001;  // Starts with a single lit bit
            // pingpong_pattern <= 8'b0000_0001;
        end
        else if (step_en)
        begin
            // Pattern 1: free-running binary counter
            counter_pattern <= counter_pattern + 8'd1;

            // Pattern 2: simple circular shift (base example)
            // TODO: you can change this logic to:
            //   - move the light only in one direction
            //   - implement a “ping-pong” bounce
            //   - create a more complex pattern
            shift_pattern <= { shift_pattern[6:0], shift_pattern[7] };

            // TODO (optional): implement here a third pattern,
            // for example ping-pong, using another variable.
        end

    // -------------------------------------------------------------------------
    // Pattern selection to the LEDs
    // -------------------------------------------------------------------------

    logic [7:0] leds_next;

    always_comb
    begin
        // Default value: binary counter
        leds_next = counter_pattern;

        unique case (mode)
            2'b00: leds_next = counter_pattern;           // Mode 0: counter
            2'b01: leds_next = shift_pattern;             // Mode 1: running light
            2'b10: leds_next = counter_pattern ^ shift_pattern;
            // Mode 2: example → XOR mix of both patterns
            2'b11: leds_next = ~counter_pattern;          // Mode 3: inverted
        endcase

        // TODO:
        // - You may redefine each mode to use different patterns.
        // - For example:
        //     00: counter
        //     01: running light
        //     10: ping-pong
        //     11: LEDs off or special pattern
    end

    assign led = leds_next;

endmodule
