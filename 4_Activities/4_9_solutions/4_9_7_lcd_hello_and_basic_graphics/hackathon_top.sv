// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.7 – LCD "HELLO" + gráficas básicas
//
// Idea general:
//   - Usar las coordenadas (x, y) que vienen del controlador de LCD.
//   - Pintar píxeles modificando red/green/blue según la región de la pantalla.
//   - Dibujar un marco y reservar un área central para escribir "HELLO"
//     con bloques (rectángulos).
//
// NOTA: Esta es una PLANTILLA para la actividad.
//       Hay varias secciones marcadas como TODO para que las completes.

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
    // Por sencillez:
    //   - Encendemos los LEDs según las teclas (para ver que responden).
    //   - Mantendremos apagado el display de 7 segmentos.
    // Puedes cambiar esto si quieres mostrar contadores u otra cosa.

    assign led      = key;
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    // -------------------------------------------------------------------------
    // Señales auxiliares para las letras "HELLO"
    // -------------------------------------------------------------------------
    //
    // La idea es reservar una franja horizontal en el centro de la pantalla
    // y dividirla en 5 "celdas", una por cada letra: H, E, L, L, O.
    //
    // En esta plantilla NO se implementan las letras; se deja como TODO
    // para que tú definas las condiciones sobre (x,y).

    logic in_H;
    logic in_E;
    logic in_L1;
    logic in_L2;
    logic in_O;

    // Constantes sugeridas para la banda de texto
    localparam int HELLO_TOP    = 80;   // y mínimo de la banda de texto
    localparam int HELLO_BOTTOM = 200;  // y máximo de la banda de texto

    // Ancho aproximado de cada celda de letra
    localparam int LETTER_W = 60;

    // Posición X inicial del texto (ajusta a tu gusto)
    localparam int HELLO_X0 = 60;

    // -------------------------------------------------------------------------
    // Lógica de dibujo en el LCD
    // -------------------------------------------------------------------------
    //
    // Todo el dibujo se hace en este always_comb:
    //   - Primero se inicializa fondo negro.
    //   - Se dibuja un marco alrededor de la pantalla.
    //   - Se reserva un "rectángulo" para la palabra HELLO.
    //   - Dentro de ese rectángulo, deberás implementar las letras con bloques.

    always_comb
    begin
        // Valores por defecto
        red   = '0;
        green = '0;
        blue  = '0;

        // Inicializar las banderas de letras en 0
        in_H  = 1'b0;
        in_E  = 1'b0;
        in_L1 = 1'b0;
        in_L2 = 1'b0;
        in_O  = 1'b0;

        // ---------------------------------------------------------------------
        // 1) Marco (borde) de la pantalla
        // ---------------------------------------------------------------------
        //
        // Si el píxel está cerca de los bordes, pintamos un marco blanco.

        if (x < 4 || x >= SCREEN_W-4 || y < 4 || y >= SCREEN_H-4)
        begin
            red   = 5'b11111;   // Blanco (máximo en los 3 canales)
            green = 6'b111111;
            blue  = 5'b11111;
        end

        // ---------------------------------------------------------------------
        // 2) Fondo dentro del marco
        // ---------------------------------------------------------------------
        //
        // Solo si NO estamos en el borde, se puede sobreescribir el color
        // dependiendo de las regiones que definamos.

        if (!(x < 4 || x >= SCREEN_W-4 || y < 4 || y >= SCREEN_H-4))
        begin
            // Fondo base: un tono suave (gris azulado)
            red   = 5'd2;
            green = 6'd4;
            blue  = 5'd8;

            // -----------------------------------------------------------------
            // 2.1) Franja central para la palabra HELLO
            // -----------------------------------------------------------------
            //
            // Primero definimos un rectángulo "contenedor" donde irá la palabra.
            // Lo pintaremos, por ejemplo, de un color más claro o diferente.
            // Luego, encima, se dibujarán las letras.
            //
            // Banda de texto:
            //    y entre HELLO_TOP y HELLO_BOTTOM
            //    x desde HELLO_X0 hasta HELLO_X0 + 5*LETTER_W

            if (   (y >= HELLO_TOP) && (y < HELLO_BOTTOM)
                && (x >= HELLO_X0)  && (x < HELLO_X0 + 5*LETTER_W) )
            begin
                // Color de fondo de la banda de texto (ej: celeste claro)
                red   = 5'd4;
                green = 6'd10;
                blue  = 5'd15;

                // -------------------------------------------------------------
                // TODO: Implementar los trazos de cada letra
                // -------------------------------------------------------------
                //
                // Sugerencia:
                //   - Divide el eje X en 5 celdas:
                //       H: [HELLO_X0 + 0*LETTER_W, HELLO_X0 + 1*LETTER_W)
                //       E: [HELLO_X0 + 1*LETTER_W, HELLO_X0 + 2*LETTER_W)
                //       L: [HELLO_X0 + 2*LETTER_W, HELLO_X0 + 3*LETTER_W)
                //       L: [HELLO_X0 + 3*LETTER_W, HELLO_X0 + 4*LETTER_W)
                //       O: [HELLO_X0 + 4*LETTER_W, HELLO_X0 + 5*LETTER_W)
                //
                //   - En cada celda, usa combinaciones de rectángulos
                //     (condiciones sobre x,y) para formar letras de bloques.
                //
                // Ejemplo de idea para la letra H (NO está implementado):
                //
                //   localparam int H_X0 = HELLO_X0 + 0*LETTER_W;
                //   localparam int H_X1 = H_X0 + LETTER_W;
                //
                //   wire in_H_left  = (x >= H_X0          ) && (x < H_X0 + 5)
                //                   && (y >= HELLO_TOP    ) && (y < HELLO_BOTTOM);
                //
                //   wire in_H_right = (x >= H_X1 - 5      ) && (x < H_X1       )
                //                   && (y >= HELLO_TOP    ) && (y < HELLO_BOTTOM);
                //
                //   wire in_H_mid   = (y >= (HELLO_TOP+HELLO_BOTTOM)/2 - 3)
                //                   && (y <  (HELLO_TOP+HELLO_BOTTOM)/2 + 3)
                //                   && (x >= H_X0 + 5) && (x < H_X1 - 5);
                //
                //   in_H = in_H_left || in_H_right || in_H_mid;
                //
                // Haz algo similar para E, L, L, O usando otros rangos de X.

                // Por ahora, las banderas in_H, in_E, in_L1, in_L2, in_O
                // siguen en 0, para que el diseño compile aun sin letras.

            end

            // -----------------------------------------------------------------
            // 2.2) Color de las letras "HELLO"
            // -----------------------------------------------------------------
            //
            // Una vez que definas las regiones de cada letra (in_H, in_E, ...),
            // usa este bloque para pintarlas de un color llamativo por encima
            // del fondo de la banda.

            if (in_H || in_E || in_L1 || in_L2 || in_O)
            begin
                // Color de las letras (por ejemplo, rojo brillante)
                red   = 5'b11111;
                green = 6'd0;
                blue  = 5'd0;
            end

            // -----------------------------------------------------------------
            // 2.3) Barra de estado (extra opcional)
            // -----------------------------------------------------------------
            //
            // Como ejemplo extra, puedes usar una barra en la parte inferior
            // que cambie de tamaño o color con las teclas.
            //
            // Debajo se deja una idea simple implementada: una barra fija
            // cuyo color depende de key[0]. Puedes modificarla libremente.

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
