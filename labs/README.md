# labs_common – Shared modules for the labs

This directory contains **SystemVerilog modules used across multiple labs** in the project, especially for the **Tang Nano 9K** using the configuration  
`tang_nano_9k_lcd_480_272_tm1638_hackathon`.

Instead of duplicating the same code in every lab, this directory gathers reusable
blocks (drivers, helpers, utilities) that are instantiated from each `hackathon_top.sv`.

> **Origin:** these modules are based on the original  
> **“basic-graphics” FPGA project** developed by **Mr. Panchul**.  
> In that project, these blocks act as “building pieces” for many examples across
> different boards.  
> In this repository, they have been **adapted** to work primarily with the Tang Nano 9K,  
> but the original authorship of the idea and the base source code belongs to  
> **Mr. Panchul** and the *basic-graphics* project.

---

## 1. Purpose of the directory

The goal of `labs_common` is to:

- Provide **reusable blocks** shared across labs  
  (e.g., the seven-segment display driver).
- Centralize “generic logic” so that:
  - It is maintained in **one place**.
  - Fixes and improvements do not require editing every lab.
- Keep each lab’s `hackathon_top.sv` clean and focused on the main concept.

---

## 2. Typical contents

The exact list changes with repo versions, but typically includes:

- `seven_segment_display.sv`  
  Multiplexed **seven-segment display driver** (8 digits), adapted from the  
  *basic-graphics* project:
  - Takes a packed `number` bus (nibbles = 4 bits per digit).
  - Takes `dots` to control decimal points.
  - Generates `abcdefgh` and `digit` signals for the hardware.
  - Used in several activities and labs (hex counters, playgrounds, etc.).

- Other reusable helper modules  
  (clock dividers, digit packing helpers, etc.).
  All follow the philosophy of:
  - Clean and documented interfaces.
  - Easy instantiation from any `hackathon_top.sv`.
  - Reusability across labs.

Place any new generic module here if used in more than one lab.

---

## 3. Use from the labs

Typical usage in labs (`5_Labs/5_xx_*/hackathon_top.sv`):

```sv
seven_segment_display #(.w_digit(8)) i_7segment (
    .clk      ( clock      ),
    .rst      ( reset      ),
    .number   ( number_reg ),
    .dots     ( dots_reg   ),
    .abcdefgh ( abcdefgh   ),
    .digit    ( digit      )
);
```
number_reg and dots_reg are prepared in each lab according to the exercise.

The synthesis scripts must include labs_common files for the toolchain to find the modules.

## 4. Best practices

- Keep modules as generic as possible, with minimal dependencies.

- Document:

  - Purpose

  - Input/output ports

  - Parameters (parameter, localparam)

- Do not include lab-specific logic inside labs_common.
If it belongs only to one lab, leave it in its corresponding directory.

## 5. Relation to other directories 
- 5_Labs/ - Each lab instantiates modules from labs_common.

- peripherals/ – Contains hardware-specific drivers (sensors, TM1638, LCD).

- scripts/ – Contains synthesis/programming scripts.

labs_common functions as a reusable library that keeps all labs cleaner and easier to maintain.

---

