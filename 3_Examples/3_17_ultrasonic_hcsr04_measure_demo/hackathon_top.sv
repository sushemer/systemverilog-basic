// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.17: Ultrasonic distance – visualización en 7 segmentos, LEDs y LCD

module hackathon_top
(
    // Relojes y reset
    input  logic       clock,
    input  logic       slow_clock,   // no usado en este ejemplo
    input  logic       reset,

    // Teclas de la tarjeta (reservadas para ejercicios futuros)
    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (TM1638)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz de la LCD
    input  logic [8:0] x,            // 0..479
    input  logic [8:0] y,            // 0..271

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio          // gpio[0]=TRIG, gpio[1]=ECHO
);

    // --------------------------------------------------------------------
    // Parámetros de sistema y pantalla
    // --------------------------------------------------------------------
    localparam int unsigned CLK_HZ        = 27_000_000;
    localparam int unsigned SCREEN_WIDTH  = 480;
    localparam int unsigned SCREEN_HEIGHT = 272;

    // --------------------------------------------------------------------
    // Sensor ultrasónico: medida de distancia relativa
    // --------------------------------------------------------------------
    logic [15:0] distance;

    ultrasonic_distance_sensor #(
        .clk_frequency          (CLK_HZ),
        .relative_distance_width($bits(distance))
    ) i_sensor (
        .clk               (clock),
        .rst               (reset),
        .trig              (gpio[0]),
        .echo              (gpio[1]),
        .relative_distance (distance)
    );

    // --------------------------------------------------------------------
    // Visualización de la distancia
    // --------------------------------------------------------------------
    // 1) LEDs: 8 bits menos significativos (debug rápido)
    assign led = distance[7:0];

    // 2) Display de 7 segmentos: muestra la distancia en decimal/hex
    seven_segment_display #(
        .w_digit (8)   // 8 dígitos en el módulo de la tarjeta hackathon
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   ({16'd0, distance}),  // extender a 32 bits
        .dots     (8'b0000_0000),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // --------------------------------------------------------------------
    // Escalado de distancia a coordenada X en pantalla
    // --------------------------------------------------------------------
    // Se usa parte alta de "distance" para mapearla al rango 0..(SCREEN_WIDTH-1).
    // distance[15:7] son 9 bits → rango 0..511 aprox. Se satura a 479.

    logic [8:0] distance_x;  // 0..479

    always_comb begin
        if (distance[15:7] >= SCREEN_WIDTH[8:0])
            distance_x = SCREEN_WIDTH[8:0] - 1;  // 479
        else
            distance_x = distance[15:7];
    end

    // --------------------------------------------------------------------
    // Lógica de video: barra horizontal roja según la distancia
    // --------------------------------------------------------------------
    // Se dibuja:
    // - Fondo negro.
    // - Una barra roja desde x=0 hasta x=distance_x alrededor de la mitad de la pantalla.

    localparam int unsigned BAR_HEIGHT = 20;
    localparam int unsigned BAR_Y_MID  = SCREEN_HEIGHT / 2;

    always_comb begin
        // Fondo negro
        red   = 5'd0;
        green = 6'd0;
        blue  = 5'd0;

        // Barra roja horizontal centrada verticalmente
        if ( (x <= distance_x) &&
             (y >= (BAR_Y_MID - (BAR_HEIGHT/2))) &&
             (y <= (BAR_Y_MID + (BAR_HEIGHT/2))) ) begin
            red   = 5'd31;  // rojo máximo
            green = 6'd0;
            blue  = 5'd0;
        end
    end

endmodule
