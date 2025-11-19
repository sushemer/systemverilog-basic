# Ultrasonic HC-SR04 basics

This document explains how the **HC-SR04** ultrasonic sensor works and how it integrates with the FPGA.

---

## What does the HC-SR04 measure?

It measures **distance** using ultrasound:

- Sends a sound burst  
- Waits for echo  
- Measures echo delay time  
- Distance ≈ (time * speed_of_sound) / 2  

---

## Main pins

- `VCC` (5 V)  
- `GND`  
- `TRIG` → FPGA output  
- `ECHO` → FPGA input (MUST be level-shifted to 3.3 V)

---

## Measurement sequence

1. FPGA sends a short high pulse to `TRIG` (≥10 µs)  
2. Sensor emits ultrasound and sets `ECHO` HIGH  
3. `ECHO` stays HIGH until the echo returns  
4. FPGA measures the HIGH duration  
5. Convert measured ticks to time, then to distance  

---

## Measuring time on FPGA

Use a **counter**:

- Reset counter on rising edge of ECHO  
- Increment counter every clock  
- Capture final value at falling edge of ECHO  

Then convert:

- Ticks → microseconds  
- Microseconds → centimeters  

Depends on clock frequency.

---

## Practical considerations

- Typical range: a few cm to ~4 m  
- Unreliable very close to sensor  
- Temperature affects sound speed slightly  
- Noise → average several readings  
- Discard out-of-range anomalies  

---

## Typical use in this repository

Examples:

- `ultrasonic_hcsr04_measure_demo`  
- `ultrasonic_hcsr04_cm` lab  
- “Ultrasonic radar” mini-project (servo + distance visualization)

---

## Related theory

- Timing (`1_2_6`)  
- Registers & clock (`1_2_5`)  
- FSMs (`1_2_7`)  

Level shifting and wiring documented in `2_devices/`.
