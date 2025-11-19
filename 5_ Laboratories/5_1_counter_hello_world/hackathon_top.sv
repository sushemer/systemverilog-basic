// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.1 – counter_hello_world
//
// Objetivo:
//   - Hacer parpadear un solo LED (~1 Hz) usando un divisor de frecuencia.
//   - Practicar: registros, always_ff, divisor de reloj, mapeo a pines.
//
// Tareas:
//   1) Implementar un contador que divida el clock de la FPGA.
//   2) Usar un bit del contador para encender/apagar led[0].
//   3) Mantener los demás LEDs apagados.
//   4) Probar en la tarjeta Tang Nano 9K.
//
// NOTA: Esta es la PLANTILLA del lab. Completa las secciones marcadas como TODO.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (no usado en este lab)
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

    // -------------------------------------------------------------------------
    // No usamos display, LCD ni GPIO en este lab
    // -------------------------------------------------------------------------
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio lo maneja el wrapper de la placa

    // -------------------------------------------------------------------------
    // Divisor de frecuencia
    // -------------------------------------------------------------------------
    //
    // Asumimos que "clock" es de ~27 MHz (desde el PLL de la placa).
    // Usaremos un contador y uno de sus bits altos para obtener un parpadeo
    // cercano a 1 Hz.
    //
    // 27 MHz / 2^25 ≈ 0.8 Hz (periodo ~1.2 s, suficiente para el lab).

    localparam int W_DIV = 25;

    logic [W_DIV-1:0] div_cnt;

    // TODO:
    //   - Implementar el contador síncrono con reset.
    //   - Sugerencia: al reset, poner div_cnt en 0.
    //   - En cada flanco de subida de clock, incrementar div_cnt.

    always_ff @(posedge clock or posedge reset)
    begin
        if (reset)
        begin
            div_cnt <= '0;
        end
        else
        begin
            // TODO: incrementar el contador
            // div_cnt <= ...;
        end
    end

    // -------------------------------------------------------------------------
    // Mapeo hacia LEDs
    // -------------------------------------------------------------------------
    //
    // led[0] debe parpadear con un bit alto del divisor (por ejemplo, bit 24).
    // Los demás LEDs deben estar apagados (0).

    always_comb
    begin
        // TODO:
        //   - Limpiar todos los LEDs.
        //   - Asignar led[0] a uno de los bits altos del contador:
        //       led[0] = div_cnt[W_DIV-1];

        led = 8'b0000_0000;  // valor por defecto

        // led[0] = ...;     // descomentar y completar
    end

endmodule
