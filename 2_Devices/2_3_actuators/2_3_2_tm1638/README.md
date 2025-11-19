# 2.3.2 TM1638 · 7-segment module + LEDs + keys
![alt text](Mult/image.png)

The **TM1638** module integrates on a single board:

- 8 digits of 7-segment display.
- 8 individual LEDs.
- 8 keys (buttons).

All controlled by the **TM1638** chip, which communicates with the FPGA through a simple synchronous protocol.

In this repository it is used as a compact user interface to:

- Display numbers and states.
- Turn LEDs on/off.
- Detect pressed keys.

---

## Logical signals and pins

The TM1638 uses three main lines to the FPGA:

- `TM_DIO` → bidirectional data line.
- `TM_CLK` → communication clock.
- `TM_STB` → “strobe” or module-select signal.

In code you may see names like:

- `tm_dio`
- `tm_clk`
- `tm_stb`

These lines connect to Tang Nano 9K `GPIO[x]` pins and are documented in:

- `2_1_Boards/2_1_1_Tang_Nano_9K/docs/pinout.md`
- `2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

---

## Key concepts

### Basic protocol

The TM1638 is controlled by sending and receiving bit “frames” through `TM_DIO`, synchronized by `TM_CLK`, and using `TM_STB` to indicate the start/end of an operation.

Typical operations:

- Send configuration commands.
- Write data for 7-segment digits and LEDs.
- Read the state of the keys.

### Inputs and outputs in the same module

Although this folder is in **Actuators**, the TM1638:

- **Displays information** (7-segment digits + LEDs).
- **Receives input** (keys).

The TM1638 keys behave as digital inputs, but they are read:

- Through data frames.
- Over the same `TM_DIO` line.

Bounce and edge concepts follow `Buttons_Switches`, though handled here at the protocol level.

---

## Relationship with theory

This module relies on:

- `1_2_3_Modules_and_Ports.md`  
  Organization of modules for the TM1638 driver.

- `1_2_4_Combinational_vs_Sequential.md`  
  Logic for handling protocol states.

- `1_2_5_Registers_and_Clock.md`  
  Registers to store display data and key states.

- `1_2_6_Timing_and_Dividers.md`  
  Timing generation for the communication bus.

- `1_2_9_Buses_Overview.md`  
  General concepts of serial communication.

---

## Related examples, activities, and labs

Typical ideas:

- **Examples**
  - Turn on a fixed pattern on display and LEDs.
  - Read the keys and show the pressed key number.

- **Activities**
  - Counter that increments/decrements depending on the key pressed.
  - Show on digits the value of a counter or measurement (e.g., HC-SR04 distance).

- **Labs / Implementation**
  - Menu controlled by TM1638 keys, with states shown on 7-segment displays.
  - Control panel for a mini-project (e.g., measurement system with visual alarms).

Exact names of Examples/Activities/Labs will be defined when the folder organization is finalized.

---
