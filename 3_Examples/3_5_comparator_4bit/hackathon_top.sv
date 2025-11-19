// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.5: 4-bit Comparator (A vs B) with two implementations.
//
// General idea:
// - Inputs:
//     A[3:0] = key[3:0]
//     B[3:0] = key[7:4]
// - Outputs (two comparators):
//     Implementation 0 (high-level: ==, >, <)
//       eq0 = (A == B)
//       gt0 = (A >  B)
//       lt0 = (A <  B)
//
//     Implementation 1 (bit-by-bit, “cascaded comparator”):
//       eq1, gt1, lt1 computed from bit-by-bit comparisons.
//
// LED mapping:
//   led[0] = eq0   (A == B)  – implementation 0
//   led[1] = gt0   (A >  B)
//   led[2] = lt0   (A <  B)
//
//   led[3] = eq1   (A == B)  – implementation 1
//   led[4] = gt1   (A >  B)
//   led[5] = lt1   (A <  B)
//
//   led[7:6] = 0   (unused)

module hackathon_top
(
    // Standard interface for this board
    input  logic       clock,
    input  logic       slow_clock,
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

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Comparator inputs
    // ------------------------------------------------------------------------
    //
    // A = key[3:0]
    // B = key[7:4]
    //
    // Changing key bits forms two 4-bit values
    // which are compared against each other.

    logic [3:0] A, B;

    assign A = key[3:0];
    assign B = key[7:4];

    // ------------------------------------------------------------------------
    // Implementation 0: high-level comparator (==, >, <)
    // ------------------------------------------------------------------------

    logic eq0, gt0, lt0;

    always_comb begin
        eq0 = (A == B);
        gt0 = (A  > B);
        lt0 = (A  < B);
    end

    // ------------------------------------------------------------------------
    // Implementation 1: bit-by-bit cascaded comparator
    // ------------------------------------------------------------------------
    //
    // Idea:
    //   - First check the most significant bit (MSB).
    //   - If A[3] and B[3] differ, the MSB decides.
    //   - If equal, move to next bit (A[2], B[2]), and so on.
    //   - If all bits are equal, then A == B.

    logic eq1, gt1, lt1;

    always_comb begin
        eq1 = 1'b0;
        gt1 = 1'b0;
        lt1 = 1'b0;

        if (A[3] != B[3]) begin
            gt1 = (A[3] & ~B[3]);
            lt1 = (~A[3] & B[3]);
        end
        else if (A[2] != B[2]) begin
            gt1 = (A[2] & ~B[2]);
            lt1 = (~A[2] & B[2]);
        end
        else if (A[1] != B[1]) begin
            gt1 = (A[1] & ~B[1]);
            lt1 = (~A[1] & B[1]);
        end
        else if (A[0] != B[0]) begin
            gt1 = (A[0] & ~B[0]);
            lt1 = (~A[0] & B[0]);
        end
        else begin
            eq1 = 1'b1;
        end
    end

    // ------------------------------------------------------------------------
    // Connect results to LEDs
    // ------------------------------------------------------------------------

    always_comb begin
        led[0] = eq0;
        led[1] = gt0;
        led[2] = lt0;

        led[3] = eq1;
        led[4] = gt1;
        led[5] = lt1;

        led[6] = 1'b0;
        led[7] = 1'b0;
    end

endmodule
