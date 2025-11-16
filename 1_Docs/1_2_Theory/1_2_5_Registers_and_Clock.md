# Registers and clock

Este documento introduce dos elementos centrales en diseños con FPGA:

- El **reloj** (`clk`).
- Los **registros** (flip-flops) que almacenan información entre ciclos.

---

## Señal de reloj (clock)

La señal de **reloj** es una onda periódica (normalmente cuadrada) que marca el ritmo de actualización del sistema:

- Cada flanco (generalmente el flanco positivo) es un “tic”.
- En cada tic, los registros pueden tomar nuevos valores.

En la Tang Nano 9K:

- La placa incluye un reloj de referencia (por ejemplo, 27 MHz, 50 MHz, etc., según configuración).
- En los diseños se suele declarar un puerto `clk` que se conecta a ese pin de reloj.

Ejemplo de puerto de reloj en un módulo:

```systemverilog
module binary_counter (
    input  logic clk,
    input  logic rst_n,
    output logic [7:0] count
);
    // ...
endmodule
```
