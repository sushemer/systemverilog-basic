// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.8: Shift register (registro de corrimiento) controlado por botón.
//
// Idea general:
// - Usar un contador para generar un pulso "enable" lento a partir del reloj rápido.
// - Tener un registro de corrimiento de 8 bits (uno por LED).
// - En cada pulso "enable", el registro se corre y entra un nuevo bit
//   dado por el estado de los botones.
//
// Resultado:
// - Los LEDs muestran un patrón que se desplaza.
// - Si se mantiene un botón presionado, se van “inyectando” unos desde un extremo.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // no se usa en este ejemplo
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Display 7 segmentos (no usado aquí)
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
    // Apagar periféricos que no usamos
    // ------------------------------------------------------------------------
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Divisor de frecuencia: contador de 32 bits
    //
    // Usamos el reloj rápido de la FPGA y contamos.
    // Cuando los 23 bits menos significativos son 0, generamos un "enable"
    // (aprox. unos pocos Hz con reloj ~27–50 MHz).
    // ------------------------------------------------------------------------

    logic [31:0] cnt;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            cnt <= '0;
        else
            cnt <= cnt + 32'd1;
    end

    // Pulso de habilitación lento
    wire enable = (cnt[22:0] == '0);

    // ------------------------------------------------------------------------
    // Registro de corrimiento
    //
    // - button_on = 1 si cualquier tecla está presionada.
    // - shift_reg[7:0] se desplaza a la derecha en cada "enable".
    // - El bit que entra por la izquierda es button_on.
    //
    // Dirección del corrimiento:
    //   shift_reg <= { button_on, shift_reg[7:1] };
    //   - shift_reg[7] recibe button_on
    //   - shift_reg[6] recibe viejo shift_reg[7], etc.
    // ------------------------------------------------------------------------

    wire button_on = |key;          // 1 si al menos una tecla está activa

    logic [7:0] shift_reg;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            // Iniciar con todos los LEDs encendidos (puedes cambiar a '0 si prefieres vacío)
            shift_reg <= 8'hFF;
        else if (enable)
            // Corrimiento hacia la derecha, inyectando button_on por el bit más significativo
            shift_reg <= { button_on, shift_reg[7:1] };
    end

    // Mostrar el contenido del registro en los LEDs
    assign led = shift_reg;


endmodule
