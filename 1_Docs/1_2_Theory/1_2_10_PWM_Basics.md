# 1.2.10 PWM basics

This document introduces **PWM (Pulse Width Modulation)** and how it is used in this repository to:

- Control LED brightness  
- Control servo position (with specific timing)  
- Represent “analog-like” levels using digital signals  

---

## 1. What is PWM?

PWM consists of:

- Generating a digital signal (0 or 1)  
- Keeping a **fixed period** (T)  
- Varying the **duty cycle**: the percentage of time the signal stays at 1 within each period  

Examples:

- 0% → always 0  
- 25% → 25% high, 75% low  
- 50% → equal high/low  
- 100% → always high  

Although digital, the **average energy** produces analog effects:

- LEDs appear brighter at higher duty  
- Servos interpret pulse width as position  

---

## 2. Counter + compare PWM

Typical implementation:

1. A counter runs from 0 to max (e.g., 0–255)  
2. A **duty** value is set  
3. Output is high when `counter < duty`, otherwise low  

This creates a PWM proportional to `duty`.

---

## 3. PWM frequency

PWM frequency depends on:

- Clock frequency  
- Counter size  

Example:

- `clk = 27 MHz`  
- 8-bit counter  

PWM freq ≈ 27 MHz / 256 ≈ 105 kHz

For LEDs:

- Several kHz is enough to avoid visible flicker  

---

## 4. PWM usage in this repository

Typical applications:

- **LED dimming** (duty from buttons, encoder, or ADC)  
- **Servo control** (requires 20 ms frame + specific pulse width)  
- **Level indicators** (brightness reflects measurement)  

Related files:

- `1_2_5_Registers_and_Clock.md`  
- `1_2_6_Timing_and_Dividers.md`  
- `1_2_11_ADC_Basics.md`  

These concepts are used throughout activities and labs involving LEDs, servos, and other actuators.
