# Verilog / SystemVerilog overview

Este documento presenta una visión rápida de **Verilog** y **SystemVerilog** y aclara:

- Qué son.
- En qué se parecen y se diferencian.
- Qué **subconjunto práctico** vamos a usar dentro de este repositorio.

El objetivo es dar contexto, **no** cubrir todo el estándar del lenguaje.

---

## 1. Verilog en pocas palabras

Verilog nació como un lenguaje para describir y simular hardware digital, pero orientado a:

- **Módulos** con entradas y salidas.
- **Señales** (`wire`, `reg` en Verilog clásico).
- **Bloques de comportamiento** (`always`, `initial`).
- **Asignaciones continuas** (`assign`) para lógica combinacional.
- **Simulación de tiempo** (delays, eventos, etc.).

Con Verilog se puede:

- Modelar **combinacional** (sumadores, comparadores, muxes…).
- Modelar **secuencial** (flip-flops, registros, FSMs).
- Describir desde pequeños bloques hasta sistemas complejos.

---

## 2. ¿Qué añade SystemVerilog?

SystemVerilog extiende Verilog con:

- Tipos más claros como `logic` (en lugar de `reg`/`wire` en muchos casos).
- Bloques especializados:
  - `always_ff` para lógica secuencial.
  - `always_comb` para lógica combinacional.
- Estructuras de datos más ricas:
  - `struct`, `enum`, `typedef`, `array` mejorados, etc.
- Cosas avanzadas de verificación:
  - Clases, randomización, assertions, interfaces, etc.

En este repositorio **no** usaremos las partes avanzadas de verificación (clases, random, etc.).  
Nos enfocaremos en el **subconjunto “sintetizable”** que sí se convierte en hardware.

---

## 3. Subconjunto que usaremos en este repositorio

En la práctica, la mayoría de los ejemplos usan:

- Declaraciones de módulo:

  ```sv
  module nombre_modulo (
      input  logic clk,
      input  logic reset,
      input  logic [7:0] a,
      output logic [7:0] y
  );
  ```