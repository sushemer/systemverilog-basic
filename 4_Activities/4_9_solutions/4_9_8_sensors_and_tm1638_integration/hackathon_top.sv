// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.8 – Integración de sensores + TM1638
//
// Modos (key[1:0]):
//   00 -> Modo 0: muestra distancia relativa (HC-SR04)
//   01 -> Modo 1: muestra valor del encoder (KY-040)
//   10 -> Modo 2: muestra suma (distancia + encoder)
//   11 -> Modo 3: reservado (sensor_value = 0)
//
// Visualización:
//   - TM1638 (7 segmentos): sensor_value en HEX (16 bits en los 4 dígitos menos significativos).
//   - LEDs (TM1638): barra de 0 a 8 nivel con base en sensor_value.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (TM1638)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no es el foco de esta actividad)
    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO para sensores externos (ultrasonido + encoder rotatorio)
    inout  logic [3:0] gpio
);

    // -------------------------------------------------------------------------
    // 0) Desactivar lo que no usamos (LCD)
    // -------------------------------------------------------------------------

    assign red   = '0;
    assign green = '0;
    assign blue  = '0;

    // -------------------------------------------------------------------------
    // 1) Sensor ultrasónico HC-SR04
    // -------------------------------------------------------------------------
    //
    // Asignación sugerida:
    //   gpio[0] -> TRIG (salida)
    //   gpio[1] -> ECHO (entrada)
    //
    // distance_rel es un valor relativo (proporcional al tiempo de eco).

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
    // 2) Encoder rotatorio KY-040 en gpio[3:2]
    // -------------------------------------------------------------------------
    //
    //   gpio[3] -> canal A (CLK)
    //   gpio[2] -> canal B (DT)
    //
    // Se sincronizan y se debouncean con sync_and_debounce, luego
    // rotary_encoder entrega un valor de 16 bits (encoder_value).

    wire enc_a_raw = gpio[3];
    wire enc_b_raw = gpio[2];

    wire enc_a_deb;
    wire enc_b_deb;

    // Sincronizar + eliminar rebotes de los dos canales
    sync_and_debounce #(.w(2)) i_sync_and_debounce
    (
        .clk    ( clock                  ),
        .reset  ( reset                  ),
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
    // 3) Selección del valor a mostrar (sensor_value)
    // -------------------------------------------------------------------------

    logic [1:0] mode;
    assign mode = key[1:0];

    logic [15:0] sensor_value;

    always_comb
    begin
        unique case (mode)
            2'b00: sensor_value = distance_rel;                     // Modo 0: ultrasonido
            2'b01: sensor_value = encoder_value;                    // Modo 1: encoder
            2'b10: sensor_value = distance_rel + encoder_value;     // Modo 2: combinación
            default: sensor_value = 16'd0;                          // Modo 3: apagado/0
        endcase
    end

    // -------------------------------------------------------------------------
    // 4) Mapeo de sensor_value a barra en LEDs (TM1638)
    // -------------------------------------------------------------------------
    //
    // Se construye un "bar graph" de 0 a 8 niveles:
    //   - Se toma un nivel a partir de los bits más altos sensor_value[15:13]. (0..7)
    //   - Si sensor_value = 0, todos los LEDs apagados.
    //   - Si es > 0, se encienden led[0..level].

    logic [7:0] led_bar;

    always_comb
    begin
        led_bar = 8'b0000_0000;

        if (sensor_value != 16'd0)
        begin
            logic [2:0] level;
            level = sensor_value[15:13];  // 0..7

            // Enciende desde led[0] hasta led[level]
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
    // 5) Mostrar el valor numérico en el TM1638 (7 segmentos)
    // -------------------------------------------------------------------------
    //
    // Se reutiliza seven_segment_display con 8 dígitos (32 bits).
    // Se copia sensor_value (16 bits) a los bits [15:0] de number_7seg.
    // El resultado se muestra en formato hexadecimal.

    localparam int W_DISPLAY_NUMBER = 32;

    logic [W_DISPLAY_NUMBER-1:0] number_7seg;

    always_comb
    begin
        number_7seg       = '0;
        number_7seg[15:0] = sensor_value;
    end

    seven_segment_display
    #(
        .w_digit ( 8 )
    )
    i_7segment
    (
        .clk      ( clock        ),
        .rst      ( reset        ),
        .number   ( number_7seg  ),
        .dots     ( 8'b0000_0000 ), // se podrían usar como indicadores de modo
        .abcdefgh ( abcdefgh     ),
        .digit    ( digit        )
    );

endmodule
