// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.3 – Priority encoder 3→2 + "valid" flag
//
// General idea:
//   - Use 3 request lines (req[2:0]) from key[2:0].
//   - Implement a priority encoder:
//       * If multiple inputs are high at the same time,
//         the one with the HIGHEST index wins (bit 2 > bit 1 > bit 0).
//   - Generate:
//       * idx[1:0] → binary code of the winning index.
//       * valid    → indicates if at least one request is active.
//   - Display req, idx and valid on LEDs.
//
// NOTE: This file is an ACTIVITY TEMPLATE.
//       You must complete the TODO sections.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    output logic [7:0] abcdefgh, // not used here
    output logic [7:0] digit,

    input  logic [8:0] x,  // not used
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;

    // -------------------------------------------------------------------------
    // Request inputs
    // -------------------------------------------------------------------------
    //
    // Suggested mapping:
    //   req[0] = key[0]
    //   req[1] = key[1]
    //   req[2] = key[2]

    logic [2:0] req;
    assign req = key[2:0];

    // -------------------------------------------------------------------------
    // Priority encoder 3→2 with "valid" flag
    // -------------------------------------------------------------------------

    logic [1:0] idx;
    logic       valid;

    always_comb
    begin
        idx   = 2'd0;   // default (no request)
        valid = 1'b0;

        // TODO: implement priority logic
        //
        // if (req[2]) begin
        //     idx   = 2'd2;
        //     valid = 1'b1;
        // end
        // else if (req[1]) begin
        //     idx   = 2'd1;
        //     valid = 1'b1;
        // end
        // else if (req[0]) begin
        //     idx   = 2'd0;
        //     valid = 1'b1;
        // end
    end

    // -------------------------------------------------------------------------
    // LED output mapping
    // -------------------------------------------------------------------------
    //
    // Suggested:
    //   led[2:0] = req[2:0]
    //   led[4:3] = idx
    //   led[7]   = valid
    //   led[6:5] available for extensions

    always_comb
    begin
        led = 8'b0000_0000;

        led[2:0] = req;
        led[4:3] = idx;
        led[7]   = valid;
    end

endmodule
