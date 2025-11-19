// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
/*
Activity 4.3 – Priority encoder 3→2 + “valid” flag

General idea:
  - Use 3 request lines (req[2:0]) taken from key[2:0].
  - Implement a “priority encoder”:
      * If multiple inputs are 1 at the same time,
        the one with the HIGHEST index wins (bit 2 has more priority than 1, than 0).
  - Generate:
      * idx[1:0] → binary code of the active index.
      * valid    → indicates if there is any request (any req[i] = 1).
  - Visualize on LEDs:
      * req, idx and valid.
*/

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used in this activity)
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

    // Display, LCD and GPIO are not used in this activity.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is handled by the board wrapper

    // -------------------------------------------------------------------------
    // Inputs: request lines
    // -------------------------------------------------------------------------
    //
    //   req[0] = key[0]
    //   req[1] = key[1]
    //   req[2] = key[2]

    logic [2:0] req;

    assign req = key[2:0];

    // -------------------------------------------------------------------------
    // Priority encoder 3→2 with “valid” flag
    // -------------------------------------------------------------------------

    logic [1:0] idx;
    logic       valid;

    always_comb
    begin
        // Default values (no request)
        idx   = 2'd0;
        valid = 1'b0;

        // Priority: req[2] > req[1] > req[0]
        if (req[2]) begin
            idx   = 2'd2;
            valid = 1'b1;
        end
        else if (req[1]) begin
            idx   = 2'd1;
            valid = 1'b1;
        end
        else if (req[0]) begin
            idx   = 2'd0;
            valid = 1'b1;
        end
        // else: keep default values (idx=0, valid=0)
    end

    // -------------------------------------------------------------------------
    // LED output
    // -------------------------------------------------------------------------
    //
    //   led[2:0] → req[2:0]   (active requests)
    //   led[4:3] → idx[1:0]   (selected code)
    //   led[7]   → valid      (at least one request)
    //   led[6:5] → free

    always_comb
    begin
        led = 8'b0000_0000;

        led[2:0] = req;   // Show which requests are active
        led[4:3] = idx;   // Index selected by encoder
        led[7]   = valid; // “At least one request” flag
    end

endmodule
