// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.5 – Contadores y patrones de desplazamiento en LEDs
//
// Idea general:
//   - Usar el reloj principal para generar un "paso" lento (step_en).
//   - Implementar al menos dos patrones en un vector de 8 LEDs:
//       * Patrón 1: contador binario (free-running counter).
//       * Patrón 2: bit que se desplaza (shift register / “running light”).
//   - Extensión: patrón tipo "ping-pong" que rebota de un extremo a otro.
//   - Seleccionar el patrón usando algunas teclas (key).
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (no usado en esta actividad)
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

    // En esta actividad no usamos display, LCD ni GPIO.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio se maneja desde el wrapper de la placa

    // -------------------------------------------------------------------------
    // Divisor de frecuencia para generar pasos "lentos"
    // -------------------------------------------------------------------------
    //
    // La FPGA corre a ~27 MHz. Un contador de 24 bits tarda ~2^24 ciclos en
    // desbordarse. Esto produce un pulso "step_en" que podemos usar como tick
    // para avanzar los patrones de LEDs.

    localparam int W_DIV = 24;

    logic [W_DIV-1:0] div_cnt;
    logic             step_en;

    always_ff @(posedge clock or posedge reset)
        if (reset)
            div_cnt <= '0;
        else
            div_cnt <= div_cnt + 1'b1;

    // Pulso de habilitación cuando el contador se desborda
    assign step_en = (div_cnt == '0);

    // -------------------------------------------------------------------------
    // Modo de visualización seleccionado por teclas
    // -------------------------------------------------------------------------
    //
    //   key[1:0] → modo de patrón:
    //     00: contador binario
    //     01: desplazamiento circular
    //     10: ping-pong (rebote)
    //     11: mezcla XOR de contador y shift circular

    logic [1:0] mode;
    assign mode = key[1:0];

    // -------------------------------------------------------------------------
    // Patrones de LEDs
    // -------------------------------------------------------------------------

    // Patrón 1: contador binario de 8 bits.
    logic [7:0] counter_pattern;

    // Patrón 2: registro de desplazamiento circular (running light).
    logic [7:0] shift_pattern;

    // Patrón 3: ping-pong (bit que rebota entre extremos).
    logic [7:0] pingpong_pattern;
    logic       pingpong_dir; // 0 = hacia la izquierda, 1 = hacia la derecha

    // Inicialización y actualización de patrones
    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            counter_pattern  <= 8'd0;
            shift_pattern    <= 8'b0000_0001;  // Empieza con un solo bit encendido
            pingpong_pattern <= 8'b0000_0001;  // También inicia en el bit 0
            pingpong_dir     <= 1'b0;         // 0 = moviéndose hacia la izquierda (hacia MSB)
        end
        else if (step_en)
        begin
            // Patrón 1: contador binario libre
            counter_pattern <= counter_pattern + 8'd1;

            // Patrón 2: desplazamiento circular hacia la izquierda
            shift_pattern <= { shift_pattern[6:0], shift_pattern[7] };

            // Patrón 3: ping-pong (rebote entre 0000_0001 y 1000_0000)
            if (!pingpong_dir)
            begin
                // Moviéndose hacia la izquierda (hacia el MSB)
                if (pingpong_pattern == 8'b1000_0000)
                begin
                    // Al llegar al extremo izquierdo, cambiamos de dirección
                    pingpong_dir     <= 1'b1;
                    pingpong_pattern <= 8'b0100_0000;
                end
                else
                    pingpong_pattern <= pingpong_pattern << 1;
            end
            else
            begin
                // Moviéndose hacia la derecha (hacia el LSB)
                if (pingpong_pattern == 8'b0000_0001)
                begin
                    // Al llegar al extremo derecho, cambiamos de dirección
                    pingpong_dir     <= 1'b0;
                    pingpong_pattern <= 8'b0000_0010;
                end
                else
                    pingpong_pattern <= pingpong_pattern >> 1;
            end
        end

    // -------------------------------------------------------------------------
    // Selección de patrón hacia los LEDs
    // -------------------------------------------------------------------------

    logic [7:0] leds_next;

    always_comb
    begin
        // Valor por defecto
        leds_next = counter_pattern;

        unique case (mode)
            2'b00: leds_next = counter_pattern;                  // Modo 0: contador
            2'b01: leds_next = shift_pattern;                    // Modo 1: circular
            2'b10: leds_next = pingpong_pattern;                 // Modo 2: ping-pong
            2'b11: leds_next = counter_pattern ^ shift_pattern;  // Modo 3: mezcla XOR
            default: leds_next = counter_pattern;
        endcase
    end

    assign led = leds_next;

endmodule
