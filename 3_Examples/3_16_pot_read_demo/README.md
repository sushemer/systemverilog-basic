# 3.16 Potentiometer Read Demo (Simulated with Switches)

This example demonstrates how to simulate the reading of a potentiometer using the 8 digital inputs (`key[7:0]`) on the Hackathon board.

The goal is to show the value in three ways:

- **LEDs** → raw binary value  
- **TM1638 (7-segment display)** → hexadecimal value  
- **LCD screen** → a horizontal green bar whose width is proportional to the potentiometer value  

This is the first step toward real analog-to-digital demos (for example, using an ADC in future labs).

---

## Objective

By the end of this example, the user will understand how to:

- Represent a numeric value visually on different outputs (LEDs, 7-segment, LCD).
- Simulate analog input using digital switches.
- Draw a dynamic graphical element (horizontal bar) on the LCD based on a variable.
- Use arithmetic operations to scale a value to screen coordinates.

---

## Concept Summary

### Simulated Potentiometer Value

Since the board does not include a built-in ADC, the potentiometer is simulated with:

- `pot_value = key[7:0]` (a number between 0 and 255)

In a real scenario, this would be replaced with an ADC output.

### Displaying the Value

The example shows `pot_value` in three places:

- **LEDs** → each bit turns on/off matching `pot_value`
- **TM1638 7-segment display** → numeric representation in hexadecimal
- **LCD horizontal bar** → width proportional to `pot_value`

### LCD Concept

The LCD receives the current pixel coordinates:

- `x` (0–479)
- `y` (0–271)

To draw a bar:

- Compute a scaled width  
  `bar_width = (pot_value * SCREEN_WIDTH) >> 8`

Then color pixels accordingly:
- Black background  
- Green bar for the first `bar_width` pixels  
- Optional red center reference line  

---

## Signals and Ports

### Key Inputs

- `key[7:0]` — simulated potentiometer value (0–255)

### Outputs

- `led[7:0]` — binary representation of `pot_value`
- `abcdefgh[7:0]`, `digit[7:0]` — TM1638 display outputs
- `red`, `green`, `blue` — LCD pixel color
- `gpio[3:0]` — unused

### LCD Coordinates

- `x` → horizontal pixel (0–479)  
- `y` → vertical pixel (0–271)

---

## Internal Behavior

### 1. Potentiometer Value Selection

`pot_value = key[7:0]` — the switches simulate the ADC output.

### 2. LEDs

Direct mapping:  
`led = pot_value`

### 3. TM1638 Display

Uses `seven_segment_display` to show `pot_value` in hexadecimal.

### 4. LCD Horizontal Bar Rendering

- Background → black
- Green bar → width proportional to `pot_value`
- Red vertical reference line at `SCREEN_WIDTH/2`

---

## Visual Output Overview

### LEDs
- Each bit of the pot value lights a corresponding LED.

### TM1638
- Shows the same value in hexadecimal.

### LCD
- A horizontal green bar grows or shrinks as `key[7:0]` changes.

---

## Relationship to Previous Examples

Builds upon:

- **3_13** — static LCD shapes  
- **3_14** — moving rectangle on LCD  
- **3_15** — TM1638 quickstart  

This is the first example to combine **LCD + LEDs + TM1638**.

---

## Possible Extensions

- Reverse bar direction  
- Add decimal or blinking indicators  
- Display value in decimal  
- Add multiple bars  
- Replace simulated input with a real ADC  

---

## Summary

The `3_16` Potentiometer Read Demo ties together:

- Digital inputs  
- LED indicators  
- TM1638 output  
- LCD graphics  

It demonstrates how to convert a numeric value into multiple visual representations on the Tang Nano 9K Hackathon board.
