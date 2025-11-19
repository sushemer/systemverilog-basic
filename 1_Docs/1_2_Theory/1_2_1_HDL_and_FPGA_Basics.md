# HDL and FPGA basics

Este documento introduce dos ideas fundamentales:

- Qué es un **HDL** (Hardware Description Language).
- Qué es una **FPGA** y cómo se diferencia de otros dispositivos programables.

---

## 1. ¿Qué es un HDL?

Un HDL (*Hardware Description Language*) es un lenguaje para describir **circuitos digitales**, no programas que se ejecutan paso a paso como en C, Python o Java.

Con un HDL:

- Se describen **señales**, **registros**, **módulos** y **conexiones**.
- Se indica qué debe ocurrir en cada **borde de reloj** o cómo se combinan las señales.
- El resultado final se puede sintetizar a **hardware real** (FPGA, ASIC).

Ejemplos de HDL:

- Verilog
- SystemVerilog
- VHDL
- Otros lenguajes de hardware de alto nivel (Chisel, etc.)

En este repositorio utilizamos principalmente **SystemVerilog** (una extensión moderna de Verilog).

---

## 2. ¿Qué es una FPGA?

Una FPGA (*Field Programmable Gate Array*) es un circuito integrado que puede configurarse después de fabricado.

En lugar de tener una lógica fija (como un microcontrolador con su CPU definida), una FPGA contiene:

- **LUTs** (Look-Up Tables): pequeñas funciones lógicas configurables.
- **Flip-flops / registros**: almacenamiento de 1 bit asociado al reloj.
- **Bloques de memoria** (BRAM).
- **Bloques especiales** (multiplicadores, PLL, etc.).
- **Red de interconexión programable** que une todo lo anterior.

Al cargar un **bitstream** en la FPGA, se define:

- Qué hace cada LUT.
- Cómo se conectan las señales.
- Qué registros se usan y cómo.

Su código SystemVerilog termina transformándose en esa configuración interna.

---

## 3. FPGA vs microcontrolador (visión rápida)

| Aspecto                | FPGA                                      | Microcontrolador                           |
|------------------------|-------------------------------------------|--------------------------------------------|
| Modelo de ejecución    | Muchos bloques en paralelo.              | CPU que ejecuta instrucciones secuenciales. |
| Flexibilidad           | Muy alta: la lógica puede cambiarse por completo. | Media: la CPU es fija, cambias el firmware. |
| Tipo de tareas         | Señales de alta velocidad, interfaces personalizados, procesamiento paralelo. | Control general, lógica secuencial, periféricos integrados. |
| Herramientas           | Sintetizador, place & route, bitstream.  | Compilador, linker, flasher de firmware.   |

En este proyecto no usamos un microcontrolador externo; la **FPGA es el “cerebro” principal**.

---

## 4. ¿Qué hace este repositorio?

Este repositorio está pensado como un camino de aprendizaje con **ejemplos pequeños y prácticos** sobre la Tang Nano 9K:

- Actividades de nivel básico (compuertas, mux, contadores).
- Labs más integrados (debounce, FSM, sensores, display).
- Implementaciones de proyectos más grandes (reloj, radar ultrasónico, etc.).

La idea es que pueda:

1. Ver el ejemplo corriendo en hardware real.
2. Abrir el código SystemVerilog.
3. Modificarlo y experimentar.
4. Relacionar el código con los LEDs, displays y sensores conectados.

---

## 5. ¿Qué no es este repositorio?

- No es un curso completo de teoría digital (álgebra de Boole, mapas de Karnaugh, etc.), aunque se usan esos conceptos.
- No pretende cubrir todo SystemVerilog ni todas las herramientas posibles.
- No es una guía oficial de Gowin ni de la Tang Nano 9K.

Se centra en:

- Ejemplos pequeños y concretos.
- Código comentado.
- Estructura clara de carpetas.
- Scripts simples para sintetizar y programar.

---

## 6. ¿Cómo se relaciona con tu aprendizaje?

Este material se puede usar de varias formas:

- Como apoyo a una asignatura de lógica o sistemas digitales.
- Como introducción práctica a FPGAs si vienes de programación clásica (C, Python, etc.).
- Como punto de partida para proyectos personales con FPGAs.

Si ya tiene experiencia con microcontroladores, piense que en el FPGA como:

- Un lugar donde, en lugar de escribir “un programa”, diseña **el circuito** que querría tener dentro del micro (o alrededor de él).
- Muchas cosas suceden **en paralelo**, no en una secuencia fija de instrucciones.

---

## 7. Siguiente paso

Para continuar con la teoría básica, puede leer:

- `1_2_2_Verilog_SystemVerilog_Overview.md`: visión general del lenguaje.
- `1_2_3_Modules_and_Ports.md`: cómo se estructuran los diseños en módulos.
- `1_2_4_Combinational_vs_Sequential.md`: diferencia entre lógica combinacional y secuencial.
