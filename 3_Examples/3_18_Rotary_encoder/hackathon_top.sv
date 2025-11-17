// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.18: Rotary encoder (KY-040) + TM1638 + LCD helper
//
// Este ejemplo usa un encoder rotatorio tipo KY-040 conectado a gpio[3:2]:
//   - gpio[3] = CLK (A)
//   - gpio[2] = DT  (B)
//
// El valor decodificado se muestra:
//   - En el display de 7 segmentos (TM1638) como número.
//   - Como “umbral” horizontal en la LCD: si x > value, se pinta azul.
//
// Los módulos auxiliares sync_and_debounce y rotary_encoder
// van en archivos separados (ver más abajo).

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // A dynamic seven-segment display

    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD screen interface

    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // Ky-040 pin marking:
    //
    // CLK - A
    // DT  - B

    wire a, b;

    sync_and_debounce # (.w (2))
    i_sync_and_debounce
    (
        .clk      ( clock      ),
        .reset    ( reset      ),
        .sw_in    ( gpio[3:2]  ),
        .sw_out   ( { b, a }   )
    );

    wire [15:0] value;

    rotary_encoder i_rotary_encoder
    (
        .clk      ( clock ),
        .reset    ( reset ),
        .a        ( a     ),
        .b        ( b     ),
        .value    ( value )
    );

    seven_segment_display
    # (.w_digit (8))
    i_7segment
    (
        .clk      ( clock       ),
        .rst      ( reset       ),
        .number   ( 32'(value)  ),
        .dots     ( '0          ),
        .abcdefgh ( abcdefgh    ),
        .digit    ( digit       )
    );

    // Opcional: usa los LEDs como debug del valor (8 LSB)
    assign led = value[7:0];

    // Exercise 1: Use rotary encoder to draw something on the screen

    // START_SOLUTION

    always_comb
    begin
        red   = 0;
        green = 0;
        blue  = 0;

        // Para todas las coordenadas con x > value, pinta azul.
        // A medida que giras el encoder, se mueve el "umbral" horizontal.
        if (x > value[8:0])
            blue = x[4:0];
    end

    // END_SOLUTION

    // Exercise 2: Conecta dos rotary encoders a distintos GPIO
    // y usa uno para X y otro para Y.

endmodule
