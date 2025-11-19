# 3. Examples – SystemVerilog Examples for Tang Nano 9K + LCD + TM1638

This directory contains **small, self-contained SystemVerilog examples** designed for:

> **Tang Nano 9K + 480×272 LCD + TM1638 (Hackathon board)**

Each example focuses on one or two core concepts (logic gates, muxes, counters, displays, sensors, encoders, etc.).  
They are intended to be:

- Short enough to read in a single sitting  
- Easy to synthesize and load onto the board  
- A bridge between **theory** (`1_docs/`) and **activities/labs** (`4_activities/`, `5_labs/`)

Most examples use `hackathon_top` and depend on the board wrapper:

`boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/`

---

## List of Examples

### **3.1 – AND/OR/NOT/XOR + De Morgan**
Basic logic gates.  
Verifies De Morgan’s law visually using LEDs.

---

### **3.2 – 2:1 Multiplexer**
Multiplexer implemented with `if/else`, ternary operator, and `case`.

---

### **3.3 – 2-to-4 Decoder**
One-hot decoder implemented in multiple styles.

---

### **3.4 – Priority Encoder**
3-bit priority encoder and comparison between implementations.

---

### **3.5 – 4-bit Comparator**
Compares two 4-bit numbers and outputs `<`, `=`, `>` on LEDs.

---

### **3.6 – 3-bit Adder/Subtractor**
Arithmetic using `+` / `-` and also using two’s complement formulation.

---

### **3.7 – Binary Counter**
Free-running counters + LED blinking using divided clock.

---

### **3.8 – Shift Register LED Animation**
Simple LED animations (KITT-style bouncing lights).

---

### **3.9 – Seven-Segment Letters**
Displays letters (F, P, G, A…) on a 7-segment digit.

---

### **3.10 – Hex Counter on 7-Segment**
Variable-speed hexadecimal counter displayed on TM1638.

---

### **3.11 – Seven-Segment Basics**
Manual control of `abcdefgh` and `digit`.  
“Hello world” for 7-segment displays.

---

### **3.12 – Hex Counter (Multiplexed)**
Full 32-bit hex counter across 8 digits using manual multiplexing.

---

### **3.13 – LCD Basic Shapes**
Draws static shapes based on pixel coordinates (`x`, `y`).

---

### **3.14 – LCD Moving Rectangle**
A red rectangle moves horizontally using a strobe + counter.

---

### **3.15 – Potentiometer Read Demo (Simulated)**
Simulated ADC using switches (`key[7:0]`).  
Displays value on LEDs, TM1638, and LCD bar.

---

### **3.16 – TM1638 Quickstart**
Basic functionality test: keys → LEDs → seven-segment.

---

### **3.17 – Ultrasonic Distance (HC-SR04)**
Reads echo pulse to obtain relative distance.  
Displays it on LEDs, TM1638, and LCD bar.

---

### **3.18 – Rotary Encoder (KY-040)**
Reads encoder phases A/B.  
Displays value on LEDs, TM1638, and shows a threshold on LCD.

---

## Recommended Workflow

1. Start with **3.11** and **3.16** for seven-segment basics.  
2. Move to **3.13** and **3.14** for LCD basics and animation.  
3. Explore input devices:
   - **3.15** (potentiometer simulation)
   - **3.17** (ultrasonic)
   - **3.18** (rotary encoder)

These examples give a strong foundation before jumping into:

- **Activities (4_activities)**  
- **Labs (5_labs)**  
- **Full projects (6_applications)**

---