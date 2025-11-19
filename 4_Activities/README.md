# Module 4 · Activities  
**Board:** `tang_nano_9k_lcd_480_272_tm1638_hackathon`

This directory contains the **activity templates** for Module 4.  
Each subfolder includes a `hackathon_top.sv` with comments and `TODOs` for the student to complete.

The idea is to **first solve the activities here** and only afterward review the solutions in `4_9_solutions`.

---

## List of activities

| Folder                                   | Main topic                                                        |
|------------------------------------------|-------------------------------------------------------------------|
| `4_01_logic_gates_and_demorgan`          | Logic gates, De Morgan’s law, combinational functions             |
| `4_02_mux_and_decoder_composition`       | Decoder 2→4 + composition with mux 4→1                            |
| `4_03_priority_encoder_and_valid_flag`   | 3→2 priority encoder + `valid` flag                               |
| `4_04_mini_alu_4bit`                     | 4-bit Mini ALU (add, subtract, AND, XOR/OR, flags)                |
| `4_05_counters_and_shift_patterns`       | Counters, frequency dividers, LED shift patterns                  |
| `4_06_seven_segment_playground`          | 7-segment display playground and animations                       |
| `4_07_lcd_hello_and_basic_graphics`      | Basic LCD graphics + “HELLO” block text                           |
| `4_08_sensors_and_tm1638_integration`    | Sensor integration (HC-SR04, encoder) + TM1638                    |

> Folder names may vary slightly depending on the original repo, but the structure and purpose remain the same.

---

## Typical structure of each activity

Inside each folder you will find:

- `hackathon_top.sv`  
  Main activity template, including:
  - Comments describing the **objective**
  - Signal mapping to `key`, `led`, `gpio`, etc.
  - Sections marked with `// TODO:` for you to complete

- (Optional) Additional support modules  
  Most activities reuse shared modules from:
  - `labs/common/`
  - `peripherals/`
  - `boards/`

---

## How to work through these activities

1. **Read the header of `hackathon_top.sv`**  
   It explains the purpose of the activity and the pin mapping.

2. **Complete the `// TODO:` sections**  
   - Start with the simple parts (gates, assignments)
   - Then move on to composition (mux/decoder), ALU, etc.

3. **Simulate (if applicable)**  
   - Use the testbench if one is provided  
   - Verify behavior before synthesizing

4. **Synthesize and test on the FPGA**  
   Usually with repo scripts:
   - `01_simulate_*.bash` (if available)  
   - `03_synthesize_for_fpga.bash`

5. **Only afterwards**, compare with the solutions  
   Look at `4_9_solutions` once your own version is complete.

---

## Suggested pedagogical order

1. `4_01_logic_gates_and_demorgan`  
2. `4_02_mux_and_decoder_composition`  
3. `4_03_priority_encoder_and_valid_flag`  
4. `4_04_mini_alu_4bit`  
5. `4_05_counters_and_shift_patterns`  
6. `4_06_seven_segment_playground`  
7. `4_07_lcd_hello_and_basic_graphics`  
8. `4_08_sensors_and_tm1638_integration`

The last activities (LCD and sensors) combine many ideas from earlier ones, so the recommended flow is sequential.

