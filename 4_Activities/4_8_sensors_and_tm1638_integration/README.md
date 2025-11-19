# 4.8 – Sensor Integration and TM1638

In this activity, **physical sensors** are integrated with the **TM1638 module**:

- At least one sensor is read (HC-SR04 ultrasonic sensor and/or KY-040 rotary encoder).
- The value is displayed on the **7-segment display** (TM1638).
- The value is represented as a **bar** using the **8 LEDs** on the TM1638.
- **Keys** are used to switch modes, sensors, or scale.

The intention is to combine several components already seen in previous examples: sensors, drivers, and simple combinational/sequential logic.

---

## Objective

At the end of the activity, the user should be able to:

- Instantiate one or more sensor modules (ultrasonic, encoder).
- Select which value to display using keys (`key`).
- Update the 7-segment display with a number up to 16 bits.
- Draw a level bar on the LEDs based on the measured value.
- Design different operating modes (for example: “distance”, “encoder”, “mixed”).

---

## Assumed Hardware

- **Board:** Tang Nano 9K with configuration  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`.
- **TM1638** connected (8 seven-segment digits + 8 LEDs + keys).
- **GPIO [3:0]** connected to sensors:
  - `gpio[0]` → TRIG of the HC-SR04.
  - `gpio[1]` → ECHO of the HC-SR04.
  - `gpio[3]` → A (CLK) of the KY-040.
  - `gpio[2]` → B (DT) of the KY-040.

If both sensors are not available, the activity can be done with only one, adapting the selection logic.

---

## Required Files / Modules

It is important to verify that the following modules are included in the project (Tcl / synthesis script):

- `ultrasonic_distance_sensor.sv`  
  (module for HC-SR04, already used in the ultrasonic example).
- `rotary_encoder.sv`
- `sync_and_debounce.sv`
- `sync_and_debounce_one.sv`
- `seven_segment_display.sv`
- `hackathon_top.sv` (main activity file).

General rule: if a module is instantiated inside `hackathon_top.sv`, its `.sv` file must be added to the project.

---

## What the `hackathon_top.sv` Template Does

The typical template for this activity includes at least the following blocks.

### 1) HC-SR04 Ultrasonic Sensor

The `ultrasonic_distance_sensor` module is instantiated with:

- Inputs:
  - `clk` and `rst` connected to the system clock and reset.
  - `trig` and `echo` connected to `gpio[0]` and `gpio[1]` (according to the chosen mapping).
- Main output:
  - `relative_distance`, connected to a 16-bit signal, e.g.,  
    `distance_rel` of type `logic [15:0]`.

The `distance_rel` output is **not in centimeters**, but in a unit **relative to echo time**, although it grows with distance, which is sufficient for visualization in this activity.

---

### 2) KY-040 Rotary Encoder

The raw signals from the encoder are taken:

- `enc_a_raw = gpio[3]`
- `enc_b_raw = gpio[2]`

Then, `sync_and_debounce` is used to **synchronize and remove bounce**:

- Module inputs: `sw_in = {enc_b_raw, enc_a_raw}`.
- Outputs: debounced signals `enc_a_deb` and `enc_b_deb`.

Then `rotary_encoder` is instantiated:

- Inputs: `clk`, `reset`, `a = enc_a_deb`, `b = enc_b_deb`.
- Output: `value`, connected to a 16-bit signal, e.g.,  
  `encoder_value` of type `logic [15:0]`.

This output represents the encoder count (positive/negative depending on implementation), allowing observation of turns and direction.

---

### 3) Selecting the Value to Display

An **operating mode** is defined from some keys, for example:

- `mode = key[1:0]` (2 bits for four possible modes).

An intermediate signal is declared:

- `sensor_value` of type `logic [15:0]`.

In a combinational block (`always_comb`), the value is selected according to the mode:

- If `mode = 2'b00` → `sensor_value = distance_rel` (ultrasonic only).
- If `mode = 2'b01` → `sensor_value = encoder_value` (encoder only).
- If `mode = 2'b10` → `sensor_value = distance_rel - encoder_value` (mixed/test mode).
- Any other case (`2'b11` or others) → `sensor_value = 16'd0` (reserved/debug mode).

The `sensor_value` signal is used as the basis for:

- The number shown on the 7-segment display.
- The level bar represented by the 8 LEDs.

---

### 4) Showing the Value on the TM1638 (7-segment)

The `seven_segment_display` module from previous activities is reused.

Typical parameters:

- `W_DIGITS = 8`
- `W_NUM    = W_DIGITS * 4 = 32`

A 32-bit bus for the number and 8 bits for the dots are declared:

- `number` of type `logic [31:0]`.
- `dots` of type `logic [7:0]`.

Common way to package the sensor value:

- `number = {16'd0, sensor_value}`  
  (the 4 least significant digits show `sensor_value` in hexadecimal).
- `dots   = 8'b0000_0000`  
  (decimal points off, or configured per mode).

Then `number` and `dots` are connected to the `seven_segment_display` instance, whose outputs `abcdefgh` and `digit` go to the TM1638.

Thus, the sensor value appears in hexadecimal on the TM1638 digits; visual inspection can be limited to the 4 least-significant digits if desired.

---

### 5) Level Bar on the TM1638 LEDs

The 8 LEDs on the TM1638 are used as a **level bar** (similar to a VU meter).

#### 5.1 Normalizing the Value

Part of `sensor_value` can be used as the level:

- `bar_level` of type `logic [7:0]`.
- Example: `bar_level = sensor_value[15:8]`.

If `sensor_value` spans a large range, `bar_level` can also be saturated or rescaled so that the bar reasonably covers the 8 LEDs.

#### 5.2 Building the Bar

Common options:

- **Cumulative bar** (filling from left to right):

  - Initialize `led_bar = 8'b0000_0000`.
  - If `bar_level > 0`, turn on bit 0 (`led_bar[0] = 1`).
  - If `bar_level > 1`, turn on bit 1, and so on up to bit 7.

- **Direct bit bar**:

  - `led_bar = bar_level`.
  - Each bit of `bar_level` directly controls one LED.

#### 5.3 Output Assignment

The `led_bar` signal is connected to the TM1638 LEDs.  
If the template also exposes the Tang Nano 9K onboard LEDs, they can be used to:

- Use TM1638 LEDs as **main bar**.
- Use onboard LEDs as **debug** (e.g., `sensor_value[15:8]`).

---

### 6) Typical Output Block Organization

A clear organization of the output block (`always_comb`) usually follows these steps:

1. Initialize default values:
   - `number   = 32'h0000_0000`
   - `dots     = 8'b0000_0000`
   - `led_bar  = 8'b0000_0000`

2. Use `case (mode)` to adjust behavior:

   - Mode `2'b00` (ultrasonic):
     - `number   = {16'd0, distance_rel}`
     - `led_bar  = bar_function(distance_rel)`

   - Mode `2'b01` (encoder):
     - `number   = {16'd0, encoder_value}`
     - `led_bar  = bar_function(encoder_value)`

   - Mode `2'b10` (combined/experiment):
     - `number   = {16'd0, sensor_value}`
     - `led_bar  = bar_function(sensor_value)`

   - Other cases (`2'b11`, etc.):
     - `number   = 32'h0000_0000`
     - `led_bar  = 8'b0000_0000`

   (“bar_function” refers to the logic that maps any 16-bit value to an 8-LED pattern as described earlier.)

Additionally, the board LEDs may be used as visual help, e.g.:

- `led[1:0]  = mode`  (current mode).
- `led[7:2]  = sensor_value[7:2]` or some other part of the value or a debug counter.

---

## Suggested Tests

### 1) Ultrasonic Mode

- Place your hand or objects at different distances from the HC-SR04.
- Verify how:
  - The number on the TM1638 display changes.
  - The LED bar changes (for example: low value with a nearby object, high value with a distant object, depending on design).

### 2) Encoder Mode

- Turn the encoder slowly in both directions.
- Check:
  - Increments and decrements on the display.
  - LED bar shifting left/right.

### 3) Mode Switching with Keys

- Change `mode` using `key[1:0]`.
- Confirm that the system changes behavior without anomalies.
- Test additional key combinations to:
  - Invert the bar.
  - Change scale.
  - Enable/disable debug modes.

### 4) Limit Tests

- Force very high or low values in `sensor_value`:
  - Moving the ultrasonic sensor target far away.
  - Turning the encoder many rotations.
- Verify:
  - The LED bar does not overflow (no unexpected patterns).
  - The displayed number remains coherent (no clearly erroneous overflow values unless part of the experiment).

---

## Optional Extensions

Some ideas to extend the activity:

- **Adjustable scale**  
  Use additional `key` bits to change the bar scale (e.g., ×1, ×2, ×4).

- **Decimal point indicators**  
  Use TM1638 `dots` to indicate:
  - Current mode.
  - Error or out-of-range states.
  - A “heartbeat” indicator (blinking dot) while the system is active.

- **Alarm threshold**  
  Light the last LED only if the value exceeds a threshold, and optionally show a special pattern on the display (e.g., fixed characters in the upper digits).

- **Averaging / filtering**  
  Implement a simple filter (e.g., moving average) to stabilize the sensor reading and reduce noise.

With this activity, the use of sensors, support modules (debounce, encoder, ultrasonic), and the TM1638 as a visualization interface is consolidated, approaching a more complete measurement and monitoring application on the FPGA.
