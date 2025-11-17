// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.2 – Composición: decoder 2→4 + mux 4→1
//
// Idea general:
//   - Usar 2 bits de selección (sel) para elegir 1 de 4 datos (data[3:0]).
//   - Implementar un decoder 2→4 "one-hot".
//   - Usar ese decoder para construir un mux 4→1 con compuertas AND/OR.
//   - Visualizar el decoder y la salida del mux en los LEDs.
//
// NOTA: Este archivo es una PLANTILLA de actividad. Falta completar
//       las partes marcadas como TODO.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos dinámico (no usado aquí)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz hacia LCD (no usada en esta actividad)
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
    // gpio lo maneja el wrapper de la placa

    // -------------------------------------------------------------------------
    // Entradas lógicas: selectores y datos del mux
    // -------------------------------------------------------------------------
    //
    // Propuesta de mapeo:
    //   sel[1:0]  = key[1:0]
    //   data[3:0] = key[5:2]
    //
    // Así puedes cambiar qué canal seleccionas (sel)
    // y qué valor tiene cada dato (data[i]) usando las teclas.

    logic [1:0] sel;
    logic [3:0] data;

    assign sel  = key[1:0];
    assign data = key[5:2];

    // -------------------------------------------------------------------------
    // Decoder 2→4 "one-hot"
    // -------------------------------------------------------------------------

    logic [3:0] dec_out;

    always_comb
    begin
        // Valor por defecto
        dec_out = 4'b0000;

        // Decoder 2→4 estándar
        case (sel)
            2'b00: dec_out = 4'b0001; // canal 0
            2'b01: dec_out = 4'b0010; // canal 1
            2'b10: dec_out = 4'b0100; // canal 2
            2'b11: dec_out = 4'b1000; // canal 3
            default: dec_out = 4'b0000;
        endcase
    end

    // -------------------------------------------------------------------------
    // Composición: mux 4→1 construido con decoder + AND + OR
    // -------------------------------------------------------------------------

    logic [3:0] and_terms;
    logic       mux_y;

    // AND de cada dato con su línea "one-hot"
    assign and_terms[0] = dec_out[0] & data[0];
    assign and_terms[1] = dec_out[1] & data[1];
    assign and_terms[2] = dec_out[2] & data[2];
    assign and_terms[3] = dec_out[3] & data[3];

    // OR final: selecciona el único dato que quedó “enmascarado”
    assign mux_y = |and_terms;
    // Equivalente a:
    // assign mux_y = and_terms[0] | and_terms[1]
    //              | and_terms[2] | and_terms[3];

    // -------------------------------------------------------------------------
    // Salidas a LEDs
    // -------------------------------------------------------------------------

    always_comb
    begin
        led = 8'b0000_0000;

        led[3:0] = dec_out;  // Visualizar salidas del decoder (one-hot)
        led[4]   = mux_y;    // Salida del mux 4→1

        // led[7:5] quedan libres para extensiones / debug.
    end

endmodule
