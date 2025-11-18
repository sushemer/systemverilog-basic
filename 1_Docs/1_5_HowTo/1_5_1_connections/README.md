# 1.5.1 Connections – Tang Nano 9K + Peripherals

This folder documents **how everything is wired together** around the Tang Nano 9K:

- One photo per device connected to the Tang Nano 9K.
- One photo with **all the devices connected at the same time**.
- Short notes on power, signals and “gotchas”.

All photos live in:

- `Mult/` → connection pictures (`.png` / `.jpg`).

Suggested filenames (you can rename as needed):

- `Mult/tang_tm1638.jpg`
- `Mult/tang_lcd_480x272.jpg`
- `Mult/tang_ultrasonic.jpg`
- `Mult/tang_potentiometer.jpg`
- `Mult/tang_all_together.jpg`

---

## 1. General wiring rules

Before any specific device:

1. **Common ground**
   - Tang Nano GND and every external module GND must be connected together.
   - If you use an external 5 V supply (for LCD or ultrasonic), it **must share GND** with the Tang.

2. **Voltage levels**
   - Tang Nano 9K I/O pins are **3.3 V only**.
   - If a module is “5 V compatible”, check:
     - Power it with 5 V **only if** its inputs accept 3.3 V as HIGH.
     - Otherwise, use a **level shifter** or power it at 3.3 V if allowed.

3. **Keep wires short and clear**
   - Use short jumper wires for clock / data signals.
   - Label or color–code: e.g. red = VCC, black = GND, yellow/green = signals.

---

## 2. Tang Nano 9K + TM1638

**Goal:** TM1638 used as a combined **8×7-seg display + 8 LEDs + 8 keys**.

Typical signals:

- `VCC` → 5 V (or 3.3 V if your TM1638 board supports it).
- `GND` → Tang ground.
- `STB` (STROBE / LATCH) → Tang GPIO pin.
- `CLK` → Tang GPIO pin.
- `DIO` (data in/out) → Tang GPIO pin.

In this repo, the exact pins are defined in the board constraint file  
(e.g. `boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific.cst`).

**Photo reference:**

![Tang Nano 9K + TM1638](Mult/tang_tm1638.jpg)

The picture should clearly show:

- Tang Nano 9K board.
- TM1638 module.
- Wires for `VCC`, `GND`, `STB`, `CLK`, `DIO`.

---

## 3. Tang Nano 9K + LCD 480×272

**Goal:** use the 4.3" / 480×272 LCD as main graphics output.

Typical connections (abstract):

- Data/clock/control lines from Tang to LCD connector (already defined in the board).
- `VCC` (often 3.3 V for logic, 5 V for backlight depending on your panel).
- `GND` common between Tang and the LCD board.

In many setups the Tang Nano carrier board already exposes a **matching LCD header**.  
If you are replicating this on your own hardware, follow the pin mapping from:

- `lcd_480_272.sv`
- The `.cst` file for this board.

**Photo reference:**

![Tang Nano 9K + LCD 480x272](Mult/tang_lcd_480x272.jpg)

Show:

- Tang Nano 9K.
- LCD panel connected to its dedicated header / ribbon adapter.
- Any extra power wiring if needed.

---

## 4. Tang Nano 9K + Ultrasonic sensor (HC-SR04)

**Goal:** measure distance using `ultrasonic_distance_sensor` module.

Typical wiring:

- `VCC` → 5 V (most HC-SR04 modules are 5 V.  
  If ECHO is 5 V, **use a resistor divider or level shifter** towards the Tang).
- `GND` → Tang ground.
- `TRIG` → Tang GPIO pin (output).
- `ECHO` → Tang GPIO pin (input, **3.3 V max**).

In the repo, TRIG/ECHO are typically mapped to `gpio[0]` / `gpio[1]` in `hackathon_top.sv`,  
but the **real physical pins** are defined in the `.cst` file.

**Photo reference:**

![Tang Nano 9K + HC-SR04](Mult/tang_ultrasonic.jpg)

Highlight:

- The HC-SR04 module.
- TRIG and ECHO wires to the Tang Nano.
- Power (5 V + GND) and any level-shifting if you use it.

---

## 5. Tang Nano 9K + Potentiometer (via ADC or simple demo)

Depending on your setup, the potentiometer can be:

- Connected to an external ADC module (SPI / I²C) and then to the Tang.
- Used in a very simple demo (e.g. as part of a voltage divider for an ADC input).

Typical wiring (generic):

- `Pot middle pin` → ADC input (on the external ADC module).
- `Pot side pin 1` → 3.3 V.
- `Pot side pin 2` → GND.
- ADC module → Tang via SPI/I²C pins (see the corresponding lab / activity and `.cst` for exact pins).

**Photo reference:**

![Tang Nano 9K + Potentiometer](Mult/tang_potentiometer.jpg)

Show:

- Tang Nano 9K.
- Breadboard with potentiometer.
- Wires from pot → ADC (if used) → Tang.

> If you also use a rotary encoder (KY-040) in your setup,  
> you can either:
> - Add a separate photo, or  
> - Include it together with the potentiometer and label both clearly.

---

## 6. All devices together

Final picture: all the main peripherals connected at once, as used in the labs/activities.

Example set:

- Tang Nano 9K.
- TM1638.
- LCD 480×272.
- Ultrasonic sensor HC-SR04.
- Potentiometer (and optionally encoder).

**Photo reference:**

![Tang Nano 9K – full setup](Mult/tang_all_together.jpg)

This picture is useful to:

- Check cable routing.
- See how power rails are shared.
- Understand how much space the full setup occupies on the bench.

---

## 7. Where to find exact pin mappings

This document focuses on **visual and conceptual connections**.

For **exact pin names and numbers** on the Tang Nano 9K:

- Check the board constraint file for your board variant, e.g.:

  - `boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific.cst`

There you will see strict mappings like:

- `TM1638_STB` → physical pin `XX`
- `LCD_R0`     → physical pin `YY`
- `GPIO0`      → physical pin `ZZ`

Use those as the authoritative reference when wiring your own hardware.
