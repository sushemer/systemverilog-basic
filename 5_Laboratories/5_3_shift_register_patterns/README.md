# Lab 5.3 – Shift register patterns (running lights / KITT)

## Objective

Design and test moving light patterns using an **8-bit shift register** connected to the Tang Nano 9K LEDs.

By the end of this lab, you should be able to:

- Generate a **slow tick** from the FPGA clock.
- Use a **shift register** to create animations on `led[7:0]`.
- Switch between several patterns using `key[1:0]`.

---

## Prerequisites

- You should have completed:
  - **5.1 blink_hello_world** (frequency divider)
  - **5.2 buttons_and_debounce** (basic input usage)

- You should understand:
  - `always_ff @(posedge clk ...)`
  - Registers such as `logic [7:0]`
  - Shift operators `<<` and `>>`

---

## Basic mapping

- **Inputs**
  - `clock`: main clock (~27 MHz)
  - `reset`: global reset
  - `key[1:0]`: selects the pattern mode

- **Outputs**
  - `led[7:0]`: display the pattern (shift register)

---

## Operation modes

- `mode = key[1:0]`

| Mode | key[1:0] | Behavior                                |
|------|----------|-------------------------------------------|
| 0    | `00`     | Circular left rotation                    |
| 1    | `01`     | Circular right rotation                   |
| 2    | `10`     | **KITT / ping-pong** pattern              |
| 3    | `11`     | LEDs off (reserved for experiments)       |

---

## Suggested procedure

1. **Review the frequency divider**
   - Locate the block with `W_DIV`, `div_cnt` and `step_en`
   - Change `W_DIV` if you want a faster or slower animation
   - Optionally simulate to check that `step_en` pulses periodically

2. **Understand the shift register**
   - Observe how `pattern_reg` updates only when `step_en = 1`
   - First try implementing only one mode (e.g., left rotation)

3. **Test on hardware**
   - Program the FPGA
   - Change `key[1:0]` and observe:
     - Mode `00`: LEDs rotate left
     - Mode `01`: LEDs rotate right
     - Mode `10`: the light bounces from one end to the other (KITT)
     - Mode `11`: all LEDs off

4. **Adjust speed**
   - Modify `W_DIV` (e.g., 20, 22, 24) and observe the effect
   - Choose a visually comfortable speed (not too fast or too slow)

---

## Test checklist

- [ ] After `reset`, only `led[0]` is ON
- [ ] In mode `00`, the light moves across all LEDs in a loop
- [ ] In mode `01`, it moves in the opposite direction
- [ ] In mode `10`, the light goes from `led[0]` to `led[7]` and back without skipping
- [ ] In mode `11`, all LEDs remain OFF
- [ ] Switching modes does not freeze or corrupt the pattern

---

## Optional extensions

Some ideas to experiment further:

- Use `key[2]` as a **pause** control:
  - If `key[2] = 0`, the pattern stops
  - If `key[2] = 1`, the pattern runs

- Create an additional mode where:
  - You combine a binary counter with the shift register:  
    `led = pattern_reg ^ counter`

- Sync the KITT direction with another key:
  - For example, invert the direction when `key[3] = 1`

This lab is a great base for more advanced LED animations (bar graphs, small games, etc.).
