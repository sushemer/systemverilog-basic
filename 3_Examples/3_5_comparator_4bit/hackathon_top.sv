// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.5: Comparador de 4 bits (A vs B) con dos implementaciones.
//
// Idea general:
// - Entradas:
//     A[3:0] = key[3:0]
//     B[3:0] = key[7:4]
// - Salidas (dos comparadores):
//     Implementación 0 (alto nivel: ==, >, <)
//       eq0 = (A == B)
//       gt0 = (A >  B)
//       lt0 = (A <  B)
//
//     Implementación 1 (bit a bit, "comparador en cascada"):
//       eq1, gt1, lt1 calculados a partir de comparaciones por bit.
//
// Mapeo a LEDs:
//   led[0] = eq0   (A == B)  – implementación 0
//   led[1] = gt0   (A >  B)
//   led[2] = lt0   (A <  B)
//
//   led[3] = eq1   (A == B)  – implementación 1
//   led[4] = gt1   (A >  B)
//   led[5] = lt1   (A <  B)
//
//   led[7:6] = 0   (no usados)

module hackathon_top
(
    // Interfaz estándar para esta board
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display 7 segmentos (no se usa aquí)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no se usa aquí)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO genéricos (no se usan aquí)
    inout  logic [3:0] gpio
);

    // ------------------------------------------------------------------------
    // Apagar lo que no usamos
    // ------------------------------------------------------------------------
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Entradas del comparador de 4 bits
    // ------------------------------------------------------------------------
    //
    // A = key[3:0]
    // B = key[7:4]
    //
    // Cambiando los bits de key puedes formar dos valores de 4 bits
    // y compararlos entre sí.

    logic [3:0] A, B;

    assign A = key[3:0];
    assign B = key[7:4];

    // ------------------------------------------------------------------------
    // Implementación 0: comparador "alto nivel" con ==, >, <
    // ------------------------------------------------------------------------

    logic eq0, gt0, lt0;

    always_comb begin
        eq0 = (A == B);
        gt0 = (A  > B);
        lt0 = (A  < B);
    end

    // ------------------------------------------------------------------------
    // Implementación 1: comparador bit a bit (cascada)
    // ------------------------------------------------------------------------
    //
    // Idea:
    //   - Primero revisamos el bit más significativo (MSB).
    //   - Si A[3] y B[3] son distintos, ya sabemos quién gana.
    //   - Si son iguales, pasamos al siguiente bit (A[2], B[2]) y así sucesivamente.
    //   - Si todos los bits son iguales, entonces A == B.
    //
    // Esta es similar a cómo se construye un comparador 4-bit a partir
    // de comparadores 1-bit en cascada.

    logic eq1, gt1, lt1;

    always_comb begin
        // Por defecto asumimos igualdad
        eq1 = 1'b0;
        gt1 = 1'b0;
        lt1 = 1'b0;

        if (A[3] != B[3]) begin
            // El MSB decide
            gt1 = (A[3] & ~B[3]);
            lt1 = (~A[3] & B[3]);
        end
        else if (A[2] != B[2]) begin
            gt1 = (A[2] & ~B[2]);
            lt1 = (~A[2] & B[2]);
        end
        else if (A[1] != B[1]) begin
            gt1 = (A[1] & ~B[1]);
            lt1 = (~A[1] & B[1]);
        end
        else if (A[0] != B[0]) begin
            gt1 = (A[0] & ~B[0]);
            lt1 = (~A[0] & B[0]);
        end
        else begin
            // Todos los bits son iguales
            eq1 = 1'b1;
        end
    end

    // ------------------------------------------------------------------------
    // Conectar resultados a LEDs
    // ------------------------------------------------------------------------
    //
    // Grupo 0: implementación "alto nivel"
    //   led[0] → eq0 (A == B)
    //   led[1] → gt0 (A >  B)
    //   led[2] → lt0 (A <  B)
    //
    // Grupo 1: implementación "bit a bit"
    //   led[3] → eq1
    //   led[4] → gt1
    //   led[5] → lt1
    //
    // led[7:6] → 0

    always_comb begin
        led[0] = eq0;
        led[1] = gt0;
        led[2] = lt0;

        led[3] = eq1;
        led[4] = gt1;
        led[5] = lt1;

        led[6] = 1'b0;
        led[7] = 1'b0;
    end

endmodule
