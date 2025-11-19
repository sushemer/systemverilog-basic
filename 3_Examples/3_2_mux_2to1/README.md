# 3.2 Multiplexer 2:1 (mux 2:1)

This example shows a **2:1 multiplexer** implemented in several ways  
in SystemVerilog and allows you to **verify that all implementations are equivalent**  
using the buttons and LEDs of the Tang Nano 9K.

The idea is:

- Use three binary inputs:
  - `d0` (data input 0)
  - `d1` (data input 1)
  - `sel` (selection signal)
- Implement the 2:1 mux in four ways:
  - `always_comb` + `if / else`
  - Conditional operator `?:`
  - `case` statement
  - Logic gate expression (`&`, `|`, `~`)
- Check that all outputs match for any combination of `d0`, `d1`, and `sel`.

---

## Objective

At the end of the example, the user will be able to:

- Relate physical inputs (switches / keys) to logical signals `d0`, `d1`, and `sel`.
- Understand the behavior of a **2:1 multiplexer**.
- Implement the same combinational function in different ways in SystemVerilog.
- Experimentally verify that all mux implementations are equivalent.

---

## Signals and pins

In the SystemVerilog code, the following vectors are used:

- `key[7:0]` as inputs (connected to switches / buttons).
- `led[7:0]` as outputs (connected to LEDs).

Logical mapping:

- Mux inputs:

  - `d0` ← `key[0]`
  - `d1` ← `key[1]`
  - `sel` ← `key[7]` (selector)

- Outputs shown on LEDs:

  - `LED[0]` → `d0`
  - `LED[1]` → `d1`
  - `LED[2]` → `sel`
  - `LED[3]` → mux output implemented with `if / else` (`y_if`)
  - `LED[4]` → mux output implemented with ternary operator `?:` (`y_tern`)
  - `LED[5]` → mux output implemented with `case` (`y_case`)
  - `LED[6]` → mux output implemented with logic gates (`y_gate`)
  - `LED[7]` → unused (can remain 0)

Behavior:

- If `sel = 0` → output `y = d0`
- If `sel = 1` → output `y = d1`

If all implementations are correct, LEDs 3, 4, 5, and 6 **should always match**.

---

## Suggested usage flow

1. **Review related theory**

   Recommended theory before this example:

   - Introduction to modules and ports
   - Difference between combinational and sequential logic
   - Optional: multiplexers topic if available in your repo

2. **Synthesize and program**

   - Run synthesis, place & route, and generate the bitstream.
   - Program the FPGA with the generated bitstream.

3. **Test on the board**

   Try several combinations of `d0`, `d1`, and `sel`:

   | d0 (`key[0]`) | d1 (`key[1]`) | sel (`key[7]`) | expected y (mux) |
   |---------------|---------------|----------------|------------------|
   |      0        |      0        |      0         |        0         |
   |      0        |      1        |      0         |        0         |
   |      1        |      0        |      0         |        1         |
   |      1        |      1        |      0         |        1         |
   |      0        |      0        |      1         |        0         |
   |      0        |      1        |      1         |        1         |
   |      1        |      0        |      1         |        0         |
   |      1        |      1        |      1         |        1         |

   Confirm:

   - `LED[0]` and `LED[1]` match `d0` and `d1`
   - `LED[2]` matches `sel`
   - `LED[3]`, `LED[4]`, `LED[5]`, and `LED[6]` **always match**

---

## Relationship with other repository elements

- **Theory (suggested docs):**
  - Basic concepts of modules and ports
  - Combinational vs sequential logic
  - Multiplexers and other combinational blocks

- **Related examples:**
  - `3.1 AND / OR / NOT / XOR + De Morgan’s Laws`
