
# Modules and ports

Este documento explica qué es un **módulo** en SystemVerilog y cómo se definen sus **puertos** (entradas, salidas y, cuando aplica, inouts).

El objetivo es entender la “unidad básica” de un diseño en este repositorio.

---

## ¿Qué es un módulo?

Un **módulo** representa un bloque de hardware:

- Tiene un nombre (`module nombre ... endmodule`).
- Define **puertos** para comunicarse con otros módulos o con el mundo externo.
- Contiene señales internas y lógica que describe su comportamiento.

En un diseño más grande:

- Varios módulos se conectan entre sí en una estructura jerárquica.
- Un módulo puede **instanciar** otros módulos como sub-bloques.

---

## Definición básica de un módulo

Estructura general:

```systemverilog
module nombre_modulo (
    // Puertos
    input  logic a,
    input  logic b,
    output logic y
);

    // Señales internas
    // logic internal_signal;

    // Lógica (assign, always_comb, always_ff, etc.)

endmodule
```
