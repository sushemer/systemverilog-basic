## References

### 1. Base repositories

- **Yuri Panchul – basics-graphics-music**  
  <https://github.com/yuri-panchul/basics-graphics-music>  

  This was the **main reference repository**. It gathers portable Verilog/SystemVerilog examples for FPGA and ASIC, organized into labs ranging from logic gates to graphics, sound, and microarchitecture.  
  Its main goals are:
  - Reduce the complexity of EDA tools and vendor ecosystems.
  - Bring academic exercises closer to real microarchitecture problems (CPU, GPU, networking).
  - Lower the entry barrier for people starting out or transitioning to FPGA/ASIC design.
  - Offer a reproducible workflow: choose a board, synthesize, and program using Bash scripts.

  Several concepts, folder structures, and scripts (`03_synthesize_for_fpga.bash`, `06_choose_another_fpga_board.bash`, etc.) from this project were adapted and simplified for the specific environment of **SiPeed Tang Nano 9K + LCD 480×272 + TM1638**.

- **Verilog Hackathon Education Kit Manual (forks and variants)**  
  - <https://github.com/ramprakashb/verilog-hackathon-education-kit-manual>  
  - <https://github.com/verilog-meetup/verilog-hackathon-education-kit-manual>  

  Repositories related to the educational kit used in various Verilog hackathons and seminars. Ideas were taken from their activity organization, difficulty levels, and practical project focus.

- **systemverilog-homework**  
  <https://github.com/yuri-panchul/systemverilog-homework>  

  A collection of SystemVerilog assignments and exercises oriented toward microarchitecture. It served as inspiration for the style of the labs and the progression of difficulty.

---

### 2. Books and study material

1. **Merrick, R. (2023).**  
   *Getting Started with FPGAs: Digital Circuit Design, Verilog, and VHDL for Beginners.* No Starch Press.

2. **Bruno, F., & Eschemann, G. (2024).**  
   *The FPGA Programming Handbook: An Essential Guide to FPGA Design for Transforming Ideas into Hardware Using SystemVerilog and VHDL (2nd ed.).* Packt Publishing.

3. **Schoeberl, M. (2025).**  
   *Digital Design with Chisel (6th ed.).* Author.

4. **Harris, S., & Harris, D.**  
   *Digital Design and Computer Architecture, RISC-V Edition.* Morgan Kaufmann.

5. **Dally, W. J., & Harting, R. C.**  
   *Digital Design: A Systems Approach.* Cambridge University Press.

These books were used as conceptual references for digital design topics such as timing, FSM, microarchitecture, and hardware best practices.

---

### 3. Online resources and tutorials

- **Verilog Meetup – Community and events**  
  - Main site: <https://verilog-meetup.com/>  
  - Article: *A new platform for FPGA seminars based on Gowin Tang Nano 9K: adding sound, graphics, and microarchitecture labs* (Panchul, 2024).  

  A key reference for understanding the educational context in which the Tang Nano 9K is used, and the focus on graphics, sound, and microarchitecture.

- **Official Tang Nano 9K documentation (SiPeed)**  
  - Tang Nano 9K – SiPeed Wiki: <https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html>  

  Used for pinout, electrical characteristics, programming flow, and board-specific details.

- **Educational resources for Verilog/SystemVerilog**  
  - HDLBits: <https://hdlbits.01xz.net/wiki/Main_Page>  
  - Nandland – Verilog Tutorial Index: <https://nandland.com/learn-verilog/>  
  - ASIC-World – Verilog Tutorial: <https://www.asic-world.com/verilog/veritut.html>  
  - ChipVerify – Verilog Tutorial: <https://www.chipverify.com/tutorials/verilog>  

  Used to reinforce basic concepts and quick examples of syntax, simulation, and module construction.

---

### 4. Datasheets and application notes (external hardware)

- **HC-SR04 – Ultrasonic sensor**  
  - Handson Technology. *HC-SR04 Ultrasonic Sensor Module User Guide (v2.0).*  

- **TM1638 – Display + LEDs + keys controller**  
  - Titan Micro Electronics. *TM1638 LED Driver Controller Datasheet.*  

- **LCD 480×272 (TFT)**  
  - Generic module reference: *480×272 TFT LCD display module* (manufacturers such as Hicenda and compatibles).  

- **KY-040 rotary encoder**  
  - Components101: *KY-040 Rotary Encoder Module* – pin descriptions, operation, common usage.

These documents were essential for defining connections, voltage levels, signal timing (TRIG/ECHO, debouncing, etc.), and correct mapping inside the SystemVerilog modules.

---

### 5. Educational context of the project

This repository was built from:

- Classes and hands-on sessions introducing **Verilog/SystemVerilog** using the **Tang Nano 9K**, taught to students with the support of **Mr. Zavala**.
- Teaching material and philosophy from **Verilog Meetup**, oriented toward:
  - Reducing tool friction.
  - Focusing learning on digital design rather than EDA configuration.
  - Taking students from basic exercises (gates, counters, FSM) to more integrated systems with graphics, audio, displays, and sensors.

The final goal of this work is to offer a set of activities, labs, and implementations that:

- Are **reproducible** on the Tang Nano 9K + LCD + TM1638 + basic sensors environment.
- Connect digital design theory with **visible and fun projects** (graphics, ultrasonic “radar,” mini-ALU, etc.).
- Serve as a foundation for future courses, workshops, and FPGA/Verilog/SystemVerilog hackathons.
