# 2.4 Common · Protoboard and wiring

The `2_4_Common` folder gathers general notes on **protoboard**, **wiring**, and **best practices** when connecting the Tang Nano 9K with the sensors and actuators in the repository.

It does not describe a specific device; instead, it provides rules and recommendations that apply to:

- HC-SR04  
- Rotary encoder  
- Buttons/switches  
- 7-segment displays  
- TM1638 module  
- LCD 16x2

---

## 1. Protoboard · General idea

The **protoboard** allows temporary connections without soldering.  
Typical rules (standard model):

- The **central rows** are connected in groups of 5 holes.
- The **side rails** (marked with + and −) are usually power rails:
  - One rail for **VCC**
  - One rail for **GND**

Recommendations:

- Reserve one rail for **3.3 V** (FPGA logic).
- If using a 5 V module (e.g., HC-SR04), be clear about:
  - Where the 5 V rail is.
  - How the level is adapted before reaching the FPGA (especially for input signals).

---

## 2. Common GND

Basic rule for the entire repository:

> **All modules must share the same GND as the Tang Nano 9K.**

This applies to:

- HC-SR04 (even if powered at 5 V).
- TM1638  
- Rotary encoder  
- LCD 16x2  
- Any other board or auxiliary power source  

Without a common GND:

- Voltage references do not match.
- Signals that “appear” 0/1 on one module may not be interpreted correctly by the FPGA.

---

## 3. Typical voltages

- The **Tang Nano 9K** operates at **3.3 V** on its IO pins.
- Some modules (HC-SR04, some TM1638, some 16x2 LCDs) often operate at **5 V**.

General rule:

- **Never** connect a 5 V output directly to an FPGA input without checking:
  - Module datasheet  
  - Level shifting recommendations  

Important example:

- **HC-SR04 → ECHO**:
  - Usually outputs 5 V  
  - Must pass through a resistor divider or level shifter before reaching the FPGA  

---

## 4. Wires and organization

To make examples easier to reproduce:

- Use **short wires** when possible.
- Avoid wires crossing over the board unnecessarily.
- Maintain an approximate color code (recommendation, not mandatory):
  - **Red** → VCC  
  - **Black** → GND  
  - Other colors → signals (`clk`, `tm_clk`, `lcd_rs`, etc.)  

Practical suggestion:

- Document in the READMEs of each example/lab:
  - Which rail each VCC/GND goes to  
  - What wire color was used (optional but helpful in lab)  

---

## 5. Typical mounting examples

### 5.1 HC-SR04

- `VCC` → **5 V** rail (power supply or regulator module)  
- `GND` → **GND** rail shared with Tang Nano 9K  
- `TRIG` → FPGA GPIO pin (3.3 V)  
- `ECHO` → FPGA GPIO **through** a divider or level shifter  

### 5.2 Rotary encoder

- `VCC` → **3.3 V** rail (if the module supports it; check specs)  
- `GND` → GND rail  
- `ENC_A`, `ENC_B`, `ENC_SW` → FPGA input pins  

### 5.3 7-segment / TM1638 / LCD 16x2

- Power according to the module (3.3 V or 5 V — always verify)  
- Data/control signals to FPGA GPIO pins  
- Each module’s README includes:
  - Recommended signal names  
  - Suggested pins  
  - Additional notes (brightness, contrast, etc.)  

---

## 6. Common files and assets

This folder may include:

- Simple wiring diagrams (protoboard layouts)  
- Reference photos of builds  
- Generic wiring templates (e.g., marking 3.3 V, 5 V, GND rails)  

These resources should be kept lightweight and focused on:

- Visual clarity  
- Reusability across examples and labs  
