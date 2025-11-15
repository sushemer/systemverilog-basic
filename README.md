# systemverilog-basic
# 1.1 Overview

## Repository Purpose
This repository serves as a complete, structured learning path for people who want to understand and practice digital design using Verilog/SystemVerilog on the Tang Nano 9K (and similar FPGA boards).  
Instead of scattering theory, examples, and labs across multiple sources, this repo consolidates everything into a single, cohesive learning environment. Each folder contains concise explanations, progressively structured exercises, and verified implementations designed to help learners build practical intuition—not just theoretical knowledge.

The aim is to enable beginners to move from zero understanding to confidently writing, testing, and deploying hardware modules. By combining conceptual clarity with hands-on examples, the repository supports both self-learning and guided instruction (mentors, classes, workshops, TECLA activities, etc.).

## Target Audience
- **HDL beginners**, including students and hobbyists starting with digital logic and FPGA development.  
- **Software developers transitioning to hardware**, who need a practical introduction without heavy electrical-engineering prerequisites.  
- **Instructors or mentors**, who want ready-to-use modules, activities, and labs for teaching digital design.

No prior FPGA experience is required. Basic programming logic (conditions, loops, variables) is helpful but not mandatory.

## Learning Outcomes
By completing the content in this repository, the learner will be able to:

### Foundational
- Understand the difference between **combinational** and **sequential** logic.  
- Describe and implement modules, ports, and signal flow in Verilog/SystemVerilog.  
- Use registers, always blocks, and sensitivity lists correctly.  
- Apply clock dividers, timing constraints, and metastability-safe input handling.

### Intermediate
- Build finite state machines (FSMs) for control-flow logic.  
- Interface common peripherals (buttons, 7-segment displays, LEDs, LCDs, sensors).  
- Integrate multiple modules hierarchically in a larger design.  
- Simulate simple designs (if the user chooses to install simulators).

### Advanced
- Implement multi-digit multiplexed displays.  
- Drive protocols such as SPI, I²C, TM1638, ultrasonic sensors, servos, and encoders.  
- Develop complete mini-systems (clocks, menus, counters, sensors) using reusable components.

All learning outcomes are measurable through the examples, activities, and labs provided.

## How the Repository Is Organized
The repo is structured into five major sections, designed to guide the learner from theory → examples → guided practice → projects:

### **1. Docs/**  
Concise, applied documentation:
- **Overview:** What the repo is and how to use it.  
- **Theory:** Short, focused explanations of digital design concepts.  
- **Install:** Setup instructions for Windows and Linux.  
- **Glossary:** Definitions of HDL and FPGA terminology.  
- **Reference:** External links, datasheets, and deeper reading.

### **2. Examples/**  
Self-contained demos showing a single concept at a time (logic gates, decoders, counters, displays, sensors).  
These act as the “Hello World” for each idea.

### **3. Activities/**  
Practice exercises with clear steps, verification checklists, and minimal deliverables.  
Perfect for students, workshops, or mentor-guided learning.

### **4. Labs/**  
Longer, guided practices that integrate multiple ideas.  
Each lab includes objectives, materials, procedures, and tests.

### **5. Proposals/**  
More open-ended mini-projects (digital clock, servo radar, etc.) designed to encourage creativity and integration of modules.

Each folder is intentionally lightweight, modular, and easy to navigate.

---

## Do You Need Images Here?
**No**, this specific “Overview” section does *not* require images.  
It’s conceptual, textual, and organizational—no diagrams needed.

### Optional (not required)
If later you want to add a “repo map diagram,” you could include a simple tree diagram, but it’s not necessary for version 1.

---
