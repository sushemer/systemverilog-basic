# 4.8 – Sensors + TM1638 Integration (Code)

```systemverilog
// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.8 – Sensor Integration + TM1638
//
// General idea:
//   - Read at least ONE physical sensor (ultrasonic and/or rotary encoder KY-040).
//   - Display the numeric value on the TM1638 module (7-segment display).
//   - Represent the value as a "bar" on the 8 LEDs of the TM1638.
//   - Use keys to change mode / sensor.
//
// IMPORTANT NOTE:
//   This file is an ACTIVITY TEMPLATE, NOT the final solution.
//   There are sections marked as TODO for you to complete.
//
//   Requires modules used in previous examples:
//     - ultrasonic_distance_sensor        (HC-SR04)
//     - sync_and_debounce, sync_and_debounce_one
//     - rotary_encoder                    (KY-040)
//     - seven_segment_display             (multi-digit 7-segment driver)

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (TM1638)

    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not the focus of this activity)

    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO for external sensors (ultrasonic + rotary encoder)

    inout  logic [3:0] gpio
);

    // -------------------------------------------------------------------------
    // 0) Disable unused peripherals (LCD)
    // -------------------------------------------------------------------------

    assign red   = '0;
    assign green = '0;
    assign blue  = '0;

    // You could reuse slow_clock for blinking effects if desired.

    // -------------------------------------------------------------------------
    // 1) Ultrasonic sensor HC-SR04 (optional but recommended)
    // -------------------------------------------------------------------------
    //
    // Suggested pin assignment:
    //   gpio[0] -> TRIG (output to sensor)
    //   gpio[1] -> ECHO (input from sensor)
    //
    // The ultrasonic_distance_sensor module outputs "relative_distance":
    // a value proportional to the echo time (NOT in cm directly).
    //
    // If you do not have this module or sensor, comment this block
    // and use only the rotary encoder.

    wire [15:0] distance_rel;

    ultrasonic_distance_sensor
    #(
        .clk_frequency          ( 27 * 1000 * 1000 ),
        .relative_distance_width( $bits(distance_rel) )
    )
    i_ultrasonic
    (
        .clk               ( clock          ),
        .rst               ( reset          ),
        .trig              ( gpio[0]        ),
        .echo              ( gpio[1]        ),
        .relative_distance ( distance_rel   )
    );

    // -------------------------------------------------------------------------
    // 2) Rotary encoder KY-040 on gpio[3:2]
    // -------------------------------------------------------------------------
    //
    // Typical KY-040 pinout:
    //   CLK -> channel A
    //   DT  -> channel B
    //
    // Here we assume:
    //   gpio[3] -> A
    //   gpio[2] -> B

    wire enc_a_raw = gpio[3];
    wire enc_b_raw = gpio[2];

    wire enc_a_deb;
    wire enc_b_deb;

    // Synchronize + debounce both channels
    sync_and_debounce #(.w(2)) i_sync_and_debounce
    (
        .clk    ( clock                     ),
        .reset  ( reset                     ),
        .sw_in  ( { enc_b_raw, enc_a_raw } ),
        .sw_out ( { enc_b_deb, enc_a_deb } )
    );

    logic [15:0] encoder_value;

    rotary_encoder i_rotary_encoder
    (
        .clk   ( clock         ),
        .reset ( reset         ),
        .a     ( enc_a_deb     ),
        .b     ( enc_b_deb     ),
        .value ( encoder_value )
    );

    // -------------------------------------------------------------------------
    // 3) Selecting the value to display (sensor_value)
    // -------------------------------------------------------------------------
    //
    // We want a single bus "sensor_value" that will be:
    //   - the relative distance from the HC-SR04,
    //   - or the rotary encoder value,
    //   - or some combination, depending on keys.
    //
    // Suggestion (for the final solution):
    //   key[1:0] as mode:
    //     00 -> display distance_rel
    //     01 -> display encoder_value
    //     10 -> display distance_rel - encoder_value (example)
    //     11 -> reserved / 0
    //
    // For now, we leave simple behavior so it compiles:
    //   -> sensor_value = distance_rel
    //
    // TODO: Rewrite this block to implement the proposed modes
    //       or others you define in the activity.

    logic [15:0] sensor_value;

    always_comb
    begin
        sensor_value = distance_rel;  // TODO: multiplex according to key[1:0]
    end

    // -------------------------------------------------------------------------
    // 4) Mapping sensor_value to a bar on the LEDs (TM1638)
    // -------------------------------------------------------------------------
    //
    // General idea:
    //   - Use LEDs as a "bar" that grows with the sensor value.
    //   - For example, compare sensor_value against 8 thresholds
    //     and turn on led[0], led[1], ... according to the level.
    //
    // In this template we use something very simple (upper bits)
    // just as a placeholder so it compiles.
    //
    // TODO: replace this with a nicer level bar graph.

    logic [7:0] led_bar;

    always_comb
    begin
        led_bar = sensor_value[15:8];  // TODO: replace with level-bar logic
    end

    assign led = led_bar;

    // -------------------------------------------------------------------------
    // 5) Displaying the numeric value on the TM1638 (7-segments)
    // -------------------------------------------------------------------------
    //
    // We reuse the seven_segment_display driver:
    //   - 8 digits (w_digit = 8).
    //   - number: 32 bits (hex) -> multiplexed on 8 digits.
    //
    // Here we copy sensor_value (16 bits) into a 32-bit bus.
    // In the solution you may:
    //   - show only 4 digits (adjust w_digit),
    //   - convert to decimal before displaying,
    //   - use dots as status indicators.

    localparam int W_DISPLAY_NUMBER = 32;

    logic [W_DISPLAY_NUMBER-1:0] number_7seg;

    always_comb
    begin
        number_7seg       = '0;
        number_7seg[15:0] = sensor_value;  // lower 16 bits
    end

    seven_segment_display #(.w_digit(8)) i_7segment
    (
        .clk      ( clock        ),
        .rst      ( reset        ),
        .number   ( number_7seg  ),
        .dots     ( 8'b0000_0000 ), // TODO optional: use bits as indicators
        .abcdefgh ( abcdefgh     ),
        .digit    ( digit        )
    );

endmodule
