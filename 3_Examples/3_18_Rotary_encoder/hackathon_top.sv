// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.18: Rotary encoder (KY-040) + TM1638 + LCD helper
//
// Example of using a KY-040 rotary encoder connected to gpio[3:2]:
//   - gpio[3] = CLK (channel A)
//   - gpio[2] = DT  (channel B)
//
// The decoded value is displayed:
//   - On the seven-segment display (TM1638) as a number.
//   - On the LEDs (8 LSB) as binary debug.
//   - As a vertical “threshold” on the LCD: for columns with x > value, the pixel is blue.
//
// The helper modules sync_and_debounce and rotary_encoder are reused without modifications.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // not used in this example
    input  logic       reset,

    input  logic [7:0] key,          // reserved for exercises
    output logic [7:0] led,

    // Seven-segment display (TM1638)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface
    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // --------------------------------------------------------------------
    // KY-040 encoder on gpio[3:2]
    // --------------------------------------------------------------------
    //
    // Typical pin names on the module:
    //   CLK - channel A
    //   DT  - channel B
    //
    // First, synchronize and debounce the encoder signals.

    logic a;
    logic b;

    sync_and_debounce #(
        .w (2)
    ) i_sync_and_debounce (
        .clk   (clock),
        .reset (reset),
        .sw_in (gpio[3:2]),
        .sw_out({b, a})
    );

    // --------------------------------------------------------------------
    // Rotary encoder decoder
    // --------------------------------------------------------------------
    //
    // The module rotary_encoder outputs a 16-bit value that increments
    // or decrements depending on encoder rotation.

    logic [15:0] value;

    rotary_encoder i_rotary_encoder (
        .clk   (clock),
        .reset (reset),
        .a     (a),
        .b     (b),
        .value (value)
    );

    // --------------------------------------------------------------------
    // TM1638 (seven-segment) and LED visualization
    // --------------------------------------------------------------------

    seven_segment_display #(
        .w_digit (8)   // 8 digits on the TM1638 module
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   (32'(value)),   // extend to 32 bits internally
        .dots     ('0),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // LEDs show the 8 LSB of the encoder value.
    assign led = value[7:0];

    // --------------------------------------------------------------------
    // LCD video logic: vertical threshold controlled by the encoder
    // --------------------------------------------------------------------
    //
    // For all coordinates with x > value[8:0], paint blue.
    // As the encoder rotates, the vertical threshold shifts.
    // Blue intensity varies with x (simple visual effect).

    always_comb begin
        // Black background
        red   = 5'd0;
        green = 6'd0;
        blue  = 5'd0;

        // Region to the right of the threshold
        if (x > value[8:0]) begin
            red   = 5'd0;
            green = 6'd0;
            blue  = x[4:0];   // blue intensity based on x
        end
    end

    // --------------------------------------------------------------------
    // Additional exercise ideas (kept from original)
    // --------------------------------------------------------------------
    //
    // - Exercise 1:
    //   Use value to control the position of a rectangle on the LCD
    //   (similar to 3.14 but driven by encoder value).
    //
    // - Exercise 2:
    //   Connect two encoders: one for X and another for Y movement.

endmodule
