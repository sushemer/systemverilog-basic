# 4_9_solutions · Module 4 Solutions

This directory contains the **reference solutions** for the activities of Module 4.

Each subfolder corresponds to an activity in `4_Activities` and usually contains:

- `hackathon_top.sv` → the **completed** version of the activity  
- `README.md` → a brief explanation of the solution, modes, and design decisions

> **Recommendation:**  
> Use these solutions only **after** attempting the activity in `4_Activities`.  
> The goal is to learn by comparing your approach with a reference, not simply copying code.

---

## Activity ↔ Solution Mapping

| Solution                                   | Based on activity                           | Quick description                                                |
|-------------------------------------------|----------------------------------------------|------------------------------------------------------------------|
| `4_9_1_logic_gates_and_demorgan/`         | `4_01_logic_gates_and_demorgan`              | Logic gates, De Morgan, 3-input functions, and EN signals        |
| `4_9_2_mux_and_decoder_composition/`      | `4_02_mux_and_decoder_composition`           | Decoder 2→4 + mux 4→1 with AND/OR + LED visualization            |
| `4_9_3_priority_encoder_and_valid_flag/`  | `4_03_priority_encoder_and_valid_flag`       | Priority encoder 3→2 with `valid` flag                           |
| `4_9_4_mini_alu_4bit/`                    | `4_04_mini_alu_4bit`                         | 4-bit Mini ALU (add, subtract, logic ops, carry, zero)           |
| `4_9_5_counters_and_shift_patterns/`      | `4_05_counters_and_shift_patterns`           | Frequency divider + LED patterns (counter/shift)                 |
| `4_9_6_seven_segment_playground/`         | `4_06_seven_segment_playground`              | Experiments with 7-segment displays and modes                    |
| `4_9_7_lcd_hello_and_basic_graphics/`     | `4_07_lcd_hello_and_basic_graphics`          | LCD frame + “HELLO” block text + bottom status bar               |
| `4_9_8_sensors_and_tm1638_integration/`   | `4_08_sensors_and_tm1638_integration`        | HC-SR04 + KY-040 + LED bar graph + TM1638 HEX display            |

---

## Naming conventions

- Solution folder:  
  `4_9_X_activity_name/`

- Main file:  
  `hackathon_top.sv` (same name as in `4_Activities`, but completed)

- Often includes:  
  `README.md` with:
  - Mode descriptions (`key`, `switches`, `gpio`)
  - Explanation of LEDs, displays, LCD usage
  - Ideas for extensions or improvements

---

## How to use these solutions

1. **First complete the activity in `4_Activities`.**  
2. Then open the corresponding solution in `4_9_solutions/`.  
3. Compare:
   - How signals (`key`, `led`, `gpio`) are mapped  
   - How `always_comb` and `always_ff` are structured  
   - How the following are implemented:
     - decoders/muxes  
     - priority logic  
     - ALU  
     - frequency dividers  
     - display drivers  
     - sensor integration  

4. If something is unclear, you can:
   - Run a diff (Git or VS Code)
   - Add your own comments to the reference code

---

## Example: solution 4_9_8 (sensors + TM1638)

- Integrates:
  - `ultrasonic_distance_sensor` (HC-SR04)
  - `sync_and_debounce` + `rotary_encoder` (KY-040)
  - `seven_segment_display` (TM1638)

- Modes (`key[1:0]`):
  - `00`: relative distance  
  - `01`: encoder value  
  - `10`: combination (distance + encoder)  
  - `11`: off/0  

- Visualization:
  - LEDs: level bar based on the upper bits of `sensor_value`  
  - 7-segment: `sensor_value` in HEX  

This pattern (sensors → value → visualization) is reusable in many projects.

---

## Final note

These solutions are meant as **learning material**, not just “answers.”  
You can:

- Use them as a base for larger projects  
- Modify constants, modes, and pin mappings  
- Add new functions (more ALU ops, more LED patterns, LCD text, etc.)  

The idea is that Module 4 becomes your initial **toolbox** for exploring SystemVerilog + FPGA.
