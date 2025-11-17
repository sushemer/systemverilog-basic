// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.4 – Mini ALU de 4 bits (suma, resta y operaciones lógicas)
//
// Idea general:
//   - Dos operandos de 4 bits: A y B.
//   - Un selector de operación de 2 bits (op).
//   - Una pequeña ALU que hace, por ejemplo:
//       00: A + B
//       01: A - B
//       10: A & B
//       11: A ^ B
//   - Banderas sencillas:
//       * carry     → acarreo/borrow (en suma / resta)
//       * zero      → el resultado es 0
//   - Mostrar el resultado y banderas en los LEDs.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (no usado directamente aquí)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no usada en esta actividad)
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
    // gpio se maneja desde el wrapper de la placa

    // -------------------------------------------------------------------------
    // Entradas: operandos A y B, y selector de operación
    // -------------------------------------------------------------------------
    //
    // En la plantilla original se propone:
    //   - A = sw[3:0]
    //   - B = sw[7:4]
    //   - op = key[1:0]
    //
    // En esta solución mapeamos "sw" directamente a "key" para poder usar
    // las mismas teclas como si fueran switches:
    //
    //   A  = key[3:0]
    //   B  = key[7:4]
    //   op = key[1:0]   (selector de operación)
    //

    logic [7:0] sw;

    assign sw = key;   // alias simple para seguir la idea de la plantilla

    logic [3:0] A;
    logic [3:0] B;
    logic [1:0] op;

    assign A  = sw[3:0];
    assign B  = sw[7:4];
    assign op = key[1:0];

    // -------------------------------------------------------------------------
    // Mini ALU de 4 bits
    // -------------------------------------------------------------------------

    logic [3:0] result;
    logic       carry;
    logic       zero;

    // Vectores extendidos para capturar acarreo/borrow
    logic [4:0] sum_ext;
    logic [4:0] diff_ext;

    always_comb
    begin
        // Valores por defecto
        result  = 4'd0;
        carry   = 1'b0;
        zero    = 1'b0;
        sum_ext = 5'd0;
        diff_ext= 5'd0;

        case (op)
            2'b00: begin
                // Suma A + B
                sum_ext = {1'b0, A} + {1'b0, B};
                result  = sum_ext[3:0];
                carry   = sum_ext[4];  // acarreo de la suma
            end

            2'b01: begin
                // Resta A - B
                diff_ext = {1'b0, A} - {1'b0, B};
                result   = diff_ext[3:0];
                // Tratamos el bit extra como borrow/acarreo simplificado
                carry    = diff_ext[4];
            end

            2'b10: begin
                // Operación lógica: AND
                result = A & B;
                carry  = 1'b0;
            end

            2'b11: begin
                // Operación lógica: XOR
                result = A ^ B;
                carry  = 1'b0;
            end

            default: begin
                result = 4'd0;
                carry  = 1'b0;
            end
        endcase

        // Bandera zero: vale 1 cuando el resultado es 0
        zero = (result == 4'd0);
    end

    // -------------------------------------------------------------------------
    // Salida a LEDs
    // -------------------------------------------------------------------------
    //
    //   led[3:0] → result[3:0]  (resultado de la ALU)
    //   led[4]   → carry        (acarreo / borrow)
    //   led[5]   → zero         (1 cuando result == 0)
    //   led[7:6] → op[1:0]      (operación actual)
    //

    always_comb
    begin
        led = 8'b0000_0000;

        led[3:0] = result;
        led[4]   = carry;
        led[5]   = zero;
        led[7:6] = op;
    end

endmodule
