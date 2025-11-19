# 6.2 – Servo-Scanned Ultrasonic Radar

## Objective

Design a system that:

1. Controls a **servo** (e.g., SG90) to sweep an arc (e.g., 0°–180°).  
2. Uses the **HC-SR04 ultrasonic sensor** to measure distance at each angle.  
3. Displays:
   - Current angle  
   - Measured distance  
   - A clear alert when an object is detected below a threshold  
4. Stops the sweep when a close object is detected, and either:
   - Waits for user input to resume, **or**
   - Automatically resumes after a timeout  
5. Uses **averaging** or filtering for stable readings.

---

## Suggested hardware

- Tang Nano 9K  
- **HC-SR04**:
  - TRIG from FPGA  
  - ECHO shifted to 3.3 V (divider or level shifter)  
- **Servo SG90** (or similar):
  - Requires 5 V supply  
  - Common GND with FPGA  
  - PWM signal from FPGA (1–2 ms pulse, ≈20 ms period)  
- **LCD 480×272**:
  - Display angle, distance, and radar graphics  
- Buttons or encoder to:
  - Change mode (scan / pause)
  - Adjust detection threshold
  - Resume scanning

---

## Concepts involved

- Generating **PWM** for servo (1–2 ms pulse every 20 ms)
- FSM for servo sweep (left → right → left…)
- Distance measurement with **HC-SR04** (pulse width)
- Averaging N samples for noise reduction
- Integrating sensors with a basic UI (buttons/encoder + LCD)

---

## Proposed behavior

### 1. Servo control

Generate PWM:

- Period ≈ 20 ms  
- Pulse width:
  - ~1.0 ms → left limit (≈0°)
  - ~1.5 ms → center (≈90°)
  - ~2.0 ms → right limit (≈180°)

Sweep FSM:

- State “sweeping right”  
- State “sweeping left”  
- Smoothly adjust pulse width to avoid jumps  

---

### 2. HC-SR04 measurement

At each position (or every N servo steps):

1. Trigger `trig`  
2. Measure the ECHO pulse width  
3. Convert to distance (relative or cm)  
4. Optionally average 2–4 readings  

---

### 3. Object detection and threshold

- Define a **distance threshold** (e.g., 30 cm or equivalent).  
- If `distance <= threshold`:
  - Set detection flag  
  - Stop the servo  
  - Highlight detection:
    - “OBJECT DETECTED” text
    - Color change or symbols  

Resume sweep:

- After button press  
- Or after a timeout (e.g., 3–5 seconds with no detection)

---

### 4. LCD visualization

On the 480×272 LCD:

- Background with a simple frame  
- Graphical area:
  - Small arc showing current servo angle  
  - A moving point along the arc  
  - Different color / thickness when detection occurs
