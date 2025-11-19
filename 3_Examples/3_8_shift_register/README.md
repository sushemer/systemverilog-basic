# 3.8 Shift register

This example implements an **8-bit shift register** using:

- A counter that generates a slow enable pulse (`enable`) from the fast clock.
- A register `shift_reg[7:0]` that shifts whenever `enable = 1`.
- An input bit (`button_on`) that is injected into one side of the register.

The LEDs show the content of the register, allowing you to visualize a pattern that slowly “moves.”

---

## Objective

By the end of this example, the user will be able to:

- Understand the concept of a **shift register**.
- Implement a simple **frequency divider** using a counter.
- Observe how a bit pattern shifts over time.
- Use input buttons to inject bits into the register.

---

## Main signals and mapping

### Inputs

- `clock`  
  Main FPGA clock (≈ 27 MHz on this board).

- `reset`  
  Active-high asynchronous reset for both the counter and the register.

- `key[7:0]`  
  Input buttons.  
  They are OR-reduced to form a single signal:

  ```sv
  wire button_on = |key;
  ```