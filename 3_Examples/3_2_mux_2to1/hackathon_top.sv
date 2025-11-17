// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Ejemplo 3.2: Multiplexor 2:1 implementado de varias maneras.
//
// - Se usan tres bits de key:
//      key[0] = d0   (dato 0)
//      key[1] = d1   (dato 1)
//      key[7] = sel  (selector)
// - Se muestran las entradas y las salidas en los LEDs:
//      led[0] = d0
//      led[1] = d1
//      led[2] = sel
//      led[3] = y_if     (implementación con if/else)
//      led[4] = y_tern   (implementación con operador ? :)
//      led[5] = y_case   (implementación con case)
//      led[6] = y_gate   (implementación con compuertas)
//      led[7] = 0
//
// Si todo está bien, led[3], led[4], led[5] y led[6] SIEMPRE deben
// mostrar el mismo valor para cualquier combinación de d0, d1 y sel.

module hackathon_top
(
    // Interfaz estándar que espera board_specific_top
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (no se usa aquí)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz de la pantalla LCD (no se usa aquí)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO genéricos (no se usan aquí)
    inout  logic [3:0] gpio
);

    // ------------------------------------------------------------------------
    // Amarrar todo lo que NO usamos a valores conocidos
    // ------------------------------------------------------------------------

    // Display de 7 segmentos apagado
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    // Pantalla LCD en negro
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    // GPIO en alta impedancia (no los manejamos)
    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Señales de entrada para el multiplexor
    // ------------------------------------------------------------------------

    logic d0, d1, sel;

    assign d0  = key[0];  // dato 0
    assign d1  = key[1];  // dato 1
    assign sel = key[7];  // selector

    // ------------------------------------------------------------------------
    // Cuatro implementaciones del mismo mux 2:1
    // ------------------------------------------------------------------------

    logic y_if;
    logic y_tern;
    logic y_case;
    logic y_gate;

    // 1) Implementación con always_comb e if/else
    always_comb begin
        if (sel)
            y_if = d1;
        else
            y_if = d0;
    end

    // 2) Implementación con operador condicional ? :
    assign y_tern = sel ? d1 : d0;

    // 3) Implementación con case
    always_comb begin
        case (sel)
            1'b0: y_case = d0;
            1'b1: y_case = d1;
            // no se usan otros valores, pero podrían agregarse como default
        endcase
    end

    // 4) Implementación solo con compuertas lógicas
    //    y = (d1 & sel) | (d0 & ~sel)
    assign y_gate = (d1 & sel) | (d0 & ~sel);

    // ------------------------------------------------------------------------
    // Mostrar entradas y salidas en los LEDs
    // ------------------------------------------------------------------------

    assign led[0] = d0;
    assign led[1] = d1;
    assign led[2] = sel;

    assign led[3] = y_if;
    assign led[4] = y_tern;
    assign led[5] = y_case;
    assign led[6] = y_gate;

    assign led[7] = 1'b0;

endmodule
