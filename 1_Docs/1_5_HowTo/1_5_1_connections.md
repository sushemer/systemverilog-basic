# 1.5.1 Connections – Tang Nano 9K + Peripherals

This folder documents **how everything is wired** around the Tang Nano 9K:

- One photo for each device connected to the Tang Nano 9K.
- One photo with **all devices connected at the same time**.
- Brief notes on power, signals, and important details (“gotchas”).

All photos are located in:

- `Mult/`.

---

## 1. General wiring rules

Before discussing each device:

1. **Common ground**
   - Tang Nano GND and the GND of **every** external module must be connected.
   - If using an external 5 V supply (for the LCD or ultrasonic sensor), it **must share GND** with the Tang.

2. **Voltage levels**
   - Tang Nano 9K I/O pins operate at **3.3 V only**.
   - If a module is “5 V compatible,” check:
     - Power it at 5 V **only if** its input pins recognize 3.3 V as HIGH.
     - Otherwise, use a **level shifter** or power the module at 3.3 V if supported.

3. **Keep wires short and clean**
   - Use short jumpers for clock/data signals.
   - Label or color-code whenever possible (red = VCC, black = GND, yellow/green = signals).

---

## 2. Tang Nano 9K + TM1638

**Goal:** use the TM1638 as a combined module for **8×7-segment display + 8 LEDs + 8 keys**.

Typical signals:

- `VCC` → 5 V (or 3.3 V if the TM1638 board supports it)
- `GND` → common ground
- `STB` → GPIO pin on the Tang
- `CLK` → GPIO pin on the Tang
- `DIO` → GPIO pin on the Tang

In this repository, exact pin assignments are defined in the board constraints file  
(e.g., `boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific.cst`).

**Photo reference:**

![Tang Nano 9K + TM1638](Mult/tang_tm1638.jpg)

The image should clearly show:

- Tang Nano 9K board  
- TM1638 module  
- Cables for `VCC`, `GND`, `STB`, `CLK`, `DIO`

---

## 3. Tang Nano 9K + LCD 480×272

**Goal:** use the 4.3" / 480×272 LCD as the main graphics output.

Typical connections (conceptual):

- Data/clock/control lines from the Tang to the LCD connector (already defined on the board).
- `VCC` (often 3.3 V for logic, 5 V for backlight depending on the panel).
- Common `GND`.

Many setups use the base board of the Tang Nano which exposes a **compatible LCD connector**.  
For custom hardware, refer to:

- `lcd_480_272.sv`
- The corresponding `.cst` file for the board.

**Photo reference:**

![Tang Nano 9K + LCD 480x272](Mult/tang_lcd_480x272.jpg)

---

## 4. Tang Nano 9K + Ultrasonic Sensor (HC-SR04)

**Goal:** measure distance using the `ultrasonic_distance_sensor` module.

Typical wiring:

- `VCC` → 5 V (most HC-SR04 require 5 V)  
  If `ECHO` outputs 5 V, **use a resistor divider or level shifter** before connecting to the Tang.
- `GND` → common ground
- `TRIG` → GPIO pin (output)
- `ECHO` → GPIO pin (input, **must not exceed 3.3 V**)

In this repository, TRIG/ECHO often map to `gpio[0]` / `gpio[1]` in `hackathon_top.sv`,  
but **actual physical pins** are specified in the `.cst` file.

**Photo reference:**

![Tang Nano 9K + HC-SR04](Mult/tang_ultrasonic.jpg)

---

## 5. Tang Nano 9K + Potentiometer (via ADC or simple demo)

Depending on the setup, the potentiometer may:

- Connect to an external ADC module (SPI/I²C) before reaching the Tang.
- Be used in a simple demo (voltage divider feeding an ADC input).

Generic wiring:

- Potentiometer middle pin → ADC input (on the external module)
- Side pin 1 → 3.3 V
- Side pin 2 → GND
- ADC module → Tang via SPI/I²C pins (check lab/activity and `.cst` for exact pins)

**Photo reference:**

![Tang Nano 9K + Potentiometer](Mult/tang_potentiometer.jpg)

---

## 6. All devices together

Final photo: all major peripherals connected simultaneously as used in labs/activities.

Typical set:

- Tang Nano 9K  
- TM1638  
- LCD 480×272  
- HC-SR04 ultrasonic sensor  
- Potentiometer (optionally rotary encoder)

**Photo reference:**

![Tang Nano 9K – full setup](Mult/tang_all_together.jpg)

---

## 7. Where to find exact pin mappings

This document focuses on **visual and conceptual** wiring.

For **exact pin numbers** on the Tang Nano 9K:

- Check the constraints file for the specific board variant, e.g.:

  - `boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific.cst`

There you will find mappings like:

- `TM1638_STB` → physical pin `XX`
- `LCD_R0` → physical pin `YY`
- `GPIO0` → physical pin `ZZ`

These files are the official reference when wiring custom hardware.
