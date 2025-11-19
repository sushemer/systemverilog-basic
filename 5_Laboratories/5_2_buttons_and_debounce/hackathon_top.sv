// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.2 – buttons_and_debounce
//
// Objetivo general:
//   - Controlar un LED usando un botón, con respuesta casi inmediata.
//   - Practicar asignaciones continuas (assign), uso de ~, &, | y wiring simple.
//
// Tareas sugeridas:
//   1) Hacer que led[0] siga directamente el estado del botón (nivel alto = LED encendido).
//   2) Hacer que led[1] se encienda cuando el botón esté SUELTO (inversión).
//   3) Usar un segundo botón como "enable" para controlar led[2] con una compuerta AND.
//   4) Dejar el resto de LEDs apagados.
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
    // Entradas lógicas (botones)
    // -------------------------------------------------------------------------
    //
    // Mapeo sugerido:
    //   btn = key[0]   → botón principal
    //   en  = key[1]   → botón de habilitación (enable)
    //
    // Puedes usar el TM1638 o los botones de la placa, según cómo esté
    // conectado el wrapper.

    logic btn;
    logic en;

    assign btn = key[0];
    assign en  = key[1];

    // -------------------------------------------------------------------------
    // Salidas a LEDs (lógica combinacional pura con assign)
    // -------------------------------------------------------------------------
    //
    // Requisitos:
    //   - led[0] = btn
    //   - led[1] = ~btn
    //   - led[2] = btn AND en
    //   - led[7:3] = 0
    //
    // Completa las asignaciones continuas (assign).

    // Todos los bits altos apagados por defecto
    assign led[7:3] = 5'b00000;

    // TODO: completar las asignaciones sencillas
    //
    // asignación directa (botón → LED)
    // assign led[0] = ...;
    //
    // asignación invertida (LED encendido cuando el botón está suelto)
    // assign led[1] = ...;
    //
    // compuerta AND con enable
    // assign led[2] = ...;

endmodule
