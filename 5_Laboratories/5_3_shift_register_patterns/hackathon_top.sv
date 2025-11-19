// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.3 – Shift register patterns (KITT / running lights / rotations)
//
// Idea:
//   - Use a frequency divider to generate a slow "tick".
//   - Maintain an 8-bit register that defines the LED pattern.
//   - Change the pattern behavior depending on key[1:0]:
//       00: circular left rotation
//       01: circular right rotation
//       10: KITT (ping-pong)
//       11: LEDs off (reserved for experiments)
//
//   - led[7:0] directly show the content of the shift register.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used here)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used in this lab)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:5] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // We do not use LCD, 7-segment display nor GPIO in this lab.
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;
    // gpio is handled by the board wrapper.

    // -------------------------------------------------------------------------
    // 1) Frequency divider to generate step_en (slow tick)
    // -------------------------------------------------------------------------
    //
    // With ~27 MHz, W_DIV = 22 gives a few steps per second (visible to the eye).

    localparam int W_DIV = 22;

    logic [W_DIV-1:0] div_cnt;
    logic             step_en;

    always_ff @(posedge clock or posedge reset)
        if (reset)
            div_cnt <= '0;
        else
            div_cnt <= div_cnt + 1'b1;

    assign step_en = (div_cnt == '0);

    // -------------------------------------------------------------------------
    // 2) Shift register + mode
    // -------------------------------------------------------------------------

    // Animation mode:
    //   key[1:0] = mode
    logic [1:0] mode;
    assign mode = key[1:0];

    // Register shown on the LEDs
    logic [7:0] pattern_reg;

    // Direction for KITT (ping-pong):
    //   0 → moving left (toward led[7])
    //   1 → moving right (toward led[0])
    logic dir_kitt;

    // Initialization and pattern update
    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            pattern_reg <= 8'b0000_0001; // start at LED 0
            dir_kitt    <= 1'b0;         // initial direction: left
        end
        else if (step_en)
        begin
            unique case (mode)
                // -------------------------------------------------------------
                // Mode 0: circular left rotation
                // -------------------------------------------------------------
                2'b00:
                begin
                    // MSB goes back to bit 0
                    pattern_reg <= { pattern_reg[6:0], pattern_reg[7] };
                end

                // -------------------------------------------------------------
                // Mode 1: circular right rotation
                // -------------------------------------------------------------
                2'b01:
                begin
                    // bit 0 goes to MSB
                    pattern_reg <= { pattern_reg[0], pattern_reg[7:1] };
                end

                // -------------------------------------------------------------
                // Mode 2: KITT / ping-pong
                // -------------------------------------------------------------
                2'b10:
                begin
                    // When reaching the left edge, change direction
                    if (!dir_kitt) // moving left
                    begin
                        if (pattern_reg == 8'b1000_0000)
                        begin
                            dir_kitt    <= 1'b1;           // change to right
                            pattern_reg <= 8'b0100_0000;    // one step inward
                        end
                        else
                            pattern_reg <= pattern_reg << 1;
                    end
                    else // dir_kitt == 1 → moving right
                    begin
                        if (pattern_reg == 8'b0000_0001)
                        begin
                            dir_kitt    <= 1'b0;           // change to left
                            pattern_reg <= 8'b0000_0010;    // one step inward
                        end
                        else
                            pattern_reg <= pattern_reg >> 1;
                    end
                end

                // -------------------------------------------------------------
                // Mode 3: all off (space to experiment)
                // -------------------------------------------------------------
                default:
                begin
                    pattern_reg <= 8'b0000_0000;
                end
            endcase
        end

    // -------------------------------------------------------------------------
    // 3) LED output
    // -------------------------------------------------------------------------

    assign led = pattern_reg;

endmodule
