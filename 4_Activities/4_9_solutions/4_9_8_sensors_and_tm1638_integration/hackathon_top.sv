// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
/*
Activity 4.8 – Sensors + TM1638 Integration

Modes (key[1:0]):
  00 -> Mode 0: show relative distance (HC-SR04)
  01 -> Mode 1: show encoder value (KY-040)
  10 -> Mode 2: show sum (distance + encoder)
  11 -> Mode 3: reserved (sensor_value = 0)

Visualization:
  - TM1638 (7-segment): sensor_value in HEX (16 bits in lower digits)
  - TM1638 LEDs: 0–8 level bar based on sensor_value
*/

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // TM1638 seven-segment display
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used in this activity)
    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO: sensors (ultrasonic + rotary encoder)
    inout  logic [3:0] gpio
);

    // -------------------------------------------------------------------------
    // Disable LCD outputs
    // -------------------------------------------------------------------------

    assign red   = '0;
    assign green = '0;
    assign blue  = '0;

    // -------------------------------------------------------------------------
    // Ultrasonic sensor HC-SR04
    // -------------------------------------------------------------------------
    //
    // gpio[0] -> TRIG (output)
    // gpio[1] -> ECHO (input)
    //
    // distance_rel is relative distance (proportional to echo time)

    wire [15:0] distance_rel;

    ultrasonic_distance_sensor
    #(
        .clk_frequency           (27 * 1000 * 1000),
        .relative_distance_width ($bits(distance_rel))
    )
    i_ultrasonic
    (
        .clk               (clock),
        .rst               (reset),
        .trig              (gpio[0]),
        .echo              (gpio[1]),
        .relative_distance (distance_rel)
    );

    // -------------------------------------------------------------------------
    // Rotary encoder KY-040 on gpio[3:2]
    // -------------------------------------------------------------------------
    //
    // gpio[3] -> channel A (CLK)
    // gpio[2] -> channel B (DT)

    wire enc_a_raw = gpio[3];
    wire enc_b_raw = gpio[2];

    wire enc_a_deb;
    wire enc_b_deb;

    // Debounce + sync
    sync_and_debounce #(.w(2)) i_sync
    (
        .clk    (clock),
        .reset  (reset),
        .sw_in  ({enc_b_raw, enc_a_raw}),
        .sw_out ({enc_b_deb, enc_a_deb})
    );

    logic [15:0] encoder_value;

    rotary_encoder i_rotary
    (
        .clk   (clock),
        .reset (reset),
        .a     (enc_a_deb),
        .b     (enc_b_deb),
        .value (encoder_value)
    );

    // -------------------------------------------------------------------------
    // Mode selection (sensor_value)
    // -------------------------------------------------------------------------

    logic [1:0] mode;
    assign mode = key[1:0];

    logic [15:0] sensor_value;

    always_comb
    begin
        unique case (mode)
            2'b00: sensor_value = distance_rel;
            2'b01: sensor_value = encoder_value;
            2'b10: sensor_value = distance_rel + encoder_value;
            default: sensor_value = 16'd0;
        endcase
    end

    // -------------------------------------------------------------------------
    // Bar graph for TM1638 LEDs
    // -------------------------------------------------------------------------

    logic [7:0] led_bar;

    always_comb
    begin
        led_bar = 8'b00000000;

        if (sensor_value != 16'd0)
        begin
            logic [2:0] level;
            level = sensor_value[15:13]; // 0..7

            for (int i = 0; i < 8; i++)
            begin
                if (level >= i[2:0])
                    led_bar[i] = 1'b1;
                else
                    led_bar[i] = 1'b0;
            end
        end
    end

    assign led = led_bar;

    // -------------------------------------------------------------------------
    // TM1638 7-segment display output
    // -------------------------------------------------------------------------

    localparam int W_DISPLAY_NUMBER = 32;

    logic [W_DISPLAY_NUMBER-1:0] number_7seg;

    always_comb
    begin
        number_7seg       = '0;
        number_7seg[15:0] = sensor_value;
    end

    seven_segment_display
    #(.w_digit(8))
    i_7segment
    (
        .clk      (clock),
        .rst      (reset),
        .number   (number_7seg),
        .dots     (8'b00000000),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

endmodule
