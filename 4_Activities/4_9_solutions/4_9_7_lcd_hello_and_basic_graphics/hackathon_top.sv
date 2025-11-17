// File: 4_9_solutions/4_9_7_lcd_hello_and_basic_graphics/hackathon_top.sv
//
// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.7 – LCD "HELLO" + gráficas básicas
//
// Idea general:
//   - Se dibuja un marco alrededor de la pantalla.
//   - El fondo interno es un tono suave azul/gris.
//   - Se reserva una banda central para la palabra "HELLO".
//   - Cada letra (H, E, L, L, O) se forma con bloques (rectángulos).
//   - En la parte inferior hay una barra de estado que cambia de color con key[0].
//
// Coordenadas:
//   x: 0..479
//   y: 0..271
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (no es el foco de esta actividad)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD: coordenadas actuales del píxel
    input  logic [8:0] x,   // 0 .. 479
    input  logic [8:0] y,   // 0 .. 271

    // Salida de color RGB (5-6-5 bits)
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio   // No se usa en esta actividad
);

    // -------------------------------------------------------------------------
    // Parámetros de la pantalla (coinciden con el driver de LCD 480x272)
    // -------------------------------------------------------------------------

    localparam int SCREEN_W = 480;
    localparam int SCREEN_H = 272;

    // -------------------------------------------------------------------------
    // LEDs y display de 7 segmentos
    // -------------------------------------------------------------------------

    assign led      = key;    // Solo reflejamos las teclas
    assign abcdefgh = 8'h00;  // 7 segmentos apagado
    assign digit    = 8'h00;
    // gpio lo maneja el wrapper
    // (aquí no lo usamos de forma explícita)

    // -------------------------------------------------------------------------
    // Señales auxiliares para las letras "HELLO"
    // -------------------------------------------------------------------------
    //
    // Reservamos una franja horizontal en el centro de la pantalla y
    // la dividimos en 5 celdas de igual ancho para cada letra.

    logic in_H;
    logic in_E;
    logic in_L1;
    logic in_L2;
    logic in_O;

    // Banda vertical para el texto
    localparam int HELLO_TOP    = 80;   // y mínimo de la banda de texto
    localparam int HELLO_BOTTOM = 200;  // y máximo de la banda de texto

    // Ancho aproximado de cada celda de letra
    localparam int LETTER_W = 60;

    // Posición X inicial del texto
    localparam int HELLO_X0 = 60;
    localparam int HELLO_X1 = HELLO_X0 + 5*LETTER_W;

    // Grosor de “línea” para trazos de las letras
    localparam int STROKE       = 6;
    localparam int HELLO_MID_Y  = (HELLO_TOP + HELLO_BOTTOM) / 2;
    localparam int MID_Y_TOP    = HELLO_MID_Y - STROKE/2;
    localparam int MID_Y_BOTTOM = HELLO_MID_Y + STROKE/2;

    // Rangos en X para cada letra
    localparam int H_X0  = HELLO_X0 + 0*LETTER_W;
    localparam int H_X1  = H_X0 + LETTER_W;

    localparam int E_X0  = HELLO_X0 + 1*LETTER_W;
    localparam int E_X1  = E_X0 + LETTER_W;

    localparam int L1_X0 = HELLO_X0 + 2*LETTER_W;
    localparam int L1_X1 = L1_X0 + LETTER_W;

    localparam int L2_X0 = HELLO_X0 + 3*LETTER_W;
    localparam int L2_X1 = L2_X0 + LETTER_W;

    localparam int O_X0  = HELLO_X0 + 4*LETTER_W;
    localparam int O_X1  = O_X0 + LETTER_W;

    // -------------------------------------------------------------------------
    // Lógica de dibujo en el LCD
    // -------------------------------------------------------------------------

    always_comb
    begin
        // Fondo por defecto: negro
        red   = '0;
        green = '0;
        blue  = '0;

        // Inicializar banderas de letras
        in_H  = 1'b0;
        in_E  = 1'b0;
        in_L1 = 1'b0;
        in_L2 = 1'b0;
        in_O  = 1'b0;

        // ---------------------------------------------------------------------
        // 1) Marco (borde) de la pantalla
        // ---------------------------------------------------------------------
        //
        // 4 píxeles de grosor alrededor de toda la pantalla.

        if (x < 4 || x >= SCREEN_W-4 || y < 4 || y >= SCREEN_H-4)
        begin
            // Marco blanco
            red   = 5'b11111;
            green = 6'b111111;
            blue  = 5'b11111;
        end

        // ---------------------------------------------------------------------
        // 2) Interior de la pantalla (no borde)
        // ---------------------------------------------------------------------
        if (!(x < 4 || x >= SCREEN_W-4 || y < 4 || y >= SCREEN_H-4))
        begin
            // Fondo base: gris-azulado suave
            red   = 5'd2;
            green = 6'd4;
            blue  = 5'd8;

            // -----------------------------------------------------------------
            // 2.1) Franja central para la palabra HELLO
            // -----------------------------------------------------------------
            //
            // Banda:
            //   y entre HELLO_TOP y HELLO_BOTTOM
            //   x entre HELLO_X0 y HELLO_X1

            if (   (y >= HELLO_TOP)   && (y < HELLO_BOTTOM)
                && (x >= HELLO_X0)    && (x < HELLO_X1) )
            begin
                // Fondo de la banda de texto (celeste claro)
                red   = 5'd4;
                green = 6'd10;
                blue  = 5'd15;

                // -------------------------------------------------------------
                // Definición de trazos de cada letra con rectángulos
                // -------------------------------------------------------------

                // -------------------------
                // Letra H (columna 0)
                // -------------------------
                in_H =
                    // Barra vertical izquierda
                    (x >= H_X0 && x < H_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Barra vertical derecha
                    (x >= H_X1 - STROKE && x < H_X1 &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Barra horizontal central
                    (y >= MID_Y_TOP && y < MID_Y_BOTTOM &&
                     x >= H_X0 + STROKE && x < H_X1 - STROKE);

                // -------------------------
                // Letra E (columna 1)
                // -------------------------
                in_E =
                    // Barra vertical izquierda
                    (x >= E_X0 && x < E_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Barra horizontal superior
                    (y >= HELLO_TOP && y < HELLO_TOP + STROKE &&
                     x >= E_X0 && x < E_X1)
                    ||
                    // Barra horizontal central
                    (y >= MID_Y_TOP && y < MID_Y_BOTTOM &&
                     x >= E_X0 && x < E_X1)
                    ||
                    // Barra horizontal inferior
                    (y >= HELLO_BOTTOM - STROKE && y < HELLO_BOTTOM &&
                     x >= E_X0 && x < E_X1);

                // -------------------------
                // Letra L (primera L, columna 2)
                // -------------------------
                in_L1 =
                    // Barra vertical izquierda
                    (x >= L1_X0 && x < L1_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Barra horizontal inferior
                    (y >= HELLO_BOTTOM - STROKE && y < HELLO_BOTTOM &&
                     x >= L1_X0 && x < L1_X1);

                // -------------------------
                // Letra L (segunda L, columna 3)
                // -------------------------
                in_L2 =
                    // Barra vertical izquierda
                    (x >= L2_X0 && x < L2_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Barra horizontal inferior
                    (y >= HELLO_BOTTOM - STROKE && y < HELLO_BOTTOM &&
                     x >= L2_X0 && x < L2_X1);

                // -------------------------
                // Letra O (columna 4)
                // -------------------------
                in_O =
                    // Borde superior
                    (y >= HELLO_TOP && y < HELLO_TOP + STROKE &&
                     x >= O_X0 && x < O_X1)
                    ||
                    // Borde inferior
                    (y >= HELLO_BOTTOM - STROKE && y < HELLO_BOTTOM &&
                     x >= O_X0 && x < O_X1)
                    ||
                    // Borde izquierdo
                    (x >= O_X0 && x < O_X0 + STROKE &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM)
                    ||
                    // Borde derecho
                    (x >= O_X1 - STROKE && x < O_X1 &&
                     y >= HELLO_TOP && y < HELLO_BOTTOM);
            end

            // -----------------------------------------------------------------
            // 2.2) Color de las letras "HELLO"
            // -----------------------------------------------------------------
            if (in_H || in_E || in_L1 || in_L2 || in_O)
            begin
                // Letras en rojo brillante
                red   = 5'b11111;
                green = 6'd0;
                blue  = 5'd0;
            end

            // -----------------------------------------------------------------
            // 2.3) Barra de estado inferior (extra)
            // -----------------------------------------------------------------
            //
            // Barra en la parte inferior de la pantalla que cambia de color
            // según key[0].

            if (y >= SCREEN_H - 30)
            begin
                if (key[0])
                begin
                    // Barra verde
                    red   = 5'd0;
                    green = 6'b111111;
                    blue  = 5'd0;
                end
                else
                begin
                    // Barra azul
                    red   = 5'd0;
                    green = 6'd0;
                    blue  = 5'b11111;
                end
            end
        end
    end

endmodule
