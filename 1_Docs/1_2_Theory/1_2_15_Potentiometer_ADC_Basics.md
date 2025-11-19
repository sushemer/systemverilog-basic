# Potentiometer + ADC basics

This document explains how to use a **potentiometer** with an **ADC** to obtain a digital adjustable value using the FPGA.

---

## What is a potentiometer?

A potentiometer is a variable resistor with three terminals:

- One end to VCC  
- One end to GND  
- Center pin (wiper) gives a variable voltage  

If Vref = 3.3 V:

- Wiper ≈ 0 V → minimum  
- Wiper ≈ 3.3 V → maximum  

Acts as a **voltage divider**.

---

## From variable voltage to digital value: ADC

The FPGA cannot read analog voltages, so an **external ADC** is used.

Setup:

- Potentiometer → ADC input  
- ADC converts to digital (0–255, 0–1023, etc.)  
- FPGA reads the value via SPI or I²C  

---

## General FPGA flow

1. FPGA communicates with ADC  
2. Receives digital value  
3. Uses the value for:
   - PWM duty  
   - Servo angle  
   - Thresholds / levels  
   - Menu selection  

---

## Scaling and mapping

Examples:

- LED brightness with 5 levels  
- Servo angle mapping (0°, 90°, 180°)  
- Menu position mapping  

Conversion done with combinational logic.

---

## Example usage

- `pot_read_demo`  
- LED dimmer  
- Parameter tuning (thresholds, delays)  
- Menus controlled by potentiometer  

---

## Related theory

- `1_2_11_ADC_Basics.md`  
- `1_2_9_Buses_Overview.md`  
- `1_2_10_PWM_Basics.md`  
- `1_2_12`, `1_2_13` for displaying the value  

Specific ADC wiring is in `2_devices/`.
