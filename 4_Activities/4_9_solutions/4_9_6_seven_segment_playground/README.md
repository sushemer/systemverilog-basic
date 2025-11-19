# 4_9_6 – Seven-Segment Display Playground

This activity is based on `4_06_seven_segment_playground` and is included in the `4_9_solutions` folder.

## Objective

Work with the repository’s `seven_segment_display` module to:

- Display various **patterns across all 8 digits**.
- Change the displayed value and **decimal dots** through the keys (`key`).
- Practice:
  - Handling hexadecimal numbers per nibble (4 bits).
  - Animations using a **slow tick** derived from the main clock.
  - Different display modes controlled by `key`.

---

## Signal Mapping

### Inputs

- `clock`  
  Main FPGA clock (~27 MHz).

- `reset`  
  Global system reset.

- `key[1:0]` → display mode:

      mode = key[1:0]

      00 → Free-running hex counter  
      01 → Manual playground (key[7:4] on D0)
      10 → “Bar” / digit 0xF scrolling across the digits
      11 → Fixed pattern 0xDEAD_BEEF

- `key[7:4]`  
  Manual nibble when mode = 01.

### Outputs

- `abcdefgh[7:0]`  
  Segment lines for the seven-segment display.

- `digit[7:0]`  
  Active-digit selector for multiplexing.

- `led[7:0]`  
  Used as auxiliary indicators:
  - `led[1:0]` = current mode
  - Remaining bits = free for debugging

---

## Internal Signals and `seven_segment_display` Module

- Number of digits:

      W_DIGITS = 8

- Total number width (4 bits per digit):

      W_NUM = 32 bits

- Registers:

      number_reg : 32 bits (8 hex digits)
      dots_reg   : 8 bits (one dot per digit)

The actual multiplexing timing is handled *inside* the `seven_segment_display` module.

---

## Slow Tick Generator

To prevent overly fast animations, a slow tick (`tick`) is generated:

- Counter increments at `clock` speed.
- When the counter wraps to 0 → `tick = 1` for one cycle.
- The tick is used to:
  - Increment counters.
  - Advance scroll positions.
  - Trigger display updates.

---

## Display Modes

### **Mode 0 – Free Hex Counter (00)**

- Increment the full 32-bit `number_reg` on every tick.
- Digits show a hexadecimal count.
- Useful to verify display stability.

### **Mode 1 – Manual Playground (01)**

- `key[7:4]` is copied into digit 0 (`D0`).
- Other digits remain unchanged.
- Good for testing all hex symbols (0–F).

### **Mode 2 – Scrolling “Bar” (10)**

- A single digit (`0xF`) moves across the 8 positions.
- `scroll_pos` determines which digit is active.
- All other digits are cleared (0x0).

### **Mode 3 – Fixed Pattern 0xDEAD_BEEF (11)**

- Shows the hex pattern `DEAD_BEEF` regardless of tick.
- Useful for testing formatting and static display behavior.

---

## Suggested Tests

- **Mode 00**  
  Observe the counter cycling through all hex digits.

- **Mode 01**  
  Test each nibble 0–F using `key[7:4]`.

- **Mode 02**  
  Confirm smooth scrolling of the “bar”.

- **Mode 03**  
  Verify correct rendering of `DEAD_BEEF`.

---

## Optional Extensions

- Speed control using additional key bits.
- Editable digit selection using key values.
- Animated fixed patterns (blinking dots, shift effects).
- Display values from other modules (ALU, sensors, etc.).

This activity provides a versatile environment for mastering the `seven_segment_display` module and implementing custom animations on a multiplexed 7-segment display.
