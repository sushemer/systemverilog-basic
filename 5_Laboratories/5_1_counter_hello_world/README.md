# Lab 5.1 – counter_hello_world

**Level:** Beginner  
**Board:** Tang Nano 9K (`tang_nano_9k_lcd_480_272_tm1638_hackathon`)  
**Main file:** `hackathon_top.sv`

---

## 1. Objective

Make an LED on the board blink (~1 Hz) using:

- A **counter** that divides the FPGA clock.
- A **register** updated using `always_ff @(posedge clk)`.
- A simple **mapping** from internal logic to a physical pin (`led[0]`).

By the end of the lab, the student should feel comfortable with:

- Creating a simple module with inputs and outputs.
- Using a register as a frequency divider.
- Understanding how a high bit of the counter becomes a visible blinking signal.

---

## 2. Prerequisites

You should have:

- Installed:
  - Gowin IDE + toolchain (as used across the repo).
  - The `03_synthesize_for_fpga.bash` script working.
- Basic understanding of:
  - `logic`, `always_ff`, `always_comb`.
  - The general `hackathon_top` structure from earlier examples.

---

## 3. Suggested Steps

### Step 1 – Explore the template

1. Open `5_Labs/5_1_counter_hello_world/hackathon_top.sv`.
2. Identify:
   - The assignments disabling `abcdefgh`, `digit`, `red`, `green`, `blue`.
   - The **frequency divider** section (`W_DIV` and `div_cnt`).
   - The `always_comb` block where LEDs are driven.

The idea is to locate where the counter is and where the LED must be mapped before writing any logic.

---

### Step 2 – Implement the counter

In the file you will find something like:

logic [W_DIV-1:0] div_cnt;

always_ff @(posedge clock or posedge reset)
begin
    if (reset)
    begin
        div_cnt <= '0;
    end
    else
    begin
        // TODO: increment counter
        // div_cnt <= ...;
    end
end

The task is for the counter to **increment continuously** while `reset` is low.

A typical implementation is:

always_ff @(posedge clock or posedge reset)
begin
    if (reset)
    begin
        div_cnt <= '0;
    end
    else
    begin
        div_cnt <= div_cnt + 1'b1;
    end
end

This makes `div_cnt` behave as a binary counter of `W_DIV` bits that increases on every rising clock edge.

---

### Step 3 – Choose the bit that will produce the blinking

Each bit of `div_cnt` toggles at a different frequency:

- Bit 0 toggles at the same frequency as the FPGA clock.
- Bit 1 toggles at half that.
- Bit 2 at one-fourth.
- …
- In general, bit `k` toggles at:

    clock / (2^(k+1))

To generate ~1 Hz blinking, choose a **higher bit** of the counter (depending on the FPGA clock and the selected `W_DIV`).

Example:

- If `W_DIV = 25`, a typical choice is `div_cnt[24]`.

You can declare an intermediate signal:

logic blink;
assign blink = div_cnt[W_DIV-1];  // highest bit of the counter

Or use an explicit index:

localparam int BLINK_BIT = W_DIV-1;
logic blink;

assign blink = div_cnt[BLINK_BIT];

---

### Step 4 – Map the blinking bit to `led[0]`

The template includes:

always_comb
begin
    led = 8'b0000_0000;
    // TODO: connect something to led[0]
end

You must:

- Keep all LEDs OFF.
- Connect `blink` to `led[0]`.

Example:

always_comb
begin
    led    = 8'b0000_0000;
    led[0] = blink;      // LED0 blinks with the counter bit
end

This ensures the physical LED receives the blinking signal.

---

### Step 5 – Synthesize, program, and observe

1. Run the synthesis/programming script from the repo root:

./03_synthesize_for_fpga.bash 5_Labs/5_1_counter_hello_world

2. Program the Tang Nano 9K once the bitstream is generated.

3. After loading the bitstream:

- Check that `led[0]` is blinking visibly.
- If it blinks **too fast**, increase `W_DIV` or use a higher counter bit.
- If it blinks **too slow**, decrease `W_DIV` or use a lower counter bit.

A comfortable blinking frequency is around 1–2 Hz.
