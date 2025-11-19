// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.2 – buttons_and_debounce
//
// General objective:
//   - Control an LED using a button, with near-immediate response.
//   - Practice continuous assignments (assign), use of ~, &, |, and simple wiring.
//
// Suggested tasks:
//   1) Make led[0] directly follow the button state (high level = LED ON).
//   2) Make led[1] turn ON when the button is RELEASED (inversion).
//   3) Use a second button as an "enable" to control led[2] with an AND gate.
//   4) Keep the rest of the LEDs OFF.
//
// NOTE: This is the LAB TEMPLATE. Complete the sections marked as TODO.

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

    // -------------------------------------------------------------------------
    // We do not use display, LCD, or GPIO in this lab
    // -------------------------------------------------------------------------
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is handled by the board wrapper

    // -------------------------------------------------------------------------
    // Logical inputs (buttons)
    // -------------------------------------------------------------------------
    //
    // Suggested mapping:
    //   btn = key[0]   → main button
    //   en  = key[1]   → enable button
    //
    // You may use the TM1638 or the onboard buttons, depending on
    // how the wrapper is connected.

    logic btn;
    logic en;

    assign btn = key[0];
    assign en  = key[1];

    // -------------------------------------------------------------------------
    // LED outputs (pure combinational logic using assign)
    // -------------------------------------------------------------------------
    //
    // Requirements:
    //   - led[0] = btn
    //   - led[1] = ~btn
    //   - led[2] = btn AND en
    //   - led[7:3] = 0
    //
    // Complete the continuous assignments (assign).

    // All upper bits OFF by default
    assign led[7:3] = 5'b00000;

    // TODO: complete the simple assignments
    //
    // direct assignment (button → LED)
    assign led[0] = btn;
    //
    // inverted assignment (LED ON when button is released)
    assign led[1] = ~btn;
    //
    // AND gate with enable
    assign led[2] = btn & en;

endmodule
