# System Verilog Basic

Academic repository for learning and practicing **Verilog/SystemVerilog** using the  
**Tang Nano 9K FPGA** and common peripherals (sensors and actuators).

Its purpose is to provide a structured path from **fundamentals** to  
**integrated mini-projects**, with reproducible examples, guided activities, labs, and clear evaluation criteria.

> Note: a large portion of the technical base (board support, peripherals, scripts, and some labs) is adapted from the work of **Yuri Panchul** and public educational repositories.  
> In this project they are reorganized, documented, and contextualized for academic use at UABC.

---

## Academic context

This repository is part of the research project:

> **“Development of innovative applications with SystemVerilog using the Tang Nano 9K FPGA”**

carried out at the **Faculty of Chemical Sciences and Engineering (FCQI), UABC**.

The goal of the project is to document and validate a learning path that enables:

- Starting from zero in Verilog/SystemVerilog and FPGA design.
- Reaching applications that integrate **sensors** and **actuators**.
- Leaving an organized foundation that can be reused in courses, workshops, and future student generations.

---

## Repository objective

The repository exists to accelerate **hands-on** learning of Verilog/SystemVerilog with the Tang Nano 9K, offering a clear path from **zero to integration**.  
It fulfills its purpose if it helps the learner to:

- Understand the **fundamentals**:
  - Modules and ports
  - Differences between **combinational** and **sequential** logic
  - Finite State Machines (FSM)
  - Clock dividers, counters, and PWM
- **Observe** concepts in action through minimal examples
- **Practice** with guided activities (checklist + evidence)
- **Integrate** sensors and actuators in labs and evaluable mini-projects
- Document each exercise or project with a clear and reproducible **README**

---

## Target audience

This material is mainly aimed at:

- Engineering students or related fields with no prior HDL/FPGA experience.
- Software developers (Python, C, Java, etc.) transitioning into digital hardware.
- Makers and enthusiasts who want to use an FPGA in practical projects without starting from scratch.

---

## Recommended background

Deep electronics experience is not required, but it helps to know:

- Basic programming (control structures, variables, functions) in C, C++, or Python
- Elementary **binary** and **Boolean logic** (AND, OR, NOT)
- Basic ability to:
  - Install software on **Windows or Linux**
  - Use the command line at a basic level
  - Use **Git** to clone and update repositories

These recommendations make progress easier, but the material is designed to support learners who are still acquiring these skills.

---

## Repository structure

The general organization is as follows (names may vary slightly depending on repo version):

- **1_Docs/**  
  Conceptual and operational documentation:
  - General project description and context
  - Short theory per topic
  - Installation guides (Windows/Linux)
  - Glossary of terms
  - References and external links

- **2_Devices/**  
  Hardware information:
  - Boards (especially **Tang Nano 9K**)
  - Sensors (HC-SR04, rotary encoder, etc.)
  - Actuators (7-segment display, TM1638, LCD, buzzer, etc.)
  - Electrical safety notes and constraint files

- **3_Examples/**  
  Minimal, self-contained examples focused on one concept.  
  Each example can be compiled, programmed, and observed directly.

- **4_Activities/**  
  Guided activities with:
  - Clear objectives
  - Suggested steps
  - Checklist and minimal required evidence

- **5_Laboratories/**  
  Structured hands-on labs by level (basic, intermediate, advanced),  
  with more complete procedures and, when needed, evaluation rubrics.

- **6_Implementation/**  
  Integrated mini-projects (e.g., digital clock, ultrasonic-servo radar)  
  combining counters, FSMs, PWM, sensors, and actuators.

- **board/**
  Board support files for multiple FPGA boards.  
  This section originates from **Yuri Panchul**’s *basic-graphics-music* project  
  and is adapted and documented here for the Tang Nano 9K.

- **labs/common/**  
  SystemVerilog modules reusable across several labs  
  (e.g., seven-segment display driver).  
  These also originate from the generic blocks in *basic-graphics-music*.

- **peripherals/**  
  High-level drivers and modules for:
  - TM1638 (7 segments + LEDs + keys)
  - LCD 480×272
  - Basic sensors  
  Most of these blocks are derived from examples in  
  *basic-graphics-music* and the *verilog-hackathon-education-kit*.

- **scripts/**  
  Bash scripts for synthesis, bitstream generation, and FPGA programming.  
  Their design closely follows the scheme proposed by **Yuri Panchul**  
  in *basic-graphics-music* (strict Bash mode, use of gw_sh, etc.).

> Each main folder tries to include a `README.md` with: objective, suggested steps,  
> short checklist, pin mapping/constraints, and when applicable, recommended deliverables.

---

## Getting started

A suggested workflow:

1. Read `1_Docs/1_1_Overview/` to understand context and the recommended path.
2. Follow the installation guide in `1_Docs/1_3_Install/` (Windows or Linux).
3. Run a basic example from `3_Examples/` (e.g., blink or a counter).
4. Continue with the associated activity in `4_Activities/`.
5. Proceed to the corresponding lab in `5_Labs/`.
6. Finally, explore the mini-projects in `6_Implementation/`.

This flow ensures you verify step by step:

- Tools are correctly installed.
- The board is correctly connected and configured.
- Each concept is assimilated before moving to the next level of complexity.

---

## Design principles

The repository is organized around these principles:

- **Actionable brevity**  
  Short theory, minimal code, clear Example → Activity → Lab connection.

- **Consistency**  
  Similar structure, unified naming, compatible README templates across folders.

- **Reuse**  
  Shared drivers and blocks live in `labs_common/`, `peripherals/` and  
  board support lives in `board_support/`, avoiding code duplication.

- **Clear evaluation**  
  When applicable, checklists, acceptance criteria, and simple rubrics are provided.

- **Scalability**  
  Gradual progression from basics to advanced topics without sudden jumps.

- **Continuity**  
  The repository is designed to allow others to extend, correct, and adapt it to  
  new activities, devices, or courses without depending on the original authors.

---
## Credits and Primary Sources

This repository is not built from scratch; it draws extensively on prior community work, open educational projects, and direct teaching experiences.  
The following sources and influences played a significant role in shaping this project:

---

### Reference Projects and Repositories

- **https://github.com/yuri-panchul/basics-graphics-music**  
  A collection of graphics and music examples for multiple FPGA boards.  
  Contributed:
  - The overall concept of an “educational kit” with examples, labs, and scripts.  
  - Foundational support for the Tang Nano 9K.  
  - The Bash script structure for synthesis and programming.  
  In this repository, these ideas were adapted to the academic context of UABC, with additional documentation and a guided learning path.

- **https://github.com/verilog-meetup/verilog-hackathon-education-kit-manual**  
  An educational manual that inspired:
  - A staged pedagogical approach.  
  - The structure of activities and mini-labs.  
  - The clear and concise documentation style used in short FPGA workshops.

- **https://github.com/ramprakashb/verilog-hackathon-education-kit-manual**  
  Forks and variants of the previous manual, used as complementary references  
  to compare approaches and refine design choices.

- **https://github.com/yuri-panchul/systemverilog-homework**  
  A collection of SystemVerilog exercises that influenced how practical activities  
  and progressive problem sets were designed.

---

### Teaching Experiences and Direct Collaboration

Beyond technical material, the final structure of this repository is strongly influenced by hands-on instructional experiences in accelerated SystemVerilog training:

- **Training sessions in Valle de Bravo**, where a 5-day intensive program was delivered starting from level zero, covering:
  - Fundamentals of Verilog/SystemVerilog.  
  - Practical use of the Tang Nano 9K.  
  - Handling of sensors, peripherals, and displays.  
  - Activities specifically shaped for short-duration courses.  
  Although time constraints limited the depth of some topics, this experience helped define the progression and pedagogical structure adopted in this repository.

- **Previous work at Hacker Dojo**, which involved practical experimentation, technical discussions, and real testing of several modules and activities.  
  This environment contributed to refining the teaching methodology, validating examples, and building the foundation for many of the mini-projects.

- **Workshops and classes delivered by Mr. Panchul and Mr. Zavala**, who contributed with:
  - Practical demonstrations.  
  - Clarification of fundamental SystemVerilog concepts.  
  - Advanced examples involving graphics, control logic, and FPGA pedagogy.  
  Their in-person sessions were essential to understanding the educational philosophy of the *basic-graphics* project and adapting it appropriately to this academic context.

---

### Adaptation Philosophy

The objective of this repository is **not** to replicate external materials literally, but to **adapt, reorganize, and extend** them in order to:

- Provide a clear and progressive learning path.  
- Offer unified documentation in English and Spanish.  
- Support both formal university instruction and independent learning.  
- Integrate original examples and mini-projects focused on sensors, actuators, and visualization.

Any future contributions should preserve proper attribution to the original authors and maintain the open educational spirit that made this project possible.
