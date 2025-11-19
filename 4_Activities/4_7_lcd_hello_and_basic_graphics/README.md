# 4.6 – 7-Segment Display Playground

This activity introduces a flexible playground for experimenting with the **7-segment display (TM1638)** using the `seven_segment_display` module already provided in the repository.

The goal is to let you try out:

- Hexadecimal counters  
- Manual digit editing  
- Scrolling patterns  
- Moving bars  
- Decimal point (dot) patterns  
- Your own visual experiments  

All using **8 digits**, fully multiplexed.

---

## Objectives

By the end of this activity, you should be able to:

1. Understand how multi-digit hexadecimal values are packed into the `number` bus.
2. Control decimal points per digit using `dots`.
3. Implement **multiple visualization modes** selected through `key[1:0]`.
4. Use a frequency divider (`tick`) to animate patterns at human-readable speeds.
5. Create your own effects by modifying the `TODO` sections in the template.

---

## Hardware context

This activity uses the board configuration:

`tang_nano_9k_lcd_480_272_tm1638_hackathon`

However, **the LCD is not used**; the focus is entirely on the 7-segment driver.

Relevant signals:

- **Outputs**
  - `abcdefgh[7:0]` → segment lines (a–g + dot)
  - `digit[7:0]` → one-hot digit enable for multiplexing
- **Inputs**
  - `clock` → ~27 MHz
  - `reset`
  - `key[7:0]` → used for mode selection and manual nibble input
- **LEDs**
  - Used only as indicators (optional)

---

## Key ideas

### 1. The display driver accepts a 32-bit packed number

`number_reg` is structured as:

mode = key[1:0]


### **Mode 0 — Free Hexadecimal Counter**
A 32-bit counter increments on each `tick` and fills all 8 digits.

Useful for testing:

- multiplexing
- speed
- stable segment wiring

### **Mode 1 — Manual test mode**
You can place a manual nibble (`key[7:4]`) into one digit (default: digit 0).

Ideas:

- Copy the nibble into multiple digits
- Mirror values
- Build simple patterns

### **Mode 2 — Scrolling or moving pattern**
Using the `scroll_pos` index, you can:

- Move a bright digit across the display  
- Create a bar animation  
- Flash a specific pattern at different positions  
- Build a scrolling text effect using duplicated patterns

This is the mode with the most creative potential.

### **Mode 3 — Free mode**
Reserved for your own experiments:

- Fixed words (`DEAD_BEEF`, `C0FF_EE00`, etc.)
- Alternating patterns
- Visual alarms
- Dot-only animations
- Combined effects

---

## Suggested experiments

Here are small, fast ideas you can try:

### **Hex bouncing**
Reverse the direction of a moving bar when reaching D0 or D7.

### **Scrolling text**
Duplicate the pattern, then shift:

extended = {pattern, pattern}

window = extended >> (scroll_pos * 4)



### **Dot wave**
Animate dots independently:

dots_reg = scroll_pos << 1;


### **Two-layer animations**
Use dots as one layer and digits as another.

---

## Testing guide

### Verify wiring and multiplexing

- Enter Mode 0
- Ensure all digits light up properly
- Enable some dots to check individual wiring

### Test manual entry

- Enter Mode 1
- Change `key[7:4]` from 0 to F
- Confirm each symbol appears correctly

### Test scrolling

- Enter Mode 2
- Confirm that movement is smooth and periodic
- Adjust divider (`W_DIV`) to fine-tune speed

### Test free mode

- Enter Mode 3
- Display a fixed known pattern to verify digit order

---

## Files involved

Inside:

4_activities/4_6_seven_segment_playground/


You will find:

- `hackathon_top.sv` → activity template  
- Uses:
  - `labs/common/seven_segment_display.sv`

---

## Summary

This activity is designed for:

- practicing multi-digit 7-segment control,
- learning how to pack and unpack hexadecimal digits,
- using tick-based animation,
- experimenting with display effects.

It is intentionally open-ended:  
**you can add as many custom modes and visual effects as you want.**

---

