# HDL and FPGA basics

Este documento introduce dos ideas fundamentales:

- Qué es un **HDL** (Hardware Description Language).
- Qué es una **FPGA** y cómo se diferencia de otros dispositivos programables.

El objetivo es dar contexto antes de entrar a detalles de Verilog/SystemVerilog.

---

## ¿Qué es un HDL?

Un **Hardware Description Language (HDL)** es un lenguaje para describir hardware digital:

- No describe instrucciones que un procesador ejecuta paso a paso.
- Describe **módulos de hardware**: compuertas, sumadores, registros, máquinas de estados, etc.
- Permite expresar:
  - Cómo se conectan las señales de entrada y salida.
  - Qué lógica combinacional se aplica.
  - Qué elementos secuenciales (flip-flops, registros) almacenan estado.

Ejemplos de HDL:

- **Verilog / SystemVerilog**
- **VHDL**

En este repositorio se utiliza principalmente **SystemVerilog**, una evolución de Verilog.

---

## ¿Qué es una FPGA?

Una **FPGA (Field Programmable Gate Array)** es un circuito integrado programable que contiene:

- Bloques lógicos configurables (LUTs y flip-flops).
- Recursos de memoria.
- Ruteo interno programable.
- A veces, bloques dedicados (multiplicadores, PLL, etc.).

La FPGA puede configurarse para comportarse como:

- Un conjunto de compuertas y registros específicos.
- Uno o varios procesadores simples.
- Controladores de periféricos.
- Máquinas de estados, filtros digitales y más.

Comparación simple:

- **Microcontrolador**  
  Ejecuta un programa secuencial almacenado en memoria (firmware).
- **FPGA**  
  Implementa hardware que funciona **en paralelo**; muchas partes del diseño “corren al mismo tiempo”.

---

## Relación entre HDL y FPGA

El flujo típico de trabajo es:

1. Se escribe un diseño en HDL (por ejemplo, SystemVerilog).
2. Se simula el diseño para verificar su comportamiento.
3. Se sintetiza y mapea el diseño a los recursos de la FPGA.
4. Se genera un archivo de configuración (bitstream).
5. Se programa la FPGA con ese archivo.

En este repositorio el énfasis está en:

- Escribir módulos en SystemVerilog.
- Sintetizar y programar la **Tang Nano 9K**.
- Observar el resultado en LEDs, displays, sensores y actuadores.

---

## Tang Nano 9K en este contexto

La **Tang Nano 9K** es la placa principal utilizada:

- Integra una FPGA Gowin.
- Expone pines de entrada/salida para:
  - Botones, switches, encoders.
  - LEDs, 7 segmentos, TM1638, LCD, servos, etc.

Cada diseño en SystemVerilog se carga en la FPGA para:

- Probar conceptos básicos (compuertas, contadores).
- Experimentar con máquinas de estados.
- Integrar sensores y actuadores.

---

## ¿Por qué es importante entender esto?

Distinguir entre:

- **Describir hardware** (HDL + FPGA).
- **Escribir software** (CPU + programa).

ayuda a interpretar correctamente los ejemplos y laboratorios:

- Un `always_ff @(posedge clk)` no es un “loop” de software, sino **hardware que se actualiza en cada flanco de reloj**.
- Una asignación combinacional describe **una red lógica**, no una instrucción única.

---

## Relación con otros archivos y ejemplos

- Este documento es un prerequisito conceptual para:
  - `1_2_2_Verilog_SystemVerilog_Overview.md`
  - `1_2_3_Modules_and_Ports.md`
- Examples sugeridos para comenzar:
  - `binary_counter` (contador simple).
  - `and_or_not_xor_demorgan` (compuertas lógicas básicas).
