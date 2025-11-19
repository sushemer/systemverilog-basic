// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.4 – 4-bit Mini ALU (add, subtract, logic)
//
// General idea:
//   - Two 4-bit operands: A and B.
//   - One 2-bit operation selector (op).
//   - ALU operations:
//       00: A + B
//       01: A - B
//       10: A & B
//       11: A ^ B   (or A | B)
//   - Flags:
//       carry → sum/sub carry/borrow
//       zero  → result == 0
//   - Display result and flags on LEDs.
//
// NOTE: This is an ACTIVITY TEMPLATE.
//       You must complete the TODO sections.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    output logic [7:0] abcdefgh, // unused
    output logic [7:0] digit,

    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;

    // -------------------------------------------------------------------------
    // Inputs: operands A, B and operation selector op
    // -------------------------------------------------------------------------
    //
    // Suggested mapping:
    //   A = sw[3:0]
    //   B = sw[7:4]
    //   op = key[1:0]
    //
    // If the board wrapper has no switches, adapt to key[].

    logic [7:0] sw;  // optional if switches exist

    logic [3:0] A;
    logic [3:0] B;
    logic [1:0] op;

    assign A  = sw[3:0];
    assign B  = sw[7:4];
    assign op = key[1:0];

    // -------------------------------------------------------------------------
    // 4-bit Mini ALU
    // -------------------------------------------------------------------------

    logic [3:0] result;
    logic       carry;
    logic       zero;

    always_comb
    begin
        result = 4'd0;
        carry  = 1'b0;
        zero   = 1'b0;

        // TODO: implement ALU using a case on op
        //
        // case (op)
        //   2'b00: begin
        //       // A + B using 5-bit extended addition
        //   end
        //
        //   2'b01: begin
        //       // A - B using 5-bit extended subtraction
        //   end
        //
        //   2'b10: begin
        //       // A & B
        //   end
        //
        //   2'b11: begin
        //       // A ^ B (or A | B)
        //   end
        // endcase
        //
        // zero = (result == 4'd0);
    end

    // -------------------------------------------------------------------------
    // LED Output Mapping
    // -------------------------------------------------------------------------
    //
    //   led[3:0] = result
    //   led[4]   = carry
    //   led[5]   = zero
    //   led[7:6] = op

    always_comb
    begin
        led = 8'b0000_0000;

        led[3:0] = result;
        led[4]   = carry;
        led[5]   = zero;
        led[7:6] = op;
    end

endmodule
