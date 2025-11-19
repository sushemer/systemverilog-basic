// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.9: Seven-segment letters (FPGA)
//
// General idea:
// - Use a "one-hot" shift register to activate each digit of the
//   7-segment display.
// - Depending on which digit is active, select the letter to display: F, P, G, A.
// - With a fast enough "enable" signal, the human eye sees the word "FPGA"
//   as solid, without noticeable flicker (multiplexing by persistence of vision).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // not used in this example
    input  logic       reset,

    input  logic [7:0] key,          // not used in the basic version
    output logic [7:0] led,          // used as debug for shift_reg

    // 7-segment display (multiplexed)
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
    // Turn off peripherals we are not using (LCD, GPIO)
    // ------------------------------------------------------------------------
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Frequency divider for multiplexing
    //
    // We use a large counter and generate a slow "enable" compared to the
    // clock, but fast enough so that the eye sees a steady word.
    // ------------------------------------------------------------------------

    logic [31:0] cnt;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            cnt <= '0;
        else
            cnt <= cnt + 32'd1;
    end

    // Enable pulse when the 23 least significant bits are 0.
    // Adjust this value if you want higher or lower refresh rate.
    wire enable = (cnt[22:0] == '0);

    // ------------------------------------------------------------------------
    // One-hot shift register to select active digit
    //
    // We will use 4 digits to display "F P G A".
    // The register cycles through the pattern:
    //   0001 -> 0010 -> 0100 -> 1000 -> 0001...
    // ------------------------------------------------------------------------

    localparam int N_DIGITS = 4;

    logic [N_DIGITS-1:0] shift_reg;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            // Start by activating digit 0 (LSB)
            shift_reg <= 4'b0001;
        else if (enable)
            // Circular left rotation:
            // bit 0 shifts out and re-enters as the most significant bit.
            shift_reg <= { shift_reg[0], shift_reg[N_DIGITS-1:1] };
    end

    // ------------------------------------------------------------------------
    // Letter encoding for the 7-segment display
    //
    // a,b,c,d,e,f,g,h map to bits [7:0] of "abcdefgh".
    // We use a typedef enum to give readable names to patterns.
    //
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h (decimal point)
    // ------------------------------------------------------------------------

    typedef enum bit [7:0]
    {
        F     = 8'b1000_1110,  // Shape of 'F' on 7 segments
        P     = 8'b1100_1110,  // 'P'
        G     = 8'b1011_1100,  // 'G'
        A     = 8'b1110_1110,  // 'A'
        space = 8'b0000_0000   // all segments off
    } seven_seg_encoding_e;

    seven_seg_encoding_e letter;

    // Select which letter to display based on the active digit.
    // shift_reg has a '1' at the index of the active digit.
    always_comb begin
        unique case (shift_reg)
            4'b1000: letter = F;     // digit 3 → F
            4'b0100: letter = P;     // digit 2 → P
            4'b0010: letter = G;     // digit 1 → G
            4'b0001: letter = A;     // digit 0 → A
            default: letter = space; // safety (should not occur)
        endcase
    end

    // Assign the encoded segments
    assign abcdefgh = letter;

    // Map the one-hot digit register to digit outputs.
    // The board has 8 digits; we only use the 4 least significant.
    assign digit = { 4'b0000, shift_reg };

    // Optional: also show the digit pattern on LEDs for debugging.
    assign led = { 4'b0000, shift_reg };

endmodule
