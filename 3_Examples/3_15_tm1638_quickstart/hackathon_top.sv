 // Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
 // 3.16: TM1638 quickstart
 //
 // Goal: minimum and fast usage of the TM1638 module through:
 // - Keys (key[7:0])
 // - LEDs (led[7:0])
 // - 7-segment display (abcdefgh + digit)
 //
 // In this board configuration, the wrapper already handles
 // communication with the TM1638 (shift-register, multiplexing, etc.).
 // From this "hackathon_top" we only see:
 //   * key[7:0]   → digital inputs (keys / switches)
 //   * led[7:0]   → LED outputs
 //   * abcdefgh   → 7-segment segments + dot
 //   * digit[7:0] → digit enable signals
 //
 // This example:
 //  - Mirrors key[7:0] directly into led[7:0].
 //  - Shows the key value as a hexadecimal number on the TM1638.
 //  - Turns off the LCD (not used in this quickstart).

 module hackathon_top
 (
     input  logic       clock,
     input  logic       slow_clock,   // not used here
     input  logic       reset,

     // HW-154 / TM1638 logical inputs/outputs
     input  logic [7:0] key;
     output logic [7:0] led;

     // Dynamic 7-segment (TM1638)
     output logic [7:0] abcdefgh;
     output logic [7:0] digit;

     // LCD interface (not used in this example)
     input  logic [8:0] x;
     input  logic [8:0] y;
     output logic [4:0] red;
     output logic [5:0] green;
     output logic [4:0] blue;

     inout  logic [3:0] gpio    // not used
 );

     // --------------------------------------------------------------------
     // Turn off the LCD (not used here)
     // --------------------------------------------------------------------
     always_comb begin
         red   = '0;
         green = '0;
         blue  = '0;
     end

     // --------------------------------------------------------------------
     // 1) Mirror keys into LEDs
     // --------------------------------------------------------------------
     //
     // Basic idea:
     //  - If a key is '1' → the corresponding LED is on.
     //  - If it is '0' → LED is off.
     //
     // This is a quick test to confirm input/output pins work correctly.

     always_comb begin
         led = key;
     end

     // --------------------------------------------------------------------
     // 2) Show the value of key on the TM1638 (7-segment)
     // --------------------------------------------------------------------
     //
     // We use the seven_segment_display module (already in the repo).
     // This module:
     //  - Takes an N-bit number (4 bits per digit).
     //  - Displays it as hexadecimal across multiple digits.
     //  - Handles TM1638 multiplexing for abcdefgh / digit.
     //
     // Here:
     //  - Treat key[7:0] as a number 0–255.
     //  - Extend it to 32 bits (8 hex digits) with leading zeros.
     //  - seven_segment_display decides what to show in each digit.

     localparam int unsigned W_DIGIT = 8;             // TM1638 has 8 digits
     localparam int unsigned W_NUM   = W_DIGIT * 4;   // 4 bits per digit

     // Extend key (8 bits) to W_NUM bits, padding with zeros
     logic [W_NUM-1:0] number_hex;

     always_comb begin
         number_hex = '0;
         number_hex[7:0] = key;  // low byte = key value
     end

     seven_segment_display #(
         .w_digit (W_DIGIT)
     ) i_7segment (
         .clk      (clock),
         .rst      (reset),
         .number   (number_hex),
         .dots     (W_DIGIT'(0)),   // no decimal points
         .abcdefgh (abcdefgh),
         .digit    (digit)
     );

     // With this, when key[7:0] changes:
     //  - LEDs reflect the bits.
     //  - TM1638 shows the corresponding hexadecimal value.

 endmodule
