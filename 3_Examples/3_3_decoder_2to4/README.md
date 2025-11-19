# 3.3 Decoder 2→4 (binary 2-to-4 line decoder)

This example shows a **2→4 decoder** (binary decoder from 2 bits to 4 lines)  
implemented in several ways in SystemVerilog, and allows you to observe on the Tang Nano 9K  
how a 2-bit input selects **exactly one** of the 4 outputs (one-hot).

The idea is:

- Use a 2-bit binary input `in[1:0]` composed of `A` and `B`.
- Generate 4 outputs `Y[3:0]` where only one is `1` depending on `in`:
  - `in = 00` → `Y = 0001`
  - `in = 01` → `Y = 0010`
  - `in = 10` → `Y = 0100`
  - `in = 11` → `Y = 1000`
- Implement the same 2→4 decoder in **four different ways**:
  - Using AND/NOT (tedious logic equations)
  - Using `case`
  - Using shift (`<<`)
  - Using bit indexing

---

## Objective

At the end of the example, the user will be able to:

- Relate physical inputs (`key[1:0]`) to a binary word `in[1:0]`.
- Understand the behavior of a **2→4 decoder** (one-hot output).
- Implement a combinational decoder in different ways in SystemVerilog.
- See on the board how exactly one output is active for each input value.

---

## Signals and pins

The SystemVerilog code uses:

- `key[7:0]` as digital inputs from the board.
- `led[7:0]` as outputs to the board LEDs.

Logical mapping:

- **Decoder input:**

  - `in[1:0]` = `{ key[1], key[0] }`

- **Visible LEDs:**

  - `LED[0]` → bit 0 of `in` (LSB)
  - `LED[1]` → bit 1 of `in` (MSB)

  Thus, `LED[1:0]` display the binary value of `in`.

  - `LED[5:2]` → bits `dec3[3:0]`  
    (one-hot output of the decoder implemented via indexing)
  - `LED[7:6]` → unused (remain 0)

This allows you to see:

- On `LED[1:0]`: the binary value of the input  
- On `LED[5:2]`: which decoder line is active (one-hot)

---

## Suggested usage flow

1. **Review related theory**

   Before this example, it is recommended to review:

   - Modules and ports (how to declare inputs/outputs)
   - Difference between combinational and sequential logic
   - Concept of **decoder** or **demultiplexer** (one-hot outputs)
