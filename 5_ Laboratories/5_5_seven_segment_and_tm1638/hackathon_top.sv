// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.5 – Seven-segment + TM1638 playground
//
// Idea general:
//   - Usar el módulo seven_segment_display del repo para controlar 8 dígitos.
//   - Tratar key[7:0] y led[7:0] como interfaz lógica del módulo TM1638.
//   - Practicar distintos modos de visualización:
//       * Modo 0: contador hexadecimal libre (32 bits).
//       * Modo 1: mostrar nibbles de key[7:0] como dos dígitos HEX.
//       * Modo 2: patrón fijo "DEAD_BEEF".
//       * Modo 3: número invertido (~counter).
//   - Usar los puntos decimales (dots) como indicadores directos de key.
//
// Notas:
//   - La lógica es intencionalmente sencilla para enfocarse en
//     el uso de seven_segment_display y en el mapeo de nibbles a dígitos.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (interfaz abstracta tipo TM1638/dinámico)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no usada en este lab)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // No usamos LCD ni GPIO en este lab.
    assign red   = '0;
    assign green = '0;
    assign blue  = '0;
    // gpio lo maneja el wrapper de la placa.

    // -------------------------------------------------------------------------
    // Modo de operación (2 bits desde key)
    // -------------------------------------------------------------------------
    //
    //   mode = key[1:0]:
    //     00 -> contador HEX
    //     01 -> nibbles desde key[7:0]
    //     10 -> patrón fijo DEAD_BEEF
    //     11 -> número invertido (~counter)

    logic [1:0] mode;
    assign mode = key[1:0];

    // -------------------------------------------------------------------------
    // Divisor de frecuencia para animaciones lentas (tick)
    // -------------------------------------------------------------------------

    localparam int W_DIV = 22;  // Ajusta para cambiar la velocidad del tick

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
    // Contador base de 32 bits (para mostrar en HEX)
    // -------------------------------------------------------------------------

    logic [31:0] hex_counter;

    always_ff @(posedge clock or posedge reset)
        if (reset)
            hex_counter <= 32'd0;
        else if (tick)
            hex_counter <= hex_counter + 32'd1;

    // -------------------------------------------------------------------------
    // Registro de número y puntos decimales para seven_segment_display
    // -------------------------------------------------------------------------

    localparam int W_DIGITS = 8;
    localparam int W_NUM    = W_DIGITS * 4;  // 32 bits

    logic [W_NUM-1:0]    number_reg; // 8 dígitos HEX
    logic [W_DIGITS-1:0] dots_reg;   // puntos decimales (uno por dígito)

    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            number_reg <= '0;
            dots_reg   <= '0;
        end
        else
        begin
            // dots: usamos directamente key[7:0]
            //       1 = punto encendido en ese dígito.
            dots_reg <= key;

            // Actualizar number_reg según el modo cada vez que hay tick.
            if (tick)
            begin
                unique case (mode)
                    // ---------------------------------------------------------
                    // Modo 0: contador hexadecimal libre (32 bits)
                    // ---------------------------------------------------------
                    2'b00:
                    begin
                        // Mostramos hex_counter tal cual (32 bits → 8 dígitos).
                        number_reg <= hex_counter;
                    end

                    // ---------------------------------------------------------
                    // Modo 1: playground manual con key[7:0]
                    // ---------------------------------------------------------
                    //   - D0 = key[3:0]
                    //   - D1 = key[7:4]
                    //   - D2..D7 = 0
                    2'b01:
                    begin
                        number_reg <= { 24'h0, key[7:4], key[3:0] };
                    end

                    // ---------------------------------------------------------
                    // Modo 2: patrón fijo "DEAD_BEEF"
                    // ---------------------------------------------------------
                    //   number_reg = 0xDEAD_BEEF (HEX clásico de debug).
                    2'b10:
                    begin
                        number_reg <= 32'hDEAD_BEEF;
                    end

                    // ---------------------------------------------------------
                    // Modo 3: número invertido (~hex_counter)
                    // ---------------------------------------------------------
                    //   - Para ver fácilmente que cambiamos de representación.
                    2'b11:
                    begin
                        number_reg <= ~hex_counter;
                    end

                    default:
                    begin
                        number_reg <= 32'd0;
                    end
                endcase
            end
        end

    // -------------------------------------------------------------------------
    // Mapeo a LEDs físicos (TM1638)
    // -------------------------------------------------------------------------
    //
    // Idea:
    //   - led[1:0] = mode (para ver rápidamente el modo activo).
    //   - led[7:2] = bits bajos del contador (patrón "decorativo").
    //

    always_comb
    begin
        led       = 8'b0000_0000;
        led[1:0]  = mode;
        led[7:2]  = hex_counter[7:2];
    end

    // -------------------------------------------------------------------------
    // Instancia del driver seven_segment_display
    // -------------------------------------------------------------------------

    seven_segment_display
    #(
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
