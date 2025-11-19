# LCD HD44780 basics

This document introduces the basics of **character LCDs** based on the **HD44780** controller (e.g., 16x2, 20x4).

---

## What is a character LCD?

A character LCD:

- Shows text in a matrix (16x2, 20x4, etc.)
- Cannot draw arbitrary graphics  
- Displays predefined characters:
  - Letters, numbers, symbols  
  - Some limited custom characters  

Typical uses in this repo:

- Display messages (“HELLO”, “READY”, “ERROR”)  
- Show counters or sensor measurements  
- Simple menus  

---

## HD44780 controller

The HD44780:

- Manages pixel driving  
- Stores characters internally  
- Interprets commands (clear, set cursor, etc.)

From the FPGA side, it appears as:

- Control lines  
- A data bus (4- or 8-bit)  
- Optional contrast/backlight controls (external)

---

## Main signals

In parallel mode:

- `RS`  
  - 0 → command  
  - 1 → data  

- `E`  
  - Enable pulse to latch data  

- `D[7:0]`  
  - Data bus (can be reduced to 4 bits: D7–D4)

- `R/W`  
  - Often tied to ground (write-only)

Plus power, contrast, and backlight connections.

---

## Connection modes: 8-bit, 4-bit, I²C

1. **8-bit parallel**
   - Uses all data lines  
   - Faster, but uses more FPGA pins  

2. **4-bit parallel**
   - Sends each byte in two nibbles  
   - Saves pins  

3. **I²C backpack** (e.g., PCF8574)
   - FPGA uses only `SCL`/`SDA`  
   - Backpack drives LCD signals  
   - Uses far fewer FPGA pins  

---

## Initialization

LCD requires a specific init sequence:

1. Wait after power-up  
2. Send mode selection (4/8 bit, lines, font)  
3. Turn display/cursor on or off  
4. Clear display  
5. Position cursor  

This sequence is handled inside LCD driver modules in examples.

---

## Writing text & cursor movement

- For characters:  
  - RS = 1  
  - Send character code  

- For cursor commands:  
  - RS = 0  
  - Send command (set address, clear, etc.)

Drivers abstract address mapping and command sequences.

---

## Typical usage in this repo

Examples:

- Display “HELLO”  
- Show counters or sensor values  
- Menu navigation (advanced labs)  

---

## Related theory

- `1_2_6_Timing_and_Dividers.md` → delays between commands  
- `1_2_7_Finite_State_Machines.md` → FSM for initialization sequences  
- `1_2_9_Buses_Overview.md` → I²C (when backpack is used)  

Device-specific wiring is documented in `2_devices/`.
