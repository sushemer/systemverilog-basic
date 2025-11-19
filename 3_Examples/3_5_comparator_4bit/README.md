# 3.5 4-bit Comparator (A vs B)

This example demonstrates a **4-bit comparator** implemented in two ways in SystemVerilog and allows you to verify in hardware whether a value `A` is less than, equal to, or greater than another value `B`, using the buttons/keys of the Tang Nano 9K.

The idea is:

- Build two 4-bit numbers:
  - `A[3:0]` from `key[3:0]`
  - `B[3:0]` from `key[7:4]`
- Evaluate the three conditions:
  - `A == B`
  - `A > B`
  - `A < B`
- Implement the comparator in two different ways:
  - Using relational operators (`==`, `>`, `<`).
  - Using a **bit-by-bit cascading comparison** (like in a classic digital comparator).
- Display the six signals (two versions of eq/gt/lt) on the LEDs.

---

## Objective

At the end of this example, the user will be able to:

- Represent two 4-bit numbers using the inputs `key[7:0]`.
- Understand how a **magnitude comparator** works (A vs B).
- See the difference between a high-level description (`==`, `>`, `<`) and a **structural bit-by-bit implementation**.
- Verify that both implementations produce the same results.

---

## Signals and LED mapping

- Inputs:

  - `A[3:0] = key[3:0]`
  - `B[3:0] = key[7:4]`

- Outputs:

  - Implementation 0 (high level):

    - `eq0` → `LED[0]`  (1 when `A == B`)
    - `gt0` → `LED[1]`  (1 when `A >  B`)
    - `lt0` → `LED[2]`  (1 when `A <  B`)

  - Implementation 1 (bitwise):

    - `eq1` → `LED[3]`
    - `gt1` → `LED[4]`
    - `lt1` → `LED[5]`

  - `LED[6]` and `LED[7]` → not used (0)

In any combination of `A` and `B`, exactly one of the following patterns must be true for each implementation:

- `eqX = 1`, `gtX = 0`, `ltX = 0`  → A equal to B.
- `eqX = 0`, `gtX = 1`, `ltX = 0`  → A greater than B.
- `eqX = 0`, `gtX = 0`, `ltX = 1`  → A less than B.

And implementation 0 and implementation 1 must produce **the same pattern**:

- `(eq0, gt0, lt0) = (eq1, gt1, lt1)`.

---

## Suggested usage flow

1. **Review associated theory**

   Before this example, it is recommended to review:

   - Binary number representation.
   - Magnitude comparators (A == B, A > B, A < B).
   - Structural bitwise implementations (as in cascading 1-bit comparators).
