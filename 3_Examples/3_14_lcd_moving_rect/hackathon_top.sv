 // Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
 // 3.14: LCD – Moving rectangle
 //
 // This example extends the previous one (static shapes) by adding:
 // - A red rectangle moving horizontally.
 // - A strobe (~30 Hz) to update the position.
 // - The position value displayed on LEDs and the 7-segment display.
 //
 // The board wrapper handles video timing;
 // here we only decide pixel color based on (x, y) and a counter.

 module hackathon_top
 (
     input  logic       clock,
     input  logic       slow_clock,   // not used in this example
     input  logic       reset,

     input  logic [7:0] key,          // reserved for exercises
     output logic [7:0] led,

     // 7-segment display
     output logic [7:0] abcdefgh,
     output logic [7:0] digit,

     // LCD interface
     input  logic [8:0] x,            // 0..479
     input  logic [8:0] y,            // 0..271

     output logic [4:0] red,
     output logic [5:0] green,
     output logic [4:0] blue,

     inout  logic [3:0] gpio          // not used
 );
     // --------------------------------------------------------------------
     // Screen parameters
     // --------------------------------------------------------------------
     localparam int unsigned SCREEN_WIDTH  = 480;
     localparam int unsigned SCREEN_HEIGHT = 272;

     // --------------------------------------------------------------------
     // Generate a slow pulse with strobe_gen (~30 Hz)
     // --------------------------------------------------------------------
     logic pulse;

     // On this board, the typical clock is 27 MHz (see original config)
     strobe_gen #(
         .clk_mhz   (27),
         .strobe_hz (30)    // ~30 times per second
     ) i_strobe_gen (
         .clk    (clock),
         .rst    (reset),
         .strobe (pulse)
     );

     // --------------------------------------------------------------------
     // Horizontal position counter for the rectangle
     // --------------------------------------------------------------------
     //
     // rect_offset increments when pulse arrives, and resets when reaching
     // the limit. This makes the rectangle “travel” across part of the screen
     // from left to right and restart.

     logic [8:0] rect_offset;  // enough for 0..480

     always_ff @(posedge clock or posedge reset) begin
         if (reset) begin
             rect_offset <= 9'd0;
         end
         else if (pulse) begin
             if (rect_offset >= SCREEN_WIDTH/2) begin
                 rect_offset <= 9'd0;
             end
             else begin
                 rect_offset <= rect_offset + 9'd1;
             end
         end
     end

     // --------------------------------------------------------------------
     // Display rectangle position on LEDs and 7-segment display
     // --------------------------------------------------------------------
     //
     // - LEDs: show the 8 least significant bits of rect_offset.
     // - 7-segment: shows rect_offset as a number (hex or dec depending on module).

     assign led = rect_offset[7:0];

     seven_segment_display #(
         .w_digit (8)   // 8 digits on the hackathon TM1638 module
     ) i_7segment (
         .clk      (clock),
         .rst      (reset),
         .number   (rect_offset),  // extended internally
         .dots     (8'b0000_0000),
         .abcdefgh (abcdefgh),
         .digit    (digit)
     );

     // --------------------------------------------------------------------
     // Video logic: colors based on (x, y) and rect_offset
     // --------------------------------------------------------------------
     //
     // Draw:
     // - Black background.
     // - A fixed green horizontal bar (optional, can be extended).
     // - A red rectangle moving horizontally.
     //
     // The red rectangle “travels” by adding rect_offset to its base position.

     // Rectangle parameters
     localparam int unsigned RECT_WIDTH  = 50;
     localparam int unsigned RECT_HEIGHT = 60;

     // Base position of the rectangle (without offset)
     localparam int unsigned RECT_X_BASE = 80;
     localparam int unsigned RECT_Y_TOP  = 100;

     // Current coordinates of the rectangle (with offset)
     logic [8:0] rect_x_left;
     logic [8:0] rect_x_right;

     always_comb begin
         rect_x_left  = RECT_X_BASE + rect_offset;
         rect_x_right = rect_x_left + RECT_WIDTH;
     end

     always_comb begin
         // 1) Black background
         red   = 5'd0;
         green = 6'd0;
         blue  = 5'd0;

         // 2) Moving red rectangle
         if (x >= rect_x_left  && x <= rect_x_right &&
             y >= RECT_Y_TOP   && y <= RECT_Y_TOP + RECT_HEIGHT) begin
             red   = 5'd31;  // max red
             green = 6'd0;
             blue  = 5'd0;
         end
     end

 endmodule
