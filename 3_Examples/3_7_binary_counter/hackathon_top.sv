// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.7: Binary counter (free‐running + variante controlada por teclas)
//
// Idea general:
// - Usar el reloj principal de la Tang Nano 9K para incrementar un contador grande.
// - Mostrar los bits más significativos del contador en los LEDs, de modo que
//   parpadeen a distintas frecuencias (efecto de “correr” en binario).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,  // no se usa en este ejemplo
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display 7 segmentos (no usado aquí)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no usada aquí)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO (no usados aquí)
    inout  logic [3:0] gpio
);

    // ------------------------------------------------------------------------
    // Apagar periféricos que no usamos
    // ------------------------------------------------------------------------
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;   // Alta impedancia en GPIO

    // ------------------------------------------------------------------------
    // Ejemplo 1: Free-running binary counter
    //
    // Contador ancho que se incrementa en cada flanco de subida de "clock".
    // Los bits más altos del contador se envían a los LEDs.
    //
    // Cambiando qué bits se muestran, cambias la velocidad aparente de parpadeo.
    // ------------------------------------------------------------------------
    
    // Frecuencia aproximada del reloj de la Tang Nano 9K (MHz)
    localparam int CLK_MHZ = 27;

    // Número de bits suficiente para contar hasta 1 segundo:
    //  cnt_max ≈ CLK_MHZ * 1e6 → necesitamos clog2(cnt_max) bits
    localparam int W_CNT = $clog2(CLK_MHZ * 1_000_000);

    logic [W_CNT-1:0] cnt;

    // Contador binario libre
    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            cnt <= '0;
        else
            cnt <= cnt + 1'b1;
    end

    // Mostrar los 8 bits más significativos del contador en los LEDs.
    // Esto hace que cada LED parpadee a una frecuencia distinta
    // (el MSB es el más lento).
    assign led = cnt[W_CNT-1 -: 8];

    // ------------------------------------------------------------------------
    // Ejemplo 2 (opcional): counter controlado por teclas
    //
    // - Comenta las líneas de "Ejemplo 1" (contadores/assign de arriba).
    // - Descomenta el bloque siguiente.
    // - El contador avanza sólo cuando se detecta un "pulso" de tecla.
    // ------------------------------------------------------------------------
    /*
    // Detectar si cualquier tecla está presionada
    wire any_key = |key;

    // Registro para detección de flanco
    logic any_key_r;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            any_key_r <= 1'b0;
        else
            any_key_r <= any_key;
    end

    // Pulso de “transición” (aquí se detecta el flanco de liberación)
    wire any_key_pulse = ~any_key & any_key_r;

    // Contador de 8 bits controlado por teclas
    logic [7:0] cnt_key;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            cnt_key <= 8'd0;
        else if (any_key_pulse)
            cnt_key <= cnt_key + 8'd1;
    end

    assign led = cnt_key;
    */

endmodule
