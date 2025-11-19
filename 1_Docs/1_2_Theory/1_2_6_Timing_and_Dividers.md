# 1.2.6 Timing and dividers

This document covers two related topics:

- The idea of **time** in a digital design (timing).
- The use of **clock dividers** to obtain slower signals from a fast clock.

It connects directly with counters, LED patterns, and display multiplexing used in activities and labs.

---

## 1. Time and frequency

Basic concepts:

- **Frequency (f)**: how many cycles per second the clock signal has.  
  Measured in Hz, kHz, MHz, etc.
- **Period (T)**: duration of one complete clock cycle.  
  Relation: `T = 1 / f`.

Example:

- If `f = 27 MHz`:
  - `T ≈ 37 ns`.

In the FPGA:

- All blocks synchronized to the same `clk` share that update period.
- For visible effects (LED blinking at 1 Hz, display multiplexing, LCD sweeps, etc.) much slower timing is needed, so **counters** are used as frequency dividers.

---

## 2. Clock divider using a counter

A typical **clock divider** consists of:

- A counter that increments on each clock edge.
- One or more outputs derived by taking specific bits of that counter.

Example concept:

- With a 24-bit counter incrementing at 27 MHz:
  - Bit 0 toggles at 13.5 MHz  
  - Bit 1 at 6.75 MHz  
  - ...  
  - Bit 23 is much slower (`≈ 27 MHz / 2^24`)

Simple example:

module clock_divider_example (clk, rst_n, slow_clk);

    logic [23:0] counter;

    On each clock edge, counter increments or resets.

    slow_clk = counter[23];   // a slower clock derived from a high bit

endmodule

Key idea:

- The counter runs at full clock speed.
- Picking a high bit generates a much slower square wave.

---

## 3. Dividers based on “enable pulses”

In many designs in this repository, we prefer **not** to create new clock signals.  
Instead we generate an **enable pulse** that is high for just one cycle at fixed intervals.

Example:

- A counter increments continuously.
- When it overflows (returns to 0), the design generates `step_en = 1` for one cycle.
- Any block that wants to operate slowly uses `if (step_en)` inside its sequential logic.

Advantages:

- Only one clock domain.
- Timing analysis becomes easier.
- Slower behavior (like LED scrolling) is driven by pulses, not by new clocks.

---

## 4. Relation with activities and labs

Clock dividers and slow ticks appear throughout the repository:

- **Activities:**
  - Counters and LED shift patterns  
  - 7-segment playground (slow counter mode)  
  - LCD refresh experiments  

- **Labs:**
  - LED blinking at ~1 Hz  
  - KITT-style LED sweep  
  - Sensor + LCD integration with periodic refresh  

---

## 5. Good practices for dividers

- Keep a **single global clock** (`clock`) whenever possible.
- Avoid multiple derived clocks; prefer **enable pulses** (`step_en`, `tick`).
- Use counters wide enough for the desired time periods.
- Comment expected timing (e.g., `// step_en ≈ 10 ms`).
- Do not require extreme precision for visual effects; human perception is forgiving.

These concepts are reused in:

- Digital clock timing  
- Traffic light delay FSM  
- Sensor polling  
- LCD and TM1638 periodic updates  
