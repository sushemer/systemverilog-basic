## Referencias

### 1. Repositorios base

- **Yuri Panchul – basics-graphics-music**  
  <https://github.com/yuri-panchul/basics-graphics-music>  

  Este fue el **repositorio principal de referencia**. Reúne ejemplos portables de Verilog/SystemVerilog para FPGA y ASIC, organizados en labs que cubren desde compuertas lógicas hasta gráficos, sonido y microarquitectura.  
  Sus objetivos principales son:
  - Reducir la complejidad de las herramientas EDA y de los vendors.
  - Acercar los ejercicios académicos a problemas reales de microarquitectura (CPU, GPU, networking).
  - Bajar la barrera de entrada para personas que comienzan o se están cambiando a diseño FPGA/ASIC.
  - Ofrecer un flujo de trabajo reproducible: elegir tarjeta, sintetizar y programar con scripts Bash.

  Varios conceptos, estructura de carpetas y scripts (`03_synthesize_for_fpga.bash`, `06_choose_another_fpga_board.bash`, etc.) de este proyecto se adaptaron y simplificaron para el entorno específico de **SiPeed Tang Nano 9K + LCD 480×272 + TM1638**.

- **Verilog Hackathon Education Kit Manual (forks y variantes)**  
  - <https://github.com/ramprakashb/verilog-hackathon-education-kit-manual>  
  - <https://github.com/verilog-meetup/verilog-hackathon-education-kit-manual>  

  Repositorios relacionados al kit educativo usado en distintos hackathons y seminarios de Verilog. Se tomaron ideas de organización de actividades, niveles de dificultad y enfoque en proyectos prácticos.

- **systemverilog-homework**  
  <https://github.com/yuri-panchul/systemverilog-homework>  

  Colección de tareas y ejercicios de SystemVerilog orientados a microarquitectura. Sirvió como inspiración para el estilo de los labs y la progresión de dificultad.

---

### 2. Libros y material de estudio

1. **Merrick, R. (2023).**  
   *Getting Started with FPGAs: Digital Circuit Design, Verilog, and VHDL for Beginners.* No Starch Press.

2. **Bruno, F., & Eschemann, G. (2024).**  
   *The FPGA Programming Handbook: An Essential Guide to FPGA Design for Transforming Ideas into Hardware Using SystemVerilog and VHDL (2nd ed.).* Packt Publishing.

3. **Schoeberl, M. (2025).**  
   *Digital Design with Chisel (6th ed.).* Autor.

4. **Harris, S., & Harris, D.**  
   *Digital Design and Computer Architecture, RISC-V Edition.* Morgan Kaufmann.

5. **Dally, W. J., & Harting, R. C.**  
   *Digital Design: A Systems Approach.* Cambridge University Press.

Estos libros se usaron como referencia conceptual para temas de diseño digital, temporización, FSM, microarquitectura y buenas prácticas de hardware.

---

### 3. Recursos en línea y tutoriales

- **Verilog Meetup – Comunidad y eventos**  
  - Sitio principal: <https://verilog-meetup.com/>  
  - Artículo: *A new platform for FPGA seminars based on Gowin Tang Nano 9K: adding sound, graphics, and microarchitecture labs* (Panchul, 2024).  

  Referencia clave para entender el contexto educativo en el que se usa la Tang Nano 9K y el enfoque en gráficos, sonido y microarquitectura.

- **Documentación oficial de Tang Nano 9K (SiPeed)**  
  - Tang Nano 9K – SiPeed Wiki: <https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html>  

  Utilizada para pinout, características eléctricas, flujo de programación y detalles específicos de la tarjeta.

- **Recursos didácticos de Verilog/SystemVerilog**  
  - HDLBits: <https://hdlbits.01xz.net/wiki/Main_Page>  
  - Nandland – Verilog Tutorial Index: <https://nandland.com/learn-verilog/>  
  - ASIC-World – Verilog Tutorial: <https://www.asic-world.com/verilog/veritut.html>  
  - ChipVerify – Verilog Tutorial: <https://www.chipverify.com/tutorials/verilog>  

  Sirvieron como apoyo para reforzar conceptos básicos y ejemplos rápidos de sintaxis, simulación y construcción de módulos.

---

### 4. Datasheets y notas de aplicación (hardware externo)

- **HC-SR04 – Sensor ultrasónico**  
  - Handson Technology. *HC-SR04 Ultrasonic Sensor Module User Guide (v2.0).*  

- **TM1638 – Controlador de display + LEDs + teclas**  
  - Titan Micro Electronics. *TM1638 LED Driver Controller Datasheet.*  

- **LCD 480×272 (TFT)**  
  - Referencia de módulo genérico: *480×272 TFT LCD display module* (fabricantes como Hicenda y compatibles).  

- **Encoder rotatorio KY-040**  
  - Components101: *KY-040 Rotary Encoder Module* – descripción de pines, funcionamiento y usos típicos.

Estos documentos fueron esenciales para definir conexiones, niveles de tensión, tiempos de señal (TRIG/ECHO, debouncing, etc.) y mapeo correcto en los módulos SystemVerilog.

---

### 5. Contexto educativo del proyecto

Este repositorio se construyó a partir de:

- Clases y sesiones prácticas de introducción a **Verilog/SystemVerilog** usando la **Tang Nano 9K**, impartidas a estudiantes con el apoyo del **Sr. Zavala**.
- Material y filosofía de enseñanza de **Verilog Meetup**, orientadas a:
  - Reducir la fricción de herramientas.
  - Enfocar el aprendizaje en diseño digital, no en configuración de EDA.
  - Llevar a los estudiantes desde ejercicios básicos (compuertas, contadores, FSM) hasta sistemas más integrados con gráficos, audio, displays y sensores.

El objetivo final de este trabajo es ofrecer un conjunto de actividades, labs e implementaciones que:

- Sean **reproducibles** en el entorno Tang Nano 9K + LCD + TM1638 + sensores básicos.
- Conecten la teoría de diseño digital con **proyectos visibles y divertidos** (gráficos, “radar” ultrasónico, mini-ALU, etc.).
- Sirvan como base para futuros cursos, talleres y hackathons centrados en FPGA y Verilog/SystemVerilog.

