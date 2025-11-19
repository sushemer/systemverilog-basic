# 1.5.2 Codeflow – How code flows in this repository

This document explains **how modules connect** in the project, from the physical top on the Tang Nano 9K down to your `hackathon_top.sv`, including peripherals such as TM1638, LCD, sensors, and more.

The intention is that, when you open any activity, lab, or implementation, you can answer:

- Who is the **real top** seen by the FPGA?
- Where should I write my logic?
- Where do signals such as `clock`, `x`, `y`, `abcdefgh`, `digit`, `gpio` come from?
- How do I follow the “path” from a button or sensor to a LED or display?

---

## 1. General module map

In most exercises, the module flow looks like this:

### 1) Physical top of the board

Typical file:  
`boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific_top.sv`

- It is the **real top** used by the synthesis tool (Gowin).
- It connects the physical pins:
  - FPGA clock  
  - LCD  
  - TM1638  
  - `gpio[3:0]` (sensors, encoder, etc.)
- This module **instantiates your `hackathon_top`**.

### 2) Logical top of the activity or lab

Typical files (inside `4_Activities` or `5_Labs`):

- `4_Activities/4_01_logic_gates_and_demorgan/hackathon_top.sv`
- `5_Labs/5_1_counter_hello_world/hackathon_top.sv`

Characteristics:

- This is where **you write your logic**.
- It receives signals already prepared by `board_specific_top`:
  - `clock`, `slow_clock`, `reset`
  - `key[7:0]`, `led[7:0]`
  - `abcdefgh`, `digit`
  - `x`, `y`, `red`, `green`, `blue`
  - `gpio[3:0]`
- It instantiates modules from `peripherals/` and `labs/common/` when required.

### 3) Peripherals and reusable modules

Examples:

- `peripherals/tm1638_board.sv`
- `peripherals/ultrasonic_distance_sensor.sv`
- `labs/common/seven_segment_display.sv`
- `labs/common/counter_with_enable.sv`

These modules implement more complex logic:

- TM1638, LCD, drivers  
- Counters  
- Debounce  
- Encoders and sensors  

You typically **just instantiate them** and connect their ports.

---

## 2. Typical structure of `hackathon_top.sv`

Common example:

module hackathon_top (  
    input  logic       clock,  
    input  logic       slow_clock,  
    input  logic       reset,  
    input  logic [7:0] key,  
    output logic [7:0] led,  
    output logic [7:0] abcdefgh,  
    output logic [7:0] digit,  
    input  logic [8:0] x,  
    input  logic [8:0] y,  
    output logic [4:0] red,  
    output logic [5:0] green,  
    output logic [4:0] blue,  
    inout  logic [3:0] gpio  
);  
    assign abcdefgh = '0;  
    assign digit    = '0;  
    assign red      = '0;  
    assign green    = '0;  
    assign blue     = '0;  

    logic [7:0] something;  
    logic       flag;  

    always_comb begin  
        led = something;  
    end  
endmodule

Mental pattern:

- **Ports** → inputs and outputs  
- **Quick assignments** → turn off unused signals  
- **Internal signals** → your workspace  
- **Submodules** → reusable logic  
- **Main logic** → `always_comb` and `always_ff`

---

## 3. Where do `clock`, `slow_clock`, `x`, `y` come from?

They do not originate inside the activity.  
They come from `board_specific_top.sv`.

Examples:

- `clock` → internal oscillator  
- `slow_clock` → internal divider  
- `x`, `y` → LCD controller  
- `abcdefgh`, `digit` → 7-segment driver  

`board_specific_top` instantiates your module like this:

hackathon_top i_hackathon_top (  
    .clock      ( clock_27mhz ),  
    .slow_clock ( slow_1hz ),  
    .reset      ( reset_sync ),  
    .key        ( key ),  
    .led        ( led ),  
    .abcdefgh   ( abcdefgh ),  
    .digit      ( digit ),  
    .x          ( x ),  
    .y          ( y ),  
    .red        ( red ),  
    .green      ( green ),  
    .blue       ( blue ),  
    .gpio       ( gpio )  
);

---

## 4. Flow by folders

### 4.1 `4_Activities`

- Focuses on single concepts: gates, mux, mini-ALU, counters…
- `hackathon_top` is small.

Flow:

board top → hackathon_top → simple logic → peripherals

### 4.2 `5_Labs`

- More integration: debounce, FSM, displays, sensors.
- Uses modules inside `labs/common` and `peripherals`.

Flow:

board top → hackathon_top → common modules → peripherals

### 4.3 `6_Implementation`

- Larger projects: digital clock, ultrasonic radar.

---

## 5. How to follow the flow

1. Look at the board top  
2. Open the exercise's `hackathon_top`  
3. Check submodules  
4. Follow the route: physical pin → top → hackathon_top → modules → output  
5. Check related howtos  

---

## 6. Summary

- Real top → `board_specific_top`  
- Your logic → `hackathon_top`  
- Reusable logic → `peripherals` and `labs/common`  
- Final flow:

board top → hackathon_top → modules → peripherals → LEDs / LCD / sensors
