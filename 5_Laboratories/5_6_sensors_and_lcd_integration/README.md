# Lab 5.6 – Sensors + LCD integration

## Objective

Integrate **physical sensors** with the **480×272 LCD panel** on the Tang Nano 9K to create a small “level gauge”:

- Read:
  - Relative distance from an **HC-SR04**.
  - Count from a **KY-040 rotary encoder**.
- Select the data source using `key[1:0]`.
- Display the value:
  - As a **vertical bar (gauge)** on the LCD.
  - As a pattern on `led[7:0]` (high byte of the value).

By the end of this lab, you should:

- Feel comfortable instantiating and wiring sensor modules.
- Understand how to scale a 16-bit value into a pixel height.
- Use `(x, y)` to draw simple sensor-driven graphics.

---

## Prerequisites

Have completed or reviewed:

- **Lab 5.1 – blink_hello_world** (clock divider)
- **Lab 5.3 – shift_register_patterns** (LED animations)
- Basic LCD exercises (e.g., `4_7_lcd_hello_and_basic_graphics`)
- Sensor + TM1638 integration (`4_8_sensors_and_tm1638_integration`)

Understand:

- How the LCD controller generates `x` and `y`
- What `ultrasonic_distance_sensor` and `rotary_encoder` do

---

## Hardware used

- Tang Nano 9K with **480×272 LCD**
- Sensors:
  - **HC-SR04** ultrasonic sensor
  - **KY-040** rotary encoder

### Suggested GPIO mapping

- `gpio[0]` → TRIG (HC-SR04)
- `gpio[1]` → ECHO (HC-SR04)
- `gpio[3]` → A (encoder)
- `gpio[2]` → B (encoder)

Check your board’s pinout to confirm wiring.

---

## Signals and modes

- `mode = key[1:0]`:

  - `00` → use `distance_rel`
  - `01` → use `encoder_value`
  - `10` → `distance_rel - encoder_value` (experimental)
  - `11` → `sensor_value = 0`

- `sensor_value[15:0]`:  
  Common bus feeding the gauge and LEDs.

- `led[7:0]` = `sensor_value[15:8]`  
  (upper byte of the 16-bit sensor value)

- `bar_height` (0..271):  
  Scaled version of the sensor value.  
  Derived from `sensor_value[15:7]` and clamped to `0 .. SCREEN_H-1`.

---

## LCD drawing logic

1. **Border**  
   Draw a white 2-pixel border around the entire screen.

2. **Background**  
   Inside the border, draw a soft gradient (slightly dependent on `y`).

3. **Vertical gauge bar**

   - X-range:
     - `BAR_X0 = 400`, `BAR_X1 = 440`
   - Height:
     - From the bottom (`y ≈ 271`) upward, based on `bar_height`
   - Color rules:
     - If `bar_height < THRESH_LOW` → **green**
     - If `bar_height < THRESH_HIGH` → **yellow**
     - Else → **red**

---

## Suggested procedure

### 1. Review sensor instances
Locate the modules:

- `ultrasonic_distance_sensor`
- `rotary_encoder`

Verify that they exist in the repo and are included in the project.

---

### 2. Understand `sensor_value`
Analyze the `case (mode)` block assigning `sensor_value`.

Try mentally:

- Ultrasonic only
- Encoder only
- Combined subtraction

---

### 3. Review scaling to `bar_height`
Observe:

- Taking the high bits `sensor_value[15:7]`
- Clamping to screen height
- The concept of mapping a wide numeric range to pixels

---

### 4. Review LCD drawing logic

Inside the RGB generation block:

```sv
if ((x >= BAR_X0) && (x < BAR_X1))
  if (y >= SCREEN_H_9B - bar_height)
    // draw bar using color thresholds
```

### 5. Synthesize and test

Program the FPGA and test the modes:

- `00` → Move an object in front of the HC-SR04.  
- `01` → Rotate the encoder (CW/CCW).  
- `10` → Experiment with the combined mode (`distance_rel - encoder_value`).  
- `11` → Zero output.

Observe:

- How the **bar changes size** as the sensor value changes.
- How the **bar changes color** (green → yellow → red).
- How `led[7:0]` reflects the **high byte** of the sensor value.

---

## Test checklist

- [ ] The design synthesizes and programs successfully on the Tang Nano 9K.
- [ ] With `mode = 00`, moving an object in front of the HC-SR04 changes the bar.
- [ ] With `mode = 01`, rotating the encoder updates the bar smoothly.
- [ ] Bar color changes correctly according to thresholds.
- [ ] `led[7:0]` changes consistently with the sensor value.
- [ ] Screen shows a clean white border and stable background when sensors are idle.

---

## Optional extensions

To take this lab further:

- Display the sensor value on the **TM1638** using `seven_segment_display`.
- Draw **two bars**: one for the ultrasonic sensor and one for the encoder.
- Add “safe”, “warning”, and “danger” zones on the LCD gauge.
- Use `slow_clock` to make the bar blink when above a safety threshold.

This lab is essentially your first simple **instrument panel**: real sensors + graphical indicators.  
From here, you can build mini-dashboards like speedometers, volume meters, proximity alerts, and more.
