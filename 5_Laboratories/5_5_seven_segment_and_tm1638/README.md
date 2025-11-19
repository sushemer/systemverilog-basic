# Lab 5.5 – Seven-segment + TM1638 playground

## Objective

Practice using the repository’s `seven_segment_display` module and understand how to:

- Map a 32-bit binary value into **8 HEX digits**.
- Use `key[7:0]` as **input** and decimal points (`dots`) as **status indicators**.
- Use the TM1638 LEDs (`led[7:0]`) as an additional debugging output.

By the end of this lab, you should feel comfortable:

- Configuring the 7-segment driver (`w_digit`, `number`, `dots`).
- Splitting numbers into **nibbles** (4 bits per digit).
- Designing small “display modes” controlled by keys.

---

## Prerequisites

You should have completed or seen:

- **Lab 5.1 – blink_hello_world** (frequency divider).
- **Activity 4.6 – seven_segment_playground** (if you already worked on it).

You should also know:

- How a multiplexed 7-segment display works.
- The nibble ↔ HEX digit relationship.

---

## Signal mapping

- `mode = key[1:0]`  
  Selects the display mode:

  - `00` → **Mode 0**: HEX counter  
  - `01` → **Mode 1**: nibbles from `key[7:0]`  
  - `10` → **Mode 2**: fixed pattern `DEAD_BEEF`  
  - `11` → **Mode 3**: bitwise inverted number `~counter`

- `hex_counter[31:0]`  
  Free-running counter that increments with each `tick`.

- `number_reg[31:0]`  
  Value sent to the 7-segment display (8 HEX digits).

- `dots_reg[7:0]`  
  Decimal points; this lab maps them directly from `key[7:0]`.

- `led[7:0]` (TM1638 LEDs):  
  - `led[1:0]` → active mode  
  - `led[7:2]` → low bits of `hex_counter` (decorative)

---

## Description of modes

### **Mode 0 – HEX counter**
- `mode = 2'b00`
- `number_reg <= hex_counter;`
- Display shows a free-running 32-bit hexadecimal counter  
  (`0000_0000` to `FFFF_FFFF` then restarts).

---

### **Mode 1 – Manual playground using key**
- `mode = 2'b01`
- `number_reg <= { 24'h0, key[7:4], key[3:0] };`

Only the two least-significant digits are used:

- D0 shows `key[3:0]`
- D1 shows `key[7:4]`
- D2..D7 = 0

Useful to experiment with nibble-to-HEX mapping.

---

### **Mode 2 – Fixed pattern DEAD_BEEF**
- `mode = 2'b10`
- `number_reg <= 32'hDEAD_BEEF;`

Display shows:

D E A D B E E F


Great as a debug pattern and to practice reading HEX on the 7-segment display.

---

### **Mode 3 – Inverted number**
- `mode = 2'b11`
- `number_reg <= ~hex_counter;`

Displays the bitwise complement of the HEX counter.  
Useful for visually comparing Mode 0 and Mode 3.

---

## Suggested procedure

### 1. **Review the frequency divider**

- Find the block using `W_DIV`, `div_cnt`, and `tick`.
- Modify `W_DIV` to change animation speed.
- Verify (optionally in simulation) that `tick` pulses periodically.

---

### 2. **Study the mode mapping**

- Locate the `case (mode)` inside the `always_ff`.
- Create a small table with:
  - mode  
  - number_reg  
  - meaning  

Make sure you understand how each pattern is constructed.

---

### 3. **Relate nibbles to digits**

Remember: each HEX digit = 4 bits.

Breakdown of `DEAD_BEEF`:

- D7 = D  
- D6 = E  
- D5 = A  
- D4 = D  
- D3 = B  
- D2 = E  
- D1 = E  
- D0 = F  

---

### 4. **Test on hardware**

- Synthesize and program the FPGA.
- Change `mode` with `key[1:0]` and observe:
  - Display pattern change  
  - `led[1:0]` reflect the mode  
- Modify `key[7:0]` and check:
  - Mode 1 updates the two LSB HEX digits  
  - Decimal points follow the exact `key` pattern  

---

### 5. **Play with dots**

Since `dots_reg <= key;`:

- `key[0] = 1` lights the dot for digit 0  
- `key[7] = 1` lights the dot for digit 7  

Experiment ideas:

- Light dots only in certain modes.
- Light multiple dots when a specific key bit is pressed.

---

## Test checklist

- [ ] Design synthesizes and programs on Tang Nano 9K without errors  
- [ ] **Mode 0:** continuous HEX counter  
- [ ] **Mode 1:** two least-significant digits match `key[7:4]` and `key[3:0]`  
- [ ] **Mode 2:** `DEAD_BEEF` shown permanently  
- [ ] **Mode 3:** inverted pattern, visually distinct from Mode 0  
- [ ] `led[1:0]` always match `mode`  
- [ ] Decimal points update according to `key[7:0]`  

---

## Optional extensions

If you want to push this lab further:

- Add a mode where the display shows values from a **sensor**  
  (potentiometer, ultrasonic sensor, encoder, etc.).
- Convert a value to **decimal** and show `0000`–`9999`  
  (requires binary-to-BCD conversion).
- Use bits of `hex_counter` to drive a dot-based progress bar.

This lab prepares you for the next one,  
where 7-segments + TM1638 + sensors combine into a small **instrument panel**. 
