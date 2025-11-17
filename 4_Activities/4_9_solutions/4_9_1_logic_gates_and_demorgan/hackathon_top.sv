// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.1 – Compuertas lógicas + ley de De Morgan + funciones combinacionales
//
// Tareas:
//  1) Implementar AND, OR, XOR y una ley de De Morgan con 2 entradas (A, B).
//  2) Extender a 3 entradas (A, B, C) y diseñar funciones “mayoría” y “exactamente una en 1”.
//  3) Agregar una entrada de habilitación (EN) que apague todas las salidas cuando EN = 0.
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

    // No usaremos display, LCD ni GPIO en esta actividad.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio se deja sin manejar desde este módulo (lo controla el wrapper de la placa)

    // -------------------------------------------------------------------------
    // Entradas lógicas
    // -------------------------------------------------------------------------
    //
    // Tarea 1 y 2:
    //   A = key[1]
    //   B = key[0]
    //   C = key[2]      (se usa en la Tarea 2)
    //
    // Tarea 3:
    //   EN = key[3]     (entrada de habilitación)

    logic A, B, C, EN;

    assign A  = key[1];
    assign B  = key[0];
    assign C  = key[2];
    assign EN = key[3];

    // -------------------------------------------------------------------------
    // Tarea 1: Compuertas básicas + ley de De Morgan (con A y B)
    // -------------------------------------------------------------------------
    //
    // Objetivo:
    //   - led[0] = A AND B
    //   - led[1] = A OR  B
    //   - led[2] = A XOR B
    //   - led[3] = ~(A & B)
    //   - led[4] = (~A) | (~B)

    logic and_ab;
    logic or_ab;
    logic xor_ab;
    logic demorgan_1;
    logic demorgan_2;

    // Implementación de la Tarea 1
    assign and_ab     = A & B;
    assign or_ab      = A | B;
    assign xor_ab     = A ^ B;
    assign demorgan_1 = ~(A & B);       // primera forma
    assign demorgan_2 = (~A) | (~B);    // forma de De Morgan equivalente

    // -------------------------------------------------------------------------
    // Tarea 2: Funciones combinacionales con 3 entradas (A, B, C)
    // -------------------------------------------------------------------------
    //
    // Objetivo (ejemplo sugerido):
    //   - led[5] = “mayoría”: al menos dos entradas en 1.
    //   - led[6] = “exactamente una entrada en 1”.
    //
    // Usamos AND, OR y NOT para construir estas funciones.

    logic majority_abc;   // al menos dos entradas en 1
    logic exactly_one_abc;

    // Mayoría: al menos dos de {A,B,C} son 1
    // Pista: (A & B) | (A & C) | (B & C)
    assign majority_abc =
          (A & B)
        | (A & C)
        | (B & C);

    // Exactamente una en 1:
    //   100 + 010 + 001
    assign exactly_one_abc =
          ( A  & ~B & ~C)
        | (~A &  B & ~C)
        | (~A & ~B &  C);

    // -------------------------------------------------------------------------
    // Tarea 3: Entrada de habilitación EN
    // -------------------------------------------------------------------------
    //
    // Requisito:
    //   - Si EN = 0 → todos los LEDs [6:0] deben estar en 0.
    //   - Si EN = 1 → mostrar los resultados de las tareas 1 y 2.
    //   - led[7] indica si EN está activo (led[7] = EN).

    logic [6:0] raw_leds;  // salidas lógicas sin habilitación

    always_comb
    begin
        // Mapear compuertas de la Tarea 1
        raw_leds[0] = and_ab;
        raw_leds[1] = or_ab;
        raw_leds[2] = xor_ab;
        raw_leds[3] = demorgan_1;
        raw_leds[4] = demorgan_2;

        // Mapear funciones de la Tarea 2
        raw_leds[5] = majority_abc;
        raw_leds[6] = exactly_one_abc;
    end

    // Aplicar la habilitación
    always_comb
    begin
        if (EN)
            led[6:0] = raw_leds;
        else
            led[6:0] = 7'b0;

        led[7] = EN;
    end

endmodule
