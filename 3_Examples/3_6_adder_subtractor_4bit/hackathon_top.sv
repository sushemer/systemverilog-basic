// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.6: Adder/Subtractor de 3 bits (A ± B) con dos implementaciones.
//
// Idea general:
// - Entradas (desde los botones KEY[7:0]):
//     A[2:0] = key[2:0]
//     B[2:0] = key[5:3]
//     mode   = key[7]   (0 = A + B, 1 = A - B)
// - Salidas (dos implementaciones):
//     Implementación 0 (alto nivel usando + y -)
//     Implementación 1 (único sumador usando complemento a dos)
//
// Mapeo a LEDs:
//   Implementación 0 (alto nivel):
//     led[0] = s0[0]  (bit 0 del resultado)
//     led[1] = s0[1]
//     led[2] = s0[2]
//     led[3] = c0     (carry/borrow flag)
//
//   Implementación 1 (2’s complement):
//     led[4] = s1[0]
//     led[5] = s1[1]
//     led[6] = s1[2]
//     led[7] = c1
//
// Donde:
//   - sX[2:0] = resultado de 3 bits (A ± B).
//   - cX      = bit extra (carry out / no-borrow) de 4 bits de resultado.
//
// Nota: al ser de 3 bits, A y B van de 0 a 7 (unsigned).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
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
    // Entradas del adder/subtractor
    // ------------------------------------------------------------------------
    //
    // A = key[2:0]
    // B = key[5:3]
    // mode = key[7]   (0 = suma, 1 = resta A - B)
    //
    // key[6] no se usa en este ejemplo.

    logic [2:0] A, B;
    logic       mode;

    assign A    = key[2:0];
    assign B    = key[5:3];
    assign mode = key[7];

    // ------------------------------------------------------------------------
    // Implementación 0: descripción de alto nivel (usa + y -)
    // ------------------------------------------------------------------------
    //
    // Cuando mode = 0: res0 = A + B
    // Cuando mode = 1: res0 = A - B
    //
    // Se trabaja con 4 bits para tener el bit extra de carry/borrow.

    logic [3:0] res0;   // [3] = carry/borrow, [2:0] = resultado

    always_comb begin
        if (mode == 1'b0) begin
            // Suma sin signo
            res0 = {1'b0, A} + {1'b0, B};
        end
        else begin
            // Resta sin signo: A - B
            // (La herramienta lo implementará con lógica combinacional adecuada)
            res0 = {1'b0, A} - {1'b0, B};
        end
    end

    logic [2:0] s0;
    logic       c0;

    assign s0 = res0[2:0];
    assign c0 = res0[3];

    // ------------------------------------------------------------------------
    // Implementación 1: adder-subtractor con complemento a dos
    // ------------------------------------------------------------------------
    //
    // Fórmula clásica de adder-subtractor:
    //
    //   res1 = A + (B XOR M) + M
    //
    // donde M = mode:
    //   - M = 0 → res1 = A + B
    //   - M = 1 → res1 = A + (~B) + 1 = A - B
    //
    // De nuevo usamos 4 bits para guardar el bit extra.

    wire  [2:0] B_xor = B ^ {3{mode}};  // Si mode=1, invierte B bit a bit
    logic [3:0] res1;

    assign res1 = {1'b0, A} + {1'b0, B_xor} + mode;

    logic [2:0] s1;
    logic       c1;

    assign s1 = res1[2:0];
    assign c1 = res1[3];

    // ------------------------------------------------------------------------
    // Salidas a LEDs
    // ------------------------------------------------------------------------
    //
    // Implementación 0 (alto nivel) en LEDs bajos:
    //   led[0] = s0[0]
    //   led[1] = s0[1]
    //   led[2] = s0[2]
    //   led[3] = c0
    //
    // Implementación 1 (complemento a dos) en LEDs altos:
    //   led[4] = s1[0]
    //   led[5] = s1[1]
    //   led[6] = s1[2]
    //   led[7] = c1

    always_comb begin
        led[0] = s0[0];
        led[1] = s0[1];
        led[2] = s0[2];
        led[3] = c0;

        led[4] = s1[0];
        led[5] = s1[1];
        led[6] = s1[2];
        led[7] = c1;
    end

endmodule
