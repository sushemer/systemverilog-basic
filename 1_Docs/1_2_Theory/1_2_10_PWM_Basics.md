# 1.2.10 PWM basics

Este documento introduce el concepto de **PWM (Pulse Width Modulation)** y cómo se usa en este repositorio para:

- Controlar el brillo de LEDs.  
- Controlar la posición de servomotores (en combinación con temporización específica).  
- Representar niveles “analógicos” a partir de una señal digital.

---

## 1. ¿Qué es PWM?

El **PWM** consiste en:

- Generar una señal digital que solo puede estar en 0 o 1.  
- Mantener un **periodo fijo** (T).  
- Variar el **ciclo de trabajo** (**duty cycle**):  
  porcentaje del tiempo que la señal está en 1 dentro de cada periodo.

Ejemplos de duty cycle:

- 0%  → siempre en 0.  
- 25% → 25% del tiempo en 1, 75% en 0.  
- 50% → mitad del tiempo en 1, mitad en 0.  
- 100% → siempre en 1.

Aunque la señal es digital, el **promedio de energía** puede interpretarse como un valor “analógico” por:

- Un LED (más brillo si el duty es mayor).  
- Un motor o servo (en ciertos rangos y frecuencias).  

---

## 2. PWM por comparación (counter + compare)

Implementación típica en FPGA:

1. Se utiliza un **contador** que recorre un rango (por ejemplo, 0 a 255).  
2. Se define un valor de **referencia** (`duty`).  
3. La salida PWM se coloca en 1 cuando `counter < duty` y en 0 en caso contrario.

Ejemplo básico:

```sv
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

En este esquema:

- Si `duty = 0`, `pwm_out` nunca está en 1.  
- Si `duty = 255`, `pwm_out` está prácticamente siempre en 1.  
- Valores intermedios producen un duty proporcional.

---

## 3. Frecuencia del PWM

El **periodo del PWM** depende de:

- La frecuencia del reloj `clk`.  
- El tamaño del contador (número de bits).  

Si:

- `clk = 27 MHz`  
- Contador de 8 bits (0–255)

entonces, de forma aproximada:

- Frecuencia PWM ≈ `27 MHz / 256 ≈ 105 kHz`.

En la práctica, para LEDs:

- Frecuencias de algunos kHz suelen ser suficientes (evitan parpadeo visible).  
- Puede combinarse un divisor previo de reloj con el PWM para ajustar mejor la frecuencia.

---

## 4. Uso de PWM en este repositorio

Casos típicos:

- **LED dimmer**:  
  El valor de `duty` se obtiene de un botón, un encoder o la lectura de un ADC (potenciómetro).
- **Servo** (combinado con temporización de 20 ms):  
  El duty controla el ancho de pulso dentro de cada periodo de 20 ms.  
  El control de servos requiere un PWM con restricciones específicas de tiempo, no solo un duty genérico.
- **Indicadores de nivel**:  
  Variación de brillo o patrones de parpadeo según la intensidad medida.

Archivos relacionados:

- `1_2_5_Registers_and_Clock.md`  
- `1_2_6_Timing_and_Dividers.md`  
- `1_2_11_ADC_Basics.md` (cuando el duty proviene de una lectura analógica).  

Estos conceptos se combinan en actividades y labs donde se controlan LEDs, servos u otros actuadores a partir de señales digitales generadas en la FPGA.
