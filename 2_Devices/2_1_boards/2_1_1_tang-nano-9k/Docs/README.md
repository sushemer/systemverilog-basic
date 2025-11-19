# Specific documentation · Tang Nano 9K

The `docs` folder gathers the specific documentation for the **Tang Nano 9K** used in this repository.

Its purpose is to complement the constraints file and provide clear information about:

- Which pins are used and for what.
- What power and voltage-level considerations must be respected.
- What the basic flow is to program the board using Gowin.

---

## Contents

Main files:

- `pinout.md`  
  - Summary of the pins used in the course/workshop.  
  - Tables of the form:
    - Logical signal → physical pin → use (LED, button, GPIO, etc.).  
  - Focus on the pins used in Examples, Activities, and Labs.

- `power_notes.md`  
  - Notes on power and voltage levels:
    - User IO at 3.3 V  
    - Considerations when using 5 V modules  
    - Importance of common GND  
  - Warnings to avoid damaging the board or peripherals.

---

## How to use this folder

- Before connecting sensors or actuators to the Tang Nano 9K:
  - Review `pinout.md` to know which pins to use.
  - Review `power_notes.md` to confirm voltage compatibility.

- When creating new Examples, Activities, or Labs:
  - Verify that the chosen pins match what is documented here and in the `constr/tang-nano-9k.cst` file.
  - If a new set of pins is introduced “officially,” update `pinout.md`.

---

## Relation with other folders

- `../constr/`  
  - Depends on the `tang-nano-9k.cst` file.  
  - `pinout.md` and `power_notes.md` are based on the assignments defined there.

- `3_examples/`, `4_activities/`, `5_labs/`, `6_implementation/`  
  - Must be consistent with the pins and notes documented in this folder for coherent use of the Tang Nano 9K across the entire repository.

---

## Updating and maintenance

If at any point:

- The pin standard is changed (e.g., new GPIO for a peripheral), or  
- A new peripheral connected to the Tang Nano 9K is added,

then:

1. Update the constraints file if needed.  
2. Document the change in `pinout.md` and/or `power_notes.md`.

The idea is that any student or newcomer can understand how to use the board by reading only these files.
