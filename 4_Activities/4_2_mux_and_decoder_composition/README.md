# 4.2 – Composition: 2→4 Decoder + 4→1 Multiplexer

In this activity, you will **compose** simple combinational blocks to build a larger circuit:

- A **2→4 one-hot decoder**
- A **4→1 multiplexer**, implemented using:
  - the decoder output,
  - AND gates,
  - a final OR gate.

Board used: **Tang Nano 9K**  
Wrapper: `tang_nano_9k_lcd_480_272_tm1638_hackathon`

---

## Objectives

By the end of this activity, you will:

1. Implement a **2→4 one-hot decoder** using `case`.
2. Build a **4→1 mux** using AND + OR instead of high-level constructs.
3. Display decoder output and mux output on the board LEDs.
4. Understand how:
   - one-hot encoding,
   - data channel selection,
   - and mux output  
   relate to each other.

---

## Signal Mapping (recommended)

Inputs:

- `sel[1:0] = key[1:0]`
- `data[3:0] = key[5:2]`

LED outputs:

- `led[3:0]` → decoder output (one-hot)
- `led[4]`   → 4→1 mux output
- `led[7:5]` → free for extensions

The 7-segment display and LCD remain unused.

---

## Step 1: Implementing the Decoder

The decoder must produce:

| sel | dec_out |
|-----|---------|
| 00  | 0001    |
| 01  | 0010    |
| 10  | 0100    |
| 11  | 1000    |

Implementation recommended:

- `always_comb`  
- `unique case (sel)`  
- A default assignment `dec_out = 0`

---

## Step 2: Building the 4→1 Mux Using Decoder Output

Logic (conceptual):

- `and0 = dec_out[0] & data[0]`
- `and1 = dec_out[1] & data[1]`
- `and2 = dec_out[2] & data[2]`
- `and3 = dec_out[3] & data[3]`

Final mux output:

mux_y = and0 | and1 | and2 | and3


Or using reduction:

mux_y = |and_terms


This selects the correct `data[i]` depending on `sel`.

---

## Step 3: Testing

Example:

If `data = 4'b1010`:

| sel | dec_out | mux_y |
|-----|---------|--------|
| 00  | 0001    | 0      |
| 01  | 0010    | 1      |
| 10  | 0100    | 0      |
| 11  | 1000    | 1      |

Visually, on LEDs:

- `led[3:0]` scroll one-hot  
- `led[4]` shows the mux result

---

## Optional Extensions

- Show `sel` on `led[6:5]`
- Implement a second mux version using `case (sel)` and compare outputs
- Add a truth table as a comment for clarity

---
