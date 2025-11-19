# 3.12 Seven-segment HEX counter (multiplexed)

This example shows how to implement a **32-bit hexadecimal counter** on the TM1638 7-segment display, performing the **multiplexing manually**:

- The counter `hex_counter` is 32 bits.
- Each 7-segment digit displays 4 bits (one nibble) of the counter.
- All 8 digits of the display are used to show the full value in HEX.
- The LEDs show the least significant byte of the counter for debugging.

It is the next natural step after:

- `3_11_seven_segment_basics` (one digit, no multiplexing).
- `3_10_hex_counter_7seg` (uses the already-built `seven_segment_display` module).

Here the user explicitly controls:

- Which digit is active (one-hot in `digit`).
- Which nibble goes to segments depending on the active digit.
- The counting speed and the display refresh speed.

---

## Objective

At the end of this example, the user will be able to:

- Understand the **multiplexing principle** of 7-segment displays.
- Implement a 32-bit HEX counter shown across 8 digits.
- Clearly separate:
  - Counting logic (slow counter).
  - Display refresh logic (fast counter).
  - HEX → 7-segment decoding logic.

---

## Relevant signals and pins

### Inputs

- `clock`  
  Main clock (~27 MHz on the Tang Nano 9K).

- `reset`  
  Active-high asynchronous reset.

- `key[7:0]`  
  Not used in the main logic of this example (available for extensions).

### Outputs

- `led[7:0]`  

  - `led = hex_counter[7:0];`  
    Shows the least significant byte of the counter in binary, useful for quick debugging.

- `abcdefgh[7:0]`  

  Segment bits:

    Bit 7 → a  
    Bit 6 → b  
    Bit 5 → c  
    Bit 4 → d  
    Bit 3 → e  
    Bit 2 → f  
    Bit 1 → g  
    Bit 0 → h (decimal point)

  Convention:

  - `1` = segment ON  
  - `0` = segment OFF

  The decimal point (h) is left OFF in all digits (`segs[0] = 1'b0`).

- `digit[7:0]`  

  **One-hot** digit selection:

    0000_0001 → Digit 0  
    0000_0010 → Digit 1  
    0000_0100 → Digit 2  
    0000_1000 → Digit 3  
    0001_0000 → Digit 4  
    0010_0000 → Digit 5  
    0100_0000 → Digit 6  
    1000_0000 → Digit 7  

  Only one bit of `digit` is active at a time.

- `red`, `green`, `blue`  
  Forced to 0 (LCD off in this example).

- `gpio[3:0]`  
  High impedance (`'z`), unused.

---

## Internal design structure

The design is organized into several blocks:

1. Generation of a **slow tick** to increment the HEX counter.  
2. 32-bit counter `hex_counter`.  
3. **Fast refresh logic** for multiplexing (digit selection).  
4. Selection of the nibble to display depending on the active digit.  
5. HEX → 7-segment decoder.  
6. Construction of outputs `abcdefgh` and `digit`.

---

### 1. Slow tick for the counter

A pulse (`tick_100ms`) is generated approximately every 100 ms using the main clock:

localparam int unsigned CLK_HZ   = 27_000_000;  
localparam int unsigned TICK_HZ  = 10;          // 10 increments/sec  
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

- `tick_cnt` counts clock cycles.  
- When it reaches `TICK_MAX - 1`, a one-cycle pulse is generated on `tick_100ms`.  
- `tick_100ms` is the **enable** for the 32-bit counter.

You may change `TICK_HZ` to adjust the counting speed.

---

### 2. 32-bit hexadecimal counter

Using the slow tick as enable:

logic [31:0] hex_counter;

always_ff @(posedge clock or posedge reset) begin  
    if (reset) begin  
        hex_counter <= 32'h0000_0000;  
    end else if (tick_100ms) begin  
        hex_counter <= hex_counter + 32'd1;  
    end  
end

- `hex_counter` increments once per `tick_100ms`.  
- This value is displayed across the 8 digits in HEX.  
- Least significant byte is mirrored to `led`.

---

### 3. Fast refresh for multiplexing

A fast counter selects the active digit:

logic [15:0] refresh_cnt;  
logic [2:0]  digit_index;

always_ff @(posedge clock or posedge reset) begin  
    if (reset) begin  
        refresh_cnt <= 16'd0;  
        digit_index <= 3'd0;  
    end else begin  
        refresh_cnt <= refresh_cnt + 16'd1;  
        digit_index <= refresh_cnt[15:13];  
    end  
end

- Each digit is on for a very short time.  
- Cycling through digits fast creates the illusion that all digits are on simultaneously.

---

### 4. Selecting the nibble based on the active digit

logic [3:0] active_nibble;

always_comb begin  
    unique case (digit_index)  
        3'd0: active_nibble = hex_counter[ 3: 0];  
        3'd1: active_nibble = hex_counter[ 7: 4];  
        3'd2: active_nibble = hex_counter[11: 8];  
        3'd3: active_nibble = hex_counter[15:12];  
        3'd4: active_nibble = hex_counter[19:16];  
        3'd5: active_nibble = hex_counter[23:20];  
        3'd6: active_nibble = hex_counter[27:24];  
        3'd7: active_nibble = hex_counter[31:28];  
        default: active_nibble = 4'h0;  
    endcase  
end

Each digit displays a different nibble of `hex_counter`.

---

### 5. HEX → 7-segment decoder

logic [6:0] seg_7bits;  // a-g

always_comb begin  
    unique case (active_nibble)  
        4'h0: seg_7bits = 7'b1111110;  
        4'h1: seg_7bits = 7'b0110000;  
        4'h2: seg_7bits = 7'b1101101;  
        4'h3: seg_7bits = 7'b1111001;  
        4'h4: seg_7bits = 7'b0110011;  
        4'h5: seg_7bits = 7'b1011011;  
        4'h6: seg_7bits = 7'b1011111;  
        4'h7: seg_7bits = 7'b1110000;  
        4'h8: seg_7bits = 7'b1111111;  
        4'h9: seg_7bits = 7'b1111011;  
        4'hA: seg_7bits = 7'b1110111;  
        4'hB: seg_7bits = 7'b0011111;  
        4'hC: seg_7bits = 7'b1001110;  
        4'hD: seg_7bits = 7'b0111101;  
        4'hE: seg_7bits = 7'b1001111;  
        4'hF: seg_7bits = 7'b1000111;  
        default: seg_7bits = 7'b0000000;  
    endcase  
end

---

### 6. Constructing `abcdefgh` and `digit`

logic [7:0] segments;

always_comb begin  
    segments[7:1] = seg_7bits;  
    segments[0]   = 1'b0;  
end

assign abcdefgh = segments;

logic [7:0] digit_int;

always_comb begin  
    digit_int = 8'b0000_0001 << digit_index;  
end

assign digit = digit_int;

---

## Relationship with other examples

- `3_11_seven_segment_basics` — basic nibble → segments.  
- `3_10_hex_counter_7seg` — uses an automatic multiplexing module.  
- Later labs reuse this multiplexing method for counters, FSM states, and sensor values.

---

## Possible extensions and exercises

- Adjust the `tick_100ms` frequency for faster/slower counting.
- Use a button to pause/resume or reset the counter.
- Use the decimal point to indicate special modes.
- Display only 4 digits and use the other 4 for other information.
- Combine sensor values with the counter.

This example provides a clear base for understanding 8-digit multiplexing and how to separate counting, refreshing, and decoding logic.
