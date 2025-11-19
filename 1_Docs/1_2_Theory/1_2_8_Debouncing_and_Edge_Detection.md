# Debouncing and edge detection

This document covers two concepts used in almost all designs involving buttons or slow signals:

- **Debouncing**
- **Edge detection**

---

## Bouncing problem

When a physical button is pressed:

- The contact does not go cleanly from 0 to 1.  
- For a few milliseconds it may “bounce”:  
  0 → 1 → 0 → 1 → … until stabilizing.

If the FPGA reads these bounces:

- It may detect multiple presses instead of one  
- FSMs may advance several steps  
- Counters may increment multiple times

---

## What is debouncing?

**Debouncing** filters bouncing to produce a stable signal:

- Raw noisy button → time-based filter → clean signal  
- A real transition (0→1 or 1→0) is accepted only after the value is stable for a certain time

Typical FPGA implementations use:

- Counters for stability
- Periodic sampling

The idea:  
Compare the sampled value to the previously filtered value; accept change only after a long enough consistency.

---

## Edge detection

Once a clean signal exists (`btn_clean`), often we want **short pulses** on transitions:

- Rising edge: 0 → 1  
- Falling edge: 1 → 0  

Useful for:

- Single-step FSM control  
- Single increment on button press even if held down  
- Triggering events  

Technique:

- Store previous value  
- Compare to current value  
- Generate a one-cycle pulse when a change is detected

---

## Relation to common modules

This repository provides reusable modules that combine:

- Synchronization  
- Debouncing  
- Edge detection  

Examples:

- `sync_and_debounce` (multiple inputs)  
- `sync_and_debounce_one` (single input)  

Outputs from these modules are used to:

- Advance FSMs  
- Start/stop counters  
- Change modes  
- Trigger sensor reads  

---

## Summary

- Buttons bounce → multiple false triggers  
- Debouncing filters noise and ensures stable transitions  
- Edge detection converts transitions into one-cycle pulses  
- These patterns are encapsulated in reusable modules used across activities, labs, and implementations  
