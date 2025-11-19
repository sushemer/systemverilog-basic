// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Lab 5.5 – Seven-segment + TM1638 playground
//
// General idea:
//   - Use the repository’s seven_segment_display module to control 8 digits.
//   - Treat key[7:0] and led[7:0] as the logical interface of a TM1638-like module.
//   - Practice several display modes:
//       * Mode 0: free-running hexadecimal counter (32 bits).
//       * Mode 1: show nibbles from key[7:0] as two HEX digits.
//       * Mode 2: fixed pattern "DEAD_BEEF".
//       * Mode 3: inverted number (~counter).
//   - Use decimal points (dots) as direct indicators of key.
//
// Notes:
//   - The logic is intentionally simple to focus on the use of
//     seven_segment_display and how to map nibbles to digits.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (TM1638-style dynamic interface)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used in this lab)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // We do not use LCD nor GPIO in this lab.
    assign red   = '0;
    assign green = '0;
    assign blue  = '0;
    // gpio handled by wrapper.

    // -------------------------------------------------------------------------
    // Operation mode (2 bits from key)
    // -------------------------------------------------------------------------
    //
    //   mode = key[1:0]:
    //     00 -> HEX counter
    //     01 -> nibbles from key[7:0]
    //     10 -> fixed pattern DEAD_BEEF
    //     11 -> inverted number (~counter)

    logic [1:0] mode;
    assign mode = key[1:0];

    // -------------------------------------------------------------------------
    // Frequency divider for slow animations (tick)
    // -------------------------------------------------------------------------

    localparam int W_DIV = 22;  // Adjust to change tick speed

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
    // Base 32-bit counter (for HEX display)
    // -------------------------------------------------------------------------

    logic [31:0] hex_counter;

    always_ff @(posedge clock or posedge reset)
        if (reset)
            hex_counter <= 32'd0;
        else if (tick)
            hex_counter <= hex_counter + 32'd1;

    // -------------------------------------------------------------------------
    // Number register and dot register for seven_segment_display
    // -------------------------------------------------------------------------

    localparam int W_DIGITS = 8;
    localparam int W_NUM    = W_DIGITS * 4;  // 32 bits

    logic [W_NUM-1:0]    number_reg; // 8 HEX digits
    logic [W_DIGITS-1:0] dots_reg;   // decimal points (one per digit)

    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            number_reg <= '0;
            dots_reg   <= '0;
        end
        else
        begin
            // dots: use key[7:0] directly
            //       1 = decimal point ON for that digit.
            dots_reg <= key;

            // Update number_reg according to mode when tick occurs.
            if (tick)
            begin
                unique case (mode)
                    // ---------------------------------------------------------
                    // Mode 0: free-running HEX counter (32 bits)
                    // ---------------------------------------------------------
                    2'b00:
                    begin
                        // Display hex_counter directly (32 bits → 8 digits).
                        number_reg <= hex_counter;
                    end

                    // ---------------------------------------------------------
                    // Mode 1: manual playground using key[7:0]
                    // ---------------------------------------------------------
                    //   - D0 = key[3:0]
                    //   - D1 = key[7:4]
                    //   - D2..D7 = 0
                    2'b01:
                    begin
                        number_reg <= { 24'h0, key[7:4], key[3:0] };
                    end

                    // ---------------------------------------------------------
                    // Mode 2: fixed pattern "DEAD_BEEF"
                    // ---------------------------------------------------------
                    //   number_reg = 0xDEAD_BEEF
                    2'b10:
                    begin
                        number_reg <= 32'hDEAD_BEEF;
                    end

                    // ---------------------------------------------------------
                    // Mode 3: inverted number (~hex_counter)
                    // ---------------------------------------------------------
                    2'b11:
                    begin
                        number_reg <= ~hex_counter;
                    end

                    default:
                    begin
                        number_reg <= 32'd0;
                    end
                endcase
            end
        end

    // -------------------------------------------------------------------------
    // LED mapping (TM1638)
    // -------------------------------------------------------------------------
    //
    // Idea:
    //   - led[1:0] = mode (to quickly see active mode).
    //   - led[7:2] = low bits of the counter (decorative pattern).
    //

    always_comb
    begin
        led       = 8'b0000_0000;
        led[1:0]  = mode;
        led[7:2]  = hex_counter[7:2];
    end

    // -------------------------------------------------------------------------
    // seven_segment_display driver instance
    // -------------------------------------------------------------------------

    seven_segment_display
    #(
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
