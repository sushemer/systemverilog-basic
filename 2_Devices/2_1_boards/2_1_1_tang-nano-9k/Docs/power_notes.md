# Power notes and logic levels · Tang Nano 9K

This document summarizes the basic **power** and **signal-level** considerations when using the Tang Nano 9K with the examples in this repository.

It is not a replacement for the datasheet, but a quick guide to avoid common mistakes.

---

## 1. Main logic levels

- Most user IOs on the Tang Nano 9K operate at **3.3 V logic**.
- In the `tang-nano-9k.cst` constraints file, signals such as:
  - `CLK`, `KEY[x]`, `LED[x]`, `GPIO[x]`
  are assumed to be 3.3 V.
- Some special pins are marked as **1.8 V** in the original `.cst` and **are not used** in the basic examples.

> General rule:  
> Treat all user IOs as 3.3 V signals unless the official documentation states otherwise.

---

## 2. Board power

In most cases:

- The Tang Nano 9K is powered through the **USB connector**.
- Internally, it regulates the voltages required for the FPGA and logic.

Recommendations:

- Use a PC USB port or a reliable charger/hub.
- Avoid connecting/disconnecting external modules while the board is powered, especially if voltage levels are uncertain.

---

## 3. Common GND

When connecting external sensors or actuators:

- The 5 V source (if used) and the Tang Nano 9K must share **ground (GND)**.
- Always connect the external module’s `GND` to the board’s `GND`.

Without common ground:

- Signals have no common reference.
- The FPGA is likely to read incorrect values or behave unpredictably.

---

## 4. 5 V modules (sensors/actuators)

Many commercial modules (HC-SR04, servos, some LCDs, etc.) operate at **5 V supply**, but their data lines must be compatible with the FPGA:

- **Towards the FPGA (input)**:
  - Never connect a **5 V** output directly to a Tang Nano 9K IO pin.
  - Use **voltage dividers** or **level shifters**.

- **From the FPGA (output)**:
  - A 3.3 V output is generally understood as “logic high” by most 5 V modules, but always check the datasheet.

Example:

- `HC-SR04`:
  - `VCC` to 5 V.
  - `TRIG` can be driven with 3.3 V.
  - `ECHO` must be reduced from 5 V to 3.3 V (divider or level shifter).

---

## 5. Current limitations

- FPGA IO pins are designed for **logic signals**, not power loads.
- Do NOT connect:
  - Motors directly to IO pins.
  - Relays or high-current actuators without intermediate drivers (transistors, MOSFETs, etc.).

The onboard LEDs usually have built-in resistors or a safe design, but external LEDs must include their own current-limiting resistor.

---
