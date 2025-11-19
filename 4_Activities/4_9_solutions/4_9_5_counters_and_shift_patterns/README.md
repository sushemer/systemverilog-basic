# 4_9_5 – Counters and LED Shift Patterns

Activity based on `4_05_counters_and_shift_patterns`, included in the `4_9_solutions` folder.

## Objective

Practice:

- Using a **frequency divider** to obtain a slow step (`step_en`) from the FPGA clock.
- Implementing **sequential LED patterns** in an 8-bit vector:
  - Binary counter (free-running counter).
  - Shift register (“running light”).
  - **Ping-pong** pattern (bit bouncing between edges).
  - A combined pattern that mixes multiple effects.
- Selecting patterns via input bits (`key`).

---

## Signal Mapping

### Inputs

- `clock`  
  Main FPGA clock (~27 MHz on the Tang Nano 9K).

- `reset`  
  Global reset to initialize counters.

- `key[1:0]`  
  Mode/pattern selection:

      mode = key[1:0]

      00 → binary counter  
      01 → circular shift  
      10 → ping-pong  
      11 → XOR mix of two patterns  

Other `key` bits may remain unused or be used for extensions such as speed control or direction inversion.

### Outputs

- `led[7:0]`  
  An 8-bit vector showing the selected LED pattern.

7-segment (`abcdefgh`, `digit`) and LCD signals are unused and remain off.

---

## Internal Structure

The solution consists of three major blocks:

1. **Frequency divider** → generates `step_en`.
2. **Pattern registers** → updated only when `step_en = 1`.
3. **Mode multiplexer** → selects which pattern is sent to `led[7:0]`.

---

## 1. Frequency Divider

A counter of configurable width:

- `W_DIV` = number of bits for slow speed.
- `div_cnt` increments every clock cycle.
- When `div_cnt == 0`, a one-cycle pulse `step_en` is generated.

Larger `W_DIV` → slower patterns.  
Smaller `W_DIV` → faster patterns.

---

## 2. LED Patterns

### 2.1 Binary Counter

- On `reset`: `counter_pattern = 0`.
- On `step_en`: increment by 1.

### 2.2 Circular Shift (Running Light)

- On `reset`: `shift_pattern = 0000_0001`.
- On `step_en`: rotate left → bit appears to “move”.

### 2.3 Ping-Pong (Bounce)

- Uses:
  - `pingpong_pattern` for the LED position.
  - `pingpong_dir` for direction.

Behavior:

- Moves left until reaching `1000_0000`.
- Then reverses direction.
- Moves right until `0000_0001`.
- Repeats.

This produces a smooth back-and-forth animation.

---

## 3. Pattern Selection (`mode`)

Based on `key[1:0]`:

- `00` → show binary counter.
- `01` → show circular shift.
- `10` → show ping-pong.
- `11` → XOR mix of counter and shift.

Each pattern is updated independently, which makes adding new patterns easy.

---

## Suggested Testing

1. **Mode 00 — Counter**  
   - Adjust divisor width for comfortable speed.  
   - Observe binary progression.

2. **Mode 01 — Circular Shift**  
   - Confirm the rotating bit behaves smoothly.

3. **Mode 10 — Ping-Pong**  
   - Verify the bounce at both edges.

4. **Mode 11 — XOR Mix**  
   - Observe richer dynamic effects combining patterns.

---

## Optional Extensions

- Use spare `key` bits for:
  - Runtime speed control.
  - Direction reversal.
  - Freeze/unfreeze animation.

- Add more patterns:
  - “Rain” effect.
  - Multiple bits lit at once.
  - OR/AND/XOR combinations.

- Integrate TM1638 or LCD:
  - Show counter on 7-segment display.
  - Animate bars on LCD.

This solution reinforces key digital design concepts: **counters**, **frequency division**, and **shift registers**, fundamental for FPGA development.
