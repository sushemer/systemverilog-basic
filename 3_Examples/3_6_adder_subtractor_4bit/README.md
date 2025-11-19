# 3.6 3-bit Adder/Subtractor (A ± B)

This example implements a **3-bit adder/subtractor** in two ways:

- **Implementation 0**: direct use of the arithmetic operators `+` and `-`.
- **Implementation 1**: use of a single adder with the **two’s complement formula**:

res = A + (B ⊕ M) + M

where `M = mode` (mode bit).

The Tang Nano 9K board is used with the configuration  
`tang_nano_9k_lcd_480_272_tm1638_hackathon`.

---

## 1. General idea

The buttons `key[7:0]` are used to build two 3-bit numbers and one mode bit:

- `A[2:0] = key[2:0]`
- `B[2:0] = key[5:3]`
- `mode   = key[7]`

Behavior:

- If `mode = 0` → **addition**:  `A + B`
- If `mode = 1` → **subtraction**: `A - B`

The result is a **4-bit number** (`[3:0]`):

- 3 bits for the value (0–7).
- 1 extra bit for **carry/borrow**.

Each implementation produces a 4-bit result which is displayed on a different group of LEDs.

Note: `key[6]` is not used in this example.

---

## 2. Objective of the example

Upon completing this example, the user will be able to:

- Represent two 3-bit numbers using the board’s buttons.
- Understand two ways to implement an **adder/subtractor**:
  - direct implementation with `+` and `-`, and
  - unified implementation with a single adder and two’s complement.
- Compare both implementations by observing the results on the LEDs.

---

## 3. Main signals

### Inputs

- `A[2:0]` ← `key[2:0]`
- `B[2:0]` ← `key[5:3]`
- `mode`  ← `key[7]` (`0` = add, `1` = subtract)

### Outputs (summary)

- **Implementation 0** → `res0[3:0]`
  - `res0[2:0]`: 3-bit result
  - `res0[3]`  : carry/borrow bit
- **Implementation 1** → `res1[3:0]`
  - `res1[2:0]`: 3-bit result
  - `res1[3]`  : carry/borrow bit

---

## 4. Implementation 0 – Arithmetic operators (`+` and `-`)

This version uses “high-level” logic:

- If `mode = 0` → `res0 = A + B`
- If `mode = 1` → `res0 = A - B`

We obtain 4 bits:

- `s0[2:0] = res0[2:0]`
- `c0      = res0[3]`

LED mapping:

- `LED[0]` ← `s0[0]`
- `LED[1]` ← `s0[1]`
- `LED[2]` ← `s0[2]`
- `LED[3]` ← `c0`

This group of LEDs displays the “raw” result from the language’s arithmetic operator.

---

## 5. Implementation 1 – Adder/Subtractor with two’s complement

This version forces the use of **a single adder** for both addition and subtraction,
applying two’s complement on `B` when necessary.

The equation used is:

res1 = A + (B ⊕ {3{mode}}) + mode

Intuition:

- If `mode = 0`:
  - `B ⊕ 000 = B`
  - `res1 = A + B + 0 = A + B`
- If `mode = 1`:
  - `B ⊕ 111 = ~B`
  - `res1 = A + (~B) + 1 = A - B` (two’s complement subtraction)

Again, we obtain 4 bits:

- `s1[2:0] = res1[2:0]`
- `c1      = res1[3]`

LED mapping:

- `LED[4]` ← `s1[0]`
- `LED[5]` ← `s1[1]`
- `LED[6]` ← `s1[2]`
- `LED[7]` ← `c1`

---

## 6. Reading results on the board

During execution:

- **LEDs 0–3** show the result of **implementation 0**.
- **LEDs 4–7** show the result of **implementation 1**.

This allows the user to:

- Confirm that both approaches produce the same value for all combinations of `A`, `B`, and `mode`.
- Study how the carry/borrow bit changes when switching from addition to subtraction.
