// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.17: Ultrasonic distance – visualization on seven-segment display, LEDs, and LCD

module hackathon_top
(
    // Clocks and reset
    input  logic       clock,
    input  logic       slow_clock,   // not used in this example
    input  logic       reset,

    // Board keys (reserved for future exercises)
    input  logic [7:0] key,
    output logic [7:0] led,

    // Seven-segment display (TM1638)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface
    input  logic [8:0] x,            // 0..479
    input  logic [8:0] y,            // 0..271

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio          // gpio[0]=TRIG, gpio[1]=ECHO
);

    // --------------------------------------------------------------------
    // System and screen parameters
    // --------------------------------------------------------------------
    localparam int unsigned CLK_HZ        = 27_000_000;
    localparam int unsigned SCREEN_WIDTH  = 480;
    localparam int unsigned SCREEN_HEIGHT = 272;

    // --------------------------------------------------------------------
    // Ultrasonic sensor: relative distance measurement
    // --------------------------------------------------------------------
    logic [15:0] distance;

    ultrasonic_distance_sensor #(
        .clk_frequency          (CLK_HZ),
        .relative_distance_width($bits(distance))
    ) i_sensor (
        .clk               (clock),
        .rst               (reset),
        .trig              (gpio[0]),
        .echo              (gpio[1]),
        .relative_distance (distance)
    );

    // --------------------------------------------------------------------
    // Distance visualization
    // --------------------------------------------------------------------
    // 1) LEDs: 8 least-significant bits (quick debug)
    assign led = distance[7:0];

    // 2) Seven-segment display: shows distance in decimal/hex
    seven_segment_display #(
        .w_digit (8)   // 8 digits on the hackathon TM1638 module
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   ({16'd0, distance}),  // extend to 32 bits
        .dots     (8'b0000_0000),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // --------------------------------------------------------------------
    // Scaling distance into an X coordinate on screen
    // --------------------------------------------------------------------
    // Uses the upper portion of "distance" to map into 0..(SCREEN_WIDTH-1).
    // distance[15:7] are 9 bits → approx. 0..511. Saturate to 479.

    logic [8:0] distance_x;  // 0..479

    always_comb begin
        if (distance[15:7] >= SCREEN_WIDTH[8:0])
            distance_x = SCREEN_WIDTH[8:0] - 1;  // 479
        else
            distance_x = distance[15:7];
    end

    // --------------------------------------------------------------------
    // Video logic: horizontal red bar based on distance
    // --------------------------------------------------------------------
    // Draws:
    // - Black background.
    // - A red bar from x=0 to x=distance_x around mid-height.

    localparam int unsigned BAR_HEIGHT = 20;
    localparam int unsigned BAR_Y_MID  = SCREEN_HEIGHT / 2;

    always_comb begin
        // Black background
        red   = 5'd0;
        green = 6'd0;
        blue  = 5'd0;

        // Horizontal red bar centered vertically
        if ( (x <= distance_x) &&
             (y >= (BAR_Y_MID - (BAR_HEIGHT/2))) &&
             (y <= (BAR_Y_MID + (BAR_HEIGHT/2))) ) begin
            red   = 5'd31;  // max red
            green = 6'd0;
            blue  = 5'd0;
        end
    end

endmodule
