# 3.10 Hex counter on 7-segment display

This example implements a **32-bit hexadecimal counter** and shows it on an **8-digit 7-segment display**.  
The counting speed can be adjusted in real time using two keys (`key[0]` and `key[1]`).

---

## Objective

By the end of this example, the user will be able to:

- Understand how to control the **frequency** of a counter using a `period` register.
- Implement a 32-bit counter (`cnt_2`) that increments using a variable period.
- Visualize the counter value in **hexadecimal** on a 7-segment display.
- Reuse the generic module `seven_segment_display` in this repository.

---

## Signals and pins

### Inputs

- `clock`  
  Main FPGA clock (≈ 27 MHz on this board).

- `reset`  
  Active-high asynchronous reset; sets `period`, `cnt_1`, and `cnt_2` to zero.

- `key[7:0]`  
  Only two bits are used:
  - `key[0]` → Increase period → slower counter  
  - `key[1]` → Decrease period → faster counter  

### Outputs

- `led[7:0]`  
  Shows the lower 8 bits of `cnt_2`:

  ```sv
  assign led = cnt_2[7:0];
  ```