// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.6 – Sensors + LCD integration
//
// General idea:
//   - Read two real sensors:
//       * HC-SR04 (ultrasonic_distance_sensor)
//       * KY-040 rotary encoder (rotary_encoder + sync_and_debounce)
//   - Select the data source using key[1:0].
//   - Map that value to:
//       * A visual “level” on the LCD (vertical gauge bar).
//       * A pattern on the LEDs (high byte of the sensor value).
//
// Focus:
//   - Practice integration of already-used modules:
//       ultrasonic_distance_sensor, sync_and_debounce, rotary_encoder.
//   - Use (x, y) from the LCD driver to draw a background + dynamic bar.
//
// Notes:
//   - To synthesize correctly, make sure these files are included in the project:
//       * peripherals/ultrasonic_distance_sensor.sv
//       * peripherals/sync_and_debounce.sv
//       * peripherals/rotary_encoder.sv
//   - The TM1638 (abcdefgh/digit) is not used in this lab (left at 0).
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // TM1638 / seven-segment (not used here)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD 480x272 interface
    input  logic [8:0] x,   // 0 .. 479
    input  logic [8:0] y,   // 0 .. 271
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO to sensors
    //   gpio[0] -> TRIG (HC-SR04)
    //   gpio[1] -> ECHO (HC-SR04)
    //   gpio[3] -> A (encoder)
    //   gpio[2] -> B (encoder)
    inout  logic [3:0] gpio
);

    // -------------------------------------------------------------------------
    // Disable TM1638 in this lab (not the focus)
    // -------------------------------------------------------------------------

    assign abcdefgh = '0;
    assign digit    = '0;

    // -------------------------------------------------------------------------
    // Screen parameters
    // -------------------------------------------------------------------------

    localparam int SCREEN_W = 480;
    localparam int SCREEN_H = 272;

    // 9-bit version for comparisons with y
    localparam [8:0] SCREEN_H_9B   = SCREEN_H;
    localparam [8:0] THRESH_LOW    = SCREEN_H / 3;
    localparam [8:0] THRESH_HIGH   = (2 * SCREEN_H) / 3;

    // Vertical gauge region in X
    localparam int BAR_X0 = 400;
    localparam int BAR_X1 = 440;

    // -------------------------------------------------------------------------
    // 1) HC-SR04 ultrasonic sensor (on gpio[1:0])
    // -------------------------------------------------------------------------

    wire [15:0] distance_rel;

    ultrasonic_distance_sensor
    #(
        .clk_frequency           ( 27 * 1000 * 1000 ),
        .relative_distance_width ( $bits(distance_rel) )
    )
    i_ultrasonic
    (
        .clk               ( clock        ),
        .rst               ( reset        ),
        .trig              ( gpio[0]      ),
        .echo              ( gpio[1]      ),
        .relative_distance ( distance_rel )
    );

    // -------------------------------------------------------------------------
    // 2) KY-040 rotary encoder (on gpio[3:2])
    // -------------------------------------------------------------------------

    wire enc_a_raw = gpio[3];
    wire enc_b_raw = gpio[2];

    wire enc_a_deb;
    wire enc_b_deb;

    // Synchronize + debounce A and B
    sync_and_debounce #(.w(2)) i_sync_and_debounce
    (
        .clk    ( clock                   ),
        .reset  ( reset                   ),
        .sw_in  ( { enc_b_raw, enc_a_raw }),
        .sw_out ( { enc_b_deb, enc_a_deb })
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
    // 3) Select which sensor value to visualize
    // -------------------------------------------------------------------------
    //
    //   mode = key[1:0]:
    //     00 -> distance_rel (ultrasonic)
    //     01 -> encoder_value
    //     10 -> distance_rel - encoder_value (test combo)
    //     11 -> 0 (reserved)
    //

    logic [1:0] mode;
    assign mode = key[1:0];

    logic [15:0] sensor_value;

    always_comb
    begin
        unique case (mode)
            2'b00: sensor_value = distance_rel;
            2'b01: sensor_value = encoder_value;
            2'b10: sensor_value = distance_rel - encoder_value;
            default: sensor_value = 16'd0;
        endcase
    end

    // -------------------------------------------------------------------------
    // 4) LED mapping (upper byte of sensor value)
    // -------------------------------------------------------------------------

    // Use the high byte of the sensor value as a direct LED pattern.
    assign led = sensor_value[15:8];

    // -------------------------------------------------------------------------
    // 5) Scale sensor_value to bar height (0..SCREEN_H-1)
    // -------------------------------------------------------------------------

    logic [8:0] bar_height;

    always_comb
    begin
        // Take the upper 9 bits as an approximation.
        logic [8:0] tmp;
        tmp = sensor_value[15:7];

        if (tmp >= SCREEN_H_9B)
            bar_height = SCREEN_H_9B - 1;
        else
            bar_height = tmp;
    end

    // -------------------------------------------------------------------------
    // 6) LCD drawing logic
    // -------------------------------------------------------------------------
    //
    //   - General background: soft gradient based on y.
    //   - Thin border around the screen.
    //   - Vertical gauge bar in region [BAR_X0, BAR_X1):
    //       * Height proportional to bar_height (from bottom upward).
    //       * Color:
    //           green   → low level
    //           yellow  → medium level
    //           red     → high level
    //

    always_comb
    begin
        // Default background: black
        red   = '0;
        green = '0;
        blue  = '0;

        // 6.1) White border
        if (x < 2 || x >= SCREEN_W-2 || y < 2 || y >= SCREEN_H-2)
        begin
            red   = 5'b11111;
            green = 6'b111111;
            blue  = 5'b11111;
        end
        else
        begin
            // 6.2) Base background inside the border
            //      A soft gradient using y (brighter at the bottom).
            red   = 5'd1;
            green = 6'(y[7:2]);   // small trick to vary with y
            blue  = 5'd6;

            // 6.3) Vertical gauge
            //
            // X-region limited to [BAR_X0, BAR_X1).
            // Height from the bottom upward, controlled by bar_height.

            if ((x >= BAR_X0) && (x < BAR_X1))
            begin
                // Are we inside the bar height?
                if (y >= SCREEN_H_9B - bar_height)
                begin
                    // Color based on level (low/mid/high)
                    if (bar_height < THRESH_LOW)
                    begin
                        // Low level → green
                        red   = 5'd0;
                        green = 6'b111111;
                        blue  = 5'd0;
                    end
                    else if (bar_height < THRESH_HIGH)
                    begin
                        // Medium level → yellow
                        red   = 5'b11111;
                        green = 6'b111111;
                        blue  = 5'd0;
                    end
                    else
                    begin
                        // High level → red
                        red   = 5'b11111;
                        green = 6'd0;
                        blue  = 5'd0;
                    end
                end
            end
        end
    end

endmodule
