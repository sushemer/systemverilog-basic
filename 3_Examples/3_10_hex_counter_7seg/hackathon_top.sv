// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.10: Hex counter en display de 7 segmentos
//
// Idea general:
// - Generar un contador de 32 bits (cnt_2) que se incrementa a una frecuencia variable.
// - Esa frecuencia se ajusta con dos teclas:
//     * key[0] → hace el conteo MÁS lento (periodo más grande).
//     * key[1] → hace el conteo MÁS rápido (periodo más pequeño).
// - Mostrar el valor de cnt_2 en HEX en los 8 dígitos del display de 7 segmentos,
//   usando el módulo seven_segment_display del repositorio.
//
// Notas:
// - Se asume reloj de ~27 MHz en la Tang Nano 9K.
// - El módulo seven_segment_display ya está incluido en el proyecto por el
//   board_specific_top (como en el repositorio original).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no se usa en este ejemplo
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (multiplexado)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no usada aquí)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO (no usados aquí)
    inout  logic [3:0] gpio
);

    // ------------------------------------------------------------------------
    // Apagar periféricos que no usamos (LCD, GPIO)
    // ------------------------------------------------------------------------
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Parámetros locales: reloj, dígitos y ancho del número a mostrar
    // ------------------------------------------------------------------------
    localparam int clk_mhz          = 27;          // Frecuencia aprox. del reloj en MHz
    localparam int w_digit          = 8;           // 8 dígitos de 7 segmentos
    localparam int w_display_number = w_digit * 4; // 4 bits por dígito hexadecimal

    // ------------------------------------------------------------------------
    // Control de periodo (frecuencia) del contador principal
    //
    // period: número de ciclos de reloj que deben pasar para que cnt_2 se incremente.
    // - min_period → frecuencia máxima.
    // - max_period → frecuencia mínima.
    //
    // key[0] presionado  → period aumenta (conteo MÁS lento).
    // key[1] presionado  → period disminuye (conteo MÁS rápido).
    // ------------------------------------------------------------------------

    logic [31:0] period;

    // Valores límite del periodo (en ciclos de reloj)
    localparam int unsigned min_period =
        clk_mhz * 1_000_000 / 50;   // aprox. 50 Hz base
    localparam int unsigned max_period =
        clk_mhz * 1_000_000 * 3;    // mucho más lento

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            // Iniciar en el punto medio entre mínimo y máximo
            period <= 32'((min_period + max_period) / 2);
        end
        else if (key[0] && (period != max_period)) begin
            // Aumentar periodo → menor frecuencia de conteo
            period <= period + 32'd1;
        end
        else if (key[1] && (period != min_period)) begin
            // Disminuir periodo → mayor frecuencia de conteo
            period <= period - 32'd1;
        end
    end

    // ------------------------------------------------------------------------
    // cnt_1: contador descendente que genera el "tick" para cnt_2
    // ------------------------------------------------------------------------
    logic [31:0] cnt_1;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            cnt_1 <= 32'd0;
        end
        else if (cnt_1 == 32'd0) begin
            // Al llegar a 0, recarga con (period - 1)
            // y genera un "tick" para cnt_2.
            cnt_1 <= period - 32'd1;
        end
        else begin
            // Cuenta hacia abajo
            cnt_1 <= cnt_1 - 32'd1;
        end
    end

    // ------------------------------------------------------------------------
    // cnt_2: contador principal de 32 bits
    // ------------------------------------------------------------------------
    logic [31:0] cnt_2;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            cnt_2 <= 32'd0;
        end
        else if (cnt_1 == 32'd0) begin
            // Solo se incrementa cuando cnt_1 llega a 0
            cnt_2 <= cnt_2 + 32'd1;
        end
    end

    // Mostrar los bits menos significativos de cnt_2 en los LEDs como debug
    assign led = cnt_2[7:0];

    // ------------------------------------------------------------------------
    // Display de 7 segmentos en HEX
    //
    // - w_display_number = 32 bits (8 dígitos * 4 bits/dígito).
    // - Pasamos cnt_2 completo al módulo seven_segment_display.
    // - dots = 0 => sin puntos encendidos.
    // ------------------------------------------------------------------------

    seven_segment_display # (w_digit) i_7segment
    (
        .clk      ( clock                               ),
        .rst      ( reset                               ),
        .number   ( w_display_number'(cnt_2)            ),
        .dots     ( w_digit'(0)                         ),
        .abcdefgh ( abcdefgh                            ),
        .digit    ( digit                               )
    );


endmodule
