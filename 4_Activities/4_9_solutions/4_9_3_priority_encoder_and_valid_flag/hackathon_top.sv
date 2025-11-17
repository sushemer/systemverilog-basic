// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Actividad 4.3 – Priority encoder 3→2 + bandera "valid"
//
// Idea general:
//   - Usar 3 líneas de petición (req[2:0]) tomadas de key[2:0].
//   - Implementar un "priority encoder":
//       * Si varias entradas están en 1 al mismo tiempo,
//         gana la de MAYOR índice (bit 2 tiene más prioridad que 1, que 0).
//   - Generar:
//       * idx[1:0] → código binario del índice activo.
//       * valid    → indica si hay alguna petición (algún req[i] = 1).
//   - Visualizar en LEDs:
//       * req, idx y valid.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (no usado en esta actividad)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no usada aquí)
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
    // Entradas: líneas de petición (requests)
    // -------------------------------------------------------------------------
    //
    //   req[0] = key[0]
    //   req[1] = key[1]
    //   req[2] = key[2]

    logic [2:0] req;

    assign req = key[2:0];

    // -------------------------------------------------------------------------
    // Priority encoder 3→2 con bandera "valid"
    // -------------------------------------------------------------------------

    logic [1:0] idx;
    logic       valid;

    always_comb
    begin
        // Valores por defecto (sin petición)
        idx   = 2'd0;
        valid = 1'b0;

        // Prioridad: req[2] > req[1] > req[0]
        if (req[2]) begin
            idx   = 2'd2;
            valid = 1'b1;
        end
        else if (req[1]) begin
            idx   = 2'd1;
            valid = 1'b1;
        end
        else if (req[0]) begin
            idx   = 2'd0;
            valid = 1'b1;
        end
        // else: se quedan los valores por defecto (idx=0, valid=0)
    end

    // -------------------------------------------------------------------------
    // Salida a LEDs
    // -------------------------------------------------------------------------
    //
    //   led[2:0] → req[2:0]   (peticiones activas)
    //   led[4:3] → idx[1:0]   (código seleccionado)
    //   led[7]   → valid      (hay al menos una petición)
    //   led[6:5] → libres

    always_comb
    begin
        led = 8'b0000_0000;

        led[2:0] = req;   // Ver qué peticiones están activas
        led[4:3] = idx;   // Índice seleccionado por el encoder
        led[7]   = valid; // Bandera de "al menos una petición"
    end

endmodule
