# 4.2 – Decoder 2→4 + 4→1 Mux (Composition)

```systemverilog
// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.2 – Composition: decoder 2→4 + 4→1 mux
//
// General idea:
//   - Use 2 selection bits (sel) to choose 1 of 4 data inputs (data[3:0]).
//   - Implement a 2→4 “one-hot” decoder.
//   - Use that decoder to build a 4→1 mux with AND/OR gates.
//   - Visualize the decoder and mux output on the LEDs.
//
// NOTE: This file is an ACTIVITY TEMPLATE. Parts marked as TODO
//       must be completed by the student.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Dynamic 7-segment display (unused here)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (unused in this activity)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // In this activity we do not use display, LCD or GPIO.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is handled by the board wrapper

    // -------------------------------------------------------------------------
    // Logical inputs: selectors and mux data
    // -------------------------------------------------------------------------
    //
    // Proposed mapping:
    //   sel[1:0]  = key[1:0]
    //   data[3:0] = key[5:2]
    //
    // This allows selecting the channel (sel)
    // and changing each data[i] using the keys.

    logic [1:0] sel;
    logic [3:0] data;

    assign sel  = key[1:0];
    assign data = key[5:2];

    // -------------------------------------------------------------------------
    // 2→4 "one-hot" Decoder
    // -------------------------------------------------------------------------

    logic [3:0] dec_out;

    always_comb
    begin
        // Default value
        dec_out = 4'b0000;

        // Standard 2→4 decoder
        case (sel)
            2'b00: dec_out = 4'b0001; // channel 0
            2'b01: dec_out = 4'b0010; // channel 1
            2'b10: dec_out = 4'b0100; // channel 2
            2'b11: dec_out = 4'b1000; // channel 3
            default: dec_out = 4'b0000;
        endcase
    end

    // -------------------------------------------------------------------------
    // Composition: 4→1 mux built using decoder + AND + OR
    // -------------------------------------------------------------------------

    logic [3:0] and_terms;
    logic       mux_y;

    // AND of each data bit with its “one-hot” line
    assign and_terms[0] = dec_out[0] & data[0];
    assign and_terms[1] = dec_out[1] & data[1];
    assign and_terms[2] = dec_out[2] & data[2];
    assign and_terms[3] = dec_out[3] & data[3];

    // Final OR: selects the one masked data input
    assign mux_y = |and_terms;
    // Equivalent to:
    // assign mux_y = and_terms[0] | and_terms[1]
    //              | and_terms[2] | and_terms[3];

    // -------------------------------------------------------------------------
    // Outputs to LEDs
    // -------------------------------------------------------------------------

    always_comb
    begin
        led = 8'b0000_0000;

        led[3:0] = dec_out;  // Decoder outputs (one-hot)
        led[4]   = mux_y;    // 4→1 mux output

        // led[7:5] remain free for extensions/debug
    end

endmodule
