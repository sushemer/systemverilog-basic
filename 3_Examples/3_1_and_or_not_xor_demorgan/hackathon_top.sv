// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Example 3.1: basic logic gates + verification of a De Morgan law.
//
// This module is intended as a "top":
// - It uses 2 digital inputs (key[1:0]) as signals A and B.
// - It uses 5 LEDs (led[4:0]) to display results of AND, OR, XOR and De Morgan outputs.
// - It does not use a clock or sequential logic; everything is purely combinational.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // A dynamic seven-segment display

    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD screen interface

    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // Internally rename signals for clarity.
    // This helps reasoning in terms of A and B instead of key[1:0].
    logic A, B;
    assign A = key[1];
    assign B = key[0];

    // ------------------------------------------------------------------------
    // Basic gates
    // ------------------------------------------------------------------------
    // Each of these assignments is combinational and evaluated continuously:
    // any change in A or B is immediately reflected on the LEDs.

    assign led[0] = A & B;    // AND: only 1 when A = 1 and B = 1
    assign led[1] = A | B;    // OR: 1 when at least one input is 1
    assign led[2] = A ^ B;    // XOR: 1 when A and B differ

    // ------------------------------------------------------------------------
    // De Morgan law
    // ------------------------------------------------------------------------
    // Two different expressions are displayed, which must produce the same result:
    //
    //   1) ~(A & B)
    //   2) (~A) | (~B)
    //
    // The truth table shows that both expressions are equivalent.
    // In hardware, this equivalence can be "seen" when led[3] and led[4]
    // always match for all combinations of A and B.

    assign led[3] = ~(A & B);       // Expression 1: negation of AND
    assign led[4] = (~A) | (~B);    // Expression 2: OR of the negated inputs

    // If the wiring and code are correct:
    // - led[3] and led[4] must always turn on and off at the same time.
    // - This allows experimental verification of De Morgan’s law.

endmodule
