// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
/*
Activity 4.4 – 4-bit Mini ALU (addition, subtraction, logical ops)

General idea:
  - Two 4-bit operands: A and B.
  - A 2-bit operation selector (op).
  - A small ALU that performs, for example:
      00: A + B
      01: A - B
      10: A & B
      11: A ^ B
  - Simple flags:
      * carry → carry/borrow (in addition / subtraction)
      * zero  → result is 0
  - Show the result and flags on the LEDs.
*/

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used directly here)
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

    // In this activity we don’t use the display, LCD or GPIO.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is handled by the board wrapper

    // -------------------------------------------------------------------------
    // Inputs: operands A and B, and operation selector
    // -------------------------------------------------------------------------
    //
    // In the original template, the proposal was:
    //   - A = sw[3:0]
    //   - B = sw[7:4]
    //   - op = key[1:0]
    //
    // In this solution we map “sw” directly to “key” so we can use
    // the same keys as switches:
    //
    //   A  = key[3:0]
    //   B  = key[7:4]
    //   op = key[1:0]   (operation selector)
    //

    logic [7:0] sw;

    assign sw = key;   // simple alias following the template idea

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

    // Extended vectors to capture carry/borrow
    logic [4:0] sum_ext;
    logic [4:0] diff_ext;

    always_comb
    begin
        // Default values
        result  = 4'd0;
        carry   = 1'b0;
        zero    = 1'b0;
        sum_ext = 5'd0;
        diff_ext= 5'd0;

        case (op)
            2'b00: begin
                // Addition A + B
                sum_ext = {1'b0, A} + {1'b0, B};
                result  = sum_ext[3:0];
                carry   = sum_ext[4];  // carry from addition
            end

            2'b01: begin
                // Subtraction A - B
                diff_ext = {1'b0, A} - {1'b0, B};
                result   = diff_ext[3:0];
                // Use extra bit as simplified borrow/carry
                carry    = diff_ext[4];
            end

            2'b10: begin
                // Logical operation: AND
                result = A & B;
                carry  = 1'b0;
            end

            2'b11: begin
                // Logical operation: XOR
                result = A ^ B;
                carry  = 1'b0;
            end

            default: begin
                result = 4'd0;
                carry  = 1'b0;
            end
        endcase

        // Zero flag: 1 when result is 0
        zero = (result == 4'd0);
    end

    // -------------------------------------------------------------------------
    // Output to LEDs
    // -------------------------------------------------------------------------
    //
    //   led[3:0] → result[3:0]  (ALU result)
    //   led[4]   → carry        (carry / borrow)
    //   led[5]   → zero         (1 when result == 0)
    //   led[7:6] → op[1:0]      (current operation)
    //

    always_comb
    begin
        led = 8'b0000_0000;

        led[3:0] = result;
        led[4]   = carry;
        led[5]   = zero;
        led[7:6] = op;
    end

endmodule
