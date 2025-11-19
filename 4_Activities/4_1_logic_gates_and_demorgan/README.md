# 4.1 – Logic Gates, De Morgan’s Law and Combinational Functions

In this activity, you will work with basic logic gates, verify one of De Morgan’s laws, and design simple combinational functions.

The board used is the **Tang Nano 9K** with the wrapper `hackathon_top` for the configuration:

`tang_nano_9k_lcd_480_272_tm1638_hackathon`

---

## Objectives

1. Implement `AND`, `OR`, `XOR` and one De Morgan expression using 2 inputs.
2. Extend the idea to 3 inputs (`A`, `B`, `C`) and design:
   - a “majority” function,
   - a “exactly one high” function.
3. Add an enable input (`EN`) that turns the entire block on/off.

---

## Signals

Inputs:

- `A = key[1]`
- `B = key[0]`
- `C = key[2]` (Task 2)
- `EN = key[3]` (Task 3)

Suggested LED mapping:

- `led[0]` → `A AND B`
- `led[1]` → `A OR B`
- `led[2]` → `A XOR B`
- `led[3]` → `~(A & B)`
- `led[4]` → `(~A) | (~B)`
- `led[5]` → majority of A,B,C
- `led[6]` → exactly one input high
- `led[7]` → indicator for EN

The LCD and 7-segment display are not used.

---

## Tasks

### **Task 1 – Logic gates + De Morgan (2 inputs)**

Implement:

- `A & B`  
- `A | B`  
- `A ^ B`  
- `~(A & B)`  
- `(~A) | (~B)`

Verify that LEDs `3` and `4` always match for every combination of A and B.

---

### **Task 2 – Functions with 3 inputs**

Implement:

- Majority → at least two of A,B,C are `1`.
- Exactly one high → only one among A,B,C is `1`.

---

### **Task 3 – Enable input**

When `EN = 0`:

- all LEDs `[6:0]` must be *off*.

When `EN = 1`:

- show the results of Tasks 1 and 2 normally.

Use `led[7]` to show EN state.

---
