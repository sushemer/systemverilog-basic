// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.3: Decoder 2→4 con cuatro implementaciones internas.
//
// - Entradas (desde key):
//     key[1] = in[1]
//     key[0] = in[0]
// - Salidas visibles:
//     led[1:0] = in (para ver el valor binario)
//     led[5:2] = dec3 (salida del decoder "canónico")
//     led[7:6] = 0
//
// Internamente se implementan 4 versiones de un decoder 2→4:
//
//   dec0: implementación "tediosa" con AND y NOT
//   dec1: implementación con case
//   dec2: implementación con desplazamiento (shift)
//   dec3: implementación con índice (dec3[in] = 1)
//
// En hardware solo se conecta dec3 a los LEDs, pero las otras
// implementaciones se pueden revisar por simulación.

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
    // Apagar todo lo que no usamos
    // ------------------------------------------------------------------------
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Entradas del decoder 2→4
    // ------------------------------------------------------------------------
    // Usamos dos bits de key como entrada binaria "in[1:0]"
    logic [1:0] in;
    assign in = { key[1], key[0] };

    // ------------------------------------------------------------------------
    // Implementación 1: "tediosa" con AND/NOT
    // ------------------------------------------------------------------------
    wire [3:0] dec0;

    assign dec0[0] = ~in[1] & ~in[0];
    assign dec0[1] = ~in[1] &  in[0];
    assign dec0[2] =  in[1] & ~in[0];
    assign dec0[3] =  in[1] &  in[0];

    // ------------------------------------------------------------------------
    // Implementación 2: case
    // ------------------------------------------------------------------------
    logic [3:0] dec1;

    always_comb begin
        case (in)
            2'b00: dec1 = 4'b0001;
            2'b01: dec1 = 4'b0010;
            2'b10: dec1 = 4'b0100;
            2'b11: dec1 = 4'b1000;
            // no se usa default porque todas las combinaciones están cubiertas
        endcase
    end

    // ------------------------------------------------------------------------
    // Implementación 3: desplazamiento (shift)
    // ------------------------------------------------------------------------
    wire [3:0] dec2 = 4'b0001 << in;

    // ------------------------------------------------------------------------
    // Implementación 4: indexado
    // ------------------------------------------------------------------------
    logic [3:0] dec3;

    always_comb begin
        dec3 = '0;         // primero todo en 0
        dec3[in] = 1'b1;   // solo la posición "in" se pone en 1
    end

    // ------------------------------------------------------------------------
    // Mostrar algo útil en los LEDs
    // ------------------------------------------------------------------------
    // led[1:0]  = valor de entrada (in)
    // led[5:2]  = salida del decoder "dec3" (one-hot)
    // led[7:6]  = 0

    assign led[1:0] = in;
    assign led[5:2] = dec3[3:0];
    assign led[7:6] = 2'b00;

endmodule
