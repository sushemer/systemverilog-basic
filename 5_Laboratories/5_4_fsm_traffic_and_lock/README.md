# Lab 5.4 – FSM: traffic light + sequence lock

## Objective

Implement two **independent finite state machines (FSMs)** inside the same design:

1. A **traffic light FSM** cycling through  
   **RED → GREEN → YELLOW → RED**,  
   using configurable durations and driven by `slow_clock` (~1 Hz).

2. A **sequence-based lock FSM**, which unlocks only when the button sequence:  
   **A → B → A → B** is entered.  
   - Button **A**: `key[4]`  
   - Button **B**: `key[5]`  
   - Unlock indicator: `led[7] = 1`

LED mapping:

- `led[2]` = red  
- `led[1]` = yellow  
- `led[0]` = green  
- `led[7]` = lock (sequence correct)

At the end of this lab, you should understand:
- How to design and run **multiple FSMs** in parallel.
- How to use **slow clocks** for timed transitions.
- How to detect **button edges** inside an FSM.
- How to map FSM outputs to LEDs.

---

## 1. Traffic Light FSM

### States

The code defines the following enumerated states:

- `TRAFFIC_RED`
- `TRAFFIC_GREEN`
- `TRAFFIC_YELLOW`

These states advance according to a timer driven by `slow_clock`.

### Timing configuration (in slow_clock ticks)

- `T_RED    = 3`  
- `T_GREEN  = 3`  
- `T_YELLOW = 1`

If `slow_clock ~ 1 Hz`, these correspond to ~3 s, ~3 s, and ~1 s.

### How it works

- On reset:  
  `traffic_state = TRAFFIC_RED`, timer = 0.
- Each tick of `slow_clock` increments the timer.
- When the timer reaches the configured duration (`T_xxx - 1`), the FSM changes to the next state and resets the timer.

### LED outputs

- `led[2]` (red) turns ON during `TRAFFIC_RED`
- `led[1]` (yellow) turns ON during `TRAFFIC_YELLOW`
- `led[0]` (green) turns ON during `TRAFFIC_GREEN`

Only one of these LEDs should be ON at a time.

---

## 2. Sequence Lock FSM (A-B-A-B)

### Button mapping

- `btnA = key[4]`  
- `btnB = key[5]`

Button transitions are detected using **edge detection** (rising edge):

pulseA = btnA & ~btnA_q

pulseB = btnB & ~btnB_q


These pulses are updated at each `slow_clock` tick.

### Sequence to unlock

Required sequence:

1. Press **A**
2. Press **B**
3. Press **A**
4. Press **B**

Once completed, the FSM enters `LOCK_OPEN` and the lock LED stays ON until reset.

### FSM states

- `LOCK_IDLE`      – waiting for A  
- `LOCK_A1`        – saw A, waiting for B  
- `LOCK_A1B2`      – saw A,B, waiting for A  
- `LOCK_A1B2A3`    – saw A,B,A, waiting for final B  
- `LOCK_OPEN`      – success

If a wrong button is pressed at any point, the FSM returns to `LOCK_IDLE`.

### LED output

- `led[7] = 1` only in state `LOCK_OPEN`.

---

## 3. Final LED mapping

led[0] = green_on

led[1] = yellow_on

led[2] = red_on

led[7] = lock_led


All other LEDs remain OFF.

---

## Testing Checklist

### Traffic Light FSM
- [ ] On reset, only the **red LED** is ON (`led[2] = 1`)
- [ ] After ~3 seconds, **green** LED turns ON
- [ ] After ~3 seconds, **yellow** LED turns ON
- [ ] After ~1 second, returns to **red**
- [ ] The cycle repeats indefinitely

### Sequence Lock FSM
- [ ] Pressing A → moves from `LOCK_IDLE` to `LOCK_A1`
- [ ] Pressing B → moves to `LOCK_A1B2`
- [ ] Pressing A → moves to `LOCK_A1B2A3`
- [ ] Pressing B → moves to `LOCK_OPEN`
- [ ] `led[7]` turns ON only in `LOCK_OPEN`
- [ ] Any incorrect button press resets the sequence

---

## Optional Extensions

- Add a **timeout** in the lock FSM (reset back to IDLE after a few seconds).
- Display the current state on the **TM1638** or **LCD** for debugging.
- Add a configuration mode using `key[2]` or `key[3]` to change traffic light durations.
- Combine both FSM outputs with sound or PWM brightness effects.

---

## Summary

This lab demonstrates how to:

- Build two **independent** state machines inside a single design.
- Use **slow_clock** for human-perceivable timing.
- Implement **edge detection** for button-driven FSMs.
- Drive LEDs from FSM states.

This pattern is essential for more advanced FPGA projects such as control systems, digital locks, UI navigation, and robotics.

