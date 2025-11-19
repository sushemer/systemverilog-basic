# 1.2.6 Timing and dividers

Este documento aborda dos temas relacionados:

- La idea de **tiempo** en un diseño digital (timing).
- El uso de **divisores de reloj** para obtener señales más lentas a partir de un reloj rápido.

Se conecta directamente con los contadores, los patrones de LEDs y el multiplexado de displays que aparecen en actividades y labs.

---

## 1. Tiempo y frecuencia

Conceptos básicos:

- **Frecuencia (f)**: cuántos ciclos por segundo tiene la señal de reloj.  
  Se mide en Hz, kHz, MHz, etc.
- **Periodo (T)**: duración de un ciclo completo de reloj.  
  Se cumple: `T = 1 / f`.

Ejemplo:

- Si `f = 27 MHz`:
  - `T ≈ 1 / 27e6 ≈ 37 ns`.

En la FPGA:

- Todos los bloques sincronizados al mismo `clk` comparten ese periodo de actualización.
- Para efectos visibles (LED que parpadea a 1 Hz, multiplexado de displays, barridos en LCD, etc.) se necesitan tiempos mucho mayores, por lo que se usan **contadores** como divisores de frecuencia.

---

## 2. Divisor de reloj con contador

Un **divisor de reloj** típico consiste en:

- Un contador que incrementa en cada flanco de reloj.
- Una o varias salidas que toman bits específicos de ese contador.

Ejemplo conceptual:

- Si se tiene un contador de 24 bits que incrementa a 27 MHz:
  - El bit 0 cambia a la mitad de la frecuencia (13.5 MHz).
  - El bit 1 a 6.75 MHz.
  - …
  - El bit 23 es mucho más lento (f ≈ 27 MHz / 2²⁴).

Ejemplo sencillo de divisor:
  ```sv
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

        // Se toma un bit "alto" del contador como reloj lento
        assign slow_clk = counter[23];

    endmodule
  ```
En este ejemplo:

- `counter` se incrementa a la frecuencia completa del reloj de entrada.
- `slow_clk` es una señal cuadrada mucho más lenta (su frecuencia depende del bit elegido).

---

## 3. Divisores basados en “pulsos de enable”

En muchos diseños de este repositorio se prefiere **no crear nuevos relojes físicos**, sino generar un **pulso de habilitación (enable)** que vale 1 solo durante un ciclo, cada cierto tiempo.

Ejemplo:
  ```sv
    logic [23:0] div_cnt;
    logic        step_en;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            div_cnt <= 24'd0;
        else
            div_cnt <= div_cnt + 1;
    end

    // Pulso de un ciclo cuando el contador se desborda (vuelve a 0)
    assign step_en = (div_cnt == 24'd0);
  ```
En este caso:

- `clk` sigue siendo el único reloj del sistema.
- Cuando `step_en` es 1, se permite que otros bloques avancen “un paso” lento:

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led_pattern <= 8'b0000_0001;
        else if (step_en)
            led_pattern <= { led_pattern[6:0], led_pattern[7] };  // Rotación
    end

Ventajas:

- Se mantiene un solo dominio de reloj.
- Es más fácil analizar tiempos y evitar problemas de sincronización.
- El comportamiento lento (por ejemplo, barrer un LED) se controla por `step_en`.

---

## 4. Relación con actividades y labs

El uso de divisores y “ticks lentos” aparece en varios puntos del repositorio:

- **Activities**:
  - Contadores y patrones de LEDs (`4_9_5_counters_and_shift_patterns`).
  - Playground de 7 segmentos (modo contador lento).
  - Experimentos con LCD donde la actualización no tiene que ser tan rápida como el reloj base.
- **Labs**:
  - `5_1_counter_hello_world`: parpadeo de LEDs a ~1 Hz.
  - `5_3_shift_register_patterns`: barrido tipo KITT a velocidad visible.
  - `5_6_sensors_and_lcd_integration`: actualización periódica de lecturas.

En todos los casos, la idea es la misma:

- Usar el reloj rápido de la placa.
- Dividirlo internamente con contadores.
- Crear señales de enable o sub-relojes para animaciones o actualizaciones visibles.

---

## 5. Buenas prácticas con divisores

Al trabajar con tiempo y divisores de reloj se recomienda:

- Mantener un **solo reloj global** siempre que sea posible (`clock`).
- Evitar crear muchos relojes derivados; preferir **pulsos de enable** (`step_en`, `tick`).
- Usar tipos con ancho suficiente:
  - Si se necesitan segundos a partir de MHz, se requieren contadores de más bits.
- Comentar claramente qué periodo aproximado se espera:
  - Por ejemplo: `// step_en ≈ 10 ms` o `// slow_clk ≈ 1 Hz`.
- No depender de tiempos extremadamente precisos para efectos visuales sencillos; basta con que “se vea bien”.

Estos conceptos serán reutilizados en:

- Contadores de tiempo (reloj digital).
- Máquinas de estados con temporización (semáforos).
- Barridos de sensores y actualizaciones periódicas en LCD o TM1638.

---

