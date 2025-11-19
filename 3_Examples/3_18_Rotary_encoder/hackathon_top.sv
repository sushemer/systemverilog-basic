// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.18: Rotary encoder (KY-040) + TM1638 + LCD helper
//
// Ejemplo de uso de un encoder rotatorio tipo KY-040 conectado a gpio[3:2]:
//   - gpio[3] = CLK (canal A)
//   - gpio[2] = DT  (canal B)
//
// El valor decodificado se muestra:
//   - En el display de 7 segmentos (TM1638) como número.
//   - En los LEDs (8 LSB) como apoyo visual.
//   - Como “umbral” vertical en la LCD: para columnas con x > value, se pinta azul.
//
// Los módulos auxiliares sync_and_debounce y rotary_encoder se reutilizan sin
// modificaciones.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no usado en este ejemplo
    input  logic       reset,

    input  logic [7:0] key,          // reservado para ejercicios
    output logic [7:0] led,

    // Display de 7 segmentos (TM1638)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz de la LCD
    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // --------------------------------------------------------------------
    // Encoder KY-040 en gpio[3:2]
    // --------------------------------------------------------------------
    //
    // Marcado típico en el módulo:
    //   CLK - canal A
    //   DT  - canal B
    //
    // Primero se sincroniza y aplica debouncing a las señales del encoder.

    logic a;
    logic b;

    sync_and_debounce #(
        .w (2)
    ) i_sync_and_debounce (
        .clk   (clock),
        .reset (reset),
        .sw_in (gpio[3:2]),
        .sw_out({b, a})
    );

    // --------------------------------------------------------------------
    // Decodificador de encoder rotatorio
    // --------------------------------------------------------------------
    //
    // El módulo rotary_encoder entrega un valor de 16 bits (value) que se
    // incrementa o decrementa según el giro del encoder.

    logic [15:0] value;

    rotary_encoder i_rotary_encoder (
        .clk   (clock),
        .reset (reset),
        .a     (a),
        .b     (b),
        .value (value)
    );

    // --------------------------------------------------------------------
    // Visualización en display TM1638 (7 segmentos) y LEDs
    // --------------------------------------------------------------------

    seven_segment_display #(
        .w_digit (8)   // 8 dígitos en el módulo de la tarjeta hackathon
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   (32'(value)),      // se extiende internamente a 32 bits
        .dots     ('0),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // LEDs: muestran los 8 bits menos significativos del valor del encoder.
    assign led = value[7:0];

    // --------------------------------------------------------------------
    // Lógica de video: umbral vertical controlado por el encoder
    // --------------------------------------------------------------------
    //
    // Para todas las coordenadas con x > value[8:0], se pinta azul.
    // A medida que se gira el encoder, se desplaza el "umbral" vertical.
    // La intensidad de azul varía ligeramente con x (demo visual simple).

    always_comb begin
        // Fondo negro
        red   = 5'd0;
        green = 6'd0;
        blue  = 5'd0;

        // Región a la derecha del umbral: azul
        if (x > value[8:0]) begin
            red   = 5'd0;
            green = 6'd0;
            blue  = x[4:0];   // intensidad de azul basada en x (solo efecto visual)
        end
    end

    // --------------------------------------------------------------------
    // Ideas de ejercicios adicionales
    // --------------------------------------------------------------------
    //
    // - Ejercicio 1:
    //   Usar el valor del encoder para controlar la posición de un rectángulo
    //   en la LCD (similar a 3.14, pero con posición definida por value).
    //
    // - Ejercicio 2:
    //   Conectar dos encoders a distintos GPIO y usar uno para desplazar en X
    //   y otro para desplazar en Y una figura dibujada en la pantalla.

endmodule
