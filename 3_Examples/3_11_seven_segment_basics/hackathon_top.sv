// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.11: Seven segment basics
//
// Ideeas principales:
// - Usar 4 bits (key[3:0]) como valor hexadecimal (0–15).
// - Mostrar ese valor en UN solo dígito del display de 7 segmentos.
// - Encender/apagar el punto decimal (segmento h) con key[4].
// - Reflejar el valor en los LEDs para debug.
//
// Este ejemplo es la "versión mínima" para entender:
//   * Cómo se codifican los segmentos (a..g + punto h).
//   * Cómo activar un solo dígito del display.
//   * Cómo mapear un nibble (4 bits) a un carácter en 7 segmentos.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no se usa en este ejemplo
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (multiplexado)
    output logic [7:0] abcdefgh,     // a b c d e f g h (punto)
    output logic [7:0] digit,        // selección de dígito

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
    // Apagar periféricos que no usamos (LCD, GPIO)
    // ------------------------------------------------------------------------
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Entradas para el display:
    //   - value: dígito hexadecimal a mostrar (0–15)
    //   - dp   : control del punto decimal (segmento h)
    // ------------------------------------------------------------------------
    logic [3:0] value;
    logic       dp;

    // Usamos key[3:0] como valor hex y key[4] como control del punto
    assign value = key[3:0];
    assign dp    = key[4];

    // Mostrar el valor en los 4 LEDs menos significativos (debug)
    always_comb begin
        led        = 8'h00;
        led[3:0]   = value;
        led[4]     = dp;     // para ver el estado del punto decimal
    end

    // ------------------------------------------------------------------------
    // Decodificador HEX → 7 segmentos
    //
    // Convención de bits en abcdefgh:
    //   bit 7: a
    //   bit 6: b
    //   bit 5: c
    //   bit 4: d
    //   bit 3: e
    //   bit 2: f
    //   bit 1: g
    //   bit 0: h (punto)
    //
    // 1 = segmento encendido
    // 0 = segmento apagado
    // ------------------------------------------------------------------------
    function automatic logic [7:0] hex_to_7seg (input logic [3:0] v);
        //   --a--
        //  |     |
        //  f     b
        //  |     |
        //   --g--
        //  |     |
        //  e     c
        //  |     |
        //   --d--  h (punto)
        //
        // Nota: h (punto) se controlará aparte con 'dp'.
        begin
            unique case (v)
                4'h0: hex_to_7seg = 8'b1111_1100; // 0 → a,b,c,d,e,f
                4'h1: hex_to_7seg = 8'b0110_0000; // 1 → b,c
                4'h2: hex_to_7seg = 8'b1101_1010; // 2 → a,b,d,e,g
                4'h3: hex_to_7seg = 8'b1111_0010; // 3 → a,b,c,d,g
                4'h4: hex_to_7seg = 8'b0110_0110; // 4 → b,c,f,g
                4'h5: hex_to_7seg = 8'b1011_0110; // 5 → a,c,d,f,g
                4'h6: hex_to_7seg = 8'b1011_1110; // 6 → a,c,d,e,f,g
                4'h7: hex_to_7seg = 8'b1110_0000; // 7 → a,b,c
                4'h8: hex_to_7seg = 8'b1111_1110; // 8 → a,b,c,d,e,f,g
                4'h9: hex_to_7seg = 8'b1111_0110; // 9 → a,b,c,d,f,g
                4'hA: hex_to_7seg = 8'b1110_1110; // A → a,b,c,e,f,g
                4'hB: hex_to_7seg = 8'b0011_1110; // b → c,d,e,f,g
                4'hC: hex_to_7seg = 8'b1001_1100; // C → a,d,e,f
                4'hD: hex_to_7seg = 8'b0111_1010; // d → b,c,d,e,g
                4'hE: hex_to_7seg = 8'b1001_1110; // E → a,d,e,f,g
                4'hF: hex_to_7seg = 8'b1000_1110; // F → a,e,f,g
                default: hex_to_7seg = 8'b0000_0000; // todo apagado
            endcase
        end
    endfunction

    // ------------------------------------------------------------------------
    // Construir el patrón final de segmentos (incluyendo punto decimal)
    // ------------------------------------------------------------------------
    logic [7:0] segs_raw;
    logic [7:0] segs_with_dp;

    always_comb begin
        segs_raw      = hex_to_7seg(value);
        segs_with_dp  = segs_raw;
        segs_with_dp[0] = dp;  // sobrescribir bit h con el valor de dp
    end

    assign abcdefgh = segs_with_dp;

    // ------------------------------------------------------------------------
    // Activar solo un dígito del display
    //
    // Usaremos el dígito 0 (bit 0 de 'digit') como dígito activo.
    // Dependiendo del mapeo de la tarjeta, será el más a la derecha o a la izquierda,
    // pero para efectos de la práctica no es crítico.
    // ------------------------------------------------------------------------
    always_comb begin
        digit = 8'b0000_0001;  // one-hot: solo un dígito activo
    end

endmodule
