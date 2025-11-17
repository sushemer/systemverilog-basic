// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.16: TM1638 quickstart
//
// Objetivo: uso mínimo y rápido del módulo TM1638 a través de:
// - Teclas (key[7:0])
// - LEDs (led[7:0])
// - Display de 7 segmentos (abcdefgh + digit)
//
// En esta configuración de placa, el wrapper ya se encarga de hablar
// con el TM1638 (shift-register, multiplexado, etc.).
// Desde este "hackathon_top" solo vemos:
//   * key[7:0]   → entradas digitales (teclas / switches)
//   * led[7:0]   → salidas a LEDs
//   * abcdefgh   → segmentos de 7-seg + punto
//   * digit[7:0] → selección de dígito a encender
//
// Este ejemplo:
//  - Refleja key[7:0] directamente en led[7:0].
//  - Muestra el valor de key como número hexadecimal en el TM1638.
//  - Apaga la LCD (no se usa pantalla en este quickstart).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no usado aquí
    input  logic       reset,

    // HW-154 / TM1638 logical inputs/outputs
    input  logic [7:0] key,
    output logic [7:0] led,

    // Dynamic 7-seg (TM1638)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (no usada en este ejemplo)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio    // no usado
);

    // --------------------------------------------------------------------
    // Apagar la LCD (no se usa en este ejemplo)
    // --------------------------------------------------------------------
    always_comb begin
        red   = '0;
        green = '0;
        blue  = '0;
    end

    // --------------------------------------------------------------------
    // 1) Reflejar teclas en LEDs
    // --------------------------------------------------------------------
    //
    // Idea básica:
    //  - Si una tecla está en '1' → LED correspondiente encendido.
    //  - Si está en '0' → LED apagado.
    //
    // Esto sirve como prueba rápida de que los pines de entrada/salida
    // están funcionando correctamente.

    always_comb begin
        led = key;
    end

    // --------------------------------------------------------------------
    // 2) Mostrar el valor de key en el TM1638 (7 segmentos)
    // --------------------------------------------------------------------
    //
    // Usamos el módulo seven_segment_display (ya presente en el repo).
    // Este módulo:
    //  - Toma un número de N bits (4 bits por dígito).
    //  - Lo muestra en formato hexadecimal en varios dígitos.
    //  - Se encarga del multiplexado de abcdefgh / digit.
    //
    // Aquí:
    //  - Tratamos key[7:0] como un número de 0–255.
    //  - Lo extendemos a 32 bits (8 dígitos hex) con ceros a la izquierda.
    //  - seven_segment_display decide qué mostrar en cada dígito.

    localparam int unsigned W_DIGIT = 8;             // 8 dígitos del TM1638
    localparam int unsigned W_NUM   = W_DIGIT * 4;   // 4 bits por dígito

    // Extender key (8 bits) a W_NUM bits, rellenando con ceros a la izquierda
    logic [W_NUM-1:0] number_hex;

    always_comb begin
        number_hex = '0;
        number_hex[7:0] = key;  // parte baja = valor de las teclas
    end

    seven_segment_display #(
        .w_digit (W_DIGIT)
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   (number_hex),
        .dots     (W_DIGIT'(0)),   // sin puntos decimales
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // Con esto, al cambiar key[7:0]:
    //  - Los LEDs reflejan los bits.
    //  - El TM1638 muestra el valor hexadecimal correspondiente.

endmodule
