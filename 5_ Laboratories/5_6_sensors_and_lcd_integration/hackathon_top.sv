// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.6 – Sensors + LCD integration
//
// Idea general:
//   - Leer dos sensores reales:
//       * HC-SR04 (ultrasonic_distance_sensor)
//       * Encoder rotatorio KY-040 (rotary_encoder + sync_and_debounce)
//   - Seleccionar el origen del dato con key[1:0].
//   - Mapear ese valor a:
//       * Un "nivel" visual en el LCD (barra vertical tipo gauge).
//       * Un patrón en los LEDs (valor alto del sensor).
//
// Enfoque:
//   - Practicar integración de módulos ya usados:
//       ultrasonic_distance_sensor, sync_and_debounce, rotary_encoder.
//   - Usar (x,y) del driver de LCD para dibujar un fondo + barra dinámica.
//
// Notas:
//   - Para que sintetice, asegúrate de incluir en el proyecto:
//       * peripherals/ultrasonic_distance_sensor.sv
//       * peripherals/sync_and_debounce.sv
//       * peripherals/rotary_encoder.sv
//   - El TM1638 (abcdefgh/digit) no se usa en este lab (se dejan en 0).
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // TM1638 / 7 segmentos (no usado aquí)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD 480x272
    input  logic [8:0] x,   // 0 .. 479
    input  logic [8:0] y,   // 0 .. 271
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO hacia sensores
    //   gpio[0] -> TRIG (HC-SR04)
    //   gpio[1] -> ECHO (HC-SR04)
    //   gpio[3] -> A (encoder)
    //   gpio[2] -> B (encoder)
    inout  logic [3:0] gpio
);

    // -------------------------------------------------------------------------
    // Desactivar TM1638 en este lab (no es el foco)
    // -------------------------------------------------------------------------

    assign abcdefgh = '0;
    assign digit    = '0;

    // -------------------------------------------------------------------------
    // Parámetros de la pantalla
    // -------------------------------------------------------------------------

    localparam int SCREEN_W = 480;
    localparam int SCREEN_H = 272;

    // Versión de 9 bits para comparaciones con y
    localparam [8:0] SCREEN_H_9B   = SCREEN_H;
    localparam [8:0] THRESH_LOW    = SCREEN_H / 3;
    localparam [8:0] THRESH_HIGH   = (2 * SCREEN_H) / 3;

    // Región de la barra vertical (gauge) en X
    localparam int BAR_X0 = 400;
    localparam int BAR_X1 = 440;

    // -------------------------------------------------------------------------
    // 1) Sensor ultrasónico HC-SR04 (en gpio[1:0])
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
    // 2) Encoder rotatorio KY-040 (en gpio[3:2])
    // -------------------------------------------------------------------------

    wire enc_a_raw = gpio[3];
    wire enc_b_raw = gpio[2];

    wire enc_a_deb;
    wire enc_b_deb;

    // Sincronizar + eliminar rebotes de A y B
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
    // 3) Selección del valor de sensor a visualizar
    // -------------------------------------------------------------------------
    //
    //   mode = key[1:0]:
    //     00 -> distance_rel (ultrasonido)
    //     01 -> encoder_value
    //     10 -> distance_rel - encoder_value (prueba de combinación)
    //     11 -> 0 (reservado)
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
    // 4) Mapeo a LEDs (valor alto del sensor)
    // -------------------------------------------------------------------------

    // Usamos el byte alto del sensor como patrón directo a LEDs.
    assign led = sensor_value[15:8];

    // -------------------------------------------------------------------------
    // 5) Escalado del valor de sensor a altura de barra (0..SCREEN_H-1)
    // -------------------------------------------------------------------------

    logic [8:0] bar_height;

    always_comb
    begin
        // Tomamos los 9 bits más significativos como aproximación.
        logic [8:0] tmp;
        tmp = sensor_value[15:7];

        if (tmp >= SCREEN_H_9B)
            bar_height = SCREEN_H_9B - 1;
        else
            bar_height = tmp;
    end

    // -------------------------------------------------------------------------
    // 6) Lógica de dibujo en el LCD
    // -------------------------------------------------------------------------
    //
    //   - Fondo general: degradado suave según y.
    //   - Marco fino alrededor de la pantalla.
    //   - Barra vertical (gauge) en la región [BAR_X0, BAR_X1):
    //       * Altura proporcional a bar_height (desde abajo hacia arriba).
    //       * Color:
    //           verde  si valor bajo
    //           amarillo si valor medio
    //           rojo    si valor alto
    //

    always_comb
    begin
        // Por defecto: fondo negro
        red   = '0;
        green = '0;
        blue  = '0;

        // 6.1) Marco (borde) blanco
        if (x < 2 || x >= SCREEN_W-2 || y < 2 || y >= SCREEN_H-2)
        begin
            red   = 5'b11111;
            green = 6'b111111;
            blue  = 5'b11111;
        end
        else
        begin
            // 6.2) Fondo base dentro del marco
            //      Un degradado suave según y (más claro abajo).
            red   = 5'd1;
            green = 6'(y[7:2]);   // pequeño truco para variar con y
            blue  = 5'd6;

            // 6.3) Barra vertical de nivel (gauge)
            //
            // Región en X restringida a [BAR_X0, BAR_X1).
            // Altura desde la parte inferior de la pantalla hacia arriba,
            // controlada por bar_height.

            if ((x >= BAR_X0) && (x < BAR_X1))
            begin
                // ¿Estamos dentro de la altura de la barra?
                if (y >= SCREEN_H_9B - bar_height)
                begin
                    // Elegimos color según bar_height (bajo/medio/alto)
                    if (bar_height < THRESH_LOW)
                    begin
                        // Nivel bajo → verde
                        red   = 5'd0;
                        green = 6'b111111;
                        blue  = 5'd0;
                    end
                    else if (bar_height < THRESH_HIGH)
                    begin
                        // Nivel medio → amarillo
                        red   = 5'b11111;
                        green = 6'b111111;
                        blue  = 5'd0;
                    end
                    else
                    begin
                        // Nivel alto → rojo
                        red   = 5'b11111;
                        green = 6'd0;
                        blue  = 5'd0;
                    end
                end
            end
        end
    end

endmodule
