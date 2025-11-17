// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.6 – Playground de display de 7 segmentos
//
// Modos:
//   mode = key[1:0]
//
//   00 → Contador hexadecimal libre en los 8 dígitos
//   01 → Playground manual (key[7:4] en el dígito 0)
//   10 → “Barra” / dígito 0xF que recorre los 8 dígitos (scroll)
//   11 → Patrón fijo 0xDEAD_BEEF
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

    // -------------------------------------------------------------------------
    // Modo (para saber qué efecto está activo)
    // -------------------------------------------------------------------------

    logic [1:0] mode;
    assign mode = key[1:0];

    // Mostramos el modo en los LEDs [1:0] solo como indicación visual
    assign led = { 6'b0, mode };

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

    logic [W_NUM-1:0]    number_reg;  // Contenido de los 8 dígitos
    logic [W_DIGITS-1:0] dots_reg;    // Puntos decimales (uno por dígito)

    // Índice de posición para animaciones de desplazamiento
    logic [2:0] scroll_pos;

    // -------------------------------------------------------------------------
    // Lógica principal de playground
    // -------------------------------------------------------------------------

    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            number_reg <= '0;
            dots_reg   <= '0;
            scroll_pos <= '0;
        end
        else
        begin
            // Usamos key[7:0] como máscara de puntos decimales:
            //   dots_reg[i] = 1 → enciende el punto en el dígito i.
            dots_reg <= key;

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
                        number_reg <= number_reg + 32'd1;
                    end

                    // ---------------------------------------------------------
                    // Modo 1: playground manual
                    // ---------------------------------------------------------
                    // D0 (nibble [3:0]) = key[7:4]
                    // El resto de dígitos se mantiene igual.
                    2'b01:
                    begin
                        number_reg[3:0] <= key[7:4];
                        // Los demás nibbles conservan su valor anterior
                    end

                    // ---------------------------------------------------------
                    // Modo 2: “barra” / dígito 0xF que se desplaza
                    // ---------------------------------------------------------
                    // Un solo nibble en 0xF recorre los 8 dígitos.
                    2'b10:
                    begin
                        number_reg <= '0;

                        unique case (scroll_pos)
                            3'd0: number_reg[ 3: 0] <= 4'hF;  // D0
                            3'd1: number_reg[ 7: 4] <= 4'hF;  // D1
                            3'd2: number_reg[11: 8] <= 4'hF;  // D2
                            3'd3: number_reg[15:12] <= 4'hF;  // D3
                            3'd4: number_reg[19:16] <= 4'hF;  // D4
                            3'd5: number_reg[23:20] <= 4'hF;  // D5
                            3'd6: number_reg[27:24] <= 4'hF;  // D6
                            3'd7: number_reg[31:28] <= 4'hF;  // D7
                            default: number_reg <= '0;
                        endcase
                    end

                    // ---------------------------------------------------------
                    // Modo 3: patrón fijo – 0xDEAD_BEEF
                    // ---------------------------------------------------------
                    2'b11:
                    begin
                        number_reg <= 32'hDEAD_BEEF;
                    end

                    default:
                    begin
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
        .clk      ( clock      ),
        .rst      ( reset      ),
        .number   ( number_reg ),
        .dots     ( dots_reg   ),
        .abcdefgh ( abcdefgh   ),
        .digit    ( digit      )
    );

endmodule
