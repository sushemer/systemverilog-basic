// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.9: Seven-segment letters (FPGA)
//
// Idea general:
// - Usar un registro de corrimiento "one-hot" para ir activando cada dígito del
//   display de 7 segmentos.
// - Según qué dígito está activo, se selecciona la letra a mostrar: F, P, G, A.
// - Con un "enable" suficientemente rápido, el ojo humano ve la palabra "FPGA"
//   sólida, sin parpadeo perceptible (multiplexeo por persistencia de la visión).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no se usa en este ejemplo
    input  logic       reset,

    input  logic [7:0] key,          // no se usan en la versión básica
    output logic [7:0] led,          // se usan como debug del shift_reg

    // Display de 7 segmentos (multiplexado)
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
    // Apagar periféricos que no usamos (LCD, GPIO)
    // ------------------------------------------------------------------------
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Divisor de frecuencia para el multiplexeo
    //
    // Usamos un contador grande y generamos un "enable" lento comparado con el
    // reloj, pero lo suficientemente rápido para que el ojo vea una palabra sólida.
    // ------------------------------------------------------------------------

    logic [31:0] cnt;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            cnt <= '0;
        else
            cnt <= cnt + 32'd1;
    end

    // Pulso de habilitación cuando los 23 bits menos significativos valen 0.
    // Ajusta este valor si quieres más o menos frecuencia de refresco.
    wire enable = (cnt[22:0] == '0);

    // ------------------------------------------------------------------------
    // Registro de corrimiento "one-hot" para seleccionar dígito activo
    //
    // Usaremos 4 dígitos para mostrar "F P G A".
    // El registro se recorre en un loop: 0001 -> 0010 -> 0100 -> 1000 -> 0001...
    // ------------------------------------------------------------------------

    localparam int N_DIGITS = 4;

    logic [N_DIGITS-1:0] shift_reg;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            // Empezamos activando el dígito 0 (LSB)
            shift_reg <= 4'b0001;
        else if (enable)
            // Rotación circular hacia la izquierda:
            // bit 0 sale y reentra como bit más significativo.
            shift_reg <= { shift_reg[0], shift_reg[N_DIGITS-1:1] };
    end

    // ------------------------------------------------------------------------
    // Codificación de letras en 7 segmentos
    //
    // a,b,c,d,e,f,g,h se mapean a bits [7:0] de "abcdefgh".
    // Usamos un typedef enum para dar nombres legibles a los patrones.
    //
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h (punto)
    // ------------------------------------------------------------------------

    typedef enum bit [7:0]
    {
        F     = 8'b1000_1110,  // Forma de 'F' en 7 segmentos
        P     = 8'b1100_1110,  // 'P'
        G     = 8'b1011_1100,  // 'G'
        A     = 8'b1110_1110,  // 'A'
        space = 8'b0000_0000   // todo apagado
    } seven_seg_encoding_e;

    seven_seg_encoding_e letter;

    // Seleccionamos cuál letra mostrar en función del dígito activo.
    // shift_reg tiene un "1" en la posición del dígito encendido.
    always_comb begin
        unique case (shift_reg)
            4'b1000: letter = F;     // dígito 3 → F
            4'b0100: letter = P;     // dígito 2 → P
            4'b0010: letter = G;     // dígito 1 → G
            4'b0001: letter = A;     // dígito 0 → A
            default: letter = space; // por seguridad (no debería ocurrir)
        endcase
    end

    // Asignamos la codificación de segmentos
    assign abcdefgh = letter;

    // Mapeo del registro one-hot a las salidas de dígitos.
    // La placa tiene 8 dígitos; usamos sólo los 4 menos significativos.
    assign digit = { 4'b0000, shift_reg };

    // Opcional: mostrar también el patrón de dígitos en los LEDs como debug.
    assign led = { 4'b0000, shift_reg };

endmodule
