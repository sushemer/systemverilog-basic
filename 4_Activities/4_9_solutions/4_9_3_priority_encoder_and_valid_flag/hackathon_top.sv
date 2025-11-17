// File: 4_Activities/4_03_priority_encoder_and_valid_flag/hackathon_top.sv
//
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
    // Mapeo sugerido:
    //   req[0] = key[0]
    //   req[1] = key[1]
    //   req[2] = key[2]
    //
    // Cada bit representa una “fuente” que pide servicio.
    // Si varias están en 1 al mismo tiempo, el encoder debe elegir la de mayor
    // prioridad:  req[2] > req[1] > req[0].

    logic [2:0] req;

    assign req = key[2:0];

    // -------------------------------------------------------------------------
    // Priority encoder 3→2 con bandera "valid"
    // -------------------------------------------------------------------------
    //
    // Requerimientos:
    //   - idx[1:0] indica cuál línea fue seleccionada:
    //
    //       req = 3'b001 → idx = 2'd0, valid = 1
    //       req = 3'b010 → idx = 2'd1, valid = 1
    //       req = 3'b100 → idx = 2'd2, valid = 1
    //
    //   - Si hay varias peticiones al mismo tiempo, gana la de MAYOR índice:
    //
    //       req = 3'b011 → idx = 2'd1, valid = 1   (gana bit 1 sobre 0)
    //       req = 3'b110 → idx = 2'd2, valid = 1   (gana bit 2 sobre 1)
    //       req = 3'b111 → idx = 2'd2, valid = 1   (gana bit 2)
    //
    //   - Si no hay peticiones (req = 0), entonces:
    //
    //       idx = 2'd0  (valor por defecto)
    //       valid = 0
    //
    // Implementación sugerida:
    //   - usar always_comb
    //   - usar cadena de if/else para expresar prioridad explícita.

    logic [1:0] idx;
    logic       valid;

    always_comb
    begin
        // Valores por defecto (sin petición)
        idx   = 2'd0;
        valid = 1'b0;

        // TODO: implementar la lógica de prioridad
        //
        // Pista:
        //   Primero pregunta por req[2],
        //   luego por req[1],
        //   luego por req[0].
        //
        // Ejemplo orientativo de estructura (no es la solución final):
        //
        // if (req[2])
        // begin
        //     idx   = 2'd2;
        //     valid = 1'b1;
        // end
        // else if (req[1])
        // begin
        //     idx   = 2'd1;
        //     valid = 1'b1;
        // end
        // else if (req[0])
        // begin
        //     idx   = 2'd0;
        //     valid = 1'b1;
        // end
        // else
        // begin
        //     // ya están puestos los valores por defecto
        // end
    end

    // -------------------------------------------------------------------------
    // Salida a LEDs
    // -------------------------------------------------------------------------
    //
    // Propuesta de visualización:
    //
    //   led[2:0] → req[2:0]   (peticiones activas)
    //   led[4:3] → idx[1:0]   (código seleccionado)
    //   led[7]   → valid      (hay al menos una petición)
    //
    //   led[6:5] → libres (para extensiones)
    //

    always_comb
    begin
        led = 8'b0000_0000;

        led[2:0] = req;   // Ver qué peticiones están activas
        led[4:3] = idx;   // Índice seleccionado por el encoder
        led[7]   = valid; // Bandera de "al menos una petición"
    end

endmodule
