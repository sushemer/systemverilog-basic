// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.1 – Logic gates + De Morgan's law + combinational functions
//
// Tasks:
//  1) Implement AND, OR, XOR and one De Morgan law with 2 inputs (A, B).
//  2) Extend to 3 inputs (A, B, C) and design “majority” and “exactly one high” functions.
//  3) Add an enable input (EN) that forces all outputs to 0 when EN = 0.
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

    // 7-segment display, LCD and GPIO are not used in this activity.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // GPIO is handled by the board wrapper

    // -------------------------------------------------------------------------
    // Logical inputs
    // -------------------------------------------------------------------------
    //
    // Task 1 and 2:
    //   A = key[1]
    //   B = key[0]
    //   C = key[2]      (used in Task 2)
    //
    // Task 3:
    //   EN = key[3]     (enable input)

    logic A, B, C, EN;

    assign A  = key[1];
    assign B  = key[0];
    assign C  = key[2];
    assign EN = key[3];

    // -------------------------------------------------------------------------
    // Task 1: Basic logic gates + De Morgan (A and B)
    // -------------------------------------------------------------------------
    //
    // Objective:
    //   - led[0] = A AND B
    //   - led[1] = A OR  B
    //   - led[2] = A XOR B
    //   - led[3] = ~(A & B)
    //   - led[4] = (~A) | (~B)
    //
    // Intermediate signals; you must complete the assignments.

    logic and_ab;
    logic or_ab;
    logic xor_ab;
    logic demorgan_1;
    logic demorgan_2;

    // TODO: implement expressions for Task 1
    // assign and_ab     = ...;
    // assign or_ab      = ...;
    // assign xor_ab     = ...;
    // assign demorgan_1 = ...;  // ~(A & B)
    // assign demorgan_2 = ...;  // (~A) | (~B)

    // -------------------------------------------------------------------------
    // Task 2: Combinational functions with 3 inputs (A, B, C)
    // -------------------------------------------------------------------------
    //
    // Objective (example suggestion):
    //   - led[5] = “majority”: at least two inputs are high.
    //   - led[6] = “exactly one high”.
    //
    // Use AND, OR and NOT to build these functions.

    logic majority_abc;      // at least two inputs = 1
    logic exactly_one_abc;

    // TODO: implement expressions for Task 2
    // Example hint:
    // majority_abc = (A & B) | (A & C) | (B & C);
    // exactly_one_abc = ...;

    // -------------------------------------------------------------------------
    // Task 3: Enable input EN
    // -------------------------------------------------------------------------
    //
    // Requirement:
    //   - If EN = 0 → all LEDs [6:0] must be 0.
    //   - If EN = 1 → display the results of Tasks 1 and 2.
    //   - led[7] may show whether EN is active (e.g., led[7] = EN).
    //
    // Suggestion:
    //   - First group all logical results without EN.
    //   - Then use EN to “mask” the outputs.

    logic [6:0] raw_leds;  // logical outputs before enable

    always_comb
    begin
        raw_leds = 7'b0;

        // Task 1
        raw_leds[0] = and_ab;
        raw_leds[1] = or_ab;
        raw_leds[2] = xor_ab;
        raw_leds[3] = demorgan_1;
        raw_leds[4] = demorgan_2;

        // Task 2
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
