# 1. Docs · Documentation and reading path

The `1_docs` folder contains the **central documentation** of the repository.  
Its main purpose is to:

- Explain the context and workflow.
- Present the minimal applied theory required.
- Guide the installation of tools.
- Standardize terms, acronyms, and external references.

The goal is not to replace books or official documentation, but to provide the **minimum necessary** to follow the examples, activities, labs, and mini-projects in the repository.

---

## Structure of `1_docs`

The folder is organized into the following subdirectories:

- `1_1_Overview/`  
  - General overview of the documentation.  
  - Relationship between Docs, Devices, Examples, Activities, Labs, and Implementation.  
  - Recommended workflow for using the repository.

- `1_2_Theory/`  
  - Short and applied theory, divided into compact files by topic, for example:
    - `modules_and_ports.md`
    - `combinational_vs_sequential.md`
    - `registers_and_clock.md`
    - `finite_state_machines.md`
    - `timing_and_dividers.md`
    - `pwm_basics.md`
    - `debouncing_and_edge_detection.md`
    - `buses_overview.md`
    - `seven_segment_basics.md`
    - `lcd_hd44780_basics.md`
    - `ultrasonic_hcsr04_basics.md`
  - Each file includes:
    - A short explanation.
    - One or a few diagrams or examples.
    - Links to related Examples, Activities, and Labs.

- `1_3_Install/`  
  - Guides for installing and configuring the working environment.
  - Suggested subfolders:
    - `1_3_1_Windows/`
    - `1_3_2_Linux/`
  - Typical topics:
    - Installation of Gowin EDA (recommended version).
    - Required drivers.
    - Notes on optional simulators (Icarus, Verilator, etc., if used).
    - Basic smoke-test procedures.

- `1_4_Glosario/`  
  - Short definitions of terms used in the repository:
    - HDL, FPGA, module, instance, clock, reset, debounce, FSM, etc.
  - Peripheral references: HC-SR04, TM1638, LCD, servo, ADC, among others.
  - The goal is to serve as a **quick reference point**, not an encyclopedia.

- `1_5_Reference/`  
  - Index of more extensive materials:
    - Notes or manuals in PDF (e.g., previous course content).
    - Relevant external repositories.
  - Each entry should include:
    - Name or short title.
    - A line explaining “what it is for”.
    - Link to the resource (URL or internal path).

---

## How to use this folder

The recommended workflow when using `1_docs` is:

1. **Read `1_1_Overview/` first**  
   To understand the context, the philosophy of the repository, and how the documentation relates to the other folders.

2. **Consult theory on demand** in `1_2_Theory/`  
   - Before or during an Example, Activity, or Lab.  
   - Only what is needed for the topic (e.g., FSM, PWM).

3. **Follow the installation guides** in `1_3_Install/`  
   - When setting up the environment for the first time.  
   - When reinstalling or switching between Windows and Linux.

4. **Use the glossary** from `1_4_Glosario/`  
   - Whenever a new term or acronym appears.  
   - As support for writing reports, presentations, or extra documentation.

5. **Review references** in `1_5_Reference/`  
   - To dive deeper into specific topics.  
   - To understand the sources of ideas or examples used in the repository.

---
