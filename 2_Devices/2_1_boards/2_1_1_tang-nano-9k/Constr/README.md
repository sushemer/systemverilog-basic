# Constraints · Tang Nano 9K

The `constr` folder contains the **constraints** file used for the Tang Nano 9K in this repository.

Its purpose is to provide a **stable and shared** pin configuration for all Examples, Activities, Labs, and Implementations that use this board.

---

## Contents

- `tang-nano-9k.cst`  
  Standard constraints file for the Tang Nano 9K.

It includes pin assignments for signals such as:

- `CLK`
- `KEY[0]`, `KEY[1]`
- `LED[0]` … `LED[5]`
- `GPIO[0]` … `GPIO[5]`
- And signals associated with more advanced modules (LCD, audio, etc.), even if they are not used in early exercises.

---

## Relation with other files

- `docs/pinout.md`  
  Explains, in table form, how the logical signals in the `.cst` map to physical FPGA pins.

- `docs/power_notes.md`  
  Includes voltage and level warnings that complement the `.cst` file.

If the `.cst` file is modified, it is important to check whether these documents should also be updated.
