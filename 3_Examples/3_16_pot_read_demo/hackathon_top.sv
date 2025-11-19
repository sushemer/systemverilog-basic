// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.16: Potentiometer read demo (simulado con switches)
//
// En este ejemplo simulamos la lectura de un potenciómetro usando 8 bits de entrada.
// La idea es:
// - Tomar un valor "pot_value" de 0 a 255 (aquí viene de key[7:0]).
// - Mostrarlo en:
//     * LEDs (patrón binario).
//     * Display de 7 segmentos (valor numérico).
//     * Pantalla LCD como una barra horizontal verde cuyo ancho depende de pot_value.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no usado aquí
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Dynamic seven-segment display
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (video coordinates)
    input  logic [8:0] x,          // 0..479
    input  logic [8:0] y,          // 0..271

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio        // not used
);

    // --------------------------------------------------------------------
    // Parámetros de pantalla
    // --------------------------------------------------------------------
    localparam int unsigned SCREEN_WIDTH  = 480;
    localparam int unsigned SCREEN_HEIGHT = 272;

    // --------------------------------------------------------------------
    // Valor de "potenciómetro" (0–255)
    // --------------------------------------------------------------------
    //
    // Por ahora lo simulamos con los 8 bits de key:
    // - key[7:0] = valor digital del potenciómetro.
    //
    // Si tuvieras un ADC real, aquí conectarías su salida:
    //   logic [7:0] adc_data;
    //   ...
    //   logic [7:0] pot_value = adc_data;

    logic [7:0] pot_value;

    always_comb begin
        pot_value = key;   // simulación: switches/teclas como valor de pot
    end

    // --------------------------------------------------------------------
    // Mostrar pot_value en LEDs
    // --------------------------------------------------------------------
    //
    //  - LED encendido = bit en 1.
    //  - LED apagado   = bit en 0.

    always_comb begin
        led = pot_value;
    end

    // --------------------------------------------------------------------
    // Mostrar pot_value en display de 7 segmentos
    // --------------------------------------------------------------------
    //
    // Usamos el módulo seven_segment_display ya disponible en el repositorio.
    // Muestra el valor en formato hexadecimal (por defecto).
    //
    // Solo usamos el valor de 8 bits, el módulo se encarga de expandir número.

    localparam int unsigned W_DIGIT = 8;
    localparam int unsigned W_NUM   = W_DIGIT * 4;  // 4 bits por dígito HEX

    seven_segment_display #(
        .w_digit (W_DIGIT)
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   (W_NUM'(pot_value)),  // se extiende a W_NUM bits
        .dots     (W_DIGIT'(0)),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // --------------------------------------------------------------------
    // Mostrar pot_value como barra en la LCD
    // --------------------------------------------------------------------
    //
    // Queremos una barra horizontal que vaya desde x=0 hasta un ancho
    // proporcional a pot_value:
    //
    //   bar_width = (pot_value / 255) * SCREEN_WIDTH
    //
    // Para evitar dividir, usamos un producto y un corrimiento (>> 8)
    // porque pot_value es de 8 bits (0..255).

    logic [15:0] bar_width;

    always_comb begin
        bar_width = (pot_value * SCREEN_WIDTH) >> 8;
    end

    // Definimos la banda vertical de la barra:
    localparam int unsigned BAR_Y_TOP    = SCREEN_HEIGHT/2 - 10;
    localparam int unsigned BAR_Y_BOTTOM = SCREEN_HEIGHT/2 + 10;

    always_comb begin
        // Fondo negro
        red   = 5'd0;
        green = 6'd0;
        blue  = 5'd0;

        // Barra verde proporcional al valor del "potenciómetro"
        if ( y >= BAR_Y_TOP && y <= BAR_Y_BOTTOM &&
             x <  bar_width )
        begin
            red   = 5'd0;
            green = 6'd50;  // bastante brillante
            blue  = 5'd0;
        end

        // Línea de referencia vertical (mitad de la pantalla)
        if (x == SCREEN_WIDTH/2 && y < SCREEN_HEIGHT) begin
            red   = 5'd31;  // rojo
            green = 6'd0;
            blue  = 5'd0;
        end
    end

endmodule
