// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.3 – Shift register patterns (KITT / running lights / rotaciones)
//
// Idea:
//   - Usar un divisor de frecuencia para generar un "tick" lento.
//   - Mantener un registro de 8 bits que define el patrón de LEDs.
//   - Cambiar el comportamiento del patrón según key[1:0]:
//       00: rotación circular a la izquierda
//       01: rotación circular a la derecha
//       10: KITT (ping-pong)
//       11: LEDs apagados (reservado para experimentos)
//
//   - led[7:0] muestran directamente el contenido del shift register.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (no usado aquí)
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

    // No usamos LCD, 7 segmentos ni GPIO en este lab.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio lo gestiona el wrapper de la placa.

    // -------------------------------------------------------------------------
    // 1) Divisor de frecuencia para generar step_en (tick lento)
    // -------------------------------------------------------------------------
    //
    // Con ~27 MHz, W_DIV=22 da unos pocos pasos por segundo (visible a ojo).

    localparam int W_DIV = 22;

    logic [W_DIV-1:0] div_cnt;
    logic             step_en;

    always_ff @(posedge clock or posedge reset)
        if (reset)
            div_cnt <= '0;
        else
            div_cnt <= div_cnt + 1'b1;

    assign step_en = (div_cnt == '0);

    // -------------------------------------------------------------------------
    // 2) Registro de desplazamiento + modo
    // -------------------------------------------------------------------------

    // Modo de animación:
    //   key[1:0] = modo
    logic [1:0] mode;
    assign mode = key[1:0];

    // Registro que se mostrará en los LEDs
    logic [7:0] pattern_reg;

    // Dirección para el modo KITT (ping-pong):
    //   0 → moviéndose hacia la izquierda (hacia led[7])
    //   1 → moviéndose hacia la derecha (hacia led[0])
    logic dir_kitt;

    // Inicialización y actualización del patrón
    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            pattern_reg <= 8'b0000_0001; // empieza en el LED 0
            dir_kitt    <= 1'b0;         // primera dirección: izquierda
        end
        else if (step_en)
        begin
            unique case (mode)
                // -------------------------------------------------------------
                // Modo 0: rotación circular a la izquierda
                // -------------------------------------------------------------
                2'b00:
                begin
                    // bit más significativo se regresa al bit 0
                    pattern_reg <= { pattern_reg[6:0], pattern_reg[7] };
                end

                // -------------------------------------------------------------
                // Modo 1: rotación circular a la derecha
                // -------------------------------------------------------------
                2'b01:
                begin
                    // bit 0 se pasa al MSB
                    pattern_reg <= { pattern_reg[0], pattern_reg[7:1] };
                end

                // -------------------------------------------------------------
                // Modo 2: KITT / ping-pong
                // -------------------------------------------------------------
                2'b10:
                begin
                    // Cuando llega al extremo izquierdo, cambia de sentido
                    if (!dir_kitt) // moviéndose hacia la izquierda
                    begin
                        if (pattern_reg == 8'b1000_0000)
                        begin
                            dir_kitt    <= 1'b1;           // cambia a derecha
                            pattern_reg <= 8'b0100_0000;    // paso hacia adentro
                        end
                        else
                            pattern_reg <= pattern_reg << 1;
                    end
                    else // dir_kitt == 1'b1 → moviéndose hacia la derecha
                    begin
                        if (pattern_reg == 8'b0000_0001)
                        begin
                            dir_kitt    <= 1'b0;           // cambia a izquierda
                            pattern_reg <= 8'b0000_0010;    // paso hacia adentro
                        end
                        else
                            pattern_reg <= pattern_reg >> 1;
                    end
                end

                // -------------------------------------------------------------
                // Modo 3: todo apagado (espacio para experimentar)
                // -------------------------------------------------------------
                default:
                begin
                    pattern_reg <= 8'b0000_0000;
                end
            endcase
        end

    // -------------------------------------------------------------------------
    // 3) Salida a LEDs
    // -------------------------------------------------------------------------

    assign led = pattern_reg;

endmodule
