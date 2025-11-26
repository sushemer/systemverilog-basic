# 1.1 Overview · How to use the documentation

This document provides a high-level view of the `1_docs` folder and explains how it connects with the rest of the repository (`2_devices`, `3_examples`, `4_activities`, `5_laboratories`, `6_implementation`).

Its aim is to answer three questions:

- Where do I start?
- When should I consult the theory?
- How do I connect the documentation with the examples, activities, labs, and implementations?

---

## 1. Suggested learning flow

A typical workflow when using this documentation is:

1. **Read this Overview (`1_1_Overview`)**  
   To understand the purpose of the repository, who it is for, and what results are expected.

2. **Review only the theory you need (`1_2_*`)**  
   Just the concepts needed for the practice you are about to do (combinational logic, FSM, counters, PWM, etc.).

3. **Follow installation and environment guides (`1_3_install`)**  
   To set up VS Code, Git, Gowin, and to clone the repository.

4. **Use the how-to guides when you get stuck (`1_5_howto`)**  
   - Hardware connections (`1_5_1_connections`).
   - Code flow (`1_5_2_code_flow`).
   - How to run scripts (`1_5_3_how_to_run`).
   - Common mistakes and precautions (`1_5_4_troubleshooting_and_pitfalls`).

5. **Work on `4_activities`, `5_labs`, and `6_implementation`**  
   Using the documentation in `1_docs` as support whenever needed.

---

## 2. Relationship with the rest of the repository

At a high level:

- `1_docs/`  
  Explains concepts, workflow, installation, and common errors.  
  It does not contain the main practice code—only theoretical and practical support.

- `2_devices/`  
  Describes the Tang Nano 9K and peripherals used.  
  Useful for questions about pinouts, voltages, and physical connections.

- `3_examples/`  
  Provides reference examples (graphics, audio, complex integrations).  
  Good for studying larger designs and understanding structure.

- `4_activities/`  
  Contains short exercises focused on specific concepts.  
  Documentation helps recall theory while completing `TODO`s.

- `5_labs/`  
  Groups more complete, integrated practices.  
  Documentation serves as a quick reference for reviewing concepts during design and debugging.

- `6_implementation/`  
  Includes mini-projects combining all previous work.  
  Documentation helps justify architecture and design decisions.

---

## 3. When to read what

- **Before touching code**:  
  - Read `1_1_1_Purpose`, `1_1_2_Audience`, and `1_1_3_Results`.  
  - Skim `1_1_4_Map` to understand the overall layout.

- **When setting up your machine**:  
  - Use `1_3_install` (Windows or Linux) to configure VS Code, Git, and Gowin.

- **When an exercise is unclear**:  
  - Check the theory summaries in `1_2_*` and the how-to guides in `1_5_*`.

- **When something breaks**:  
  - Check `1_5_3_how_to_run` (script-related issues).  
  - Check `1_5_4_troubleshooting_and_pitfalls` (common errors and warnings).

---

## 4. Summary

- `1_docs` is the **manual** that supports the code and hardware folders.
- This `1_1_Overview` subfolder explains:
  - Why the repository exists.
  - Who it is for.
  - What results are expected.
  - How documentation connects with examples, activities, labs, and implementations.

Once you understand this structure, you can navigate the rest of the project with more confidence.
