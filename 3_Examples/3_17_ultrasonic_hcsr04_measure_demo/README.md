# 3.17 Ultrasonic Distance – Visualization on LEDs, TM1638, and LCD

This example integrates the **HC-SR04 ultrasonic distance sensor** with the Tang Nano 9K to:

- Measure a **relative distance** using the `ultrasonic_distance_sensor` module.
- Display this distance on:
  - **LEDs** (`led[7:0]`),
  - **TM1638 seven-segment display** using `seven_segment_display`,
  - A **horizontal red bar** on the 480×272 LCD, whose length depends on the measured distance.

This is the first step toward a “radar-style” **distance visualization** application.

---

## Objective

By the end of this example, the user will be able to:

- Understand how to connect and use the `ultrasonic_distance_sensor` with the Tang Nano 9K.
- Visualize the measured distance on:
  - LEDs (binary pattern),
  - The seven-segment display (numeric value),
  - The LCD (horizontal bar proportional to distance).
- Practice:
  - Scaling a 16-bit distance value to screen coordinates,
  - Integrating multiple peripherals (sensor + TM1638 + LCD) into one design.

---

## Signals and Pins

### Main Inputs

- **clock**  
  Main system clock (~27 MHz).

- **slow_clock**  
  Not used in this example (reserved for other labs).

- **reset**  
  Asynchronous active-high reset.

- **key[7:0]**  
  Reserved for future exercises.

### Ultrasonic Sensor (using `gpio`)

In this example:

- `gpio[0]` → `TRIG` (output to HC-SR04)  
- `gpio[1]` → `ECHO` (input from HC-SR04)

Refer to hardware docs and the board constraint file for physical wiring.

### Outputs

- **led[7:0]**  
  Shows the 8 LSBs of the measured distance:

      assign led = distance[7:0];

- **abcdefgh[7:0]** and **digit[7:0]**  
  Generated with `seven_segment_display`:

      seven_segment_display #(
          .w_digit (8)
      ) i_7segment (
          .clk      (clock),
          .rst      (reset),
          .number   ({16'd0, distance}),
          .dots     (8'b0000_0000),
          .abcdefgh (abcdefgh),
          .digit    (digit)
      );

- **LCD RGB outputs**  
  Used to draw the horizontal bar.

- **gpio[3:0]**  
  Only bits 0 and 1 are used for TRIG/ECHO.

---

## Internal Flow

### 1. Distance Measurement (`ultrasonic_distance_sensor`)

The module measures the echo time from the HC-SR04 and outputs a **relative distance value**.

Configuration example:

    localparam int unsigned CLK_HZ = 27_000_000;

    ultrasonic_distance_sensor #(
        .clk_frequency          (CLK_HZ),
        .relative_distance_width($bits(distance))
    ) i_sensor (
        .clk               (clock),
        .rst               (reset),
        .trig              (gpio[0]),
        .echo              (gpio[1]),
        .relative_distance (distance)
    );

Notes:

- `distance` is **not in centimeters**; it is a monotonic relative measurement.
- Larger values → echo took longer → object is farther.

---

### 2. Numerical Visualization (LEDs + TM1638)

#### LEDs (debug)

    assign led = distance[7:0];

Shows the least-significant byte of the distance.

#### TM1638 seven-segment display

The distance is zero-extended to 32 bits:

    number = {16'd0, distance};

`seven_segment_display` handles:

- Hexadecimal decoding,
- Digit multiplexing,
- Segment patterns.

This allows real-time numeric display of the measured distance.

---

### 3. Mapping Distance to LCD X-Coordinate

Screen resolution:

- Width: 480  
- Height: 272

We project part of `distance` into the x-coordinate space.

Using the upper bits:

    distance[15:7] → range roughly 0..511

Mapping logic:

    if distance[15:7] >= 480  
        distance_x = 479  
    else  
        distance_x = distance[15:7]

This saturates values above the screen max.

The resulting `distance_x` defines the **bar length**.

---

### 4. LCD Visualization (Horizontal Red Bar)

The LCD draws:

1. **Black background**  
2. A **red bar** centered vertically, from x = 0 to x = distance_x.

Vertical region:

- Height: 20 px  
- Centered at `SCREEN_HEIGHT / 2`

Color logic (conceptual):

- If pixel within bar region → red = 31, green = 0, blue = 0  
- Else → black

Effect:

- Small distance → short bar  
- Large distance → long bar  
- Far object (saturated) → full-width bar

---

## Relationship with Other Examples

This example combines concepts from several earlier modules:

- LCD basics  
  `3_13_lcd_basic_shapes`  
  `3_14_lcd_moving_rectangle`

- Seven-segment TM1638 basics  
  `3_11_seven_segment_basics`  
  `3_15_tm1638_quickstart`

- Sensor interfacing and buses  
  `1_2_9_Buses_Overview.md`  
  `1_2_11_ADC_Basics.md`

Together, they form a complete system integrating:

- Digital sensor input  
- Two display outputs (numeric + graphical)  
- Auxiliary debugging (LEDs)

---

## Summary

This example demonstrates a full visualization pipeline:

1. **HC-SR04 ultrasonic sensor** measures relative distance.  
2. Distance value is sent to:
   - **LEDs** (binary),
   - **TM1638** (numeric),
   - **LCD** (graphical bar).
3. A scaled coordinate maps distance into a red bar on the LCD.
4. The system provides a foundation for advanced “radar” or “distance meter” projects.

