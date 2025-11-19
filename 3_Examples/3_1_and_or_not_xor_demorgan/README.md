# 3.1 AND / OR / NOT / XOR + De Morgan's Laws

This example demonstrates the basic use of logic gates (`AND`, `OR`, `NOT`, `XOR`)  
and allows you to **verify one of De Morgan’s laws** using the buttons and LEDs of the Tang Nano 9K.

The idea is:

- Use two binary inputs `A` and `B` (buttons or keys).
- Display on different LEDs the result of:
  - `A AND B`
  - `A OR B`
  - `A XOR B`
  - `~(A & B)`
  - `(~A) | (~B)`
- Confirm that `~(A & B)` and `(~A) | (~B)` produce the same result for all combinations of `A` and `B`.

---

## Objective

At the end of the example, the user will be able to:

- Relate physical inputs (buttons) to logical signals `A` and `B`.
- Implement basic logic gates in SystemVerilog.
- Experimentally verify a De Morgan law by comparing two equivalent logical expressions.

---

## Files in this example

This folder uses at least:

- `fpga_top.sv`  
  Synthesizable top module for the Tang Nano 9K.  
  Implements the logic gates and the De Morgan expressions.

---

## Signals and pins

It is assumed that the constraints file `tang-nano-9k.cst` maps:

- Buttons to logical inputs:

  - `KEY[0]` → `B`
  - `KEY[1]` → `A`

- LEDs to logical outputs:

  - `LED[0]` → `A AND B`
  - `LED[1]` → `A OR B`
  - `LED[2]` → `A XOR B`
  - `LED[3]` → `~(A & B)`
  - `LED[4]` → `(~A) | (~B)`

In the SystemVerilog code, the following vectors are used:

- `key[1:0]` as inputs (coming from `KEY[1:0]`).
- `led[4:0]` as outputs (mapped to `LED[4:0]`).

A = `key[1]`  
B = `key[0]`

---

## Suggested usage flow

1. **Review related theory**

   Before this example, it is recommended to read in `1_2_Theory`:

   - `1_2_3_Modules_and_Ports.md`
   - `1_2_4_Combinational_vs_Sequential.md`

2. **Open the project in Gowin**

   - Create or open a Gowin IDE project for the Tang Nano 9K.
   - Add the example file `fpga_top.sv`.
   - Ensure that the top module is `fpga_top` (or the configured name).

3. **Verify constraints**

   - Ensure the project uses the constraints file:

     `2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

   - Confirm that `KEY[0]`, `KEY[1]` and `LED[4:0]` are correctly assigned.

4. **Synthesize and program**

   - Run synthesis and place & route in Gowin.
   - Program the FPGA with the generated bitstream.

5. **Test on the board**

   - Test all combinations of `A` and `B` (buttons):

     | A (`KEY[1]`) | B (`KEY[0]`) | LED0 = A & B | LED1 = A \| B | LED2 = A ^ B | LED3 = ~(A & B) | LED4 = (~A) \| (~B) |
     |--------------|--------------|--------------|----------------|---------------|------------------|----------------------|
     |      0       |      0       |      0       |       0        |       0       |        1         |          1           |
     |      0       |      1       |      0       |       1        |       1       |        1         |          1           |
     |      1       |      0       |      0       |       1        |       1       |        1         |          1           |
     |      1       |      1       |      1       |       1        |       0       |        0         |          0           |

   - Observe that `LED3` and `LED4` always have the same value:  
     this verifies De Morgan’s law:

     `~(A & B) = (~A) | (~B)`

## Relationship to other repository elements

- **Theory:**  
  `1_docs/1_2_Theory/1_2_3_Modules_and_Ports.md`  
  `1_docs/1_2_Theory/1_2_4_Combinational_vs_Sequential.md`
