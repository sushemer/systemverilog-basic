// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.5 – Contadores y patrones de desplazamiento en LEDs
//
// Idea general:
//   - Usar el reloj principal para generar un "paso" lento (step_en).
//   - Implementar al menos dos patrones en un vector de 8 LEDs:
//       * Patrón 1: contador binario (free-running counter).
//       * Patrón 2: bit que se desplaza (shift register / “running light”).
//   - Seleccionar el patrón usando algunas teclas (key).
//
// NOTA: Este archivo es una PLANTILLA de actividad.
//       Debes completar y/o modificar las secciones marcadas como TODO.
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

    assign step_en = (div_cnt == '0);

    // TODO (opcional):
    // - Puedes cambiar W_DIV o la condición de step_en para acelerar o
    //   desacelerar la animación.

    // -------------------------------------------------------------------------
    // Patrones de LEDs
    // -------------------------------------------------------------------------

    // Modo de visualización seleccionado por teclas:
    //   key[1:0] → modo de patrón.
    logic [1:0] mode;
    assign mode = key[1:0];

    // Patrón 1: contador binario de 8 bits.
    logic [7:0] counter_pattern;

    // Patrón 2: registro de desplazamiento (running light / KITT).
    logic [7:0] shift_pattern;

    // (Opcional) Patrón 3: puedes crear un patrón "ping-pong" o mezcla.
    // logic [7:0] pingpong_pattern;

    // Inicialización y actualización de patrones
    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            counter_pattern <= 8'd0;
            shift_pattern   <= 8'b0000_0001;  // Empieza con un solo bit encendido
            // pingpong_pattern <= 8'b0000_0001;
        end
        else if (step_en)
        begin
            // Patrón 1: contador binario libre
            counter_pattern <= counter_pattern + 8'd1;

            // Patrón 2: desplazamiento circular simple (ejemplo base)
            // TODO: puedes cambiar esta lógica para:
            //   - mover la luz sólo hacia un lado
            //   - implementar un "ping-pong" (rebote)
            //   - hacer un patrón más complejo
            shift_pattern <= { shift_pattern[6:0], shift_pattern[7] };

            // TODO (opcional): implementar aquí un tercer patrón,
            // por ejemplo ping-pong, usando otra variable.
        end

    // -------------------------------------------------------------------------
    // Selección de patrón hacia los LEDs
    // -------------------------------------------------------------------------

    logic [7:0] leds_next;

    always_comb
    begin
        // Valor por defecto: contador binario
        leds_next = counter_pattern;

        unique case (mode)
            2'b00: leds_next = counter_pattern;           // Modo 0: contador
            2'b01: leds_next = shift_pattern;             // Modo 1: running light
            2'b10: leds_next = counter_pattern ^ shift_pattern;
            // Modo 2: ejemplo → mezcla XOR de ambos patrones
            2'b11: leds_next = ~counter_pattern;          // Modo 3: invertido
        endcase

        // TODO:
        // - Puedes redefinir cada modo para que use patrones distintos.
        // - Por ejemplo:
        //     00: contador
        //     01: running light
        //     10: ping-pong
        //     11: LEDs apagados o patrón especial
    end

    assign led = leds_next;

endmodule
