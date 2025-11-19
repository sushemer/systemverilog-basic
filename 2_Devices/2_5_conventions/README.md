# 2.5 Conventions · Device usage conventions

This folder gathers the **conventions** followed in `2_devices` to:

- Keep pin assignments consistent  
- Unify signal names  
- Standardize documentation for each device  
- Improve safety and reproducibility of builds  

The goal is for collaborators to extend the project without breaking the existing organization.

---

## 1. Centralized constraints file

- Pin assignments for the Tang Nano 9K are defined in a single file:

  2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst

- Each Example, Activity, Lab, or Implementation must:
  - Reuse this `.cst` or a documented variant  
  - Avoid creating many contradictory versions for the same board  

Practical rule:

> If a device pin is changed, first update `.cst` and `pinout.md`, then update READMEs and code.

---

## 2. Coherent signal names

Signal names should be consistent across:

- SystemVerilog code  
- `.cst` file  
- Device documentation (`README.md`)  

Examples of naming conventions:

- General signals:
  - `clk`, `rst_n`, `btn`, `led[5:0]`
- HC-SR04:
  - `hcsr04_trig`, `hcsr04_echo`
- Rotary encoder:
  - `enc_a`, `enc_b`, `enc_sw`
- Buttons/switches:
  - `btn_a`, `btn_b`, `sw_mode`
- 7-segment:
  - `seg[6:0]`, `seg_dp`, `digit_en[3:0]`
- TM1638:
  - `tm_dio`, `tm_clk`, `tm_stb`
- LCD 16x2:
  - `lcd_rs`, `lcd_en`, `lcd_d[3:0]`

The goal is for the signal name in code or `.cst` to make it easy to find the corresponding device documentation.

---

## 3. Minimum README structure for each device

Each device folder in `2_2_Sensors` and `2_3_Actuators` must include a `README.md` with at least:

1. **Purpose**  
   - What the device does  
   - How it is used in the repository  

2. **Logical signals / pins**  
   - List of signals (`hcsr04_trig`, `hcsr04_echo`, etc.)  
   - Reference to `pinout.md` and `.cst` for physical pins  

3. **Wiring notes**  
   - Basic description of how it connects to Tang Nano 9K and protoboard  
   - Link to `2_4_Common` when applicable  

4. **Basic electrical notes**  
   - Indicate explicitly when a device uses 5 V  
   - Warnings about level shifting needs  

5. **Relation to theory**  
   - Recommend `1_2_Theory` files needed to understand the device  

6. **Relation to Examples / Activities / Labs**  
   - List where it is used (once defined)  
   - Type of use (simple example, guided activity, integrator lab)  

---

## 4. Safety and reproducibility

- Clearly mark all cases involving voltage differences:
  - 3.3 V (FPGA) ↔ 5 V (some modules)

Minimum rules:

- Do not connect 5 V outputs directly to FPGA inputs  
- Always maintain **common GND**  
- Document any special wiring or exceptions  

Avoid “implicit” wiring:

- Always document:
  - Which FPGA pin connects to which module pin  
  - Which rail is used for VCC and GND  

---
