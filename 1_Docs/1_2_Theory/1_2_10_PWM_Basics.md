# PWM basics

Este documento introduce el concepto de **PWM (Pulse Width Modulation)** y cómo se usa en este repositorio para:

- Controlar el brillo de LEDs.
- Controlar la posición de servos (en combinación con temporización específica).
- Representar niveles “analógicos” a partir de una señal digital.

---

## ¿Qué es PWM?

El **PWM** consiste en:

- Generar una señal digital que solo puede estar en 0 o 1.
- Mantener un **periodo fijo** (T).
- Variar el **ciclo de trabajo** (**duty cycle**):  
  porcentaje del tiempo que la señal está en 1 dentro de cada periodo.

Ejemplos (duty cycle):

- 0% → siempre en 0.
- 25% → 25% del tiempo en 1, 75% en 0.
- 50% → mitad del tiempo en 1, mitad en 0.
- 100% → siempre en 1.

Aunque la señal es digital, el **promedio de energía** puede interpretarse como un valor “analógico” por:

- Un LED (más brillo si el duty es mayor).
- Un motor o servo (en ciertos rangos y frecuencias).

---

## PWM por comparación (counter + compare)

Implementación típica en FPGA:

1. Se usa un **contador** que recorre un rango (por ejemplo, 0 a 255).
2. Se define un valor de **referencia** (duty).
3. La salida PWM se pone en 1 cuando `counter < duty` y en 0 en caso contrario.

Ejemplo básico:

```systemverilog
module pwm_basic (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] duty,   // 0–255
    output logic       pwm_out
);

    logic [7:0] counter;

    // Contador libre
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 8'd0;
        else
            counter <= counter + 1;
    end

    // Comparación para generar PWM
    always_comb begin
        pwm_out = (counter < duty);
    end

endmodule
```
