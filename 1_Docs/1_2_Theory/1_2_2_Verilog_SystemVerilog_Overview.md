# Verilog / SystemVerilog overview

This document provides a quick overview of **Verilog** and **SystemVerilog** and clarifies:

- What they are.
- How they are similar and different.
- What **practical subset** we will use in this repository.

The goal is to give context, **not** to cover the full language standard.

---

## 1. Verilog in a nutshell

Verilog was created as a language to describe and simulate digital hardware, focusing on:

- **Modules** with inputs and outputs.
- **Signals** (`wire`, `reg` in classic Verilog).
- **Behavioral blocks** (`always`, `initial`).
- **Continuous assignments** (`assign`) for combinational logic.
- **Time simulation** (delays, events, etc.).

With Verilog you can model:

- **Combinational logic** (adders, comparators, muxes…).
- **Sequential logic** (flip-flops, registers, FSMs).
- Designs ranging from small blocks to complex systems.

---

## 2. What does SystemVerilog add?

SystemVerilog extends Verilog with:

- Clearer types like `logic` (instead of `reg`/`wire` in many cases).
- Specialized blocks:
  - `always_ff` for sequential logic.
  - `always_comb` for combinational logic.
- Richer data structures:
  - `struct`, `enum`, `typedef`, improved arrays, etc.
- Advanced verification features:
  - Classes, randomization, assertions, interfaces, etc.

In this repository we **do not** use the advanced verification features.  
We focus on the **synthesizable subset** that becomes hardware.

---

## 3. Subset used in this repository

Most examples use:

- Module declarations:

  ```sv
  module module_name (
      input  logic clk,
      input  logic reset,
      input  logic [7:0] a,
      output logic [7:0] y
  );
  ```
  