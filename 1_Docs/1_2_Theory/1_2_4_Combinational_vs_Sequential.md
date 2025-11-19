# 1.2.4 Combinational vs sequential logic

This document explains the difference between **combinational logic** and **sequential logic**, one of the most important concepts when designing with SystemVerilog and FPGAs.

---

## 1. Combinational logic

**Combinational logic** is logic in which:

- The output depends **only** on the inputs **at that moment**.
- There is no explicit memory inside the block.
- If the inputs change, the outputs change “immediately” (logically speaking, ignoring physical delays).

Typical examples:

- Logic gates (AND, OR, NOT, XOR)
- Comparators
- Multiplexers (mux)
- Decoders

In SystemVerilog, combinational logic is usually described using:

### 1.1 Continuous assignments

assign y = a & b;
assign z = sel ? d1 : d0;

- `assign` creates a continuous relationship between signals.
- Whenever any signal on the right-hand side changes, the tool updates the output.

### 1.2 `always_comb` blocks

module mux2to1 (
    input  logic       sel,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] y
);
    always_comb begin
        if (sel)
            y = a;
        else
            y = b;
    end
endmodule

Characteristics of `always_comb`:

- Used to describe **memoryless** logic.
- The tool automatically infers the sensitivity list (no need for `@(*)`).
- If a branch is missing, the tool may infer a latch, which usually indicates an error.

---

## 2. Sequential logic

**Sequential logic** includes **memory**:

- The output depends on:
  - The **current inputs**, and  
  - The **stored state** in registers (flip-flops)
- It normally updates on a **clock edge** (`clk`).

Typical examples:

- Counters  
- Shift registers  
- Finite State Machines (FSM)  
- Accumulators and digital filters  

In SystemVerilog, sequential logic is usually described with:

### 2.1 `always_ff` clocked blocks

module counter_8bit (
    input  logic       clk,
    input  logic       rst_n,
    output logic [7:0] count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;           // Asynchronous reset
        else
            count <= count + 1;   // Increment on each clock
    end
endmodule

Characteristics of `always_ff`:

- Used to describe **registers** (flip-flops).
- Sensitivity list includes:
  - A clock edge (`posedge clk` or `negedge clk`)
  - Optionally a reset signal (`rst` or `rst_n`)
- **Non-blocking assignments** (`<=`) must be used to avoid ordering issues.

---

## 3. Combining combinational and sequential logic

Most real-world designs **combine both**:

- Sequential logic stores the **state**
- Combinational logic computes:
  - The **next state**
  - The **outputs** based on inputs and current state

Example:

module counter_with_next (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enable,
    output logic [7:0] count
);
    logic [7:0] next_count;

    always_comb begin
        if (enable)
            next_count = count + 1;
        else
            next_count = count;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else
            count <= next_count;
    end
endmodule

Separating “calculation” (combinational) from “storage” (sequential) helps to:

- Improve readability
- Avoid unintended latches
- Visualize the data flow better

---

## 4. How to distinguish them when reading code

A simple rule:

- **Does the sensitivity include a clock?**
  - Yes → **Sequential logic**
  - No, and it uses `always_comb` or `assign` → **Combinational logic**

Examples:

- `assign`, `always_comb` → combinational  
- `always_ff @(posedge clk ...)` → sequential  
- `always_ff @(posedge clk or posedge rst)` → sequential with reset  

Repository conventions:

- Use **only** `always_comb` for combinational logic  
- Use **only** `always_ff` for sequential logic  
- Avoid generic `always @(*)` or `always @(posedge clk)`  

---

## 5. Common mistakes

1. **Using combinational logic when memory is required**  
   Example: implementing a counter in `always_comb` instead of `always_ff`.

2. **Not assigning all branches in `always_comb`**  
   → Tool infers a **latch** (unwanted memory).

3. **Using blocking assignment (`=`) in sequential logic**  
   → Can cause simulation mismatches and timing errors.

---

## 6. Relation to other theory documents

- `1_2_3_Modules_and_Ports.md`  
- `1_2_5_Registers_and_Clock.md`  
- `1_2_6_Timing_and_Dividers.md`  
- `1_2_7_Finite_State_Machines.md`

Understanding this distinction is essential for:

- Reading `3_examples/` correctly  
- Solving `4_activities/` without inferring latches  
- Designing stable and debuggable labs and implementations  
