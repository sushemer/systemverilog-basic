
# Timing and dividers

Este documento aborda dos temas relacionados:

- La idea de **tiempo** en un diseño digital (timing).
- El uso de **divisores de reloj** para obtener señales más lentas a partir de un reloj rápido.

---

## Tiempo y frecuencia

Conceptos básicos:

- **Frecuencia (f)**: cuántos ciclos por segundo tiene la señal de reloj.
  - Se mide en Hz, kHz, MHz, etc.
- **Periodo (T)**: duración de un ciclo completo de reloj.
  - T = 1 / f.

Ejemplo:

- Si `f = 27 MHz`:
  - `T ≈ 1 / 27e6 ≈ 37 ns`.

En la FPGA:

- Todos los bloques sincronizados al mismo `clk` comparten ese periodo de actualización.
- Para efectos visibles (LED que parpadea a 1 Hz, multiplexado de displays, etc.) se necesitan tiempos mucho mayores, por lo que se usan contadores como **divisores de frecuencia**.

---

## Divisor de reloj con contador

Un **divisor de reloj** consiste en:

- Un contador que incrementa en cada flanco de reloj.
- Una o varias salidas que toman bits específicos de ese contador.

Ejemplo sencillo:

```systemverilog
module clock_divider_example (
    input  logic clk,
    input  logic rst_n,
    output logic slow_clk
);

    logic [23:0] counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 24'd0;
        else
            counter <= counter + 1;
    end

    assign slow_clk = counter[23];

endmodule
```
