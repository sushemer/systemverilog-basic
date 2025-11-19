// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.13: LCD – Basic static shapes
//
// First example of LCD usage:
// - Use pixel coordinates (x,y) to decide color.
// - Draw bars and a fixed rectangle.
// - No counters, no movement, no key usage.
//
// The board wrapper handles video timing;
// here we only decide the pixel color.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // not used in this example
    input  logic       reset,        // not used here, kept for consistency

    input  logic [7:0] key,          // not used in this example
    output logic [7:0] led,          // off

    // 7-segment display (off in this example)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Current pixel coordinates on the LCD
    input  logic [8:0] x,            // 0..479
    input  logic [8:0] y,            // 0..271

    // Current pixel color
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
    // Non-graphics outputs: all off
    // --------------------------------------------------------------------
    always_comb begin
        led       = 8'h00;
        abcdefgh  = 8'h00;
        digit     = 8'h00;
        // gpio left unassigned (unused port)
    end

    // --------------------------------------------------------------------
    // Color logic based only on (x, y)
    // --------------------------------------------------------------------
    //
    // Drawing layers (from lowest to highest priority):
    //  1) Black background.
    //  2) Red vertical bar at x ~ 100.
    //  3) Green horizontal bar at y ~ 50.
    //  4) Yellow rectangle centered on screen.
    //
    // Priority:
    //   center rectangle > horizontal bar > vertical bar > background.

    always_comb begin
        // 1) Black background
        red   = 5'd0;
        green = 6'd0;
        blue  = 5'd0;

        // 2) Red vertical bar (y = 20 to SCREEN_HEIGHT - 20)
        if (x >= 95 && x <= 105 &&
            y >= 20 && y <= SCREEN_HEIGHT - 20) begin
            red   = 5'd31;  // strong red
            green = 6'd0;
            blue  = 5'd0;
        end

        // 3) Green horizontal bar (x = 20 to SCREEN_WIDTH - 20)
        if (y >= 45 && y <= 55 &&
            x >= 20 && x <= SCREEN_WIDTH - 20) begin
            red   = 5'd0;
            green = 6'd50; // bright green
            blue  = 5'd0;
        end

        // 4) Center yellow rectangle
        if (x >= (SCREEN_WIDTH/2  - 40) && x <= (SCREEN_WIDTH/2  + 40) &&
            y >= (SCREEN_HEIGHT/2 - 30) && y <= (SCREEN_HEIGHT/2 + 30)) begin
            red   = 5'd31;
            green = 6'd63;
            blue  = 5'd0;
        end
    end

endmodule
