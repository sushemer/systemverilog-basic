# 1.4.3 Peripherals and buses terms

Terms related to peripherals (sensors, actuators) and communication buses used in the repository.

---

### GPIO (General-Purpose Input/Output)

General-purpose pins configurable as digital input or output.  
Used on the FPGA to connect buttons, LEDs, 7-segment displays, buzzers, etc.

---

### Bus

Set of lines (signals) that transmit information between modules or between the FPGA and a peripheral.  
It may be:

- Parallel (multiple bits in parallel, e.g., `led[7:0]`)  
- Serial (bits sent one after another: SPI, I²C)

---

### ADC (Analog-to-Digital Converter)

Converts an analog voltage into a digital number.  
The FPGA uses it to read analog signals, such as a potentiometer.  
This repository uses external ADCs (MCP3008, ADS1115, ADC0832, etc.).

---

### PWM (Pulse Width Modulation)

Technique that uses a fixed-period digital signal with a variable duty cycle to emulate analog levels.  
Used in this repository to control LED brightness and servo position.

---

### Seven-segment display

Display formed by 7 LEDs arranged in the shape of an “8” (plus optional decimal point).  
Uses segment combinations to represent digits and some letters.  
In the repository it is used to show counters, results, and simple states.

---

### LCD (Liquid Crystal Display) HD44780

Character display (typically 16x2 or 20x4) based on the HD44780 controller or compatible ones.  
Used to display text (messages, numeric values, menus).  
Can be connected in 4/8-bit parallel mode or through an I²C backpack (PCF8574).

---

### TM1638

Controller/module integrating:

- 7-segment displays  
- Several keys  
- Individual LEDs  

Communicates with the FPGA via a simple serial protocol (CLK, DIO, STB).  
Used in this repository for compact user interfaces.

---

### PCF8574

8-bit I/O expander via I²C.  
Allows increasing available digital I/O using only two lines (SCL, SDA).  
Commonly used to control HD44780 LCDs through an I²C backpack.

---

### HC-SR04

Ultrasonic distance sensor.  
Uses a pulse on `TRIG` to start the measurement and returns a pulse on `ECHO` whose duration is proportional to the measured distance.  
The FPGA measures the width of the `ECHO` pulse using counters.

---

### Servo (e.g., SG90)

Rotational actuator positioned according to the width of a fixed-period PWM pulse (~20 ms).  
In the repository, custom PWM modules are used to generate 1–2 ms pulses for positions such as 0°, 90°, 180°.

---

### Potentiometer

Variable resistor with three terminals acting as a voltage divider.  
When connected to an ADC, it provides an adjustable digital value (e.g., for brightness, position, thresholds).

---

### Buzzer (active / passive)

Device that produces sound:

- **Active buzzer**: produces sound when driven with a stable logic level (frequency generated internally).  
- **Passive buzzer**: requires a PWM signal at a specific frequency to produce a tone.

Used with PWM or clock dividers to generate simple tones/melodies.

---

### SPI (Serial Peripheral Interface)

Synchronous serial bus with typical lines:

- `SCK` (clock)  
- `MOSI` (Master Out, Slave In)  
- `MISO` (Master In, Slave Out)  
- `CS` / `SS` (Chip Select)

The FPGA acts as master and controls communication with devices such as some ADCs.

---

### I²C (Inter-Integrated Circuit)

Two-wire serial bus:

- `SCL` (clock)  
- `SDA` (bidirectional data)

Supports multiple devices with addresses.  
Used with expanders (PCF8574), some ADCs, and LCD modules with I²C backpacks.

---

### UART (Universal Asynchronous Receiver/Transmitter)

Asynchronous serial interface (TX/RX) used for point-to-point communication, e.g., with a PC.  
Not a main focus of this repository but typical in FPGA projects.

---

### Debounce (debouncing)

Technique to eliminate mechanical bounce in buttons or switches by filtering very fast transitions.  
Applied to user-button inputs.

---

### Edge detection (for inputs)

Logic for detecting rising/falling edges in external signals (buttons, ECHO, etc.) to generate one-cycle pulses.  
Used to capture unique events from longer signals.

---

### Pull-up / pull-down resistor

Resistors used to set a signal to a known default value when not actively driven.

- **Pull-up**: keeps the signal at logic 1 by default  
- **Pull-down**: keeps the signal at logic 0 by default

Used in buttons and buses like I²C.

---

### Level shifter / level shifting

Circuit used to adapt voltage levels between devices operating at different tensions (e.g., 5 V ↔ 3.3 V).  
Important for modules such as the HC-SR04 (ECHO at 5V) when connected to the FPGA.
