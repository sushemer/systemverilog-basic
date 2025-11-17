// File: 4_Activities/4_04_mini_alu_4bit/hackathon_top.sv
//
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
//       11: A ^ B   (o A | B, a elección)
//   - Banderas sencillas:
//       * carry     → acarreo (en suma / resta)
//       * zero      → el resultado es 0
//   - Mostrar el resultado y banderas en los LEDs.
//
// NOTA: Este archivo es una PLANTILLA de actividad.
//       Debes completar las secciones marcadas como TODO.
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
    // Mapeo sugerido:
    //   - A = sw[3:0]
    //   - B = sw[7:4]
    //   - op = key[1:0]
    //
    // Si tu wrapper de placa no expone "sw", puedes adaptar el mapeo usando
    // solo "key" (por ejemplo, A=key[3:0], B=key[7:4]) o el TM1638.

    logic [7:0] sw;   // Opcional: si el wrapper ya conecta switches reales

    // Si no tienes "sw" reales, puedes comentar lo de abajo y mapear A/B
    // directamente desde "key".
    //
    // assign sw = 8'h00;  // Placeholder si no hay switches

    logic [3:0] A;
    logic [3:0] B;
    logic [1:0] op;

    // TODO: adapta este mapeo a tu placa si es necesario.
    assign A  = sw[3:0];
    assign B  = sw[7:4];
    assign op = key[1:0];

    // -------------------------------------------------------------------------
    // Mini ALU de 4 bits
    // -------------------------------------------------------------------------

    logic [3:0] result;
    logic       carry;
    logic       zero;

    // Señales auxiliares sugeridas para suma / resta
    //
    // logic [4:0] sum_ext;
    // logic [4:0] diff_ext;

    always_comb
    begin
        // Valores por defecto
        result = 4'd0;
        carry  = 1'b0;
        zero   = 1'b0;

        // TODO: implementar la ALU
        //
        // Sugerencia:
        //
        // case (op)
        //   2'b00: begin
        //       // Suma A + B
        //       // - usar un vector de 5 bits para capturar el acarreo
        //       // - asignar result[3:0] y carry
        //   end
        //
        //   2'b01: begin
        //       // Resta A - B
        //       // - puedes tratar el bit extra como "borrow" o simplemente
        //       //   ignorarlo y usar result[3:0]
        //   end
        //
        //   2'b10: begin
        //       // Operación lógica: A & B
        //   end
        //
        //   2'b11: begin
        //       // Operación lógica: A ^ B  (o A | B si prefieres)
        //   end
        //
        //   default: begin
        //       // Mantener valores por defecto
        //   end
        // endcase
        //
        // Después del case, calcula la bandera zero a partir de "result":
        //   zero = (result == 4'd0);
    end

    // -------------------------------------------------------------------------
    // Salida a LEDs
    // -------------------------------------------------------------------------
    //
    // Propuesta de visualización:
    //
    //   led[3:0] → result[3:0]  (resultado de la ALU)
    //   led[4]   → carry        (acarreo / borrow simplificado)
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
