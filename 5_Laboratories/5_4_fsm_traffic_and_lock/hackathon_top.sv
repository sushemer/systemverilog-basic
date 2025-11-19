// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.4 – FSM: traffic light + sequence lock
//
// Idea general:
//   - Dos máquinas de estados en el mismo diseño:
//       1) Semáforo simple (R → G → Y → R) con tiempos configurables.
//       2) Cerradura por secuencia de botones (A-B-A-B) que enciende un LED.
//
//   - Estados del semáforo avanzan con slow_clock (~1 Hz).
//   - La cerradura detecta flancos en dos teclas key[4] ("A") y key[5] ("B").
//   - LEDs:
//       led[2] = rojo
//       led[1] = amarillo
//       led[0] = verde
//       led[7] = lock (secuencia correcta)
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display de 7 segmentos (no usado en este lab)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // Interfaz LCD (no usada en este lab)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // No usamos 7 segmentos, LCD ni GPIO en este lab.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio lo controla el wrapper de la placa.

    // =========================================================================
    // 1) FSM de semáforo (traffic light)
    // =========================================================================

    // Estados del semáforo
    typedef enum logic [1:0]
    {
        TRAFFIC_RED    = 2'd0,
        TRAFFIC_GREEN  = 2'd1,
        TRAFFIC_YELLOW = 2'd2
    } traffic_state_t;

    traffic_state_t traffic_state;

    // Tiempos (en ticks de slow_clock)
    localparam int T_RED    = 3;  // ~3 s (si slow_clock ~1 Hz)
    localparam int T_GREEN  = 3;  // ~3 s
    localparam int T_YELLOW = 1;  // ~1 s

    logic [3:0] traffic_timer;  // suficiente para contar hasta 7

    // FSM + temporización usando slow_clock
    always_ff @(posedge slow_clock or posedge reset)
        if (reset)
        begin
            traffic_state  <= TRAFFIC_RED;
            traffic_timer  <= 4'd0;
        end
        else
        begin
            unique case (traffic_state)
                TRAFFIC_RED:
                begin
                    if (traffic_timer == T_RED - 1)
                    begin
                        traffic_state <= TRAFFIC_GREEN;
                        traffic_timer <= 4'd0;
                    end
                    else
                        traffic_timer <= traffic_timer + 4'd1;
                end

                TRAFFIC_GREEN:
                begin
                    if (traffic_timer == T_GREEN - 1)
                    begin
                        traffic_state <= TRAFFIC_YELLOW;
                        traffic_timer <= 4'd0;
                    end
                    else
                        traffic_timer <= traffic_timer + 4'd1;
                end

                TRAFFIC_YELLOW:
                begin
                    if (traffic_timer == T_YELLOW - 1)
                    begin
                        traffic_state <= TRAFFIC_RED;
                        traffic_timer <= 4'd0;
                    end
                    else
                        traffic_timer <= traffic_timer + 4'd1;
                end

                default:
                begin
                    traffic_state <= TRAFFIC_RED;
                    traffic_timer <= 4'd0;
                end
            endcase
        end

    // Salidas del semáforo
    logic red_on;
    logic yellow_on;
    logic green_on;

    always_comb
    begin
        red_on    = 1'b0;
        yellow_on = 1'b0;
        green_on  = 1'b0;

        unique case (traffic_state)
            TRAFFIC_RED:
                red_on = 1'b1;

            TRAFFIC_GREEN:
                green_on = 1'b1;

            TRAFFIC_YELLOW:
                yellow_on = 1'b1;

            default: ; // nada
        endcase
    end

    // =========================================================================
    // 2) FSM de cerradura por secuencia A-B-A-B
    // =========================================================================

    // Mapeo de botones
    //   key[4] -> botón A
    //   key[5] -> botón B
    logic btnA;
    logic btnB;

    assign btnA = key[4];
    assign btnB = key[5];

    // Registros para detección de flancos (edge detect) en el dominio slow_clock
    logic btnA_q;
    logic btnB_q;

    always_ff @(posedge slow_clock or posedge reset)
        if (reset)
        begin
            btnA_q <= 1'b0;
            btnB_q <= 1'b0;
        end
        else
        begin
            btnA_q <= btnA;
            btnB_q <= btnB;
        end

    wire pulseA = btnA & ~btnA_q;  // flanco de subida en A
    wire pulseB = btnB & ~btnB_q;  // flanco de subida en B

    // Estados de la cerradura
    typedef enum logic [2:0]
    {
        LOCK_IDLE      = 3'd0, // esperando primer A
        LOCK_A1        = 3'd1, // se vio A
        LOCK_A1B2      = 3'd2, // se vio A,B
        LOCK_A1B2A3    = 3'd3, // se vio A,B,A
        LOCK_OPEN      = 3'd4  // secuencia A,B,A,B completa
    } lock_state_t;

    lock_state_t lock_state;

    always_ff @(posedge slow_clock or posedge reset)
        if (reset)
        begin
            lock_state <= LOCK_IDLE;
        end
        else
        begin
            unique case (lock_state)
                // Espera A
                LOCK_IDLE:
                begin
                    if (pulseA)
                        lock_state <= LOCK_A1;
                    else if (pulseB)
                        lock_state <= LOCK_IDLE; // error → queda en idle
                end

                // Se recibió A, ahora se espera B
                LOCK_A1:
                begin
                    if (pulseB)
                        lock_state <= LOCK_A1B2;
                    else if (pulseA)
                        lock_state <= LOCK_IDLE; // error → reset
                end

                // Se recibió A,B; ahora se espera A
                LOCK_A1B2:
                begin
                    if (pulseA)
                        lock_state <= LOCK_A1B2A3;
                    else if (pulseB)
                        lock_state <= LOCK_IDLE; // error → reset
                end

                // Se recibió A,B,A; ahora se espera B final
                LOCK_A1B2A3:
                begin
                    if (pulseB)
                        lock_state <= LOCK_OPEN;
                    else if (pulseA)
                        lock_state <= LOCK_IDLE; // error → reset
                end

                // Cerradura abierta (LED de lock encendido hasta reset)
                LOCK_OPEN:
                begin
                    lock_state <= LOCK_OPEN;
                end

                default:
                    lock_state <= LOCK_IDLE;
            endcase
        end

    // LED de lock encendido sólo en estado LOCK_OPEN
    logic lock_led;
    assign lock_led = (lock_state == LOCK_OPEN);

    // =========================================================================
    // 3) Mapeo final a LEDs
    // =========================================================================

    always_comb
    begin
        led = 8'b0000_0000;

        // Semáforo
        led[0] = green_on;   // verde
        led[1] = yellow_on;  // amarillo
        led[2] = red_on;     // rojo

        // Cerradura
        led[7] = lock_led;


        // Por simplicidad se dejan en 0.
    end

endmodule
