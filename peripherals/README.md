# peripherals – Drivers and modules for external hardware

This directory contains **hardware-specific SystemVerilog modules**  
(sensors, displays, I/O boards, etc.) used in activities and labs, mainly with the  
**Tang Nano 9K** in the configuration:

    tang_nano_9k_lcd_480_272_tm1638_hackathon

Here we group **drivers for real physical devices** (peripherals) so they are not mixed
with the logic in the exercises (`hackathon_top.sv`) nor with the generic modules in  
`labs_common`.

> Origin: most of these modules are based on or derived from the  
> **“basic-graphics” FPGA project**, developed by **Mr. Panchul**.  
> In that project, these modules are used as drivers and support blocks for many
> boards (Gowin, Altera, etc.).  
> In this repository, they have been **adapted** for the Tang Nano 9K, but the
> original idea and much of the base code belongs to **Mr. Panchul** and the
> *basic-graphics* project.  
>
> This README only documents how these modules are used and integrated in the labs,
> and does not claim authorship over the files in this directory.

---

## 1. Purpose of the directory

The purpose of `peripherals` is:

- To gather **all modules that interface directly with external hardware**:  
  sensors, encoder, TM1638, LCD, etc.
- To keep each lab/activity cleaner by delegating here:
  - Device-specific timing.
  - Simple communication protocols (signals, multiplexing, scanning).
- To allow **reusing** the same drivers across activities without duplicating code.

In summary:  
While `labs_common` contains more *generic* helper blocks,  
`peripherals` contains the **drivers for real physical peripherals**.

---

## 2. Typical contents

The exact file list may vary depending on the repository version, but typically includes modules such as:

- ultrasonic_distance_sensor.sv  
  Driver for the **HC-SR04 ultrasonic sensor**:
  - Generates the `TRIG` pulse.
  - Measures the `ECHO` width using the FPGA clock.
  - Outputs a relative distance value (`relative_distance`, often 16 bits)
    which can then be mapped to LEDs, LCD, TM1638, etc.
  - Used in activities such as:
    - Ultrasonic sensor examples.
    - Sensor-integration labs (LCD, TM1638).

- rotary_encoder.sv  
  Driver for the **KY-040 rotary encoder**:
  - Receives A/B (CLK/DT) signals already synchronized and debounced.
  - Detects clockwise/counter-clockwise steps.
  - Maintains a counter (e.g., `value[15:0]`) that increments/decrements.
  - Used to adjust parameters, select modes, etc.

- sync_and_debounce.sv  
  Generic **synchronization and debounce** module (multi-bit):
  - Receives a vector of “slow” inputs (buttons, encoder lines).
  - Passes them through a flip-flop chain and filter logic.
  - Outputs a clean, clock-synchronous vector.  
  Typical use:
    - Cleaning `key`, encoder A/B lines, external switches, etc.

- sync_and_debounce_one.sv  
  **Single-bit** version of sync_and_debounce:
  - Simpler when only one signal needs cleaning.
  - Used for a single “step” or “external reset” button.

- TM1638 modules (names may vary, e.g. tm1638_board, tm1638_controller, etc.)  
  Drivers for the **TM1638 board** (8 seven-segment digits + 8 LEDs + 8 buttons):
  - Implement the TM1638 serial protocol.
  - Receive:
    - Digit data (hex nibbles)
    - LED pattern
  - Output:
    - State of TM1638 buttons  
  Used in:
    - Seven-segment counter activities
    - Sensor + LED bar-graph integration

- LCD helper modules (typical names in basic-graphics)  
  Depending on repo organization, LCD 480×272 helpers may be here or in a dedicated directory.  
  Generally:
  - Receive x/y coordinates and sync signals
  - Generate colors, backgrounds, bars, etc.
  - Used for “HELLO” and simple graphics exercises

Note: exact filenames should be checked in the repository tree, but all modules share the idea of being **drivers for real physical peripherals**, many originally from *basic-graphics* and adapted.

---

## 3. Usage from labs and activities

In the various `hackathon_top.sv` files (e.g.:

- 4_Activities/4_xx_*/hackathon_top.sv  
- 5_Labs/5_xx_*/hackathon_top.sv  

it is common to see instantiations of `peripherals` modules. For example:

1) Using `ultrasonic_distance_sensor`:

    wire [15:0] distance_rel;

    ultrasonic_distance_sensor
    #(
        .clk_frequency           ( 27 * 1000 * 1000 ),
        .relative_distance_width ( 16 )
    )
    i_ultrasonic
    (
        .clk               ( clock        ),
        .rst               ( reset        ),
        .trig              ( gpio[0]      ),
        .echo              ( gpio[1]      ),
        .relative_distance ( distance_rel )
    );

2) Using `sync_and_debounce` + `rotary_encoder`:

    wire enc_a_raw = gpio[3];
    wire enc_b_raw = gpio[2];

    wire enc_a_deb;
    wire enc_b_deb;

    sync_and_debounce #(.w(2)) i_sync_and_debounce
    (
        .clk    ( clock                   ),
        .reset  ( reset                   ),
        .sw_in  ( { enc_b_raw, enc_a_raw }),
        .sw_out ( { enc_b_deb, enc_a_deb })
    );

    logic [15:0] encoder_value;

    rotary_encoder i_rotary_encoder
    (
        .clk   ( clock         ),
        .reset ( reset         ),
        .a     ( enc_a_deb     ),
        .b     ( enc_b_deb     ),
        .value ( encoder_value )
    );

In all cases, **high-level logic** (mode selection, scaling, displaying on LEDs/LCD/TM1638) is implemented in `hackathon_top.sv`, while **low-level hardware interaction** is delegated to the modules in `peripherals`.

---

## 4. Inclusion in synthesis scripts

For Gowin (or any toolchain) to use these modules, you must:

- Explicitly include all `peripherals` files:
  - In `03_synthesize_for_fpga.bash`, or
  - In the Tcl project file (`fpga_project.tcl`), or
  - In the IDE project.

If synthesis reports:

    ERROR (EX3937): Instantiating unknown module 'ultrasonic_distance_sensor'

or similar errors for `rotary_encoder`, `sync_and_debounce`, `tm1638_*`, etc., it almost always means the corresponding `.sv` file **was not added** to the synthesis project.

General rule:

- If a `peripherals` module is instantiated in `hackathon_top.sv`,  
  its `.sv` file **must** be listed in the synthesis scripts/project.

---

## 5. Best practices

When working with this directory:

- Treat these modules as a **driver library**:
  - Do not mix lab-specific logic here.
  - Avoid hacking the code for a single exercise; if needed, create a clear variant.
- Keep comments in English (following basic-graphics style) or bilingual, without removing original credit.
- If adding support for **a new peripheral**:
  - Create a new `.sv` file in `peripherals` (e.g., `my_new_sensor.sv`).
  - Add a short description in this README.
  - Update synthesis scripts accordingly.

---

## 6. Relation to other directories

- boards/  
  FPGA board descriptions and support files (pinouts, constraints), also inspired by *basic-graphics*.

- labs_common/  
  Generic reusable modules (e.g., seven-segment driver), independent of specific hardware.

- 4_Activities/, 5_Labs/  
  Exercises and labs that **instantiate** drivers from `peripherals` and helper blocks from `labs_common`.

- scripts/  
  Automation scripts (synthesis, place&route, programming), based on the *basic-graphics* workflow and adapted to this repo.

Together, `peripherals` provides the **real hardware layer** with sensors, displays, and external modules—building on the prior work of **Mr. Panchul** and the *basic-graphics* project—and serves as the foundation for the labs and activities in this repository.
