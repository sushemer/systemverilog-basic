// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.8: Shift register controlled by button.
//
// Main idea:
// - Use a counter to generate a slow "enable" pulse from the fast clock.
// - Have an 8-bit shift register (one bit per LED).
// - On each enable pulse, the register shifts and a new bit enters
//   depending on the button state.
//
// Result:
// - The LEDs display a pattern that moves across the array.
// - If a button is held down, ones are continuously “injected” from one side.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // not used in this example
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used here)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used here)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO (not used here)
    inout  logic [3:0] gpio
);

    // ------------------------------------------------------------------------
    // Turn off unused peripherals
    // ------------------------------------------------------------------------
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio = 4'hz;

    // ------------------------------------------------------------------------
    // Frequency divider: 32-bit counter
    //
    // We use the fast FPGA clock and count cycles.
    // When the lower 23 bits are zero, we generate an "enable"
    // (roughly a few Hz with a ~27–50 MHz clock).
    // ------------------------------------------------------------------------

    logic [31:0] cnt;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            cnt <= '0;
        else
            cnt <= cnt + 32'd1;
    end

    // Slow enable pulse
    wire enable = (cnt[22:0] == '0);

    // ------------------------------------------------------------------------
    // Shift register
    //
    // - button_on = 1 if any key is pressed.
    // - shift_reg[7:0] shifts right on each enable.
    // - The bit entering from the left is button_on.
    //
    // Shift direction:
    //     shift_reg <= { button_on, shift_reg[7:1] };
    // ------------------------------------------------------------------------

    wire button_on = |key;

    logic [7:0] shift_reg;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            shift_reg <= 8'hFF;          // start full of ones (can be '0 if preferred)
        else if (enable)
            shift_reg <= { button_on, shift_reg[7:1] };
    end

    // LEDs show shift register content
    assign led = shift_reg;

endmodule
