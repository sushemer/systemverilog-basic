# 3.18 Rotary Encoder (KY-040) + TM1638 + LCD Helper

This example integrates three elements simultaneously:

- A **KY-040 rotary encoder** connected to `gpio[3:2]`
- The **TM1638** seven-segment display module
- The **480×272 LCD** used as a visual helper

Board configuration:

> `tang_nano_9k_lcd_480_272_tm1638_hackathon`

The encoder acts as a **rotary control** that updates an integer value. This value is displayed:

- On the TM1638 (numerical display)
- On the LEDs (`value[7:0]`)
- On the LCD as a **vertical threshold**  
  (pixels with `x > value` are painted blue)

---

## Objective

By completing this example, the user will:

- Understand how to connect and read a **KY-040 rotary encoder**.
- Learn the importance of:
  - **Synchronizing** external signals to the FPGA clock.
  - **Debouncing** mechanical inputs.
- Interpret the encoder value:
  - Numerically (TM1638 display),
  - In binary (LEDs),
  - Graphically (LCD threshold visualization).
- Build a foundation for:
  - Menus,
  - Parameter tuning,
  - Real-time control via encoder input.

---

## Hardware Connections

### KY-040 Pins

- `CLK` → Encoder Phase A  
- `DT`  → Encoder Phase B  
- `SW` → Optional push button (not used here)  
- `VCC`, `GND` → Power

In this design:

- `gpio[3]` = CLK (A)
- `gpio[2]` = DT (B)

⚠️ **Important**: The encoder must share **GND** with the FPGA.

---

## Module Signals

### Board Inputs

- `clock` → Main system clock (~27 MHz)  
- `slow_clock` → Not used  
- `reset` → Active high  
- `key[7:0]` → Reserved  

### TM1638 Outputs

- `abcdefgh[7:0]` → Segment data  
- `digit[7:0]` → Digit selection (one-hot)

### LCD Interface

- `x`, `y` coordinates (0..479, 0..271)
- `red`, `green`, `blue` (current pixel color)

### LEDs

- Display the lower 8 bits of `value`

---

## Internal Structure

### 1. Synchronization and Debouncing

Signals from the encoder arrive asynchronously.  
We use `sync_and_debounce` to:

- Avoid metastability
- Filter mechanical noise (debounce)

Output of this module → stable `a`, `b` phases.

---

### 2. Rotary Encoder Decoding

The `rotary_encoder` module converts the phase transitions into an integer:

- Clockwise rotation  → `value++`
- Counter-clockwise  → `value--`

`value` is 16 bits and may wrap or saturate depending on implementation.

---

### 3. TM1638 Display

`seven_segment_display` is used to show the 16-bit encoder value on all 8 digits.

- `number = 32'(value)`  
- No decimal dots (`dots = '0`)

---

### 4. LEDs

`led = value[7:0];`  
A simple binary visualization of the encoder output.

---

### 5. LCD Visualization

The LCD shows a vertical threshold:

- Background = black
- For every pixel:
  - If `x > value[8:0]` → pixel becomes blue  
    (`blue = x[4:0]` adds small variation)
  - Otherwise → black

This creates a dynamic **moving vertical boundary**.

---

## Expected Behavior

When rotating the encoder:

- **Clockwise**:
  - `value` increases
  - TM1638 increments
  - LEDs update
  - Threshold moves right

- **Counter-clockwise**:
  - `value` decreases
  - TM1638 decrements
  - LEDs update
  - Threshold moves left

---

## Extension Ideas

- Limit `value` to 0–100 and scale it to LCD width.
- Use two encoders: one for X-axis, one for Y-axis movement.
- Build an interactive on-screen menu and use:
  - Encoder = selector
  - Encoder button (SW) = “enter”

---

## Related Files

- `peripherals/rotary_encoder.sv`
- `labs/common/sync_and_debounce.sv`
- `labs/common/seven_segment_display.sv`

Also see:

- `3_14_lcd_moving_rectangle`
- `3_12_seven_segment_hex_counter_multiplexed`
- `1_2_7_Finite_State_Machines.md`
