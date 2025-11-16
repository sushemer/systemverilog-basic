# Verilog / SystemVerilog overview

Este documento presenta una visión general de Verilog y SystemVerilog,  
enfocada en el uso que se les da dentro de este repositorio.

El objetivo es dar contexto suficiente para entender la sintaxis básica que aparece en los ejemplos, actividades y laboratorios.

---

## Verilog en pocas palabras

**Verilog** es un lenguaje de descripción de hardware (HDL) que permite:

- Declarar módulos con entradas y salidas.
- Describir lógica combinacional (AND, OR, sumadores, comparadores, etc.).
- Describir lógica secuencial (registros, contadores, máquinas de estados).
- Simular el comportamiento de un diseño antes de implementarlo en hardware.

Algunas características importantes:

- Sintaxis con cierto parecido a C.
- Uso extendido en industria y academia.
- Distingue entre:
  - Código **sintetizable** (implementable en FPGA/ASIC).
  - Código solo de **simulación** (testbenches, constructos no sintetizables).

En este repositorio se utiliza únicamente la parte **sintetizable**, enfocada a FPGA.

---

## ¿Qué agrega SystemVerilog?

**SystemVerilog** extiende Verilog con nuevas construcciones que facilitan el diseño:

- Nuevos tipos de datos:
  - `logic`, `enum`, `struct`, entre otros.
- Bloques especializados:
  - `always_ff` para lógica secuencial.
  - `always_comb` para lógica combinacional.
  - `always_latch` (no se usa de forma habitual en este proyecto).
- Mejor soporte para máquinas de estados y código más legible.

En este repositorio se aprovechan principalmente:

- `logic` para puertos y señales internas.
- `always_ff @(posedge clk)` para procesos sincronizados al reloj.
- `always_comb` para lógica combinacional.
- `typedef enum` para definir estados en máquinas de estados.

El propósito es que el código sea:

- Más claro para quienes están empezando.
- Más fácil de relacionar con diagramas de bloques y FSM.

---

## Estructura típica de un módulo

Un módulo sencillo en SystemVerilog suele tener:

1. **Cabecera del módulo**
   - Nombre del módulo.
   - Lista de puertos (entradas, salidas y, cuando aplica, inouts).

2. **Declaración de señales internas**
   - Registros, buses, estados, contadores, flags.

3. **Bloques de lógica**
   - Asignaciones continuas (`assign`) para lógica combinacional simple.
   - `always_comb` para combinacional más compleja.
   - `always_ff` para lógica secuencial.

4. **Comentarios** para documentar intención y decisiones.

Ejemplo mínimo ilustrativo:

```systemverilog
module blink_led (
    input  logic clk,
    input  logic rst_n,
    output logic led
);

    logic [23:0] counter;

    // Lógica secuencial: contador
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 24'd0;
        else
            counter <= counter + 1;
    end

    // Lógica combinacional: LED toma el bit más significativo
    assign led = counter[23];

endmodule
```
