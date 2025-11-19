# 4_9_1 – Solution: Logic Gates, De Morgan, and Combinational Functions

This solution completes the 3 tasks described in the original `hackathon_top.sv` activity file.

---

## Inputs

From the board keys (according to the wrapper):

- `A  = key[1]`
- `B  = key[0]`
- `C  = key[2]`
- `EN = key[3]` (global enable signal)

These inputs are used to build combinational expressions and to control what is shown on the LEDs.

---

## Task 1 – Basic logic gates + De Morgan (2 inputs)

We implement the following expressions:

- `and_ab     = A & B`
- `or_ab      = A | B`
- `xor_ab     = A ^ B`
- `demorgan_1 = ~(A & B)`
- `demorgan_2 = (~A) | (~B)`

### LED mapping

- `led[0]` → `and_ab`
- `led[1]` → `or_ab`
- `led[2]` → `xor_ab`
- `led[3]` → `demorgan_1`
- `led[4]` → `demorgan_2`

This lets you visually verify that `demorgan_1` and `demorgan_2` always produce the same output.

---

## Task 2 – Functions with 3 inputs (A, B, C)

### 2.1 Majority function (`majority_abc`)

Definition:

(A & B) | (A & C) | (B & C)


Outputs 1 when at least two inputs are 1.

### 2.2 Exactly-one function (`exactly_one_abc`)

Definition:

( A & ~B & ~C)

|(~A & B & ~C)

|(~A & ~B & C)


Outputs 1 when exactly one input is 1.

### LED mapping

- `led[5]` → majority  
- `led[6]` → exactly-one  

---

## Task 3 – Global enable (`EN`)

- If `EN = 0`: all LEDs are zero.
- If `EN = 1`: the results of Tasks 1 and 2 are shown.
- `led[7] = EN` acts as an indicator.

Implementation:

- Build `raw_leds` with the logical results.
- Use `EN` to choose between `raw_leds` and zero.

---

## Summary

This solution:

- Implements all basic logic gates.
- Verifies De Morgan’s law visually.
- Implements two 3-input functions (majority, exactly-one).
- Adds a global enable mechanism.
- Maps each result to an LED for easy verification.

This `hackathon_top.sv` serves as a clean reference implementation for Activity 4.1.
