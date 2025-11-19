// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.6: 3-bit Adder/Subtractor (A ± B) with two implementations.
//
// General idea:
// - Inputs (from buttons KEY[7:0]):
//     A[2:0] = key[2:0]
//     B[2:0] = key[5:3]
//     mode   = key[7]   (0 = A + B, 1 = A - B)
// - Outputs (two implementations):
//     Implementation 0 (high-level using + and -)
//     Implementation 1 (single adder using two’s complement)
//
// LED mapping:
//   Implementation 0 (high-level):
//     led[0] = s0[0]  (result bit 0)
//     led[1] = s0[1]
//     led[2] = s0[2]
//     led[3] = c0     (carry/borrow flag)
//
//   Implementation 1 (2’s complement):
//     led[4] = s1[0]
//     led[5] = s1[1]
//     led[6] = s1[2]
//     led[7] = c1
//
// Where:
//   - sX[2:0] = 3-bit result (A ± B)
//   - cX      = extra bit (carry out / no-borrow) from the 4-bit result
//
// Note: because A and B are 3-bit values, their range is 0–7 (unsigned).

module hackathon_top
(
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

    assign gpio  = 4'hz;   // High impedance on GPIO

    // ------------------------------------------------------------------------
    // Adder/Subtractor inputs
    // ------------------------------------------------------------------------
    //
    // A = key[2:0]
    // B = key[5:3]
    // mode = key[7]   (0 = addition, 1 = subtraction A - B)
    //
    // key[6] is not used in this example.

    logic [2:0] A, B;
    logic       mode;

    assign A    = key[2:0];
    assign B    = key[5:3];
    assign mode = key[7];

    // ------------------------------------------------------------------------
    // Implementation 0: high-level description (using + and -)
    // ------------------------------------------------------------------------
    //
    // When mode = 0: res0 = A + B
    // When mode = 1: res0 = A - B
    //
    // We work with 4 bits to have the extra carry/borrow bit.

    logic [3:0] res0;

    always_comb begin
        if (mode == 1'b0) begin
            res0 = {1'b0, A} + {1'b0, B};
        end
        else begin
            res0 = {1'b0, A} - {1'b0, B};
        end
    end

    logic [2:0] s0;
    logic       c0;

    assign s0 = res0[2:0];
    assign c0 = res0[3];

    // ------------------------------------------------------------------------
    // Implementation 1: adder-subtractor with two’s complement
    // ------------------------------------------------------------------------
    //
    // Classic adder-subtractor formula:
    //
    //   res1 = A + (B XOR M) + M
    //
    // where M = mode:
    //   M = 0 → res1 = A + B
    //   M = 1 → res1 = A + (~B) + 1 = A - B
    //
    // Again, use 4 bits to store the extra bit.

    wire  [2:0] B_xor = B ^ {3{mode}};
    logic [3:0] res1;

    assign res1 = {1'b0, A} + {1'b0, B_xor} + mode;

    logic [2:0] s1;
    logic       c1;

    assign s1 = res1[2:0];
    assign c1 = res1[3];

    // ------------------------------------------------------------------------
    // LED outputs
    // ------------------------------------------------------------------------
    //
    // Implementation 0 → LEDs 0–3
    // Implementation 1 → LEDs 4–7

    always_comb begin
        led[0] = s0[0];
        led[1] = s0[1];
        led[2] = s0[2];
        led[3] = c0;

        led[4] = s1[0];
        led[5] = s1[1];
        led[6] = s1[2];
        led[7] = c1;
    end

endmodule
