// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.8 – Integración de sensores + TM1638
//
// Idea general:
//   - Leer al menos UN sensor físico (ultrasonido y/o encoder rotatorio KY-040).
//   - Mostrar el valor numérico en el módulo TM1638 (display de 7 segmentos).
//   - Representar el valor como una "barra" en los 8 LEDs del TM1638.
//   - Usar teclas para cambiar de modo / sensor.
//
// NOTA IMPORTANTE:
//   Este archivo es PLANTILLA de actividad, NO es la solución final.
//   Hay secciones marcadas como TODO para que tú las completes.
//
//   Requiere módulos ya usados en ejemplos anteriores:
//     - ultrasonic_distance_sensor        (HC-SR04)
//     - sync_and_debounce, sync_and_debounce_one
//     - rotary_encoder                    (KY-040)
//     - seven_segment_display             (driver 7 segmentos multipunto)

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

    // Podrías reutilizar slow_clock para efectos de parpadeo si quieres.

    // -------------------------------------------------------------------------
    // 1) Sensor ultrasónico HC-SR04 (opcional pero recomendado)
    // -------------------------------------------------------------------------
    //
    // Asignación sugerida en pines:
    //   gpio[0] -> TRIG (salida hacia el sensor)
    //   gpio[1] -> ECHO (entrada desde el sensor)
    //
    // El módulo ultrasonic_distance_sensor entrega "relative_distance":
    // un valor proporcional al tiempo de eco (NO está en cm directamente).
    //
    // Si no tienes el módulo o el sensor, puedes comentar este bloque
    // y usar solo el encoder rotatorio.

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
    // 2) Encoder rotatorio KY-040 en gpio[3:2]
    // -------------------------------------------------------------------------
    //
    // Ky-040 pinout típico:
    //   CLK -> canal A
    //   DT  -> canal B
    //
    // Aquí asumimos:
    //   gpio[3] -> A
    //   gpio[2] -> B

    wire enc_a_raw = gpio[3];
    wire enc_b_raw = gpio[2];

    wire enc_a_deb;
    wire enc_b_deb;

    // Sincronizar + eliminar rebotes de los dos canales
    sync_and_debounce #(.w(2)) i_sync_and_debounce
    (
        .clk    ( clock                ),
        .reset  ( reset                ),
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
    //
    // Queremos un solo bus "sensor_value" que será:
    //   - la distancia relativa del HC-SR04,
    //   - o el valor del encoder rotatorio,
    //   - o alguna combinación, según teclas.
    //
    // Sugerencia (para la solución final):
    //   key[1:0] como modo:
    //     00 -> mostrar distancia_rel
    //     01 -> mostrar encoder_value
    //     10 -> mostrar distance_rel - encoder_value (por ejemplo)
    //     11 -> reservado / 0
    //
    // Por ahora, dejamos un comportamiento simple para que compile:
    //   -> sensor_value = distance_rel
    //
    // TODO: Reescribe este bloque para implementar los modos propuestos
    //       u otros que tú definas en la actividad.

    logic [15:0] sensor_value;

    always_comb
    begin
        sensor_value = distance_rel;  // TODO: multiplexar según key[1:0]
    end

    // -------------------------------------------------------------------------
    // 4) Mapeo de sensor_value a una barra en LEDs (TM1638)
    // -------------------------------------------------------------------------
    //
    // Idea general:
    //   - Usar los LEDs como "barra" que crece con el valor del sensor.
    //   - Por ejemplo, comparar sensor_value contra 8 umbrales
    //     y encender led[0], led[1], ... según el nivel.
    //
    // En esta plantilla usamos algo muy simple (bits altos),
    // solo como placeholder para que compile.
    //
    // TODO: sustituir esto por un bar graph "bonito" usando niveles.

    logic [7:0] led_bar;

    always_comb
    begin
        led_bar = sensor_value[15:8];  // TODO: reemplazar por lógica de barra por niveles
    end

    assign led = led_bar;

    // -------------------------------------------------------------------------
    // 5) Mostrar el valor numérico en el TM1638 (7 segmentos)
    // -------------------------------------------------------------------------
    //
    // Reutilizamos el driver seven_segment_display usado en ejemplos:
    //   - 8 dígitos (w_digit = 8).
    //   - number: 32 bits (hex) → multiplexado en 8 dígitos.
    //
    // Aquí copiamos sensor_value (16 bits) a un bus de 32 bits.
    // En la solución puedes hacer:
    //   - mostrar solo 4 dígitos (ajustando w_digit),
    //   - o convertir a decimal antes de mostrar,
    //   - o usar dots como indicadores de estado.

    localparam int W_DISPLAY_NUMBER = 32;

    logic [W_DISPLAY_NUMBER-1:0] number_7seg;

    always_comb
    begin
        number_7seg          = '0;
        number_7seg[15:0]    = sensor_value;  // 16 bits menos significativos
        // El resto queda en 0
    end

    seven_segment_display #(.w_digit(8)) i_7segment
    (
        .clk      ( clock        ),
        .rst      ( reset        ),
        .number   ( number_7seg  ),
        .dots     ( 8'b0000_0000 ), // TODO opcional: usar bits como indicadores
        .abcdefgh ( abcdefgh     ),
        .digit    ( digit        )
    );

endmodule
