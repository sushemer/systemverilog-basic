# 3.x Priority Encoder 3→2 (priority-based encoder)

This example shows a **3→2 priority encoder** implemented in several ways in SystemVerilog
and allows you to observe how, when multiple inputs are active, only the index of the one with the **highest priority** is encoded.

In this design:

- There are **3 inputs** `in[2:0]` coming from `key[2:0]`.
- The output is **2 bits** encoding the index of the selected active input.
- The priority is defined as:

  - Bit 0 → highest priority  
  - Then bit 1  
  - Then bit 2  

If more than one input is `1` at the same time, the one with **highest priority** wins.

---

## General idea

- Inputs:
  - `in[0]` ← `key[0]`  (highest priority)
  - `in[1]` ← `key[1]`
  - `in[2]` ← `key[2]`  (lowest priority)

- Encoded outputs (2 bits):

  | Active inputs (priority) | Output (code) |
  |--------------------------|----------------|
  | `in[0] = 1`              | `00`           |
  | `in[0] = 0`, `in[1] = 1` | `01`           |
  | `in[0] = 0`, `in[1] = 0`, `in[2] = 1` | `10` |
  | No active inputs         | `00` (by convention) |

- Four internal implementations of the priority encoder are included:

  1. Chain of `if / else if`.
  2. `casez` with patterns and don’t cares.
  3. Split into:
     - Priority arbiter (generates a one-hot vector).
     - “Normal” encoder without priority over that vector.
  4. For-loop that scans the input vector.

All implementations receive the same vector `in` and produce a 2-bit code.

---

## Signals and LED mapping

In the code:

- Inputs:
  - `key[2:0]` → `in[2:0]`

- Outputs to LEDs:

  The final vector is assembled as:

  assign led = { enc0, enc1, enc2, enc3 };
