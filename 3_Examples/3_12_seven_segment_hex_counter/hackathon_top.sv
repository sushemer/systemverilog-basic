// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.12: Seven-segment HEX counter (manual multiplexing)
//
// Displays a 32-bit hexadecimal counter on the 8 digits of the
// TM1638 7-segment display, using manual multiplexing.
// - Each digit shows 4 bits (one nibble) of the counter.
// - The counter increments at ~10 steps per second.
// - The LEDs show the least significant byte of the counter.

module hackathon_top
(
    input  logic       clock,
    input  logic       slow_clock,   // not used in this example
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (multiplexed)
    output logic [7:0] abcdefgh,     // a b c d e f g h (dot)
    output logic [7:0] digit,        // digit selection (one hot)

    // LCD interface (not used here)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // GPIO (not used here)
    inout  logic [3:0] gpio
);
    // --------------------------------------------------------------------
    // Turn off unused peripherals
    // --------------------------------------------------------------------
    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // --------------------------------------------------------------------
    // 1) Slow tick to increment the HEX counter
    // --------------------------------------------------------------------
    localparam int unsigned CLK_HZ   = 27_000_000;  // approx. Tang Nano 9K
    localparam int unsigned TICK_HZ  = 10;          // 10 increments/second
    localparam int unsigned TICK_MAX = CLK_HZ / TICK_HZ;

    logic [31:0] tick_cnt;
    logic        tick_100ms;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            tick_cnt    <= 32'd0;
            tick_100ms  <= 1'b0;
        end else if (tick_cnt == TICK_MAX - 1) begin
            tick_cnt    <= 32'd0;
            tick_100ms  <= 1'b1;
        end else begin
            tick_cnt    <= tick_cnt + 32'd1;
            tick_100ms  <= 1'b0;
        end
    end

    // --------------------------------------------------------------------
    // 32-bit hexadecimal counter
    // --------------------------------------------------------------------
    logic [31:0] hex_counter;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            hex_counter <= 32'h0000_0000;
        end else if (tick_100ms) begin
            hex_counter <= hex_counter + 32'd1;
        end
    end

    // Display least significant byte on LEDs (debug)
    always_comb begin
        led = hex_counter[7:0];
    end

    // --------------------------------------------------------------------
    // 2) Multiplexing of the 8 display digits
    // --------------------------------------------------------------------
    logic [15:0] refresh_cnt;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            refresh_cnt <= 16'd0;
        end else begin
            refresh_cnt <= refresh_cnt + 16'd1;
        end
    end

    // Use the upper bits as digit index (0..7)
    wire [2:0] digit_idx = refresh_cnt[15:13];

    // One-hot digit selection
    logic [7:0] digit_onehot;

    always_comb begin
        case (digit_idx)
            3'd0: digit_onehot = 8'b0000_0001;
            3'd1: digit_onehot = 8'b0000_0010;
            3'd2: digit_onehot = 8'b0000_0100;
            3'd3: digit_onehot = 8'b0000_1000;
            3'd4: digit_onehot = 8'b0001_0000;
            3'd5: digit_onehot = 8'b0010_0000;
            3'd6: digit_onehot = 8'b0100_0000;
            3'd7: digit_onehot = 8'b1000_0000;
            default: digit_onehot = 8'b0000_0001;
        endcase
    end

    assign digit = digit_onehot;

    // Select the nibble corresponding to the active digit
    logic [3:0] current_nibble;

    always_comb begin
        case (digit_idx)
            3'd0: current_nibble = hex_counter[3:0];
            3'd1: current_nibble = hex_counter[7:4];
            3'd2: current_nibble = hex_counter[11:8];
            3'd3: current_nibble = hex_counter[15:12];
            3'd4: current_nibble = hex_counter[19:16];
            3'd5: current_nibble = hex_counter[23:20];
            3'd6: current_nibble = hex_counter[27:24];
            3'd7: current_nibble = hex_counter[31:28];
            default: current_nibble = 4'h0;
        endcase
    end

    // --------------------------------------------------------------------
    // 3) HEX → 7-segment conversion
    //    Bit convention in abcdefgh:
    //      bit 7: a
    //      bit 6: b
    //      bit 5: c
    //      bit 4: d
    //      bit 3: e
    //      bit 2: f
    //      bit 1: g
    //      bit 0: h (dot)
    //
    //    1 = segment on, 0 = off.
    // --------------------------------------------------------------------
    function automatic logic [7:0] hex_to_7seg(input logic [3:0] v);
        begin
            unique case (v)
                4'h0: hex_to_7seg = 8'b1111_1100; // 0
                4'h1: hex_to_7seg = 8'b0110_0000; // 1
                4'h2: hex_to_7seg = 8'b1101_1010; // 2
                4'h3: hex_to_7seg = 8'b1111_0010; // 3
                4'h4: hex_to_7seg = 8'b0110_0110; // 4
                4'h5: hex_to_7seg = 8'b1011_0110; // 5
                4'h6: hex_to_7seg = 8'b1011_1110; // 6
                4'h7: hex_to_7seg = 8'b1110_0000; // 7
                4'h8: hex_to_7seg = 8'b1111_1110; // 8
                4'h9: hex_to_7seg = 8'b1111_0110; // 9
                4'hA: hex_to_7seg = 8'b1110_1110; // A
                4'hB: hex_to_7seg = 8'b0011_1110; // b
                4'hC: hex_to_7seg = 8'b1001_1100; // C
                4'hD: hex_to_7seg = 8'b0111_1010; // d
                4'hE: hex_to_7seg = 8'b1001_1110; // E
                4'hF: hex_to_7seg = 8'b1000_1110; // F
                default: hex_to_7seg = 8'b0000_0000; // all off
            endcase
        end
    endfunction

    logic [7:0] segs;

    always_comb begin
        segs     = hex_to_7seg(current_nibble);
        segs[0]  = 1'b0;    // decimal point off
        abcdefgh = segs;
    end

endmodule
