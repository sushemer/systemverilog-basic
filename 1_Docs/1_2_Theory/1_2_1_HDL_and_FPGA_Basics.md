# HDL and FPGA basics

This document introduces two fundamental ideas:

- What an **HDL** (Hardware Description Language) is.
- What an **FPGA** is and how it differs from other programmable devices.

---

## 1. What is an HDL?

An HDL (Hardware Description Language) is a language for describing **digital circuits**, not programs that run step by step like in C, Python, or Java.

With an HDL:

- You describe **signals**, **registers**, **modules**, and **connections**.
- You specify what happens on each **clock edge** or how signals combine.
- The final result can be synthesized into **real hardware** (FPGA, ASIC).

Examples of HDLs:

- Verilog  
- SystemVerilog  
- VHDL  
- Other higher-level hardware languages (Chisel, etc.)

In this repository we primarily use **SystemVerilog** (a modern extension of Verilog).

---

## 2. What is an FPGA?

An FPGA (Field Programmable Gate Array) is an integrated circuit that can be configured after manufacturing.

Instead of having fixed logic (like a microcontroller with a predefined CPU), an FPGA contains:

- **LUTs** (Look-Up Tables): small configurable logic functions.
- **Flip-flops / registers**: 1-bit storage elements tied to the clock.
- **Memory blocks** (BRAM).
- **Special blocks** (multipliers, PLL, etc.).
- A **programmable interconnect network** that links everything.

When you load a **bitstream** into the FPGA, you define:

- What each LUT does.
- How signals are connected.
- What registers exist and how they behave.

Your SystemVerilog code becomes this internal configuration.

---

## 3. FPGA vs. microcontroller (quick view)

| Aspect                | FPGA                                       | Microcontroller                              |
|-----------------------|---------------------------------------------|-----------------------------------------------|
| Execution model       | Many blocks running in parallel.           | CPU executing sequential instructions.         |
| Flexibility           | Very high—logic can change completely.     | Moderate—CPU is fixed, you change firmware.    |
| Typical tasks         | High-speed signals, custom interfaces, parallel processing. | General control, sequential logic, built-in peripherals. |
| Tools                 | Synthesizer, place-and-route, bitstream.   | Compiler, linker, firmware flasher.            |

In this project we do not use an external microcontroller; the **FPGA is the main “brain.”**

---

## 4. What does this repository do?

This repository provides a practical learning path with **small, hands-on examples** on the Tang Nano 9K:

- Basic activities (gates, muxes, counters).
- More integrated labs (debounce, FSM, sensors, display).
- Larger implementations (digital clock, ultrasonic radar, etc.).

The idea is that you can:

1. See the example running on real hardware.  
2. Open the SystemVerilog code.  
3. Modify it and experiment.  
4. Relate the code to the LEDs, displays, and sensors.

---

## 5. What this repository is not

- It is not a full digital theory course (Boolean algebra, Karnaugh maps, etc.), although those concepts appear.
- It does not cover all of SystemVerilog or all possible tools.
- It is not an official Gowin or Tang Nano 9K guide.

Instead, it focuses on:

- Small, concrete examples.
- Commented code.
- Clear folder structure.
- Simple scripts for synthesis and programming.

---

## 6. How it fits into your learning

You can use this material in different ways:

- As support material for a course on logic or digital systems.
- As a practical introduction to FPGAs if you come from software (C, Python, etc.).
- As a starting point for personal FPGA projects.

If you have microcontroller experience, think of an FPGA as:

- A place where, instead of writing “a program,” you design **the circuit** you want inside (or around) the microcontroller.
- Many things happen **in parallel**, not in a fixed instruction sequence.

---

## 7. Next step

To continue with the basic theory, you can read:

- `1_2_2_Verilog_SystemVerilog_Overview.md`
- `1_2_3_Modules_and_Ports.md`
- `1_2_4_Combinational_vs_Sequential.md`
