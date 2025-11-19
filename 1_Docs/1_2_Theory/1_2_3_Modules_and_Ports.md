# Modules and ports

This document explains what a **module** is in SystemVerilog and how its **ports** (inputs, outputs, and when applicable, `inout`) are defined.

The goal is to understand the “basic unit” of a design in this repository.

---

## 1. What is a module?

A **module** represents a hardware block:

- It has a name (`module name ... endmodule`).
- It defines **ports** to communicate with other modules or with the external world.
- It contains internal signals and logic that describe its behavior.

In a larger design:

- Multiple modules connect to each other in a hierarchical structure.
- A module can **instantiate** other modules as sub-blocks.

---

## 2. Basic module definition

General structure:

module module_name (
    // Ports
    input  logic a,
    input  logic b,
    output logic y
);

    // Internal signals
    // logic internal_signal;

    // Logic (assign, always_comb, always_ff, etc.)

endmodule

Key elements:

- `module module_name` marks the start of the module.
- The list of ports goes inside parentheses.
- The module body contains declarations and logic.
- `endmodule` marks the end.

---

## 3. Port directions

Ports define **how information flows** between modules:

- `input`  
  - Signals that **enter** the module.  
  - The module **reads** them.

- `output`  
  - Signals that **leave** the module.  
  - The module **drives** them.

- `inout`  
  - Bidirectional signals (tri-state buses or certain peripherals).  
  - Rare in this repository; mainly used for `gpio` in the top-level modules.

Example combinational module (AND):

module and_gate (
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = a & b;
endmodule

---

## 4. Port width (vectors)

Ports may be:

- **Scalars**: a single bit (e.g., `logic a;`)
- **Vectors**: multiple bits (e.g., `logic [7:0] data;`)

Typical syntax:

input  logic       clk;        // 1 bit
input  logic [7:0] key;        // 8 bits
output logic [7:0] led;        // 8 bits

8-bit adder example:

module adder_8bit (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] sum
);
    assign sum = a + b;
endmodule

---

## 5. Internal signals vs ports

Inside a module we can declare **internal signals**:

module example (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] in_data,
    output logic [7:0] out_data
);

    logic [7:0] reg_data;   // internal register
    logic [7:0] next_data;  // internal combinational signal

    // Combinational logic
    always_comb begin
        next_data = in_data + 1;
    end

    // Sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            reg_data <= 0;
        else
            reg_data <= next_data;
    end

    assign out_data = reg_data;

endmodule

Differences:

- **Ports** connect the module to the outside world.
- **Internal signals** live only inside the module.

---

## 6. Module instantiation

To use a module inside another:

module top_example (
    input  logic a,
    input  logic b,
    output logic y
);

    logic y_internal;

    and_gate u_and (
        .a (a),
        .b (b),
        .y (y_internal)
    );

    assign y = y_internal;

endmodule

Key points:

- `and_gate` → name of the module.
- `u_and` → name of the instance.
- `.a(a)` → named connections (recommended).

---

## 7. Top-level modules in this repository

Two types appear frequently:

### 1. Board-specific top (actual synthesis top)

- Located in paths like `boards/.../board_specific_top.sv`
- Connects physical pins:
  - Clock, GPIO, LCD, TM1638, etc.
- Instantiates the logical top (`hackathon_top`)

### 2. Logical top for activities/labs (`hackathon_top`)

Found in each folder of `4_activities/` and `5_labs/`.

Defines standard logical ports:

- `clock`, `slow_clock`, `reset`
- `key[7:0]`, `led[7:0]`
- `abcdefgh`, `digit`
- `x`, `y`, `red`, `green`, `blue`
- `gpio[3:0]`

Example:

module hackathon_top (
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,
    input  logic [7:0] key,
    output logic [7:0] led,
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,
    inout  logic [3:0] gpio
);

    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;

    always_comb begin
        led = key;
    end

endmodule

This `hackathon_top` is instantiated inside the corresponding `board_specific_top`.

---

## 8. Best practices for modules and ports

1. **Define ports clearly**  
   Use `input/output/inout logic` and specify widths.

2. **Separate combinational and sequential logic**  
   - Use `always_comb` for combinational.
   - Use `always_ff` for registers.

3. **Avoid complex logic in top-level modules**  
   Extract reusable blocks into separate modules.

4. **Use named connections** in instantiations  
   Safer and more readable.

5. **Comment ports and modules**  
   Useful for peripherals like TM1638, LCD, and sensors.

---

## 9. Related theory documents

- `1_2_1_HDL_and_FPGA_Basics.md`
- `1_2_2_Verilog_SystemVerilog_Overview.md`
- `1_2_4_Combinational_vs_Sequential.md`
- `1_2_5_Registers_and_Clock.md`
