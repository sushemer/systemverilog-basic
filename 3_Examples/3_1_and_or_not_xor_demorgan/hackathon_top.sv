// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Ejemplo 3.1: compuertas lógicas básicas + verificación de una ley de De Morgan.
//
// Este módulo está pensado como "top" mínimo para la Tang Nano 9K:
// - Usa 2 entradas digitales (key[1:0]) como señales A y B.
// - Usa 5 LEDs (led[4:0]) para mostrar resultados de AND, OR, XOR y De Morgan.
// - No utiliza reloj ni lógica secuencial; todo es puramente combinacional.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // A dynamic seven-segment display

    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD screen interface

    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // Renombrar internamente para claridad.
    // Esto ayuda a razonar en términos de A y B en lugar de key[1:0].
    logic A, B;
    assign A = key[1];
    assign B = key[0];

    // ------------------------------------------------------------------------
    // Compuertas básicas
    // ------------------------------------------------------------------------
    // Cada una de estas asignaciones es combinacional y se evalúa de forma
    // continua: cualquier cambio en A o B se reflejará de inmediato en los LEDs.

    assign led[0] = A & B;    // AND: solo es 1 cuando A = 1 y B = 1
    assign led[1] = A | B;    // OR: es 1 cuando al menos una entrada es 1
    assign led[2] = A ^ B;    // XOR: es 1 cuando A y B son distintos

    // ------------------------------------------------------------------------
    // Ley de De Morgan
    // ------------------------------------------------------------------------
    // Se muestran dos expresiones distintas que deben producir el mismo resultado:
    //
    //   1) ~(A & B)
    //   2) (~A) | (~B)
    //
    // La tabla de verdad indica que ambas expresiones son equivalentes.
    // En hardware, se puede "ver" esta equivalencia cuando led[3] y led[4]
    // siempre coinciden para todas las combinaciones de A y B.

    assign led[3] = ~(A & B);       // Expresión 1: negación de AND
    assign led[4] = (~A) | (~B);    // Expresión 2: OR de las negaciones

    // Si el cableado y el código son correctos:
    // - led[3] y led[4] deberán encenderse y apagarse siempre al mismo tiempo.
    // - Esto permite verificar experimentalmente la ley de De Morgan.

endmodule
