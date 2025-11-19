// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.7: Binary counter (free‐running + key-controlled variant)
//
// General idea:
// - Use the main clock of the Tang Nano 9K to increment a wide counter.
// - Display the most significant bits of the counter on the LEDs, so that
//   they blink at different frequencies (binary “running” effect).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,  // not used in this example
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used here)
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
    // Turn off peripherals not used
    // ------------------------------------------------------------------------
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;   // High impedance on GPIO

    // ------------------------------------------------------------------------
    // Example 1: Free-running binary counter
    //
    // Wide counter that increments on every rising edge of "clock".
    // The most significant bits of the counter are sent to the LEDs.
    //
    // By changing which bits are displayed, you change the apparent blink speed.
    // ------------------------------------------------------------------------
    
    // Approximate clock frequency of the Tang Nano 9K (MHz)
    localparam int CLK_MHZ = 27;

    // Number of bits needed to count up to 1 second:
    //  cnt_max ≈ CLK_MHZ * 1e6 → we need clog2(cnt_max) bits
    localparam int W_CNT = $clog2(CLK_MHZ * 1_000_000);

    logic [W_CNT-1:0] cnt;

    // Free-running binary counter
    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            cnt <= '0;
        else
            cnt <= cnt + 1'b1;
    end

    // Display the 8 most significant bits of the counter on the LEDs.
    // This makes each LED blink at a different frequency
    // (the MSB is the slowest).
    assign led = cnt[W_CNT-1 -: 8];

    // ------------------------------------------------------------------------
    // Example 2 (optional): key-controlled counter
    //
    // - Comment out the “Example 1” lines (counter/assign above).
    // - Uncomment the block below.
    // - The counter advances only when a key “pulse” is detected.
    // ------------------------------------------------------------------------
    /*
    // Detect if any key is pressed
    wire any_key = |key;

    // Register for edge detection
    logic any_key_r;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            any_key_r <= 1'b0;
        else
            any_key_r <= any_key;
    end

    // “Transition” pulse (here release edge is detected)
    wire any_key_pulse = ~any_key & any_key_r;

    // 8-bit key-controlled counter
    logic [7:0] cnt_key;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            cnt_key <= 8'd0;
        else if (any_key_pulse)
            cnt_key <= cnt_key + 8'd1;
    end

    assign led = cnt_key;
    */

endmodule
