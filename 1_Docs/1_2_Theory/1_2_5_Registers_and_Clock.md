# 1.2.5 Registers and clock

This document introduces two core elements in FPGA design:

- The **clock signal** (`clk`)
- **Registers** (flip-flops) that store information between cycles

Most logic in this repository follows a **synchronous** style, meaning it is controlled by a common clock.

---

## 1. Clock signal

The **clock** is a periodic waveform (usually square) that sets the update rhythm of the system:

- Each edge (usually the **rising edge**) is a “tick”
- At each tick, registers may take new values

On the Tang Nano 9K:

- The board includes a reference oscillator (~27 MHz)
- Designs declare a port `clock` or `clk` connected to that pin
- The board-level module usually provides:
  - `clock` (fast raw clock)
  - `slow_clock` (a divided clock for slow effects)

Example clock port:

module binary_counter (
    input  logic clk,
    input  logic rst_n,
    output logic [7:0] count
);
    ...
endmodule

---

## 2. Registers (flip-flops)

A **register** is a set of flip-flops that stores a value:

- Updated only on a clock edge (according to the `always_ff` sensitivity list)
- Maintains the stored value between cycles
- Forms the basis of counters, FSMs, filters, etc.

Example:

module binary_counter (
    input  logic clk,
    input  logic rst_n,
    output logic [7:0] count
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else
            count <= count + 1;
    end

endmodule

Key points:

- `count` is an 8-bit register  
- Changes only on the rising edge or reset  
- Holds its value between edges  

---

## 3. Clock + register = sequential design

When you combine:

- A clock signal  
- Registers updated on the clock edge  
- Combinational logic between registers  

You get a **synchronous sequential design**.

Typical flow:

1. Registers sample data at a clock edge  
2. Combinational logic computes next values  
3. Next edge loads those values into registers  

This pattern:

- Simplifies reasoning about time behavior  
- Avoids metastability and glitches found in large combinational-only designs  
- Is the foundation of almost every `hackathon_top.sv` file  

---

## 4. Reset: synchronous vs asynchronous

Two reset styles appear in this repository:

### 4.1 Asynchronous reset

Register clears **immediately**, without waiting for a clock edge.

always_ff @(posedge clk or negedge rst_n)

Characteristics:

- Responds instantly  
- Useful for forcing the system to a known state at any moment  
- Requires careful timing design  

### 4.2 Synchronous reset

Register clears **on the next clock edge**.

always_ff @(posedge clk)

Characteristics:

- Reset aligns with the clock  
- Easier timing analysis  
- Common in modern synchronous design  

---

## 5. Practical rules for registers and clock

While working with these exercises:

- Prefer using **one main clock** per design  
- Avoid generating multiple clocks from logic; instead use:
  - **Enable pulses**
  - **Frequency dividers**
- Use:
  - `always_ff` for sequential logic  
  - `always_comb` for combinational logic  
- Keep reset style **consistent** inside each module  
- If signals cross clock domains, use proper **synchronizers**  

These rules are applied in:

- Counters in `5_1_counter_hello_world`  
- Traffic light FSM and lock FSM  
- Sensor + TM1638 labs  
- Implementations like:
  - Digital clock  
  - Ultrasonic radar display  

They form the foundation of the design style practiced in this material.
