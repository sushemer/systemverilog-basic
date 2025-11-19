# 4.5 – LED Counters and Shift Patterns

This activity introduces two classic digital logic patterns:

- A **free-running binary counter** (8 bits).
- A **shift register light** (also called “running light” or “KITT pattern”).

A frequency divider creates a slower pulse (`step_en`) so the LED animation is visible.

## Objectives
1. Use a frequency divider to generate a slow update tick.
2. Implement an 8-bit binary counter.
3. Implement a circular shift pattern.
4. Select a pattern using `key[1:0]`.
5. Optionally create additional patterns.

## Key Signals
- `step_en`: slow clock pulse derived from the main FPGA clock.
- `counter_pattern`: increments every step_en.
- `shift_pattern`: rotates one bit across 8 LEDs.
- `mode = key[1:0]`: selects which pattern is displayed.

## Modes
| mode | LED pattern |
|------|-------------|
| 00   | Binary counter |
| 01   | Shifted single bit |
| 10   | XOR mix of both patterns |
| 11   | Inverted counter |

## Suggested Extensions
- Create a ping-pong (bouncing) pattern.
- Add adjustable speed using more keys.
- Mix patterns with OR, AND, or XOR.
- Drive the patterns to the TM1638 or LCD.
