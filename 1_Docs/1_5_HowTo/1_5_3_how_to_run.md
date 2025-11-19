# 1.5.3 How to run – How to simulate, synthesize, and program

This document explains **how to run the examples** in the repository:

- Simulate (when a testbench is available)
- Synthesize for the Tang Nano 9K
- Program the FPGA and see the result

The idea is that for **any activity/lab/implementation**, you know:

- Which script to use  
- From which folder to run it  
- What output to expect  

---

## 0. Before starting

### Basic requirements

- Repository cloned locally  
- Tang Nano 9K connected by USB  
- **Gowin EDA** installed  
- A Unix-like terminal (Git Bash / MSYS2 / WSL) able to run:
  - bash ...
  - Gowin tools (`gw_sh.exe`, `programmer_cli.exe`) through the scripts

Note: The synthesis script (`03_synthesize_for_fpga.bash`) usually detects Gowin automatically under `C:\Gowin\...`. If installed elsewhere, adjust the script manually.

---

## 1. Correct working directory

Each activity/lab/implementation has its own folder, for example:

- `4_Activities/4_9_1_logic_gates_and_demorgan`
- `4_Activities/4_9_8_sensors_and_tm1638_integration`
- `5_Labs/5_1_counter_hello_world`

Inside you will find:

- `hackathon_top.sv` → your main module  
- `fpga_project.tcl` → Gowin project file  
- Scripts:
  - `01_simulate.bash`
  - `02_simulate_and_view.bash`
  - `03_synthesize_for_fpga.bash`
  - `04_program_fpga.bash`
  - `05_run_gui_for_fpga_synthesis`

**Rule:**  
Always run scripts **inside the folder** of that exercise.

Example:

cd /c/Users/YOUR_USER/Documents/GitHub/systemverilog-basic/4_Activities/4_9_8_sensors_and_tm1638_integration

---

## 2. Typical flow (quick)

1. Synthesize:  
bash 03_synthesize_for_fpga.bash
2. Test on the board:
   press keys, read sensors, check LEDs/displays.

---

## 3. FPGA synthesis (Gowin)

1. Open a terminal (Git Bash / MSYS2 / WSL).
2. Go to the exercise folder:

cd /c/Users/YOUR_USER/Documents/GitHub/systemverilog-basic/4_Activities/4_9_8_sensors_and_tm1638_integration

3. Run:

bash 03_synthesize_for_fpga.bash

### What to expect

Terminal output will show:

- `GowinSynthesis start`
- List of analyzed RTL files
- `Compiling module ...`
- Final message `GowinSynthesis finish`

Warnings:
- Usually safe, but recommended to review.

Errors:
- Stop the process; no bitstream generated.

Check `1_5_4_troubleshooting_and_pitfalls.md` for common synthesis problems.
