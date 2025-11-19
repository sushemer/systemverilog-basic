# 1.4.1 Core digital logic terms

Basic digital logic and HDL terms that appear frequently in theory, examples, and labs.

---

### HDL (Hardware Description Language)

Language to describe digital hardware (modules, registers, FSM, etc.) instead of writing sequential instructions like in software.  
This repository mainly uses Verilog/SystemVerilog.

---

### RTL (Register Transfer Level)

Description level where the design is expressed in terms of registers, data operations, and clock-controlled transfers.  
Most examples and labs in this repository follow RTL style.

---

### Module

Basic unit of design in Verilog/SystemVerilog.  
Defines inputs, outputs, and internal logic connecting signals and submodules.  
In this repository, each example or block is usually encapsulated in one or more `module`.

---

### Port

External connection of a module: `input`, `output`, or `inout`.  
Allows a module to receive signals from other modules or from physical elements (buttons, LEDs, etc.).  
Clear port organization improves reuse and integration.

---

### Signal / net

Generic name for an internal or external connection in the design (typically declared as `logic`).  
Can represent a single bit or a vector of multiple bits (e.g., `led[7:0]`).

---

### Combinational logic

Logic where outputs depend only on **current inputs**, with no explicit internal memory.  
Described using `assign` or `always_comb`.  
Examples: gates, comparators, decoders, multiplexers.

---

### Sequential logic

Logic where outputs depend on current inputs **and previous state**, stored in registers.  
Described with `always_ff @(posedge clk ...)`.  
Examples: counters, shift registers, FSMs.

---

### Register

Memory element that stores a digital value between clock edges.  
Modeled with signals updated in `always_ff` blocks.  
Used to store states, counters, or intermediate data.

---

### Flip-flop (FF)

Basic sequential memory block storing one bit, typically updated on a clock edge.  
A register of N bits may be viewed as N flip-flops.

---

### Clock (clk)

Periodic signal that sets the timing of the digital system.  
Registers, counters, and FSMs update on the active clock edge.  
On the Tang Nano 9K, it is connected to a dedicated pin and distributed internally.

---

### Reset (rst / rst_n)

Signal used to bring the design to a known initial state.  
It may be:
- Active high (`rst = 1`)  
- Active low (`rst_n = 0`, common in this repo)

Handled inside sequential blocks (`always_ff`) to initialize registers and FSMs.

---

### Edge (rising / falling)

Transition in a signal:

- **Rising edge**: 0 → 1  
- **Falling edge**: 1 → 0  

Sequential logic typically triggers on rising clock edges (`posedge clk`).  
Used also to detect button presses or sensor events (ECHO from HC-SR04).

---

### Counter

Sequential circuit that increments or decrements its value on each clock edge.  
Used for frequency division, timing, state progression, etc.  
Appears in examples like `binary_counter` and LED blink/timing labs.

---

### Divider (clock divider)

Use of a counter to derive a slower signal from a fast clock.  
Example: from 27 MHz generate a few Hz to blink LEDs or multiplex displays.  
Detailed in `1_2_6_Timing_and_Dividers.md`.

---

### Duty cycle

Percentage of time a PWM signal remains high during a period.  
Used for LED brightness and servo positioning.

---

### FSM (Finite State Machine)

Machine consisting of states and transitions defined by inputs and logic.  
Used for sequences (traffic lights, menus, basic protocols, etc.).  
Described using `typedef enum` + `always_ff` + `always_comb`.

---

### State

One of the possible “modes” or “situations” an FSM can be in (e.g., `IDLE`, `MEASURE`, `DISPLAY`).  
Represented with enumerated types (`enum`) and stored in a register.

---

### Debounce (debouncing)

Technique to filter electrical bounce from buttons or switches, preventing false multiple pulses.  
Implemented with counters and comparisons ensuring stability.

---

### Edge detection

Logic converting a transition (e.g., 0→1) into a one-clock-cycle pulse.  
Used to detect button presses or single events.

---

### Sample / sampling

Reading the value of a signal at a specific moment (e.g., each clock edge).  
Applied when reading buttons, sensor ECHO, or serial data.

---

### Latency

Time between an input and the observable output response, measured in clock cycles or time units.  
Some operations require multiple cycles (e.g., multi-state FSMs).
