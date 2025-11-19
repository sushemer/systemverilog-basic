# Lab 5.2 – buttons_and_debounce

**Level:** Beginner  
**Board:** Tang Nano 9K (`tang_nano_9k_lcd_480_272_tm1638_hackathon`)  
**Main file:** `hackathon_top.sv`

---

## 1. Objective

Control one or more LEDs using buttons, with **pure combinational logic**, practicing:

- Continuous assignments (`assign`)
- Basic 1-bit logic operators: `~`, `&`
- Simple wiring between inputs and outputs

At the end of this lab, the student should understand:

- The difference between `assign` (continuous combinational logic) and `always_ff`
- How to map button inputs to LED outputs
- How Boolean operations behave visibly on the FPGA board

---

## 2. Signal mapping

Suggested mapping (may vary depending on the board wrapper):

- **Inputs:**
  - `btn = key[0]` → main button
  - `en  = key[1]` → enable button

- **Outputs:**
  - `led[0]` → follows the button (`btn`)
  - `led[1]` → ON when button is released (`~btn`)
  - `led[2]` → ON only when both `btn` and `en` are 1 (`btn & en`)
  - `led[7:3]` → OFF (`0`)

---

## 3. Suggested steps

### Step 1 – Open the template

1. Go to:
   `5_Labs/5_2_buttons_and_debounce/`
2. In `hackathon_top.sv`, locate:
   - The assignments that disable `abcdefgh`, `digit`, `red`, `green`, `blue`
   - The section where `btn` and `en` are mapped from `key`
   - The `assign` lines marked as TODO

---

### Step 2 – Complete the assignments

The template contains:

assign led[7:3] = 5'b00000;

// assign led[0] = ...;
// assign led[1] = ...;
// assign led[2] = ...;

You must complete them with the correct logic.

#### 1. LED 0 → direct mapping

assign led[0] = btn;

#### 2. LED 1 → inverted behavior

assign led[1] = ~btn;

#### 3. LED 2 → AND with enable

assign led[2] = btn & en;

Full block:

assign led[7:3] = 5'b00000;  // higher LEDs OFF
assign led[0]   = btn;       // direct button
assign led[1]   = ~btn;      // inverted button
assign led[2]   = btn & en;  // AND with enable

---

## 4. Suggested tests

### 4.1 Test LED 0 and LED 1

Press `key[0]`:

- `btn = 1` →  
  - `led[0]` ON  
  - `led[1]` OFF  

Release `key[0]`:

- `btn = 0` →  
  - `led[0]` OFF  
  - `led[1]` ON  

This visually demonstrates:

- The button value (`led[0]`)
- Its logical negation (`led[1]`)

### 4.2 Test LED 2 with enable

Case analysis:

- `en = 0` → `led[2] = 0`, regardless of `btn`
- `en = 1` and `btn = 0` → `led[2] = 0`
- `en = 1` and `btn = 1` → `led[2] = 1`

Truth table (`btn`, `en` → `led[2]`):

- 0,0 → 0  
- 0,1 → 0  
- 1,0 → 0  
- 1,1 → 1  

---

## 5. About mechanical button bounce

This lab uses **raw button inputs**, so electrical bouncing is visible but harmless.

Real buttons typically “bounce” (0↔1 transitions during press/release).  
For simple LED mapping this is fine, but later labs (counters, FSMs) **require** clean inputs.

The repository includes debounce modules:

- `sync_and_debounce`
- `sync_and_debounce_one`

These can be added later if desired.

---

## 6. Optional extensions

### 6.1 Try other logic operations

Some examples:

- `led[3] = btn | en;` → ON if **either** button is pressed  
- `led[4] = btn ^ en;` → ON if **exactly one** is pressed  
- `led[5] = ~(btn & en);` → De Morgan practice  

### 6.2 Invert LED polarity

If the board uses active-low LEDs:

assign led[0] = ~btn;

### 6.3 Add debounce

To prepare for future labs:

- Use `sync_and_debounce_one` before mapping `btn` to LEDs

---

## 7. Summary

This lab reinforces:

- **Combinational logic (`assign`)**
- **Boolean operations** on single-bit signals
- **Direct mapping** from digital inputs to LEDs

This pattern is essential for:

- Debugging  
- Visualizing FSM states  
- Understanding basic logic behavior on real hardware  
