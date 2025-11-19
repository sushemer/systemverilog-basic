# 3.11 Seven-segment basics

This example introduces the basics of a **7-segment display**:

- How to turn on/off individual segments.
- How to map a hexadecimal value (0–F) to a segment pattern.
- How to activate **a single digit** of the display.
- How to control the **decimal point** (segment `h`).

It is the minimal version needed to understand the display “alphabet” before using more advanced modules like `seven_segment_display`.

---

## Objective

By the end of the example, the user will be able to:

- Relate a nibble (`value`, 4 bits) to a displayed 7-segment symbol.
- Understand the `abcdefgh` bit convention:
  - `a, b, c, d, e, f, g` + `h` (decimal point)
- Activate a single digit using a one-hot mask in `digit`.
- Turn the decimal point on/off using an input button.

---

## Signals and pins

### Inputs

- `clock`  
  Main FPGA clock (≈ 27 MHz on Tang Nano 9K).

- `reset`  
  Active-high asynchronous reset.

- `key[7:0]`  
  Used as:
  - `key[3:0]` → hexadecimal value `value` (0–15)
  - `key[4]` → `dp` flag (decimal point)
  - `key[7:5]` → unused

### Outputs

- `led[7:0]`  
  - `led[3:0]` = `value`  
  - `led[4]` = `dp`  
  - `led[7:5]` = 0  

- `abcdefgh[7:0]`  
  Segment bits:

  | Bit | Segment |
  |-----|---------|
  | 7   | a       |
  | 6   | b       |
  | 5   | c       |
  | 4   | d       |
  | 3   | e       |
  | 2   | f       |
  | 1   | g       |
  | 0   | h (dp)  |

- `digit[7:0]`  
  - `digit = 8'b0000_0001` → only digit 0 active  

- `red`, `green`, `blue`  
  Forced to 0 (LCD not used).
