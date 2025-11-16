# Combinational vs sequential logic

Este documento explica la diferencia entre **lógica combinacional** y **lógica secuencial**,  
uno de los conceptos más importantes al diseñar con SystemVerilog y FPGA.

---

## Lógica combinacional

La **lógica combinacional** es aquella en la que:

- La salida depende **solo** de las entradas **en este instante**.
- No hay memoria explícita dentro del bloque.
- Si las entradas cambian, las salidas cambian “inmediatamente” (a nivel lógico).

Ejemplos típicos:

- Compuertas lógicas (AND, OR, NOT, XOR).
- Comparadores.
- Multiplexores (`mux`).
- Decodificadores.

En SystemVerilog, la lógica combinacional suele describirse con:

- Asignaciones continuas:
  ```systemverilog
  assign y = a & b;
  ```
  