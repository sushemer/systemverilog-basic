# Seven-segment display basics

This document explains the fundamentals of **7-segment displays** and how they are used in examples and labs in this repository.

---

## Structure of a 7-segment display

A 7-segment digit contains:

- 7 LEDs arranged like an “8”
- Optional **decimal point** (`dp`)

Segments are named:

`a, b, c, d, e, f, g` (and optionally `dp`)

By turning segments ON/OFF you can display:

- Digits 0–9  
- Some letters (A, b, C, d, etc.)

---

## Common anode vs common cathode

### Common anode
- All anodes tied together  
- To turn ON:  
  - Common → VCC  
  - Segment line → LOW (0)

### Common cathode
- All cathodes tied together  
- To turn ON:  
  - Common → GND  
  - Segment line → HIGH (1)

Your logic depends on which type is used. Documentation for this repo specifies the exact ON/OFF polarity.

---

## Segment mapping

To display a character, a **segment map** is defined.

Example for “0” (common-cathode):

Segments a, b, c, d, e, f ON, g OFF.

Often represented as `seg[6:0] = {a,b,c,d,e,f,g}`.

Hex-to-segment decoders output the correct pattern for each digit.

---

## Multi-digit displays and multiplexing

Many boards use **multiple digits** (4 or 8). To save pins, multiplexing is used:

- Segment lines are shared  
- Each digit has an enable line  
- The controller:
  - Enables digit 0 + sets segment pattern  
  - Quickly switches to digit 1 + updates pattern  
  - Repeats fast enough → appears all digits are lit continuously

Modules like `seven_segment_display.sv` manage multiplexing.

---

## Related theory & labs

Concepts linked with:

- Timing & dividers (`1_2_6`) → avoid flicker  
- Registers & clock (`1_2_5`)  
- PWM (`1_2_10`) → brightness control in some cases  

Used in activities/labs:

- Basic 7-segment demos  
- TM1638 multi-digit module  
- Counters, timers, and sensor readings  
