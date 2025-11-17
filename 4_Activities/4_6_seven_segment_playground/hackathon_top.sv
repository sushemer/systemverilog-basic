// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.6 – Playground de display de 7 segmentos
//
// Idea general:
//   - Usar el módulo seven_segment_display ya existente en el repo.
//   - Jugar con distintos patrones usando los 8 dígitos del display.
//   - Cambiar el contenido y los puntos decimales según teclas (key).
//
// NOTA: Esta es una PLANTILLA de actividad.
//       Modifica y extiende la lógica marcada como TODO.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (TM1638 / dinámico)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no usada en esta actividad)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // En esta actividad no usamos LCD ni GPIO.
    assign red   = '0;
    assign green = '0;
    assign blue  = '0;
    // gpio se maneja desde el wrapper de la placa.

    // Podemos usar los LEDs simplemente como indicador de modo.
    // (Puedes cambiar esto si quieres que muestren otra cosa).
    // mode = key[1:0]
    logic [1:0] mode;
    assign mode = key[1:0];

    assign led = { 6'b0, mode };  // Solo para saber en qué modo estamos.

    // -------------------------------------------------------------------------
    // Divisor de frecuencia para animaciones lentas
    // -------------------------------------------------------------------------
    //
    // Genera un "tick" lento (tick) a partir del clock principal (~27 MHz).
    // Cada vez que tick=1, actualizamos el contenido del display.

    localparam int W_DIV = 22;  // Ajusta para cambiar la velocidad
    logic [W_DIV-1:0] div_cnt;
    logic             tick;

    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            div_cnt <= '0;
            tick    <= 1'b0;
        end
        else
        begin
            div_cnt <= div_cnt + 1'b1;
            tick    <= (div_cnt == '0);
        end

    // -------------------------------------------------------------------------
    // Número y puntos decimales para el display de 7 segmentos
    // -------------------------------------------------------------------------
    //
    // El módulo seven_segment_display interpreta `number` como:
    //   - 4 bits por dígito (nibble), en total w_digit * 4 bits.
    //   - w_digit = 8  → number[31:0] = { D7, D6, D5, D4, D3, D2, D1, D0 }
    //       D0 = number[ 3: 0]
    //       D1 = number[ 7: 4]
    //       ...
    //       D7 = number[31:28]
    //
    // Cada nibble representa un dígito hexadecimal (0–F).

    localparam int W_DIGITS = 8;
    localparam int W_NUM    = W_DIGITS * 4;  // 32 bits

    logic [W_NUM-1:0]   number_reg;  // Contenido de los 8 dígitos
    logic [W_DIGITS-1:0] dots_reg;   // Puntos decimales (uno por dígito)

    // -------------------------------------------------------------------------
    // Lógica principal de playground
    // -------------------------------------------------------------------------

    // (Opcional) Un índice de posición para animaciones de desplazamiento
    logic [2:0] scroll_pos;

    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            number_reg <= '0;
            dots_reg   <= '0;
            scroll_pos <= '0;
        end
        else
        begin
            // Ejemplo base: usar key[7:0] para controlar puntos decimales.
            // Puedes cambiar esta lógica si quieres otra cosa.
            dots_reg <= key;  // 1 = punto encendido en cada dígito

            if (tick)
            begin
                // Pequeño contador de posición para modos de scroll
                scroll_pos <= scroll_pos + 3'd1;

                unique case (mode)
                    // ---------------------------------------------------------
                    // Modo 0: contador hexadecimal libre en todos los dígitos
                    // ---------------------------------------------------------
                    2'b00:
                    begin
                        // TODO: puedes cambiar la velocidad de suma,
                        // o limitar el rango del contador.
                        number_reg <= number_reg + 32'd1;
                    end

                    // ---------------------------------------------------------
                    // Modo 1: playground manual
                    // ---------------------------------------------------------
                    // Idea sugerida:
                    //   - Mostrar en el dígito menos significativo (D0)
                    //     el valor de key[7:4] como dígito HEX.
                    //   - Dejar el resto de dígitos en cero o con un patrón fijo.
                    2'b01:
                    begin
                        // Conserva el valor anterior de todos los dígitos
                        // y solo actualiza D0.
                        number_reg[3:0] <= key[7:4];

                        // TODO:
                        // - Cambia aquí para copiar key[7:4] a otro dígito.
                        // - O usa distintas combinaciones de teclas para llenar
                        //   todos los dígitos con valores HEX.
                    end

                    // ---------------------------------------------------------
                    // Modo 2: "barra" o dígito que se desplaza
                    // ---------------------------------------------------------
                    // Idea sugerida:
                    //   - Mover un dígito "lleno" (por ejemplo 0xF)
                    //     a lo largo de los 8 dígitos, usando scroll_pos.
                    2'b10:
                    begin
                        // Plantilla: todos los dígitos en 0
                        number_reg <= '0;

                        // TODO:
                        // - Usa scroll_pos para seleccionar qué nibble activar.
                        //   Por ejemplo:
                        //      case (scroll_pos)
                        //        3'd0: number_reg[ 3: 0] = 4'hF;
                        //        3'd1: number_reg[ 7: 4] = 4'hF;
                        //        ...
                        //      endcase
                        //
                        // - También puedes hacer un patrón simétrico
                        //   (ej: desde los extremos hacia el centro).
                    end

                    // ---------------------------------------------------------
                    // Modo 3: modo libre
                    // ---------------------------------------------------------
                    // Espacio para que definas tu propio experimento:
                    //   - Mostrar un patrón fijo (0xDEAD_BEEF, 0xC0FFEE, etc.).
                    //   - Alternar entre dos palabras/patrones.
                    //   - Hacer "scroll" de texto hexadecimal.
                    2'b11:
                    begin
                        // TODO:
                        // - Implementa aquí tu propio efecto.
                        //   Por ejemplo:
                        //     number_reg <= 32'hDEAD_BEEF;
                        //
                        // - O usa scroll_pos para desplazamiento de hex.
                        number_reg <= number_reg;
                    end
                endcase
            end
        end

    // -------------------------------------------------------------------------
    // Instancia del driver de display de 7 segmentos
    // -------------------------------------------------------------------------

    seven_segment_display
    # (
        .w_digit (W_DIGITS)
    )
    i_7segment
    (
        .clk      ( clock       ),
        .rst      ( reset       ),
        .number   ( number_reg  ),
        .dots     ( dots_reg    ),
        .abcdefgh ( abcdefgh    ),
        .digit    ( digit       )
    );

endmodule
