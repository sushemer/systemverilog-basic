// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.2 – Composition: 2→4 decoder + 4→1 multiplexer
//
// General idea:
//   - Use 2 selection bits (sel) to choose 1 of 4 data inputs (data[3:0]).
//   - Implement a 2→4 "one-hot" decoder.
//   - Build a 4→1 mux using the decoder + AND + OR.
//   - Display decoder outputs and mux output on LEDs.
//
// NOTE: This file is a TEMPLATE for the activity.
//       Complete the TODO sections.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Seven-segment display (not used here)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used here)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // Display, LCD and GPIO unused
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;

    // -------------------------------------------------------------------------
    // Logical inputs: selectors and data inputs
    // -------------------------------------------------------------------------
    //
    // Suggested mapping:
    //   sel[1:0]  = key[1:0]
    //   data[3:0] = key[5:2]

    logic [1:0] sel;
    logic [3:0] data;

    assign sel  = key[1:0];
    assign data = key[5:2];

    // -------------------------------------------------------------------------
    // 2→4 "one-hot" decoder
    // -------------------------------------------------------------------------

    logic [3:0] dec_out;

    always_comb
    begin
        dec_out = 4'b0000;

        // TODO: implement 2→4 decoder
        // case (sel)
        //   2'b00: dec_out = 4'b0001;
        //   2'b01: dec_out = 4'b0010;
        //   2'b10: dec_out = 4'b0100;
        //   2'b11: dec_out = 4'b1000;
        // endcase
    end

    // -------------------------------------------------------------------------
    // Composition: 4→1 mux using decoder + ANDs + OR
    // -------------------------------------------------------------------------

    logic [3:0] and_terms;
    logic       mux_y;

    // TODO: AND terms
    // assign and_terms[0] = dec_out[0] & data[0];
    // assign and_terms[1] = dec_out[1] & data[1];
    // assign and_terms[2] = dec_out[2] & data[2];
    // assign and_terms[3] = dec_out[3] & data[3];

    // TODO: OR for mux output
    // assign mux_y = | and_terms;

    // -------------------------------------------------------------------------
    // LED outputs
    // -------------------------------------------------------------------------

    always_comb
    begin
        led = 8'b0000_0000;

        led[3:0] = dec_out;  // decoder one-hot output
        led[4]   = mux_y;    // mux result

        // led[7:5] available for extensions
    end

endmodule
