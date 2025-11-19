// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.10: Hex counter on 7-segment display
//
// General idea:
// - Generate a 32-bit counter (cnt_2) that increments at a variable frequency.
// - That frequency is adjusted using two buttons:
//     * key[0] → makes the counting SLOWER (larger period).
//     * key[1] → makes the counting FASTER (smaller period).
// - Display the value of cnt_2 in HEX across the 8 digits of the 7-segment display,
//   using the seven_segment_display module from the repository.
//
// Notes:
// - We assume a ~27 MHz clock on the Tang Nano 9K.
// - The seven_segment_display module is already included by the
//   board_specific_top (as in the original repository).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // not used in this example
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

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
    // Turn off peripherals not used (LCD, GPIO)
    // ------------------------------------------------------------------------
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Local parameters: clock, digits, and width of the number to display
    // ------------------------------------------------------------------------
    localparam int clk_mhz          = 27;          // Approx. clock frequency in MHz
    localparam int w_digit          = 8;           // 8 seven-segment digits
    localparam int w_display_number = w_digit * 4; // 4 bits per HEX digit

    // ------------------------------------------------------------------------
    // Period (frequency) control of the main counter
    //
    // period: number of clock cycles that must elapse before cnt_2 increments.
    // - min_period → highest frequency.
    // - max_period → lowest frequency.
    //
    // key[0] pressed → period increases (slower counting)
    // key[1] pressed → period decreases (faster counting)
    // ------------------------------------------------------------------------

    logic [31:0] period;

    // Limits for the period (clock cycles)
    localparam int unsigned min_period =
        clk_mhz * 1_000_000 / 50;   // approx. 50 Hz base
    localparam int unsigned max_period =
        clk_mhz * 1_000_000 * 3;    // much slower

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            // Start at midpoint between min and max
            period <= 32'((min_period + max_period) / 2);
        end
        else if (key[0] && (period != max_period)) begin
            // Increase period → lower frequency
            period <= period + 32'd1;
        end
        else if (key[1] && (period != min_period)) begin
            // Decrease period → higher frequency
            period <= period - 32'd1;
        end
    end

    // ------------------------------------------------------------------------
    // cnt_1: down counter generating the "tick" for cnt_2
    // ------------------------------------------------------------------------
    logic [31:0] cnt_1;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            cnt_1 <= 32'd0;
        end
        else if (cnt_1 == 32'd0) begin
            // When reaching 0, reload with (period - 1)
            // and generate a "tick" for cnt_2.
            cnt_1 <= period - 32'd1;
        end
        else begin
            // Count down
            cnt_1 <= cnt_1 - 32'd1;
        end
    end

    // ------------------------------------------------------------------------
    // cnt_2: main 32-bit counter
    // ------------------------------------------------------------------------
    logic [31:0] cnt_2;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            cnt_2 <= 32'd0;
        end
        else if (cnt_1 == 32'd0) begin
            // Increment only when cnt_1 reaches 0
            cnt_2 <= cnt_2 + 32'd1;
        end
    end

    // Debug: display LSB of cnt_2 on LEDs
    assign led = cnt_2[7:0];

    // ------------------------------------------------------------------------
    // 7-segment display in HEX
    //
    // - w_display_number = 32 bits (8 digits × 4 bits each).
    // - Pass cnt_2 to the seven_segment_display module.
    // - dots = 0 → no decimal points enabled.
    // ------------------------------------------------------------------------

    seven_segment_display # (w_digit) i_7segment
    (
        .clk      ( clock                               ),
        .rst      ( reset                               ),
        .number   ( w_display_number'(cnt_2)            ),
        .dots     ( w_digit'(0)                         ),
        .abcdefgh ( abcdefgh                            ),
        .digit    ( digit                               )
    );

endmodule
