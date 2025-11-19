# 1.2.7 Finite state machines (FSM)

This document introduces **Finite State Machines (FSMs)**, a key tool for controlling sequences, menus, protocols, and decision logic.

---

## 1. What is an FSM?

An **FSM** is a model where:

- The system is always in **one current state** from a finite set of possible states.
- Based on:
  - The **current state**, and
  - The **inputs**,  
- The FSM determines:
  - The **next state**  
  - The **outputs** associated with it  

Typical examples:

- Traffic light (Red → Green → Yellow → Red)  
- Combination lock (correct sequence of buttons)  
- Button-based menus  
- Protocol control (I²C, SPI, UART, etc.)

---

## 2. Basic components of an FSM

A typical synchronous FSM has:

1. **State set**  
   e.g., `IDLE`, `READ`, `WAIT`, `DONE`.

2. **Current state**  
   Stored in a register (sequential logic).

3. **Next-state logic**  
   Determines which state to go to on the next clock cycle.

4. **Output logic**  
   Determines the outputs (may depend on state alone or state + inputs).

---

## 3. Representation in SystemVerilog

Recommended style:

- Define states with `typedef enum`
- Use:
  - One `always_ff` block for the **current state**
  - One `always_comb` block for **next state** and outputs

Example traffic light FSM:

(States RED → GREEN → YELLOW → RED in a loop)

In real designs, a **counter** is often added so each state lasts multiple seconds.

---

## 4. Moore vs Mealy (simple view)

- **Moore machine:**  
  Outputs depend **only on the current state**.  
  (Most simple FSMs in this repo follow this style)

- **Mealy machine:**  
  Outputs depend on **state + inputs**.  
  Useful when immediate reaction to an input is required.

---

## 5. Relationship with other design elements

FSMs frequently interact with:

- **Counters / dividers**: determine how long each state lasts  
- **Debounced buttons**: avoid multi-triggering  
- **Peripheral drivers**: many protocols are sequential (send command, wait, read, etc.)

Examples in the repo:

- Traffic light FSM  
- Sequence-lock FSM  
- Menus in TM1638 / LCD labs  
- Project implementations (digital clock, ultrasonic radar)

---

## 6. Best practices

- Give states descriptive names (`IDLE`, `WAIT`, `ERROR`, etc.)
- Use `typedef enum logic [...]` instead of numeric codes
- Separate:
  - State register (`always_ff`)
  - Next-state + output logic (`always_comb`)
- Give **default values** to outputs and next_state
- Prefer `unique case` to detect uncovered states
- Keep FSMs focused; avoid overloading them with unrelated logic

You'll see these patterns throughout activities, labs, and implementations.
