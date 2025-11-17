# 3. Examples

This folder contains **short, self-contained SystemVerilog examples** for the  
**Tang Nano 9K + LCD 480×272 + TM1638 (hackathon board)**.

Each example focuses on 1–2 core ideas (gates, muxes, counters, displays, sensors…)  
and is meant to be:

- Small enough to read in one sitting.
- Easy to synthesize and try on the board.
- A bridge between the theory docs and the Activities/Labs.

Most examples use `hackathon_top` (or `lab_top`) as the top module and the board wrapper in  
`boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/`.

---

## 3.1 `3_1_and_or_not_xor_demorgan`

**Topic:** basic logic gates + De Morgan’s law.  
**What it does:**

- Reads two inputs `A`, `B` from `key[1:0]`.
- Drives several LEDs with `A & B`, `A | B`, `A ^ B`.
- Shows `~(A & B)` and `(~A) | (~B)` on two LEDs so you can **visually confirm** that both expressions always match (De Morgan).

---

## 3.2 `3_2_mux_2to1`

**Topic:** 2:1 multiplexer in different coding styles.  
**What it does:**

- Uses `key` bits as data inputs and select.
- Implements a 2:1 mux with:
  - `if/else`
  - conditional `?:`
  - `case`
- Shows the selected input on an LED, and also demonstrates using `sel` to index a small vector.

---

## 3.3 `3_3_decoder_2to4`

**Topic:** 2→4 decoder (one-hot) in multiple implementations.  
**What it does:**

- Takes a 2-bit input from keys or switches.
- Generates a **one-hot** 4-bit output:
  - A direct sum-of-products version.
  - A `case`-based version.
  - A shift-based version (`4'b0001 << in`).
  - An indexed version that sets `out[in] = 1`.
- Maps all outputs to LEDs so you can test inputs `00..11`.

---

## 3.4 `3_4_priority_encoder`

**Topic:** 3-input priority encoder (several styles).  
**What it does:**

- Reads a 3-bit input vector from keys/switches.
- Encodes the **highest-priority ‘1’** into 2 bits:
  - Chained `if/else`.
  - `casez` with don’t-care bits.
  - Combination of priority arbiter + normal encoder.
  - Loop-based implementation.
- All encoder outputs are packed into LEDs for visual comparison.

---

## 3.5 `3_5_comparator_4bit`

**Topic:** 4-bit magnitude comparator.  
**What it does:**

- Uses switches/keys to set 4-bit values `A` and `B`.
- Compares them and lights LEDs to indicate:
  - `A < B`
  - `A == B`
  - `A > B`
- Illustrates relational operators and basic combinational design.

---

## `3_6_adder_subtractor_4bit`

**Topic:** 4-bit adder/subtractor with mode select.  
**What it does:**

- Reads 4-bit operands `A` and `B` from switches/keys.
- A mode bit selects between **addition** and **subtraction**.
- Displays the result (and optionally carry/borrow flags) on LEDs.
- Reinforces two’s complement and arithmetic with simple logic.

---

## `3_7_binary_counter`

**Topic:** binary counters and clock division.  
**What it does:**

- Implements a **free-running counter** that increments every clock cycle.
- Uses upper bits to blink LEDs at human-visible rates.
- Optional variant: a **key-controlled counter** that increments on button presses (edge detection).

---

## 3.8 `3_8_shift_register`

**Topic:** shift register + simple LED animations.  
**What it does:**

- Implements a shift register feeding an LED bar.
- Periodically shifts bits to create a moving “light” (KITT-style).
- You can modify the direction, add looping, and use keys to reset or change behaviour.

---

## 3.9 `3_9_seven_segment_letter`

**Topic:** letters on a single 7-segment digit.  
**What it does:**

- Defines segment encodings for letters like `F`, `P`, `G`, `A` and a blank.
- Moves a one-hot pattern across digits and selects the letter to draw.
- Displays a short word like “FPGA” by scanning the digits fast enough.

> The individual letter encodings can be adjusted using an external “seven segment font editor” image/tool.

---

## 3.10 `3_10_hex_counter_7seg`

**Topic:** hex counter on 7-segment display with adjustable speed.  
**What it does:**

- Creates a programmable timer (`period`) that defines the counting speed.
- Uses keys to **increase/decrease** the speed.
- Maintains a 32-bit counter and feeds it to a multi-digit 7-segment module.
- Shows the count in **hexadecimal** across digits.

---

## 3.11 `3_11_seven_segment_basics`

**Topic:** 7-segment “hello world” and calibration.  
**What it does:**

- Drives `abcdefgh` and per-digit `digit` lines directly.
- Lets you turn segments on/off manually (via constants or switches) to:
  - Confirm wiring (which bit controls which segment).
  - Confirm whether the display is common-anode or common-cathode.
- A good starting point before more advanced 7-segment examples.

---

## 3.12 `3_12_seven_segment_hex_counter`

**Topic:** multi-digit hex counter using `seven_segment_display.sv`.  
**What it does:**

- Uses the common `seven_segment_display` module from `labs/common/`.
- Packs a wider number (e.g. 32 bits) into `w_digit * 4` hex digits.
- Shows a free-running counter or system status value across multiple digits.
- Demonstrates **multiplexing** and reusable display modules.

---

## 3.13 `3_13_lcd_basic_shapes`

**Topic:** first steps with the LCD graphics interface.  
**What it does:**

- Uses `x`, `y` coordinates from the LCD controller.
- Draws simple shapes (rectangles/areas) by checking coordinate ranges:
  - Example: a solid rectangle in a fixed region of the screen.
- Shows how to map boolean expressions on `(x, y)` to `red/green/blue` outputs.

---

## 3.14 `3_14_lcd_moving_shapes`

**Topic:** moving graphics on LCD (animation + keys).  
**What it does:**

- Generates a **strobe** at a low frequency to animate motion.
- Uses internal registers (`dx`, `dy`…) that are updated either:
  - Periodically (auto-move), or
  - Via keys (move left/right/up/down).
- Adds shapes whose positions depend on these offsets, creating simple animations.

---

## 3.15 `3_15_pot_read_demo`

**Topic:** reading a potentiometer via ADC and mapping to LEDs.  
**What it does:**

- Uses an external ADC (SPI/I²C, depending on board) to sample a pot.
- Scales the result to 8 bits and uses it as a **bar graph** on LEDs.
- Optional: show the numeric value on a 7-segment display.
- Good intro to **mixed-signal** workflows: analog input → digital value → visualization.

*(If you removed this example in your local repo, you can skip it or use it as a template for a future “pot bar meter” example.)*

---

## 3.16 `3_16_tm1638_quickstart`

**Topic:** TM1638 basics (keys + 7-segment + LEDs).  
**What it does:**

- Talks to a TM1638 module over its 3-wire interface (CLK/DIO/STB).
- Displays a number on the 7-segment digits.
- Reads keys and uses them to increment/reset the number and/or toggle on-board LEDs.
- Serves as a minimal “hello world” for the TM1638 peripheral.

---

## 3.17 `3_17_ultrasonic_hcsr04_measure_demo`

**Topic:** ultrasonic distance measurement with HC-SR04.  
**What it does:**

- Instantiates `ultrasonic_distance_sensor` (from peripherals) with:
  - `trig` and `echo` on GPIO pins.
  - A relative distance output.
- Shows the measured distance on 7-segment display.
- Optionally draws a horizontal bar on the LCD whose length depends on the measured distance (e.g. “near” = short bar, “far” = long bar).

> Make sure `ultrasonic_distance_sensor.sv` is included in the project/synthesis file list.

---

## 3.18 `3_18_rotary_encoder`

**Topic:** rotary encoder (KY-040) + 7-segment + LCD.  
**What it does:**

- Uses `sync_and_debounce` to clean the raw `A/B` signals from the encoder (on `gpio[3:2]`).
- Instantiates `rotary_encoder` to convert quadrature pulses into a signed 16-bit `value`.
- Shows `value` on the 7-segment display.
- Uses `value` to modulate something on the LCD (e.g. a bar or color region), so turning the knob has a **visual effect** on screen.

---


