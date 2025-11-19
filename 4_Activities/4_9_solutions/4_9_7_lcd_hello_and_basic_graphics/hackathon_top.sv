Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
/*
Activity 4.7 – LCD "HELLO" + basic graphics

General idea:
  - Draw a frame around the screen.
  - Inner background is a soft blue/gray tone.
  - A central band is reserved for the word "HELLO".
  - Each letter (H, E, L, L, O) is formed with block rectangles.
  - At the bottom, a status bar changes color with key[0].

Coordinates:
  x: 0..479
  y: 0..271
*/

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Seven-segment display (not used in this activity)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface: current pixel coordinates
    input  logic [8:0] x,   // 0 .. 479
    input  logic [8:0] y,   // 0 .. 271

    // RGB color output (5-6-5 bits)
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio   // Not used here
);

    // -------------------------------------------------------------------------
    // Screen parameters (match the 480x272 LCD controller)
    // -------------------------------------------------------------------------

    localparam int SCREEN_W = 480;
    localparam int SCREEN_H = 272;

    // -------------------------------------------------------------------------
    // LEDs and seven-segment display
    // -------------------------------------------------------------------------

    assign led      = key;    // Just reflect keys on LEDs
    assign abcdefgh = 8'h00;  // 7-segment display turned off
    assign digit    = 8'h00;

    // -------------------------------------------------------------------------
    // Auxiliary signals for the "HELLO" letters
    // -------------------------------------------------------------------------

    logic in_H;
    logic in_E;
    logic in_L1;
    logic in_L2;
    logic in_O;

    // Vertical text band
    localparam int HELLO_TOP    = 80;
    localparam int HELLO_BOTTOM = 200;

    // Approx. width of each letter cell
    localparam int LETTER_W = 60;

    // Starting X position of text
    localparam int HELLO_X0 = 60;
    localparam int HELLO_X1 = HELLO_X0 + 5*LETTER_W;

    // Stroke thickness
    localparam int STROKE       = 6;
    localparam int HELLO_MID_Y  = (HELLO_TOP + HELLO_BOTTOM) / 2;
    localparam int MID_Y_TOP    = HELLO_MID_Y - STROKE/2;
    localparam int MID_Y_BOTTOM = HELLO_MID_Y + STROKE/2;

    // X ranges for each letter
    localparam int H_X0  = HELLO_X0 + 0*LETTER_W;
    localparam int H_X1  = H_X0 + LETTER_W;

    localparam int E_X0  = HELLO_X0 + 1*LETTER_W;
    localparam int E_X1  = E_X0 + LETTER_W;

    localparam int L1_X0 = HELLO_X0 + 2*LETTER_W;
    localparam int L1_X1 = L1_X0 + LETTER_W;

    localparam int L2_X0 = HELLO_X0 + 3*LETTER_W;
    localparam int L2_X1 = L2_X0 + LETTER_W;

    localparam int O_X0  = HELLO_X0 + 4*LETTER_W;
    localparam int O_X1  = O_X0 + LETTER_W;

    // -------------------------------------------------------------------------
    // LCD drawing logic
    // -------------------------------------------------------------------------

    always_comb
    begin
        // Default background: black
        red   = '0;
        green = '0;
        blue  = '0;

        // Reset letter flags
        in_H  = 1'b0;
        in_E  = 1'b0;
        in_L1 = 1'b0;
        in_L2 = 1'b0;
        in_O  = 1'b0;

        // ---------------------------------------------------------------------
        // 1) Screen border
        // ---------------------------------------------------------------------
        // 4-pixel-thick white frame.

        if (x < 4 || x >= SCREEN_W-4 || y < 4 || y >= SCREEN_H-4)
        begin
            red   = 5'b11111;
            green = 6'b111111;
            blue  = 5'b11111;
        end

        // ---------------------------------------------------------------------
        // 2) Interior (non-border)
        // ---------------------------------------------------------------------
        if (!(x < 4 || x >= SCREEN_W-4 || y < 4 || y >= SCREEN_H-4))
        begin
            // Soft blue-gray background
            red   = 5'd2;
            green = 6'd4;
            blue  = 5'd8;

            // -----------------------------------------------------------------
            // 2.1) Central "HELLO" band
            // -----------------------------------------------------------------

            if (   (y >= HELLO_TOP)   && (y < HELLO_BOTTOM)
                && (x >= HELLO_X0)    && (x < HELLO_X1) )
            begin
                // Text band background (light cyan)
                red   = 5'd4;
                green = 6'd10;
                blue  = 5'd15;

                // -------------------------------------------------------------
                // Letter strokes
                // -------------------------------------------------------------

                // H
                in_H =
                    // Left vertical bar
                    (x >= H_X0 && x < H_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Right vertical bar
                    (x >= H_X1 - STROKE && x < H_X1 &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Middle horizontal bar
                    (y >= MID_Y_TOP && y < MID_Y_BOTTOM &&
                     x >= H_X0 + STROKE && x < H_X1 - STROKE);

                // E
                in_E =
                    // Left vertical bar
                    (x >= E_X0 && x < E_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Top horizontal bar
                    (y >= HELLO_TOP && y < HELLO_TOP + STROKE &&
                     x >= E_X0 && x < E_X1)
                    ||
                    // Middle horizontal bar
                    (y >= MID_Y_TOP && y < MID_Y_BOTTOM &&
                     x >= E_X0 && x < E_X1)
                    ||
                    // Bottom horizontal bar
                    (y >= HELLO_BOTTOM - STROKE && y < HELLO_BOTTOM &&
                     x >= E_X0 && x < E_X1);

                // L1
                in_L1 =
                    (x >= L1_X0 && x < L1_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    (y >= HELLO_BOTTOM - STROKE && y < HELLO_BOTTOM &&
                     x >= L1_X0 && x < L1_X1);

                // L2
                in_L2 =
                    (x >= L2_X0 && x < L2_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    (y >= HELLO_BOTTOM - STROKE && y < HELLO_BOTTOM &&
                     x >= L2_X0 && x < L2_X1);

                // O
                in_O =
                    // Top
                    (y >= HELLO_TOP && y < HELLO_TOP + STROKE &&
                     x >= O_X0 && x < O_X1)
                    ||
                    // Bottom
                    (y >= HELLO_BOTTOM - STROKE && y < HELLO_BOTTOM &&
                     x >= O_X0 && x < O_X1)
                    ||
                    // Left
                    (x >= O_X0 && x < O_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Right
                    (x >= O_X1 - STROKE && x < O_X1 &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM);
            end

            // -----------------------------------------------------------------
            // 2.2) Letter color
            // -----------------------------------------------------------------
            if (in_H || in_E || in_L1 || in_L2 || in_O)
            begin
                red   = 5'b11111;
                green = 6'd0;
                blue  = 5'd0;
            end

            // -----------------------------------------------------------------
            // 2.3) Bottom status bar
            // -----------------------------------------------------------------
            if (y >= SCREEN_H - 30)
            begin
                if (key[0])
                begin
                    red   = 5'd0;
                    green = 6'b111111;
                    blue  = 5'd0;
                end
                else
                begin
                    red   = 5'd0;
                    green = 6'd0;
                    blue  = 5'b11111;
                end
            end
        end
    end

endmodule
