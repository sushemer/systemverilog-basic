# 4.4 – 4-bit Mini ALU (Addition, Subtraction and Logic)

In this activity, you will design a **small 4-bit ALU** that performs both arithmetic and logical operations.

It will operate on:

- 4-bit operand `A`
- 4-bit operand `B`
- 2-bit selector `op`

And produce:

- 4-bit result
- carry/borrow flag
- zero flag

---

## Suggested Mapping

Operands:

- `A = sw[3:0]`
- `B = sw[7:4]`

If your board wrapper has no switches, map A and B to keys instead.

Operation selector:

| op   | Meaning     |
|------|-------------|
| 00   | A + B       |
| 01   | A - B       |
| 10   | A & B       |
| 11   | A ^ B / OR  |

LED output:

- `led[3:0] = result`
- `led[4]   = carry`
- `led[5]   = zero`
- `led[7:6] = op`

---

## Objectives

1. Implement a **combinational 4-bit ALU** using `case (op)`.
2. Handle:
   - addition and subtraction using **5-bit extended arithmetic**,
   - bitwise logic (AND, XOR).
3. Produce status flags:
   - `carry`
   - `zero = (result == 0)`
4. Display results on LEDs.

---

## Implementation Strategy

Inside `always_comb`:

- Initialize result, carry and zero.
- Use an extended 5-bit value (`{1'b0, A} ± {1'b0, B}`) for sum/sub.
- For logical operations, set carry = 0.
- Compute zero after selecting the result.

---

## Testing

Try different inputs for A, B and op, for example:

- `A = 3`, `B = 2`, `op = 00` → result = 5
- `A = 15`, `B = 1`, `op = 00` → result = 0, carry = 1
- `A = 4`, `B = 7`, `op = 01` → subtraction
- `A = 12`, `B = 10`, `op = 10` → AND
- `A = 10`, `B = 10`, `op = 11` → XOR = 0 → zero = 1

---

## Optional Extensions

- Add more operations (NOT, shifts, OR, comparisons).
- Add a negative flag (interpreting as signed values).
- Display the result on the TM1638 using `seven_segment_display`.
- Document a truth table with test values.
