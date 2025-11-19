// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Example 3.2: 2:1 multiplexer implemented in several ways.
//
// - Three bits of key are used:
//      key[0] = d0   (data 0)
//      key[1] = d1   (data 1)
//      key[7] = sel  (selector)
// - Inputs and outputs are displayed on LEDs:
//      led[0] = d0
//      led[1] = d1
//      led[2] = sel
//      led[3] = y_if     (implementation with if/else)
//      led[4] = y_tern   (implementation with ? : operator)
//      led[5] = y_case   (implementation with case)
//      led[6] = y_gate   (implementation with logic gates)
//      led[7] = 0
//
// If everything is correct, led[3], led[4], led[5], and led[6] MUST
// always display the same value for any combination of d0, d1 and sel.

module hackathon_top
(
    // Standard interface expected by board_specific_top
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used here)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD display interface (not used here)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // Generic GPIO (not used here)
    inout  logic [3:0] gpio
);

    // ------------------------------------------------------------------------
    // Tie everything we DO NOT use to known values
    // ------------------------------------------------------------------------

    // Turn off 7-segment display
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    // LCD screen black
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    // GPIO in high impedance (not used)
    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Input signals for the multiplexer
    // ------------------------------------------------------------------------

    logic d0, d1, sel;

    assign d0  = key[0];  // data 0
    assign d1  = key[1];  // data 1
    assign sel = key[7];  // selector

    // ------------------------------------------------------------------------
    // Four implementations of the same 2:1 mux
    // ------------------------------------------------------------------------

    logic y_if;
    logic y_tern;
    logic y_case;
    logic y_gate;

    // 1) Implementation using always_comb + if/else
    always_comb begin
        if (sel)
            y_if = d1;
        else
            y_if = d0;
    end

    // 2) Implementation using conditional operator ? :
    assign y_tern = sel ? d1 : d0;

    // 3) Implementation using case
    always_comb begin
        case (sel)
            1'b0: y_case = d0;
            1'b1: y_case = d1;
        endcase
    end

    // 4) Implementation using logic gates only
    //    y = (d1 & sel) | (d0 & ~sel)
    assign y_gate = (d1 & sel) | (d0 & ~sel);

    // ------------------------------------------------------------------------
    // Display inputs and outputs on LEDs
    // ------------------------------------------------------------------------

    assign led[0] = d0;
    assign led[1] = d1;
    assign led[2] = sel;

    assign led[3] = y_if;
    assign led[4] = y_tern;
    assign led[5] = y_case;
    assign led[6] = y_gate;

    assign led[7] = 1'b0;

endmodule
