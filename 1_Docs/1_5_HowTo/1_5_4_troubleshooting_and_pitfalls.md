# 1.5.4 Troubleshooting and Pitfalls – Common errors and how to avoid them

This document summarizes the **most frequent problems** when working with this repository and the Tang Nano 9K, and the **precautions** to avoid them.

---

## 0. Quick map

- 1. Typical synthesis errors  
- 2. Hardware / connection problems  
- 3. Problems running `.bash` scripts  
- 4. Common SystemVerilog mistakes  
- 5. Real errors that have already happened  
- 6. Checklist before asking for help  

---

## 1. Synthesis errors

### 1.1 `Instantiating unknown module '...'`

It means the tool **cannot find the module**.

Causes:

- Missing `.sv` file in:
  - `fpga_project.tcl`
  - or `03_synthesize_for_fpga.bash`
- You copied a `hackathon_top` without copying its dependent modules.

Fix:

- Look for the module in `peripherals/` or `labs/common/`.
- Add it to the project file list.

---

### 1.2 `Module 'hackathon_top' remains a black box`

Causes:

- Internal module errors  
- Unknown modules  
- Incorrect signal declarations  

Fix:

- Look for the **first real error** in the log.

---

### 1.3 Truncation warnings

Example: assigning a larger-bit value to a smaller vector.

Fix: slice bits or fix widths.

---

## 2. Hardware problems

- Missing **common ground**  
- Sending **5 V directly** into the FPGA  
- TRIG/ECHO swapped  
- Loose jumpers  
- Incorrect `.cst` mapping  

---

## 3. Problems running scripts

### 3.1 `00_run_all.bash` fails

Fix:

1. Look for the first ERROR  
2. Run the failing stage manually  
3. Compare with this section  

### 3.2 Nothing executes

Check:

- Permissions  
- Correct folder  
- Git Bash/WSL instead of PowerShell  
- LF line endings  

---

## 4. Common SystemVerilog errors

### 4.1 `<=` vs `=`

- `always_ff` → use `<=`  
- `always_comb` → use `=`  

### 4.2 Latches due to incomplete logic

Always give default values.

### 4.3 Off-by-one errors

Be careful with `<` vs `<=`.

### 4.4 Incorrect clock/reset handling

Prefer a single main clock, use enables, synchronize external inputs.

---

## 5. Real errors that already occurred

- No common ground  
- 5 V into 3.3 V pins  
- Wrong `.cst`  
- Running scripts from the wrong folder  
- Missing dependent modules  
- Loose cables in sensors  

---

## 6. Checklist before asking for help

1. Check the first log error  
2. Confirm included modules  
3. Check wiring  
4. Try a known working example  
5. Review logic (`always_ff`, `always_comb`, sizes)  
6. Check environment (Git Bash, permissions)

If the issue persists, share:

- Exact error  
- Expected behavior  
- Activity/lab used  


Email: diego.peralta52@uabc.edu.mx