# 3.7 Binary counter

This example implements a **binary counter** using the Tang Nano 9K clock
and displays its most significant bits on the LEDs. It is a classic way to:

- Verify that the clock and reset are working.
- Observe how the bits of a binary counter toggle at different frequencies.
- Practice **sequential logic** (flip-flops, `always_ff`, asynchronous reset).

An **optional variant** is also included where the counter only advances
when a key is pressed (and released).

---

## Objective

At the end of this example, the user will be able to:

- Understand the difference between **combinational** and **sequential** logic.
- Implement a simple binary counter in SystemVerilog.
- Relate the clock frequency to the LED blinking rate.
- Extend the design to key-controlled variants.

---

## Main signals and mapping

### Inputs

- `clock`  
  Main board clock (≈ 27 MHz in this configuration).

- `reset`  
  Asynchronous reset signal (active high).  
  Its physical origin depends on the `board_specific_top.sv` and the board’s `.cst`
  file (usually a reset button).

- `key[7:0]`  
  Button/key inputs.  
  **Not used in the basic free-running counter.**  
  Only used in the optional key-controlled variant.

### Outputs

- `led[7:0]`  
  Display the most significant bits of the counter:

  assign led = cnt[W_CNT-1 -: 8];
