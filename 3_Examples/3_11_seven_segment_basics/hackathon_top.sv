// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.11: Seven-segment basics
//
// Main concepts:
// - Use 4 bits (key[3:0]) as a hexadecimal value (0–15).
// - Display that value on ONE digit of the 7-segment display.
// - Turn the decimal point (segment h) on/off with key[4].
// - Also mirror the value on the LEDs for debugging.
//
// This example is the "minimal version" to understand:
//   * How segments are encoded (a..g + decimal point h).
//   * How to activate a single digit of the display.
//   * How to map a nibble (4 bits) to a character on 7-segment.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // not used in this example
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (multiplexed)
    output logic [7:0] abcdefgh,     // a b c d e f g h (decimal point)
    output logic [7:0] digit,        // digit selection

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
    // Turn off unused peripherals (LCD, GPIO)
    // ------------------------------------------------------------------------
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Inputs for the display:
    //   - value: hexadecimal digit to show (0–15)
    //   - dp   : control of the decimal point (segment h)
    // ------------------------------------------------------------------------
    logic [3:0] value;
    logic       dp;

    // Use key[3:0] as hex value and key[4] as decimal point control
    assign value = key[3:0];
    assign dp    = key[4];

    // Display the value on the lower LEDs (debug)
    always_comb begin
        led        = 8'h00;
        led[3:0]   = value;
        led[4]     = dp;     // visualize decimal point state
    end

    // ------------------------------------------------------------------------
    // HEX → 7-segment decoder
    //
    // Bit convention in abcdefgh:
    //   bit 7: a
    //   bit 6: b
    //   bit 5: c
    //   bit 4: d
    //   bit 3: e
    //   bit 2: f
    //   bit 1: g
    //   bit 0: h (decimal point)
    //
    // 1 = segment ON
    // 0 = segment OFF
    // ------------------------------------------------------------------------
    function automatic logic [7:0] hex_to_7seg (input logic [3:0] v);
        //   --a--
        //  |     |
        //  f     b
        //  |     |
        //   --g--
        //  |     |
        //  e     c
        //  |     |
        //   --d--  h (decimal point)
        //
        // Note: h (decimal point) will be overridden by 'dp'.
        begin
            unique case (v)
                4'h0: hex_to_7seg = 8'b1111_1100;
                4'h1: hex_to_7seg = 8'b0110_0000;
                4'h2: hex_to_7seg = 8'b1101_1010;
                4'h3: hex_to_7seg = 8'b1111_0010;
                4'h4: hex_to_7seg = 8'b0110_0110;
                4'h5: hex_to_7seg = 8'b1011_0110;
                4'h6: hex_to_7seg = 8'b1011_1110;
                4'h7: hex_to_7seg = 8'b1110_0000;
                4'h8: hex_to_7seg = 8'b1111_1110;
                4'h9: hex_to_7seg = 8'b1111_0110;
                4'hA: hex_to_7seg = 8'b1110_1110;
                4'hB: hex_to_7seg = 8'b0011_1110;
                4'hC: hex_to_7seg = 8'b1001_1100;
                4'hD: hex_to_7seg = 8'b0111_1010;
                4'hE: hex_to_7seg = 8'b1001_1110;
                4'hF: hex_to_7seg = 8'b1000_1110;
                default: hex_to_7seg = 8'b0000_0000;
            endcase
        end
    endfunction

    // ------------------------------------------------------------------------
    // Build final segment pattern (including decimal point)
    // ------------------------------------------------------------------------
    logic [7:0] segs_raw;
    logic [7:0] segs_with_dp;

    always_comb begin
        segs_raw       = hex_to_7seg(value);
        segs_with_dp   = segs_raw;
        segs_with_dp[0] = dp;  // override h with dp
    end

    assign abcdefgh = segs_with_dp;

    // ------------------------------------------------------------------------
    // Activate only one digit of the display
    //
    // We will activate digit 0 (bit 0 of 'digit').
    // Depending on board wiring it may be leftmost or rightmost.
    // ------------------------------------------------------------------------
    always_comb begin
        digit = 8'b0000_0001;  // one-hot: only one digit active
    end

endmodule
