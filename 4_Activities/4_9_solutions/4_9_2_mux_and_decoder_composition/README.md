# 4_9_2 – 4-to-1 Mux + 2-to-4 Decoder (composition)

This solution corresponds to the activity based on `4_02_mux_and_decoder_composition`, but located in the `4_9_solutions` folder.

Its purpose is to show a complete and organized implementation of:

- A **2-to-4 one-hot decoder**.
- A **4-to-1 multiplexer** built from:
  - The decoder’s one-hot outputs.
  - AND gates.
  - A final OR.

---

## Objective

Practice **combinational block composition**, moving from simple selection signals (`sel[1:0]`) to:

1. A one-hot vector `dec_out[3:0]` (2-to-4 decoder).
2. A 4-to-1 mux that uses that one-hot value to select one of the `data[3:0]` bits.

All outputs are visualized on the board’s LEDs for easy verification.

---

## Signal mapping

### Inputs from `key`

- `sel[1:0] = key[1:0]`  
  Selection bits for the mux (index 0 to 3).

- `data[3:0] = key[5:2]`  
  Data inputs for the mux; each bit represents an independent channel.

In typical code inside `hackathon_top.sv`:

logic [1:0] sel;
logic [3:0] data;

assign sel  = key[1:0];
assign data = key[5:2];

### Outputs to `led`

- `led[3:0] = dec_out[3:0]`  
  Shows the **2-to-4 decoder** output (one-hot).

- `led[4] = mux_y`  
  Shows the **4-to-1 mux** output.

- `led[7:5]`  
  Not used in this solution (available for extensions or debugging).

Final assignment example:

assign led[3:0] = dec_out;
assign led[4]   = mux_y;
assign led[7:5] = 3'b000;  // free in this solution

---

## Logical design

### 1. 2-to-4 one-hot decoder

The decoder takes `sel[1:0]` and generates `dec_out[3:0]` as one-hot encoding:

- `sel = 2'b00 → dec_out = 4'b0001`
- `sel = 2'b01 → dec_out = 4'b0010`
- `sel = 2'b10 → dec_out = 4'b0100`
- `sel = 2'b11 → dec_out = 4'b1000`

It is important to initialize `dec_out` to zero and then set exactly one bit.

Typical implementation in `always_comb`:

logic [3:0] dec_out;

always_comb begin
    dec_out = 4'b0000;  // default value

    unique case (sel)
        2'b00: dec_out = 4'b0001;
        2'b01: dec_out = 4'b0010;
        2'b10: dec_out = 4'b0100;
        2'b11: dec_out = 4'b1000;
        default: dec_out = 4'b0000;
    endcase
end

This guarantees that exactly one bit is 1 for each valid sel.

---

### 2. 4-to-1 mux built with decoder + AND + OR

The 4→1 mux is built **without** using the `?:` operator or a `case`.  
Instead, it uses:

1. The decoder’s one-hot output.
2. AND gates for each channel.
3. A final OR combining the terms.

Logical idea:

and0 = dec_out[0] & data[0]  
and1 = dec_out[1] & data[1]  
and2 = dec_out[2] & data[2]  
and3 = dec_out[3] & data[3]  
mux_y = and0 | and1 | and2 | and3

This can be written as:

logic and0, and1, and2, and3;
logic mux_y;

always_comb begin
    and0 = dec_out[0] & data[0];
    and1 = dec_out[1] & data[1];
    and2 = dec_out[2] & data[2];
    and3 = dec_out[3] & data[3];

    mux_y = and0 | and1 | and2 | and3;
end

Because the decoder is one-hot, only one AND term can be 1.  
Therefore:

mux_y = data[sel]

but implemented through structural composition:

selection → decoder → AND-masking → OR-final

---

## Solution summary

The solution in `4_9_2` for `hackathon_top.sv` typically follows:

1. **Read inputs from `key`**  
   sel and data extracted from specific bits.

2. **2-to-4 decoder**  
   - `always_comb` with `case (sel)`  
   - Output visible on `led[3:0]`

3. **4→1 mux**  
   - AND between one-hot and each data bit  
   - OR to produce final output  
   - Output visible on `led[4]`

4. **Remaining LEDs (`led[7:5]`)**  
   Left unused but available for extra debugging or experiments.

---

## How to test on the board

1. Program the Tang Nano 9K with this solution.
2. Adjust inputs:
   - Change `sel` with `key[1:0]`
   - Change `data[3:0]` with `key[5:2]`
3. Observe LEDs:
   - `led[3:0]`: active one-hot line  
   - `led[4]`: selected data bit (`mux_y`)

### Example test

If:

data = 4'b1010  
sel  = 2'b10  

Then:

dec_out = 4'b0100  
selected channel = data[2]  
mux_y = 1

On the board:

led[2] = 1 (active decoder channel)  
led[4] = 1 (mux output)

This verifies:

- The decoder produces correct one-hot output  
- The 4→1 mux (decoder + AND + OR) selects the correct bit from data
