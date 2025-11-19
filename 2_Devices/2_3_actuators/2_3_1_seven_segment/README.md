# 2.3.1 Seven Segment · 7-segment displays
![alt text](Mult/image.png)

**7-segment displays** are used to show numbers (0–9, 0–F) and some simple letters.  
In this repository they are mainly used for:

- Binary/hexadecimal counters.
- State or mode indicators.
- Basic visualization of results (for example, approximate distance, level, etc.).

They can be **single-digit** or **multi-digit** (with multiplexing).

---

## Logical signals and pins

A typical 7-segment digit has:

- 7 segments: `a, b, c, d, e, f, g`.
- Optional decimal point: `dp`.
- A common terminal (common-anode or common-cathode).

In code it is commonly represented as:

- `seg[6:0]` → segments `a..g`.
- `dp` → decimal point (optional).
- `en_digit[n:0]` → digit enables (when there is more than one).

Example names:

- `seg[6:0]`
- `seg_dp`
- `digit_en[3:0]` (for 4 digits)

The assignment to specific FPGA pins is documented in:

- `2_1_Boards/2_1_1_Tang_Nano_9K/docs/pinout.md`
- `2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

---

## Key concepts

### Display type: common-anode vs common-cathode

- **Common-anode**: segments light up by driving the signal low (0).
- **Common-cathode**: segments light up by driving the signal high (1).

This affects:

- The logic of the decoder (whether inversion is needed).
- The interpretation of bits in the segment map.

### Segment map

Each number/letter is encoded as a pattern of on/off segments.  
For example, for a display where `1` is represented by turning on only `b` and `c`:

a b c d e f g  
0 1 1 0 0 0 0
