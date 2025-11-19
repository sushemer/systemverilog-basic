# 2. Devices · Base hardware

The `2_devices` folder gathers all information related to the **physical hardware** used in the repository:

- The **Tang Nano 9K FPGA** board  
- **Sensors** (inputs)  
- **Actuators** (outputs)  
- Common notes on **protoboard and wiring**  
- Conventions to keep hardware documented and reproducible  

The goal is that before wiring anything or modifying constraints, it is possible to:

- See **which devices** are used  
- Understand **how they connect** to the Tang Nano 9K  
- Adopt the same **naming and wiring conventions** in examples, activities, and labs  

---

## 2.1 Boards · Boards

Main path:

    2_devices/
     └─ 2_1_Boards/
         └─ 2_1_1_Tang_Nano_9K/
             ├─ docs/
             │   ├─ pinout.md
             │   ├─ power_notes.md
             │   └─ programming.md
             └─ constr/
                 └─ tang-nano-9k.cst

### 2.1.1 Tang Nano 9K

Main FPGA board used in the entire repository.

- **Purpose**  
  Base platform for all activities, labs, and implementations.  
  All SystemVerilog examples are designed for this board and this constraints file.

- **Key files**
  - `docs/pinout.md`  
    Summary of relevant pins (clock, GPIO, LCD, TM1638, expansion pins, etc.)
  - `docs/power_notes.md`  
    Notes on power, voltage levels, and safety considerations
  - `docs/programming.md`  
    How to program the Tang Nano 9K (Gowin Programmer, scripts, connection mode)
  - `constr/tang-nano-9k.cst`  
    Gowin constraints file — the **single source of truth** for mapping:
    - Logical signals (`clock`, `gpio`, `tm1638_*`, `lcd_*`, etc.)  
    - To physical FPGA pins  

> Recommendation: always check this `.cst` before changing wiring or pin assignments.

---

## 2.2 Sensors · Inputs

Sensors are organized under:

    2_devices/
     └─ 2_2_Sensors/
         ├─ 2_2_X_Sensor_A/
         ├─ 2_2_Y_Sensor_B/
         └─ ...

Each sensor should ideally contain:

- A `README.md` describing:
  - The sensor purpose  
  - Relevant pins  
  - Interface type (digital, PWM, SPI, I²C, trigger/echo, etc.)
- Links to its datasheet or external documentation  
- Simple wiring diagrams or photos when useful  

Sensors expected in this repository:

- **HC-SR04 (ultrasonic distance)**  
  - Signals: `TRIG`, `ECHO`, `VCC`, `GND`  
  - Level notes: `ECHO` is usually 5 V → requires level shifting
- **Rotary encoder (KY-040 or similar)**  
  - Signals: `CLK`, `DT`, `SW`, `VCC`, `GND`  
  - Used for menu navigation or value adjustment
- **Potentiometer + external ADC**  
  - Potentiometer acts as voltage divider  
  - ADC communicates via SPI or I²C  

Images may be stored in a `Mult/` folder inside each sensor directory.

---

## 2.3 Actuators · Outputs

Actuators are organized under:

    2_devices/
     └─ 2_3_Actuators/
         ├─ 2_3_X_TM1638/
         ├─ 2_3_Y_LCD_480x272/
         └─ ...

Typical examples:

- **TM1638** (7-segment display + LEDs + keys)  
  - Signals: `VCC`, `GND`, `STB`, `CLK`, `DIO`  
  - Used as both output (display) and input (keys)

- **LCD 480×272 (4.3")**  
  - Data, sync, and backlight connections  
  - Used as graphical output in some labs/implementation

- **Buzzer / small speaker** (for sound examples)

- **Servos / motors** (if added for PWM exercises)

Each actuator folder should document:

- Working voltages  
- Connectors and pin numbering  
- Protection notes (resistors, transistors, etc.)

Recommended: subfolder `Mult/` for wiring photos.

---

## 2.4 Protoboard and wiring

Some devices use protoboard wiring.  
This section may include:

- General protoboard recommendations  
  - Power rail distribution  
  - Separation of power and data signals  

- Example diagrams/photos:
  - Tang Nano 9K on base + protoboard with potentiometer and HC-SR04  
  - 3.3 V / 5 V rail distribution  

Images should follow the pattern:

    2_devices/
     └─ 2_4_Breadboard/
         └─ Mult/
             ├─ base_wiring_top.jpg
             └─ base_wiring_side.jpg

---
