// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.x: Priority encoder 3→2 con varias implementaciones.
//
// Idea general:
// - Entradas: in[2:0] vienen de key[2:0].
// - Si varias entradas están en '1', se elige la de **mayor prioridad**.
// - En este ejemplo la prioridad es: bit 0 > bit 1 > bit 2
//   (es decir, el bit 0 es el de mayor prioridad).
//
// Implementaciones internas:
//   enc0: cadena de if / else if
//   enc1: casez con patrones "don't care"
//   enc2: separación en "árbitro de prioridad" + encoder normal
//   enc3: recorrido con for-loop
//
// Salida visible:
//   led[7:6] = enc0
//   led[5:4] = enc1
//   led[3:2] = enc2
//   led[1:0] = enc3

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
    // Entradas del priority encoder (3 bits)
    // ------------------------------------------------------------------------
    //
    // in[0] = bit de mayor prioridad
    // in[2] = bit de menor prioridad
    //
    // Si varias entradas están en 1 al mismo tiempo:
    //   - se elige primero in[0]
    //   - luego in[1]
    //   - luego in[2]

    logic [2:0] in;
    assign in = key[2:0];

    // ------------------------------------------------------------------------
    // Implementación 1: cadena de if / else if
    // ------------------------------------------------------------------------
    //
    // Regla:
    //   - Si in[0] = 1 → código 0
    //   - Si in[0] = 0 y in[1] = 1 → código 1
    //   - Si in[0] = 0, in[1] = 0 y in[2] = 1 → código 2
    //   - Si todo es 0 → por convención regresamos 0

    logic [1:0] enc0;

    always_comb begin
        if      (in[0]) enc0 = 2'd0;
        else if (in[1]) enc0 = 2'd1;
        else if (in[2]) enc0 = 2'd2;
        else            enc0 = 2'd0;
    end

    // ------------------------------------------------------------------------
    // Implementación 2: casez con prioridades
    // ------------------------------------------------------------------------
    //
    // Se exploran patrones de in[2:0] de más genérico a más específico:
    //
    //   3'b??1 → hay un 1 en bit 0, gana prioridad 0
    //   3'b?10 → si no se cumplió lo anterior y hay '10x', gana prioridad 1
    //   3'b100 → si sólo bit 2 está en 1, gana prioridad 2
    //   default → sin entradas activas, devolvemos 0

    logic [1:0] enc1;

    always_comb begin
        casez (in)
            3'b??1:  enc1 = 2'd0;
            3'b?10:  enc1 = 2'd1;
            3'b100:  enc1 = 2'd2;
            default: enc1 = 2'd0;
        endcase
    end

    // ------------------------------------------------------------------------
    // Implementación 3:
    //   Separar "árbitro de prioridad" y "encoder normal"
    // ------------------------------------------------------------------------
    //
    // Paso 1: generar un vector one-hot "g" donde solo un bit es 1,
    //         aplicando prioridad (bit 0 > 1 > 2).
    //
    // Paso 2: aplicar un encoder sin prioridad sobre "g".

    logic [2:0] g;
    logic [1:0] enc2;

    // Árbitro de prioridad: genera g (one-hot)
    always_comb begin
        g = 3'b000;
        if      (in[0]) g = 3'b001;  // prioridad más alta
        else if (in[1]) g = 3'b010;
        else if (in[2]) g = 3'b100;
        // Si no hay bits en 1, g se queda en 000
    end

    // Encoder normal sobre g (que ya es one-hot)
    always_comb begin
        unique case (g)
            3'b001:  enc2 = 2'd0;
            3'b010:  enc2 = 2'd1;
            3'b100:  enc2 = 2'd2;
            default: enc2 = 2'd0;   // sin entradas activas
        endcase
    end

    // ------------------------------------------------------------------------
    // Implementación 4: for-loop
    // ------------------------------------------------------------------------
    //
    // Se recorre el vector de entrada usando un for:
    //   - Se inicializa enc3 en 0.
    //   - Se recorre desde el bit de MENOR prioridad (2) hacia el de MAYOR (0).
    //   - Cada vez que se encuentra un '1', se actualiza enc3 con el índice.
    //   - Como el último índice visitado es 0, si está en 1, termina siendo
    //     el que domina (bit 0 tiene más prioridad).

    logic [1:0] enc3;

    always_comb begin
        enc3 = 2'd0;

        // $bits(in) vale 3 → índices 0, 1, 2
        for (int i = $bits(in)-1; i >= 0; i--) begin
            if (in[i]) begin
                enc3 = i[1:0];
            end
        end
    end

    // ------------------------------------------------------------------------
    // Empaquetar todas las versiones en los LEDs
    // ------------------------------------------------------------------------
    //
    // Concatenación:
    //   led = { enc0, enc1, enc2, enc3 };
    //
    // Mapeo:
    //   led[7:6] → enc0 (if/else)
    //   led[5:4] → enc1 (casez)
    //   led[3:2] → enc2 (árbitro + encoder)
    //   led[1:0] → enc3 (for-loop)

    assign led = { enc0, enc1, enc2, enc3 };

endmodule
