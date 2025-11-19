# 1.4.2 FPGA and tools terms

Terms related to FPGAs, internal resources, and the toolchain.

---

### FPGA (Field Programmable Gate Array)

Configurable integrated circuit containing logic blocks, registers, memory, and interconnection resources.  
It allows implementing custom digital hardware after the chip is manufactured.  
The main board in this repository, the Tang Nano 9K, includes a Gowin FPGA.

---

### Fabric / logic fabric

Set of programmable FPGA resources (LUTs, flip-flops, routing) where RTL modules are mapped.  
It is the internal “fabric” configured through the bitstream.

---

### LUT (Look-Up Table)

Programmable logic block that implements combinational functions.  
It receives several inputs and produces an output based on an internally stored truth table.  
Synthesis tools translate logical expressions into LUT networks.

---

### IO / IO pin / IO bank

- **IO pin**: physical input/output pin of the FPGA, used to connect to external peripherals.  
- **IO bank**: group of pins that share electrical characteristics (voltage, standards).

In this repository, Tang Nano 9K pinouts are documented in `2_devices/tang-nano-9k/`.

---

### Constraints / constraints file

Restrictions that instruct the tools how to map logical signals to physical pins and specify clock/timing requirements.  
This repository uses constraints files (e.g., `.cst`) as the single source of truth for pin assignment and basic configurations.

---

### Toolchain

Set of tools used in sequence:

1. Code editor / development environment  
2. RTL synthesis  
3. Place & Route  
4. Bitstream generation  
5. FPGA programmer

In this project, we use the toolchain associated with the Tang Nano 9K FPGA (Gowin EDA and its programmer).

---

### Synthesis

Process where RTL (SystemVerilog) code is translated into a network of logic components (LUTs, flip-flops, etc.).  
The synthesis tool checks the design and produces an intermediate representation for Place & Route.

---

### Place & Route (P&R)

Stage where:

- The **placement** of each logic resource is decided.  
- The **routing** (physical interconnection paths) is determined.

The result must meet timing constraints (clock frequency) and resource usage requirements.

---

### Bitstream

Configuration file uploaded to the FPGA to program it with the defined design.  
It is the final result of synthesis + Place & Route.  
When programming the Tang Nano 9K, this bitstream is sent to the FPGA.

---

### Programmer / programming cable

Tool or module (sometimes integrated) used to transfer the bitstream from the PC to the FPGA via USB or another interface.  
The Tang Nano 9K usually includes an onboard programming interface.

---

### Timing analysis

Analysis that verifies whether signal paths in the design meet the timing requirements for the specified clock frequency.  
It checks for setup/hold violations and other timing issues.

---

### Clock domain

Group of logic (registers, FFs, etc.) that shares the same clock.  
Multiple clock domains may require special synchronization techniques.  
This repository recommends starting with simple designs using a single clock domain.

---

### Simulation

Running the design in a simulated environment (without hardware) to observe its behavior.  
It allows verifying logic and FSMs before synthesizing and programming the FPGA.  
Although this repository focuses on on-board testing, simulation is a useful complementary tool.

---

### Testbench

Verification module used in simulation that:

- Generates stimuli (inputs) for the design under test  
- Observes and checks outputs  

It is not synthesized into hardware; it only serves to test the design in simulation.

---

### IP core / IP block

Reusable hardware block implementing a specific function:  
e.g., memory controller, communication module, or configurable PWM.  
In this repository, simple reusable blocks can be considered internal IPs inside `ip_blocks/`.

---

### Resource utilization

Measure of how many FPGA resources (LUTs, flip-flops, memory, etc.) a design uses.  
Tools report utilization after synthesis and P&R.  
In introductory designs this is rarely a limitation but is an important concept.

---

### Device / part number

Specific identifier of the FPGA model (family, size, package).  
In the EDA tool, you must select the correct **device** for the Tang Nano 9K, as it affects resource mapping and the generated bitstream.
