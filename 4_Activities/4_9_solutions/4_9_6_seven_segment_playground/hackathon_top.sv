// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
/*
Activity 4.6 – Seven-segment display playground

Modes:
  mode = key[1:0]

  00 → Free hexadecimal counter across all 8 digits
  01 → Manual playground (key[7:4] shown on digit 0)
  10 → “Bar” / digit 0xF scrolling across the 8 digits
  11 → Fixed pattern 0xDEAD_BEEF
*/

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // Seven-segment display (TM1638 / dynamic)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used in this activity)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // LCD and GPIO not used in this activity.
    assign red   = '0;
    assign green = '0;
    assign blue  = '0;
    // gpio is handled by the board wrapper.

    // -------------------------------------------------------------------------
    // Mode (to know which effect is active)
    // -------------------------------------------------------------------------

    logic [1:0] mode;
    assign mode = key[1:0];

    // Show mode on LEDs [1:0] only as indication
    assign led = { 6'b0, mode };

    // -------------------------------------------------------------------------
    // Frequency divider for slow animations
    // -------------------------------------------------------------------------
    //
    // Generates a slow tick from the main clock (~27 MHz).
    // Each time tick=1, we update the display contents.

    localparam int W_DIV = 22;  // Adjust to change animation speed
    logic [W_DIV-1:0] div_cnt;
    logic             tick;

    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            div_cnt <= '0;
            tick    <= 1'b0;
        end
        else
        begin
            div_cnt <= div_cnt + 1'b1;
            tick    <= (div_cnt == '0);
        end

    // -------------------------------------------------------------------------
    // Number and decimal dots for the seven-segment display
    // -------------------------------------------------------------------------
    //
    // The seven_segment_display module interprets `number` as:
    //   - 4 bits per digit (nibble), total w_digit * 4 bits.
    //   - w_digit = 8 → number[31:0] = { D7, D6, D5, D4, D3, D2, D1, D0 }
    //       D0 = number[ 3: 0]
    //       D1 = number[ 7: 4]
    //       ...
    //       D7 = number[31:28]
    //
    // Each nibble is a hexadecimal digit (0–F).

    localparam int W_DIGITS = 8;
    localparam int W_NUM    = W_DIGITS * 4;  // 32 bits

    logic [W_NUM-1:0]    number_reg;  // Display content (8 digits)
    logic [W_DIGITS-1:0] dots_reg;    // Decimal dots (one per digit)

    // Scroll index for scroll animations
    logic [2:0] scroll_pos;

    // -------------------------------------------------------------------------
    // Main playground logic
    // -------------------------------------------------------------------------

    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            number_reg <= '0;
            dots_reg   <= '0;
            scroll_pos <= '0;
        end
        else
        begin
            // Use key[7:0] as mask for decimal dots:
            //   dots_reg[i] = 1 → enable decimal point of digit i.
            dots_reg <= key;

            if (tick)
            begin
                // Small scroll counter for scroll modes
                scroll_pos <= scroll_pos + 3'd1;

                unique case (mode)

                    // ---------------------------------------------------------
                    // Mode 0: Free-running hexadecimal counter
                    // ---------------------------------------------------------
                    2'b00:
                    begin
                        number_reg <= number_reg + 32'd1;
                    end

                    // ---------------------------------------------------------
                    // Mode 1: Manual playground
                    // ---------------------------------------------------------
                    // D0 (nibble [3:0]) = key[7:4]
                    // The rest of the digits remain unchanged.
                    2'b01:
                    begin
                        number_reg[3:0] <= key[7:4];
                    end

                    // ---------------------------------------------------------
                    // Mode 2: “Bar” / 0xF digit scanning through 8 digits
                    // ---------------------------------------------------------
                    2'b10:
                    begin
                        number_reg <= '0;

                        unique case (scroll_pos)
                            3'd0: number_reg[ 3: 0] <= 4'hF;  // D0
                            3'd1: number_reg[ 7: 4] <= 4'hF;  // D1
                            3'd2: number_reg[11: 8] <= 4'hF;  // D2
                            3'd3: number_reg[15:12] <= 4'hF;  // D3
                            3'd4: number_reg[19:16] <= 4'hF;  // D4
                            3'd5: number_reg[23:20] <= 4'hF;  // D5
                            3'd6: number_reg[27:24] <= 4'hF;  // D6
                            3'd7: number_reg[31:28] <= 4'hF;  // D7
                            default: number_reg <= '0;
                        endcase
                    end

                    // ---------------------------------------------------------
                    // Mode 3: Fixed pattern – 0xDEAD_BEEF
                    // ---------------------------------------------------------
                    2'b11:
                    begin
                        number_reg <= 32'hDEAD_BEEF;
                    end

                    default:
                    begin
                        number_reg <= number_reg;
                    end
                endcase
            end
        end

    // -------------------------------------------------------------------------
    // Seven-segment display driver instance
    // -------------------------------------------------------------------------

    seven_segment_display
    # (
        .w_digit (W_DIGITS)
    )
    i_7segment
    (
        .clk      ( clock      ),
        .rst      ( reset      ),
        .number   ( number_reg ),
        .dots     ( dots_reg   ),
        .abcdefgh ( abcdefgh   ),
        .digit    ( digit      )
    );

endmodule
