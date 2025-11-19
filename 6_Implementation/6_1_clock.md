# 6.1 – Clock (digital 12/24 h)

## Objective

Implement a **digital clock** that:

1. Generates a **1-second time base** from the FPGA clock (≈27 MHz).  
2. Maintains counters for:
   - seconds (0–59),
   - minutes (0–59),
   - hours (24 h and/or 12 h mode).
3. Allows **minute adjustment** in steps:
   - ±1 minute,
   - ±5 minutes,
   - ±10 minutes,
   using buttons (or an encoder) with **debounce and edge detection**.
4. Displays the time on a **seven-segment display** or **TM1638**, with no visible flicker.
5. Ensures **correct rollovers**:
   - 59 → 00 for seconds/minutes.
   - 23 → 00 (24 h mode).
   - Correct 12 h logic (AM/PM) if implemented.

---

## Suggested hardware

- **FPGA:** Tang Nano 9K  
- **Display:**
  - 4-digit seven-segment display, **or**
  - TM1638 module (recommended due to existing integration)
- **Inputs:**
  - 3–4 buttons (for example):
    - `BTN_MODE` → toggle 12/24 h or other modes  
    - `BTN_UP`   → increase minutes  
    - `BTN_DOWN` → decrease minutes  
    - `BTN_STEP` → change step (±1 / ±5 / ±10)  
  - **or** a rotary encoder (minute adjustment) + push button  
- Breadboard / jumpers as needed

---

## Concepts involved

- Stable frequency divider (clock divider)  
- Counters with rollover (seconds, minutes, hours)  
- Simple FSM for 12/24 h mode and adjustment mode  
- Button debounce + edge detection  
- Multiplexing and driving seven-segment or TM1638  
- Glitch-free display updates  

---

## Proposed behavior

### 1. Time base (1 Hz)

- Start from the FPGA clock (~27 MHz).
- Implement a large counter to generate a `tick_1s` pulse.
- Use `tick_1s` to increment the seconds counter.

---

### 2. Time counters

- `sec` : 0–59  
- `min` : 0–59  
- `hour`:
  - 0–23 in 24 h mode
  - 1–12 in 12 h mode (AM/PM)

Chained rollover:

- If `sec == 59` and `tick_1s` arrives → `sec = 0`, then `min++`.
- If `min == 59` and incrementing → `min = 0`, then `hour++`.
- If `hour == 23` and incrementing (24 h) → `hour = 0`.

---

### 3. Minute adjustment

Using debounced, edge-detected buttons:

- `BTN_STEP` selects step (1, 5, or 10 minutes).
- `BTN_UP` increases minutes.
- `BTN_DOWN` decreases minutes.

Rollover examples:

- 58 + 5 → 03 (and hour++)  
- 02 − 5 → 57 (and hour--)  

---

### 4. 12 / 24 h modes

`BTN_MODE` toggles display mode:

- Internally, keep time in 0–23 format.
- Convert to 12 h representation before display:
  - 0 → 12 (AM)
  - 13 → 1 PM
  - etc.

---

### 5. Display output

For **4 digits**:

- Show HH:MM (no seconds)
- Display `hour` and `min` as two digits each
