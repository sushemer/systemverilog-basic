# 3.15 TM1638 quickstart

This example is a **“hello world” for the TM1638 module** in the configuration:

> `tang_nano_9k_lcd_480_272_tm1638_hackathon`

The idea is to have the simplest possible way to verify:

- Key reading (`key[7:0]`).
- LED control (`led[7:0]`).
- Basic use of the 7-segment display (TM1638) through the signals  
  `abcdefgh` and `digit`.

The LCD is not used in this example; it is kept off.

---

## Objective

By the end of this example, the user will be able to:

- Confirm that the **digital inputs** (buttons / switches) reach the FPGA correctly.
- Confirm that the **LEDs** react to those inputs.
- See how the key values are reflected on the **TM1638 display** in hexadecimal using the `seven_segment_display` module.

This example serves as a **starting point** for all TM1638-related exercises.

---

## Main signals

### Logical inputs / outputs

In `hackathon_top.sv` (simplified view):

input  logic       clock,  
input  logic       slow_clock,  
input  logic       reset,  

input  logic [7:0] key,  
output logic [7:0] led,  

output logic [7:0] abcdefgh,  
output logic [7:0] digit,  

input  logic [8:0] x,  
input  logic [8:0] y,  
output logic [4:0] red,  
output logic [5:0] green,  
output logic [4:0] blue,  

inout  logic [3:0] gpio

- `key[7:0]`  
  Digital inputs (buttons / switches from the hackathon board).

- `led[7:0]`  
  Outputs to discrete LEDs on the same board.

- `abcdefgh[7:0]`, `digit[7:0]`  
  Outputs to the TM1638 module (7 segments + dot + digit selection).

- `red`, `green`, `blue`  
  LCD outputs (not used here, forced to 0).

- `gpio[3:0]`  
  Generic pins (unused in this example).

---

## Internal structure of the example

The logic of this quickstart is intentionally simple and can be described in three conceptual blocks.

---

### 1. Direct echo from keys to LEDs

The simplest way to check that inputs work is to **directly reflect** the `key` value into `led`:

assign led = key;

Interpretation:

- If `key[0]` is active → `led[0]` turns on.  
- If multiple keys are active → multiple LEDs turn on.

This quickly verifies that:

- Buttons are wired correctly.
- Reset is not blocking logic.
- The constraints file applied the correct pin mapping.

---

### 2. Displaying data on the TM1638 (7-segment)

To show a value on the TM1638 7-segment display, the reusable `seven_segment_display` module is used.  
A typical minimal usage looks like:

logic [7:0] value_for_display;

assign value_for_display = key;

seven_segment_display #(
    .w_digit (8)   // 8 digits available on the TM1638 module
) i_7segment (
    .clk      (clock),
    .rst      (reset),
    .number   (value_for_display),
    .dots     (8'b0000_0000),   // all decimal points off
    .abcdefgh (abcdefgh),
    .digit    (digit)
);

Key points:

- `number` may be up to 32 bits; the module splits it into nibbles and displays HEX.
- A simple option for this quickstart is using `key` directly:
  - If `key[3:0]` is changed → you see values 0–15 in HEX.
  - If full `key[7:0]` is used → you see values 0–255 in HEX (spanning several digits).
- `dots` is kept at zero so no decimal points light up.

This confirms that:

- The path **FPGA → TM1638** works.
- The TM1638’s internal multiplexing and driver operate correctly.

---

### 3. Disabling LCD and GPIO

To avoid interference and make it clear the example focuses solely on TM1638, all unused outputs are forced to fixed values:

assign red   = '0;  
assign green = '0;  
assign blue  = '0;

assign gpio  = 4'bz;   // or '0 depending on wrapper conventions

This ensures:

- The LCD stays blank (black).
- `gpio` remains unused and available for later examples.

---

## Typical flow of `hackathon_top.sv`

A simplified skeleton of the file might look like:

// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon  
module hackathon_top (

    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // 1) Echo keys to LEDs
    assign led = key;

    // 2) Value for 7-segment display (simple example)
    logic [7:0] value_for_display;
    assign value_for_display = key;

    seven_segment_display #(
        .w_digit (8)
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   (value_for_display),
        .dots     (8'b0000_0000),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // 3) LCD off
    assign red   = '0;
    assign green = '0;
    assign blue  = '0;

    // 4) GPIO unused
    assign gpio = 4'bz;

endmodule

---

## What to observe on the board

With the bitstream loaded:

1. Press various buttons / switches on `key[7:0]`:
   - LEDs should light up according to the pattern of active keys.

2. Look at the TM1638:
   - The value of `key` should appear on the display in hexadecimal.
   - When changing `key[3:0]`, the least significant digit clearly updates.

3. Verify:
   - The LCD remains black.
   - No unexpected behavior appears on other peripherals.

---

## Ideas to extend the example

Some variations that can be proposed as exercises:

- Show on the 7-segment display **only some** pressed keys (e.g., `key[3:0]`).
- Light the decimal points (`dots`) to mark which bits are active.
- Use a **simple FSM** that:
  - Changes display mode based on a key.
  - For example, “HEX mode”, “shifted binary mode”, “counter mode”.

This quickstart is designed so that in just a few minutes you can verify that the path:

> **Keys → FPGA → LEDs/TM1638**

works correctly before moving to more complex examples.
