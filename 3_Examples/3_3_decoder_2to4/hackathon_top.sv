// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// 3.3: Decoder 2→4 with four internal implementations.
//
// - Inputs (from key):
//     key[1] = in[1]
//     key[0] = in[0]
// - Visible outputs:
//     led[1:0] = in (to display the binary value)
//     led[5:2] = dec3 (output of the “canonical” decoder)
//     led[7:6] = 0
//
// Internally, 4 versions of a 2→4 decoder are implemented:
//
//   dec0: “tedious” implementation with AND and NOT
//   dec1: implementation using case
//   dec2: implementation using shift
//   dec3: implementation using indexing (dec3[in] = 1)
//
// In hardware, only dec3 is connected to the LEDs, but the other
// implementations can be reviewed through simulation.

module hackathon_top
(
    // Standard interface for this board
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // 7-segment display (not used here)
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD interface (not used here)
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    // Generic GPIO (not used here)
    inout  logic [3:0] gpio
);

    // ------------------------------------------------------------------------
    // Turn off everything we are not using
    // ------------------------------------------------------------------------
    assign abcdefgh = 8'h00;
    assign digit    = 8'h00;

    assign red   = 5'h00;
    assign green = 6'h00;
    assign blue  = 5'h00;

    assign gpio  = 4'hz;

    // ------------------------------------------------------------------------
    // Inputs for the 2→4 decoder
    // ------------------------------------------------------------------------
    // We use two bits of key as the binary input “in[1:0]”
    logic [1:0] in;
    assign in = { key[1], key[0] };

    // ------------------------------------------------------------------------
    // Implementation 1: “tedious” with AND/NOT
    // ------------------------------------------------------------------------
    wire [3:0] dec0;

    assign dec0[0] = ~in[1] & ~in[0];
    assign dec0[1] = ~in[1] &  in[0];
    assign dec0[2] =  in[1] & ~in[0];
    assign dec0[3] =  in[1] &  in[0];

    // ------------------------------------------------------------------------
    // Implementation 2: case
    // ------------------------------------------------------------------------
    logic [3:0] dec1;

    always_comb begin
        case (in)
            2'b00: dec1 = 4'b0001;
            2'b01: dec1 = 4'b0010;
            2'b10: dec1 = 4'b0100;
            2'b11: dec1 = 4'b1000;
            // no default is used because all combinations are covered
        endcase
    end

    // ------------------------------------------------------------------------
    // Implementation 3: shift
    // ------------------------------------------------------------------------
    wire [3:0] dec2 = 4'b0001 << in;

    // ------------------------------------------------------------------------
    // Implementation 4: indexing
    // ------------------------------------------------------------------------
    logic [3:0] dec3;

    always_comb begin
        dec3 = '0;         // start with everything at 0
        dec3[in] = 1'b1;   // only the position indexed by “in” goes high
    end

    // ------------------------------------------------------------------------
    // Display something useful on the LEDs
    // ------------------------------------------------------------------------
    // led[1:0]  = input value (in)
    // led[5:2]  = decoder output “dec3” (one-hot)
    // led[7:6]  = 0

    assign led[1:0] = in;
    assign led[5:2] = dec3[3:0];
    assign led[7:6] = 2'b00;

endmodule
