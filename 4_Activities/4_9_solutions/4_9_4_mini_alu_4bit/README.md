# 4_9_4 – 4-bit Mini ALU

Activity based on `4_04_mini_alu_4bit`, included in the `4_9_solutions` folder.

## Objective

Implement a **4-bit mini ALU** with:

- Two operands: `A[3:0]` and `B[3:0]`
- Operation selector: `op[1:0]`
- Supported operations:
  - `op = 2'b00` → `A + B`
  - `op = 2'b01` → `A - B`
  - `op = 2'b10` → `A & B`
  - `op = 2'b11` → `A ^ B`
- Flags:
  - `carry` → carry/borrow in addition/subtraction
  - `zero`  → equals 1 when the result is zero

The ALU result and flags are displayed on the board LEDs.

---

## Signal Mapping

### Inputs

Keys `key[7:0]` are used as if they were switches:

- `sw = key`
- `A = sw[3:0]`
- `B = sw[7:4]`
- `op = key[1:0]` (operation selector)

Note: `key[1:0]` influence both `A` and `op`, but this is a simplification to use only the `key` inputs.

### Outputs (LEDs)

- `led[3:0] = result[3:0]`  
  ALU result.

- `led[4] = carry`  
  Carry from addition or simplified borrow indication from subtraction.

- `led[5] = zero`  
  Zero flag (1 when `result == 0`).

- `led[7:6] = op[1:0]`  
  Shows current ALU operation.

---

## ALU Behavior

### Arithmetic operations

To capture carry/borrow, operands are extended to 5 bits:

#### Addition (`op = 2'b00`)

sum_ext = {1’b0, A} + {1’b0, B}  
result  = sum_ext[3:0]  
carry   = sum_ext[4]  

#### Subtraction (`op = 2'b01`)

diff_ext = {1’b0, A} - {1’b0, B}  
result   = diff_ext[3:0]  
carry    = diff_ext[4] (interpreted as simple borrow indicator)

### Logical operations

AND (`op = 2'b10`):

result = A & B  
carry  = 0  

XOR (`op = 2'b11`):

result = A ^ B  
carry  = 0  

### Zero flag

zero = (result == 4’d0);

---

## Internal Structure of `always_comb`

1. Default values for all outputs.
2. `case (op)` computes the result.
3. Zero flag is computed at the end.

Example:

result = A + B;  
carry  = sum_ext[4];  
zero   = (result == 0);

---

## Suggested Tests

### Addition

A=3, B=1 → result=4, carry=0, zero=0  
A=15, B=1 → result=0, carry=1, zero=1  

### Subtraction

A=5, B=2 → result=3, carry=0  
A=2, B=5 → wrap-around result, borrow indicated in carry  

### AND

A=5, B=3 → result=1  

### XOR

A=5, B=3 → result=6  
A=7, B=7 → result=0, zero=1  

---

## Optional Extensions

- Add operations like OR, NOT, comparisons.
- Add flags such as negative or overflow.
- Display ALU result on the TM1638 (7-segment + LEDs).
- Extract ALU into a separate reusable module.

This solution provides a complete, fully commented implementation of a 4-bit combinational ALU for activity `4_04_mini_alu_4bit`.
