# 6. Implementation – Mini-Project Proposals

This folder contains **implementation proposals** that integrate multiple topics from the repository:

- Sequential design (counters, FSMs, clock dividers)
- Display handling (seven-segment / TM1638)
- Sensors (HC-SR04)
- External peripherals (servo, LCD)

> Note: these are **proposed projects**, not mandatory assignments.  
> They can be adapted to the available hardware (e.g., using only TM1638 + 480×272 LCD if you do not have a 16×2 display or servos).

---

## 6.1 Clock

A digital clock on seven-segment displays (or TM1638) with:

- Stable timebase derived from the FPGA clock.
- **12 h / 24 h** time formats.
- Minute adjustment with **±1, ±5, ±10** steps via buttons (or a rotary encoder).
- Correct rollover handling:
  - Minutes: 59 → 00
  - Hours: 23 → 00 (24 h mode)
  - 12/11 → 1/12 depending on 12 h logic, if implemented.
- Flicker-free, glitch-free display.

---

## 6.2 Servo-scanned ultrasonic radar

A simple “radar” system that:

- Sweeps an arc using a **servo** (e.g., SG90).
- Measures distance with the **HC-SR04** at each angle.
- Displays on the screen:
  - Current angle
  - Measured distance
  - Visual highlight when an object is detected below a threshold
- Applies averaging for stable readings.
- Stops the servo when a nearby object is detected, and resumes scanning:
  - either after a timeout  
  - or when the user requests it (button/encoder).
