// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.14: LCD – Rectángulo en movimiento
//
// Este ejemplo extiende el anterior (figuras estáticas) agregando:
// - Un rectángulo rojo que se mueve horizontalmente.
// - Un strobe (~30 Hz) para actualizar la posición.
// - El valor de la posición se muestra en los LEDs y en el display de 7 segmentos.
//
// El wrapper de la placa se encarga del timing de video;
// aquí solo decidimos el color del píxel con base en (x, y) y en un contador.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no usado en este ejemplo
    input  logic       reset,

    input  logic [7:0] key,          // reservado para ejercicios
    output logic [7:0] led,

    // Display de 7 segmentos
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz de la LCD
    input  logic [8:0] x,            // 0..479
    input  logic [8:0] y,            // 0..271

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio          // no usado
);
    // --------------------------------------------------------------------
    // Parámetros de pantalla
    // --------------------------------------------------------------------
    localparam int unsigned SCREEN_WIDTH  = 480;
    localparam int unsigned SCREEN_HEIGHT = 272;

    // --------------------------------------------------------------------
    // Generar un pulso lento con strobe_gen (~30 Hz)
    // --------------------------------------------------------------------
    logic pulse;

    // En esta tarjeta, el clock típico es de 27 MHz (ver config original)
    strobe_gen #(
        .clk_mhz   (27),
        .strobe_hz (30)    // ~30 veces por segundo
    ) i_strobe_gen (
        .clk    (clock),
        .rst    (reset),
        .strobe (pulse)
    );

    // --------------------------------------------------------------------
    // Contador de posición horizontal del rectángulo
    // --------------------------------------------------------------------
    //
    // counter se incrementa cuando llega pulse, y se reinicia
    // cuando llega al límite. Eso hace que el rectángulo “recorra”
    // parte de la pantalla de izquierda a derecha y vuelva a empezar.

    logic [8:0] rect_offset;  // suficiente para 0..480

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            rect_offset <= 9'd0;
        end
        else if (pulse) begin
            if (rect_offset >= SCREEN_WIDTH/2) begin
                rect_offset <= 9'd0;
            end
            else begin
                rect_offset <= rect_offset + 9'd1;
            end
        end
    end

    // --------------------------------------------------------------------
    // Mostrar la posición del rectángulo en LEDs y 7 segmentos
    // --------------------------------------------------------------------
    //
    // - LEDs: muestran los 8 bits menos significativos de rect_offset.
    // - 7 segmentos: muestra rect_offset como número (hex o dec, según módulo).

    assign led = rect_offset[7:0];

    seven_segment_display #(
        .w_digit (8)   // 8 dígitos en el módulo de la tarjeta hackathon
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   (rect_offset),  // se extiende internamente
        .dots     (8'b0000_0000),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // --------------------------------------------------------------------
    // Lógica de video: colores según (x, y) y rect_offset
    // --------------------------------------------------------------------
    //
    // Dibujamos:
    // - Fondo negro.
    // - Una barra horizontal verde fija.
    // - Un rectángulo rojo que se mueve horizontalmente.
    //
    // El rectángulo rojo “viaja” sumando rect_offset a su posición base.

    // Parámetros del rectángulo
    localparam int unsigned RECT_WIDTH  = 50;
    localparam int unsigned RECT_HEIGHT = 60;

    // Posición base del rectángulo (sin offset)
    localparam int unsigned RECT_X_BASE = 80;
    localparam int unsigned RECT_Y_TOP  = 100;

    // Coordenadas actuales del rectángulo (con desplazamiento)
    logic [8:0] rect_x_left;
    logic [8:0] rect_x_right;

    always_comb begin
        rect_x_left  = RECT_X_BASE + rect_offset;
        rect_x_right = rect_x_left + RECT_WIDTH;
    end

    always_comb begin
        // 1) Fondo negro
        red   = 5'd0;
        green = 6'd0;
        blue  = 5'd0;

        // 2) Rectángulo rojo en movimiento
        if (x >= rect_x_left  && x <= rect_x_right &&
            y >= RECT_Y_TOP   && y <= RECT_Y_TOP + RECT_HEIGHT) begin
            red   = 5'd31;  // rojo máximo
            green = 6'd0;
            blue  = 5'd0;
        end
    end

endmodule
