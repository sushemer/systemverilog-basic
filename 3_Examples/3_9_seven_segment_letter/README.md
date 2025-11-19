# 3.9 Seven-segment letters (FPGA)

This example shows how to **display letters on a 7-segment display** using:

- A **one-hot shift register** to select the active digit.
- A **segment encoding table** for the letters `F`, `P`, `G`, `A`.
- Fast multiplexing so the human eye perceives the word **"FPGA"** as stable.

---

## Objective

By the end of this example, the user will be able to:

- Understand how multiplexing works on a 7-segment display.
- Implement a **shift register** to select digits.
- Create a table of **segment patterns** for letters.
- Adjust the refresh rate so that the letters appear continuous.

![Segment map](Mult/seven_segment_font_editor.jpg)

---

## Signals and mapping

### Inputs

- `clock`  
  Main FPGA clock (~27 MHz in this configuration).

- `reset`  
  Active-high asynchronous reset for the counter and shift register.

- `key[7:0]`  
  Not used in the basic version, but may be used in later exercises (change letters, speed, etc.).

### Outputs

- `abcdefgh[7:0]`  
  Segment bits:

  - `a` → bit 7  
  - `b` → bit 6  
  - `c` → bit 5  
  - `d` → bit 4  
  - `e` → bit 3  
  - `f` → bit 2  
  - `g` → bit 1  
  - `h` → bit 0 (decimal point or custom use)

  Patterns are defined using an `enum`:

  ```sv
  typedef enum bit [7:0]
  {
      F     = 8'b1000_1110,
      P     = 8'b1100_1110,
      G     = 8'b1011_1100,
      A     = 8'b1110_1110,
      space = 8'b0000_0000
  } seven_seg_encoding_e;
  ```