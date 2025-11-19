# 4_9_8 – Sensors + TM1638 Integration

Activity based on `4_8_sensors_and_tm1638_integration`, located in `4_9_solutions/4_9_8_sensors_and_tm1638_integration`.

## Objective

Integrate **physical sensors** with the **TM1638** board so that:

- The **HC-SR04** (ultrasonic) and **KY-040** (rotary encoder) are read.
- A numerical value is shown on the **TM1638 7-segment display**.
- A **bar graph** is rendered on the **8 LEDs** of the TM1638.
- The display mode can be changed using the keys (`key[1:0]`).

The solution uses modules already available in the repository (sensors, input synchronization, and 7-segment driver).

---

## Sensor connections (GPIO)

The following mapping on `gpio` is assumed:

**HC-SR04 (ultrasonic)**  
- `gpio[0]` → `TRIG` (output from FPGA to the sensor)  
- `gpio[1]` → `ECHO` (input from the sensor to the FPGA)

**KY-040 (rotary encoder)**  
- `gpio[3]` → channel A (`CLK`)  
- `gpio[2]` → channel B (`DT`)

Modules involved:

- `ultrasonic_distance_sensor`: outputs a relative-distance value  
  `distance_rel : logic [15:0]`
- `sync_and_debounce`: synchronizes and removes bounce from the encoder signals
- `rotary_encoder`: generates a quadrature counter  
  `encoder_value : logic [15:0]`

In the solution, the encoder signals (`A`, `B`) are processed through `sync_and_debounce` first to obtain stable versions before feeding `rotary_encoder`.

---

## TM1638 and main signals

In addition to GPIO for the sensors, the TM1638 signals are used:

- Control lines to the TM1638 (handled by the board wrapper)
- Output **segments** (internally driven by `seven_segment_display`)
- **8 LEDs** integrated in the TM1638, used as a level bar

On the design side, the important signals are:

- A 16-bit value `sensor_value` representing the selected data (distance or encoder)
- A `number` register (often 4 hexadecimal/BCD nibbles) connected to the 7-segment module
- An 8-bit `led_bar` pattern mapped to the TM1638 LEDs

---

## Required modules

For the solution to synthesize correctly, the following must be included (in addition to the board wrapper):

- `peripherals/ultrasonic_distance_sensor.sv`
- `peripherals/rotary_encoder.sv`
- `peripherals/sync_and_debounce.sv`
- `peripherals/sync_and_debounce_one.sv`
- `peripherals/seven_segment_display.sv`
- The corresponding `hackathon_top.sv` for this activity (in `4_9_solutions/4_9_8_...`)

It is important to ensure that all these files are included in the synthesis script or the Gowin project.

---

## Operating modes (`key[1:0]`)

`key[1:0]` is used as a mode selector:

- `mode = key[1:0];`

The solution proposes, for example, the following modes:

- `mode = 2'b00` → **Distance mode**  
  `sensor_value = distance_rel`  
  The display shows the distance (hex or scaled), and the LEDs form a bar proportional to this value.

- `mode = 2'b01` → **Encoder mode**  
  `sensor_value = encoder_value`  
  The display shows the encoder value (positive/negative, typically in hex), and the bar reflects the magnitude or higher bits of the counter.

- `mode = 2'b10` → **Mixed or debug mode**  
  A combination of both values is shown, for example:  
  upper half of the display = distance, lower half = encoder, or another helpful mix for debugging.

- `mode = 2'b11` → **Free mode**  
  Reserved for extensions (freeze value, fixed scale, LED patterns, etc.)

The exact implementation may vary, but the included solution uses this general idea: a multiplexer over `sensor_value` controlled by `mode`.

---

## General solution flow

The logic of the design can be summarized in the following steps:

1. **Sensor reading**

   - `ultrasonic_distance_sensor` generates `distance_rel` from the `TRIG` and `ECHO` signals.  
   - `sync_and_debounce` receives `gpio[3:2]` and outputs stabilized signals to `rotary_encoder`.  
   - `rotary_encoder` generates `encoder_value`, an incremental/decremental counter based on rotation direction.

2. **Value selection (mode multiplexer)**

   A register or combinational logic selects the value:

   - `mode = 00` → `sensor_value = distance_rel`  
   - `mode = 01` → `sensor_value = encoder_value`  
   - `mode = 10` → some function of both (e.g., `distance_rel - encoder_value`)  
   - `mode = 11` → a fixed/test value (e.g., 0)

   This ensures that all later logic (display + LEDs) always works with `sensor_value`.

3. **Scaling for 7-segment display**

   From `sensor_value` (16 bits), a number is prepared for the 7-segment driver:

   - Simple option: display `sensor_value` directly in **hex** (4 hex digits).  
     E.g., put `sensor_value` into `number[15:0]` and fill the remaining digits with 0 if using an 8-digit TM1638.

   - Alternative: convert to **decimal** (BCD) to display human-readable values (adds extra logic).

   The repository solution typically uses the simple hex method.

4. **LED bar generation**

   To build an 8-level bar graph:

   - A subset of `sensor_value` bits is used (e.g., the highest bits)
   - A threshold/scale converts this into a level from 0 to 8
   - The LED pattern is built:

     - Level 0 → `00000000`
     - Level 1 → `00000001`
     - Level 2 → `00000011`
     - …
     - Level 8 → `11111111`

   This bar is sent to the TM1638 LEDs to provide a quick visual magnitude indicator.

5. **Additional key handling (optional)**

   - Other `key` bits (like `key[7:2]`) may be used to:
     - Change the bar scale (zoom)  
     - Enable test modes  
     - Freeze sensor values  
   - The base solution keeps these bits free for extensions.

---

## Suggested tests

1. **Distance mode (`mode = 00`)**

   - Point the HC-SR04 at objects at different distances  
   - Observe:  
     - The displayed number changes when approaching/moving away  
     - The LED bar increases/decreases accordingly  

2. **Encoder mode (`mode = 01`)**

   - Rotate the KY-040 slowly in both directions  
   - Confirm:  
     - The display increments/decrements  
     - The bar reflects the magnitude (absolute or top bits)  

3. **Fast mode switching**

   - Switch between `00` and `01`  
   - Verify that the system transitions correctly with no glitches  

4. **Mixed and free modes (`10` and `11`)**

   - Test the behavior defined in the solution (combined sensors, fixed values, etc.)  
   - Modify if experimenting with new combinations  

---

## Optional extensions

Ideas to extend this activity:

- Add a **unit scale** (e.g., centimeters or steps) and document it in comments  
- Use the TM1638 to:  
  - Show one sensor on the right digits  
  - Show the other sensor on the left digits  
- Implement a simple **menu system** using the TM1638 buttons to select:  
  - Active sensor  
  - Display type (hex / decimal)  
  - Bar graph type (linear, logarithmic, etc.)  
- Integrate the functionality with the LCD:  
  - Draw a bar on screen matching the LED bar  
  - Show text describing the active mode and approximate reading  

This solution brings together several previously seen components (sensors, debounce, encoder, 7-segment, LED bars) and demonstrates how to coordinate them to build a simple but complete sensor dashboard on the Tang Nano 9K + TM1638.
