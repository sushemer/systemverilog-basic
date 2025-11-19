# Buses overview

This document introduces the main **communication buses** relevant to this repository:

- Simple **parallel** buses  
- Basic **serial** buses (SPI and I²C) from the FPGA perspective  

It does not go into full protocol details but provides enough context to understand their usage.

---

## What is a bus?

A **bus** is a set of signal lines used to transmit information between:

- The FPGA and an external peripheral  
- Modules within a digital system  

It may be:

- **Parallel**: several bits transmitted at once  
- **Serial**: bits transmitted one after another

---

## Simple parallel buses

Examples:

- 7-segment displays  
  - `seg[6:0]` → segment lines  
  - `digit[7:0]` → digit enable lines  
- LEDs: `led[7:0]`

Characteristics:

- Easy to understand  
- Require many FPGA pins  
- Good when the number of signals is manageable  

The bus directly reflects the value to be shown.

---

## Serial buses: motivation

Used when:

- Peripherals increase  
- FPGA pins must be saved  
- Commercial sensors/expanders are used  

Relevant in this repo:

- **SPI**  
- **I²C**

---

## SPI

General characteristics:

- Master/slave model  
- Lines:
  - `SCK`  
  - `MOSI`  
  - `MISO`  
  - `CS`  

Basic flow:

1. FPGA lowers `CS`  
2. Toggles `SCK`  
3. Sends data on `MOSI`, receives on `MISO`  
4. Raises `CS` at end  

Used for:

- External ADCs  
- Serial peripheral modules  

---

## I²C

General characteristics:

- Only two lines:
  - `SCL`  
  - `SDA` (bidirectional)  
- Devices share the bus  
- Each device has an address  

Basic flow:

1. Master generates **start**  
2. Sends address + R/W bit  
3. Receives ACK/NACK  
4. Sends/receives multiple bytes  
5. Generates **stop**  

---

## FPGA's role

In this repo the FPGA acts as **master**:

- Generates the clock (`SCL`/`SCK`)  
- Controls when bits are sent/received  
- Implements protocol sequences in SystemVerilog  

---

## Relation to other theory files

- FSMs: protocol sequences handled with state machines  
- Timing/dividers: serial clock frequencies lower than system clock  
- Registers: shift registers used for serial data  

Related:

- `1_2_6_Timing_and_Dividers.md`  
- `1_2_7_Finite_State_Machines.md`  
- `1_2_11_ADC_Basics.md`  
- `1_2_15_Potentiometer_ADC_Basics.md`

---

## Examples and labs

Serial buses appear in:

- Potentiometer reading with external ADC  
- Activities with PCF8574 (I²C expander)  
- LCD integration via I²C  
- TM1638 (its own protocol but conceptually similar)

Concepts:

- Use few physical lines  
- Coordinate sequences via clocks, FSMs, and registers  
