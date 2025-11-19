# 4_9_1 – Solution Code (Logic Gates, De Morgan, Combinational Functions)

```systemverilog
// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.1 – Logic gates + De Morgan’s law + combinational functions
//
// Tasks:
//  1) Implement AND, OR, XOR and one form of De Morgan’s law with 2 inputs (A, B).
//  2) Extend to 3 inputs (A, B, C) and design the “majority” and “exactly one is 1” functions.
//  3) Add an enable input (EN) that turns off all outputs when EN = 0.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Dynamic 7-segment display (not used here)
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

    // We do not use display, LCD or GPIO in this activity.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is left unhandled here (wrapper handles it)

    // -------------------------------------------------------------------------
    // Logical inputs
    // -------------------------------------------------------------------------
    //
    // Tasks 1 and 2:
    //   A = key[1]
    //   B = key[0]
    //   C = key[2]   (used in Task 2)
    //
    // Task 3:
    //   EN = key[3]  (enable input)

    logic A, B, C, EN;

    assign A  = key[1];
    assign B  = key[0];
    assign C  = key[2];
    assign EN = key[3];

    // -------------------------------------------------------------------------
    // Task 1: Basic gates + De Morgan (A and B)
    // -------------------------------------------------------------------------
    //
    // Objective:
    //   - led[0] = A AND B
    //   - led[1] = A OR  B
    //   - led[2] = A XOR B
    //   - led[3] = ~(A & B)
    //   - led[4] = (~A) | (~B)

    logic and_ab;
    logic or_ab;
    logic xor_ab;
    logic demorgan_1;
    logic demorgan_2;

    // Implementation of Task 1
    assign and_ab     = A & B;
    assign or_ab      = A | B;
    assign xor_ab     = A ^ B;
    assign demorgan_1 = ~(A & B);       // first form
    assign demorgan_2 = (~A) | (~B);    // equivalent De Morgan form

    // -------------------------------------------------------------------------
    // Task 2: Combinational functions with 3 inputs (A, B, C)
    // -------------------------------------------------------------------------
    //
    // Objective (suggested example):
    //   - led[5] = “majority”: at least two inputs are 1.
    //   - led[6] = “exactly one input is 1”.
    //
    // We use AND, OR, and NOT to build these functions.

    logic majority_abc;
    logic exactly_one_abc;

    // Majority: at least two of {A,B,C} are 1
    // Hint: (A & B) | (A & C) | (B & C)
    assign majority_abc =
          (A & B)
        | (A & C)
        | (B & C);

    // Exactly one is 1:
    //   100 + 010 + 001
    assign exactly_one_abc =
          ( A  & ~B & ~C)
        | (~A &  B & ~C)
        | (~A & ~B &  C);

    // -------------------------------------------------------------------------
    // Task 3: Enable input EN
    // -------------------------------------------------------------------------
    //
    // Requirement:
    //   - If EN = 0 → all LEDs [6:0] must be 0.
    //   - If EN = 1 → show the results of Tasks 1 and 2.
    //   - led[7] indicates whether EN is active (led[7] = EN).

    logic [6:0] raw_leds;

    always_comb
    begin
        // Task 1 mapping
        raw_leds[0] = and_ab;
        raw_leds[1] = or_ab;
        raw_leds[2] = xor_ab;
        raw_leds[3] = demorgan_1;
        raw_leds[4] = demorgan_2;

        // Task 2 mapping
        raw_leds[5] = majority_abc;
        raw_leds[6] = exactly_one_abc;
    end

    // Apply enable
    always_comb
    begin
        if (EN)
            led[6:0] = raw_leds;
        else
            led[6:0] = 7'b0;

        led[7] = EN;
    end

endmodule
