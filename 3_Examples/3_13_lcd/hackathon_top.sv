// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.13: LCD – Figuras estáticas básicas
//
// Primer ejemplo de uso del LCD:
// - Usar las coordenadas de píxel (x,y) para decidir el color.
// - Dibujar barras y un rectángulo fijo.
// - Sin contadores, sin movimiento, sin uso de teclas.
//
// El wrapper de la placa se encarga del timing de video;
// aquí solo decimos de qué color va cada píxel.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no usado en este ejemplo
    input  logic       reset,        // no usado aquí, pero se deja por consistencia

    input  logic [7:0] key,          // no usado en este ejemplo
    output logic [7:0] led,          // apagados

    // Display de 7 segmentos (apagado en este ejemplo)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Coordenadas del píxel actual en la LCD
    input  logic [8:0] x,            // 0..479
    input  logic [8:0] y,            // 0..271

    // Color del píxel actual
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
    // Salidas “no gráficas”: todo apagado
    // --------------------------------------------------------------------
    always_comb begin
        led       = 8'h00;
        abcdefgh  = 8'h00;
        digit     = 8'h00;
        // gpio se deja sin asignar (queda como puerto sin usar)
    end

    // --------------------------------------------------------------------
    // Lógica de color basada solo en (x, y)
    // --------------------------------------------------------------------
    //
    // Capas de dibujo (de menos a más importante):
    //  1) Fondo negro.
    //  2) Barra vertical roja en x ~ 100.
    //  3) Barra horizontal verde en y ~ 50.
    //  4) Rectángulo amarillo en el centro de la pantalla.
    //
    // La prioridad es:
    //   rectángulo central > barra horizontal > barra vertical > fondo.

    always_comb begin
        // 1) Fondo negro
        red   = 5'd0;
        green = 6'd0;
        blue  = 5'd0;

        // 2) Barra vertical roja (de y = 20 a y = SCREEN_HEIGHT - 20)
        if (x >= 95 && x <= 105 &&
            y >= 20 && y <= SCREEN_HEIGHT - 20) begin
            red   = 5'd31;  // rojo intenso
            green = 6'd0;
            blue  = 5'd0;
        end

        // 3) Barra horizontal verde (de x = 20 a x = SCREEN_WIDTH - 20)
        if (y >= 45 && y <= 55 &&
            x >= 20 && x <= SCREEN_WIDTH - 20) begin
            red   = 5'd0;
            green = 6'd50; // verde brillante
            blue  = 5'd0;
        end

        // 4) Rectángulo central amarillo
        if (x >= (SCREEN_WIDTH/2  - 40) && x <= (SCREEN_WIDTH/2  + 40) &&
            y >= (SCREEN_HEIGHT/2 - 30) && y <= (SCREEN_HEIGHT/2 + 30)) begin
            red   = 5'd31;
            green = 6'd63;
            blue  = 5'd0;
        end
    end

endmodule
