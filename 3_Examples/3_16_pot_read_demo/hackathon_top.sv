 // Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
 // 3.16: Potentiometer read demo (simulated with switches)
 //
 // In this example we simulate reading a potentiometer using 8 input bits.
 // The idea is:
 // - Obtain a "pot_value" from 0 to 255 (here it comes from key[7:0]).
 // - Display it on:
 //     * LEDs (binary pattern).
 //     * 7-segment display (numeric value).
 //     * LCD screen as a green horizontal bar whose width depends on pot_value.
 //

 module hackathon_top
 (
     input  logic       clock,
     input  logic       slow_clock,   // not used here
     input  logic       reset,

     input  logic [7:0] key,
     output logic [7:0] led,

     // Dynamic seven-segment display
     output logic [7:0] abcdefgh,
     output logic [7:0] digit,

     // LCD interface (video coordinates)
     input  logic [8:0] x,          // 0..479
     input  logic [8:0] y,          // 0..271

     output logic [4:0] red,
     output logic [5:0] green,
     output logic [4:0] blue,

     inout  logic [3:0] gpio        // not used
 );

     // --------------------------------------------------------------------
     // Screen parameters
     // --------------------------------------------------------------------
     localparam int unsigned SCREEN_WIDTH  = 480;
     localparam int unsigned SCREEN_HEIGHT = 272;

     // --------------------------------------------------------------------
     // "Potentiometer" value (0–255)
     // --------------------------------------------------------------------
     //
     // For now we simulate it with the 8 bits of key:
     // - key[7:0] = digital potentiometer value.
     //
     // If you had a real ADC, you would connect it here:
     //   logic [7:0] adc_data;
     //   ...
     //   logic [7:0] pot_value = adc_data;

     logic [7:0] pot_value;

     always_comb begin
         pot_value = key;   // simulation: switches/keys as pot value
     end

     // --------------------------------------------------------------------
     // Display pot_value on LEDs
     // --------------------------------------------------------------------
     //
     //  - LED on  = bit is 1
     //  - LED off = bit is 0

     always_comb begin
         led = pot_value;
     end

     // --------------------------------------------------------------------
     // Display pot_value on 7-segment display
     // --------------------------------------------------------------------
     //
     // We use the seven_segment_display module already available.
     // It shows the value in hexadecimal format (default).
     //
     // We only use the 8-bit value; the module expands the number internally.

     localparam int unsigned W_DIGIT = 8;
     localparam int unsigned W_NUM   = W_DIGIT * 4;  // 4 HEX bits per digit

     seven_segment_display #(
         .w_digit (W_DIGIT)
     ) i_7segment (
         .clk      (clock),
         .rst      (reset),
         .number   (W_NUM'(pot_value)),  // extended to W_NUM bits
         .dots     (W_DIGIT'(0)),
         .abcdefgh (abcdefgh),
         .digit    (digit)
     );

     // --------------------------------------------------------------------
     // Display pot_value as a bar on the LCD
     // --------------------------------------------------------------------
     //
     // We want a horizontal bar that goes from x=0 up to a width
     // proportional to pot_value:
     //
     //   bar_width = (pot_value / 255) * SCREEN_WIDTH
     //
     // To avoid division, we use multiplication followed by a shift (>> 8)
     // since pot_value is 8 bits (0..255).

     logic [15:0] bar_width;

     always_comb begin
         bar_width = (pot_value * SCREEN_WIDTH) >> 8;
     end

     // Define the vertical band of the bar:
     localparam int unsigned BAR_Y_TOP    = SCREEN_HEIGHT/2 - 10;
     localparam int unsigned BAR_Y_BOTTOM = SCREEN_HEIGHT/2 + 10;

     always_comb begin
         // Black background
         red   = 5'd0;
         green = 6'd0;
         blue  = 5'd0;

         // Green bar proportional to the "potentiometer" value
         if ( y >= BAR_Y_TOP && y <= BAR_Y_BOTTOM &&
              x <  bar_width )
         begin
             red   = 5'd0;
             green = 6'd50;  // fairly bright
             blue  = 5'd0;
         end

         // Vertical reference line (middle of the screen)
         if (x == SCREEN_WIDTH/2 && y < SCREEN_HEIGHT) begin
             red   = 5'd31;  // red
             green = 6'd0;
             blue  = 5'd0;
         end
     end

 endmodule
