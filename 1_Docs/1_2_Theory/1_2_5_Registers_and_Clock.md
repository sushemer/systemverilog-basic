# 1.2.5 Registers and clock

Este documento introduce dos elementos centrales en diseños con FPGA:

- La **señal de reloj** (`clk`).
- Los **registros** (flip-flops) que almacenan información entre ciclos.

La mayor parte de la lógica en este repositorio sigue un estilo **sincrónico**, es decir, controlado por un reloj común.

---

## 1. Señal de reloj (clock)

La señal de **reloj** es una onda periódica (normalmente cuadrada) que marca el ritmo de actualización del sistema:

- Cada flanco (generalmente el **flanco positivo**) es un “tic”.
- En cada tic, los registros pueden tomar nuevos valores.

En la Tang Nano 9K:

- La placa incluye un oscilador de referencia (por ejemplo, ~27 MHz).
- En los diseños se declara un puerto `clock` o `clk` que se conecta a ese pin de reloj.
- En este repositorio, el módulo de la tarjeta suele entregar:
  - `clock` (rápido, directamente derivado del reloj de la placa).
  - `slow_clock` (reloj dividido para efectos muy lentos, según el ejemplo concreto).

Ejemplo de puerto de reloj en un módulo:
  ```sv
    module binary_counter (
        input  logic       clk,
        input  logic       rst_n,
        output logic [7:0] count
    );
        // ...
    endmodule
  ```
---

## 2. Registros (flip-flops)

Un **registro** es un conjunto de flip-flops que guarda un valor:

- Se actualiza solo en el flanco del reloj (según la sensibilidad del `always_ff`).
- Permite recordar información de un ciclo al siguiente.
- Es la base de contadores, máquinas de estados (FSM), filtros digitales, etc.

Ejemplo de un contador de 8 bits con registro:
  ```sv
    module binary_counter (
        input  logic       clk,
        input  logic       rst_n,
        output logic [7:0] count
    );

        always_ff @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                count <= 8'd0;           // Reset asíncrono, pone el contador en cero
            else
                count <= count + 8'd1;   // En cada flanco de reloj, incrementa
        end

    endmodule
  ```
Puntos clave:

- `count` es un registro de 8 bits.
- Solo cambia de valor en el flanco positivo de `clk` (o cuando `rst_n` pasa a 0).
- Entre flancos, `count` mantiene su valor.

---

## 3. Reloj + registro = diseño secuencial

Cuando se combinan:

- Un reloj `clk`.
- Registros que se actualizan en el flanco de `clk`.
- Lógica combinacional entre registros.

Se obtiene un diseño **secuencial sincrónico**. El flujo típico es:

1. En un flanco de reloj, los registros capturan nuevos datos.
2. Entre flancos, la lógica combinacional calcula los siguientes valores.
3. En el próximo flanco, esos nuevos valores vuelven a registrarse.

Este patrón:

- Facilita razonar sobre el comportamiento en el tiempo.
- Evita muchos problemas de metastabilidad y “glitches” que aparecen en diseños puramente combinacionales grandes.
- Es la base de casi todos los `hackathon_top.sv` del repositorio.

---

## 4. Reset: síncrono vs asíncrono

En los ejemplos de este repositorio se utilizan, principalmente, dos estilos de reset:

### 4.1 Reset asíncrono

El registro se borra en cuanto `rst_n` cambia, **sin esperar un flanco de reloj**.
  ```sv
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
  ```
Características:

- Responde de inmediato al cambio de `rst_n`.
- Es útil cuando se quiere poder forzar el sistema a un estado conocido en cualquier momento.
- Requiere más cuidado en el hardware físico para asegurar que la señal de reset cumple requisitos de tiempo.

### 4.2 Reset síncrono

El registro solo se borra en el **flanco de reloj**, cuando `reset` está activo.
  ```sv
    always_ff @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
  ```
Características:

- El reset se aplica alineado con el reloj.
- Facilita el análisis de tiempo (todo depende del mismo `clk`).
- Es un estilo muy común en diseños sincrónicos modernos.

En este repositorio se usa uno u otro estilo según el ejemplo o el entorno del módulo de placa (`board_specific_top`).

---

## 5. Reglas prácticas al usar registros y reloj

Al trabajar con los ejercicios de este proyecto:

- Mantener, en lo posible, **un solo reloj principal** (`clock`) por diseño.
- Evitar crear muchos relojes nuevos a partir de lógica; es preferible:
  - generar pulsos de **enable**, o
  - usar **divisores de frecuencia** internos,
  en lugar de múltiples dominios de reloj.
- Declarar la lógica secuencial con `always_ff` y la lógica combinacional con `always_comb`, para mantener el código claro y fácil de verificar.
- Usar resets de manera **consistente** dentro de cada módulo (no mezclar muchos estilos sin necesidad).
- Asegurar que todas las señales que cruzan entre diferentes dominios de reloj (si existen) pasen por mecanismos de **sincronización** adecuados (no es el foco de este repositorio, pero es importante a nivel profesional).

Estas ideas se aplican en:

- Contadores de `5_1_counter_hello_world`.
- Máquinas de estados del semáforo y del “lock”.
- Labs con sensores y TM1638.
- Implementaciones como:
  - el **reloj digital**, y
  - el sistema tipo **radar ultrasónico**.

Son la base del estilo de diseño que se espera practicar con este material.
