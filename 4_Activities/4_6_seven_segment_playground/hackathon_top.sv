// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// Activity 4.6 – 7-segment display playground
//
// General idea:
//   - Use the seven_segment_display module already existing in the repo.
//   - Play with different patterns using the 8 digits of the display.
//   - Change the content and the decimal points according to keys (key).
//
// NOTE: This is an ACTIVITY TEMPLATE.
//       Modify and extend the logic marked as TODO.
//

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (TM1638 / dynamic)
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

    // In this activity we do not use LCD or GPIO.
    assign red   = '0;
    assign green = '0;
    assign blue  = '0;
    // gpio is handled from the board wrapper.

    // We may use LEDs simply as a mode indicator.
    // (You may change this if you want them to show something else.)
    // mode = key[1:0]
    logic [1:0] mode;
    assign mode = key[1:0];

    assign led = { 6'b0, mode };  // Just to know which mode we are in.

    // -------------------------------------------------------------------------
    // Frequency divider for slow animations
    // -------------------------------------------------------------------------
    //
    // Generates a “tick” from the main clock (~27 MHz).
    // Each time tick=1, we update the display content.

    localparam int W_DIV = 22;  // Adjust to change speed
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
    // Number and decimal points for the 7-segment display
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
    // Each nibble represents a hexadecimal digit (0–F).

    localparam int W_DIGITS = 8;
    localparam int W_NUM    = W_DIGITS * 4;  // 32 bits

    logic [W_NUM-1:0]    number_reg;  // 8-digit content
    logic [W_DIGITS-1:0] dots_reg;    // Decimal points (one per digit)

    // -------------------------------------------------------------------------
    // Main playground logic
    // -------------------------------------------------------------------------

    // (Optional) A position index for scrolling animations
    logic [2:0] scroll_pos;

    always_ff @(posedge clock or posedge reset)
        if (reset)
        begin
            number_reg <= '0;
            dots_reg   <= '0;
            scroll_pos <= '0;
        end
        else
        begin
            // Base example: use key[7:0] to control decimal points.
            // You may change this logic if you want something else.
            dots_reg <= key;  // 1 = dot ON for each digit

            if (tick)
            begin
                // Small position counter for scroll modes
                scroll_pos <= scroll_pos + 3'd1;

                unique case (mode)
                    // ---------------------------------------------------------
                    // Mode 0: free hexadecimal counter on all digits
                    // ---------------------------------------------------------
                    2'b00:
                    begin
                        // TODO: you may change the increment speed,
                        // or limit the counter range.
                        number_reg <= number_reg + 32'd1;
                    end

                    // ---------------------------------------------------------
                    // Mode 1: manual playground
                    // ---------------------------------------------------------
                    // Suggested idea:
                    //   - Show in least significant digit (D0)
                    //     the value of key[7:4] as a HEX digit.
                    //   - Keep the other digits in zero or fixed patterns.
                    2'b01:
                    begin
                        // Keep previous content for all digits
                        // and update only D0.
                        number_reg[3:0] <= key[7:4];

                        // TODO:
                        // - Change this to copy key[7:4] to another digit.
                        // - Or use combinations of keys to fill all digits
                        //   with HEX values.
                    end

                    // ---------------------------------------------------------
                    // Mode 2: “bar” or digit that scrolls
                    // ---------------------------------------------------------
                    // Suggested idea:
                    //   - Move a “full” digit (e.g., 0xF)
                    //     across the 8 digits using scroll_pos.
                    2'b10:
                    begin
                        // Template: all digits at 0
                        number_reg <= '0;

                        // TODO:
                        // - Use scroll_pos to select which nibble to activate.
                        //   For example:
                        //      case (scroll_pos)
                        //        3'd0: number_reg[ 3: 0] = 4'hF;
                        //        3'd1: number_reg[ 7: 4] = 4'hF;
                        //        ...
                        //      endcase
                        //
                        // - You may also create a symmetric pattern
                        //   (e.g., from ends toward center).
                    end

                    // ---------------------------------------------------------
                    // Mode 3: free mode
                    // ---------------------------------------------------------
                    // Space to define your own experiment:
                    //   - Show a fixed pattern (0xDEAD_BEEF, 0xC0FFEE, etc.)
                    //   - Alternate between two words/patterns.
                    //   - Implement HEX text scrolling.
                    2'b11:
                    begin
                        // TODO:
                        // - Implement your own effect here.
                        //   For example:
                        //     number_reg <= 32'hDEAD_BEEF;
                        //
                        // - Or use scroll_pos for HEX scrolling.
                        number_reg <= number_reg;
                    end
                endcase
            end
        end

    // -------------------------------------------------------------------------
    // Instance of the 7-segment display driver
    // -------------------------------------------------------------------------

    seven_segment_display
    # (
        .w_digit (W_DIGITS)
    )
    i_7segment
    (
        .clk      ( clock       ),
        .rst      ( reset       ),
        .number   ( number_reg  ),
        .dots     ( dots_reg    ),
        .abcdefgh ( abcdefgh    ),
        .digit    ( digit       )
    );

endmodule
