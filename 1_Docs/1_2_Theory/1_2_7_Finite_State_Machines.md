# 1.2.7 Finite state machines (FSM)

Este documento introduce las **máquinas de estados finitos (FSM)**,  una herramienta clave para controlar secuencias, menús, protocolos y lógica de decisión.

---

## 1. ¿Qué es una FSM?

Una **FSM (Finite State Machine)** es un modelo donde:

- El sistema se encuentra siempre en **un estado actual** de un conjunto finito de estados posibles.
- Según:
  - El **estado actual** y
  - Las **entradas**,
- la FSM decide:
  - El **siguiente estado**.
  - Las **salidas** asociadas.

Ejemplos típicos:

- Semáforo (Rojo → Verde → Amarillo → Rojo).
- Cerradura de combinación (secuencia correcta de botones).
- Menús con botones (arriba/abajo/OK).
- Control de protocolos (I²C, SPI, UART, etc., en versiones más avanzadas).

---

## 2. Componentes básicos de una FSM

Una FSM sincrónica típica tiene:

1. **Conjunto de estados**  
   Por ejemplo: `IDLE`, `READ`, `WAIT`, `DONE`.

2. **Estado actual**  
   Se guarda en un registro (lógica secuencial).

3. **Lógica de siguiente estado**  
   Decide a qué estado se debe pasar en el siguiente ciclo de reloj.

4. **Lógica de salidas**  
   Calcula las salidas de la FSM (dependiendo del estado y, a veces, de las entradas).

---

## 3. Representación en SystemVerilog

En este repositorio se recomienda:

- Definir los estados con `typedef enum`.
- Usar:
  - Un `always_ff` para el **estado actual**.
  - Un `always_comb` para el **siguiente estado** y, si aplica, las salidas.

Ejemplo simplificado de FSM de semáforo:
  ```sv
    typedef enum logic [1:0] {
        RED,
        GREEN,
        YELLOW
    } state_t;

    module fsm_traffic_light (
        input  logic clk,
        input  logic rst_n,
        output logic led_R,
        output logic led_G,
        output logic led_Y
    );

        state_t state, next_state;

        // 1) Registro de estado actual
        always_ff @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                state <= RED;
            else
                state <= next_state;
        end

        // 2) Lógica de siguiente estado y salidas
        always_comb begin
            // Valores por defecto
            next_state = state;
            led_R      = 1'b0;
            led_G      = 1'b0;
            led_Y      = 1'b0;

            unique case (state)
                RED: begin
                    led_R      = 1'b1;
                    next_state = GREEN;
                end

                GREEN: begin
                    led_G      = 1'b1;
                    next_state = YELLOW;
                end

                YELLOW: begin
                    led_Y      = 1'b1;
                    next_state = RED;
                end
            endcase
        end

    endmodule
  ```
En este ejemplo, la FSM recorre los estados `RED → GREEN → YELLOW → RED` de forma cíclica.  
En un diseño real se suele combinar con un **contador de tiempo** para que cada estado dure varios segundos.

---

## 4. Tipos de FSM: Mealy y Moore (visión simple)

En la teoría clásica se distingue entre:

- **Máquina de Moore**:
  - Las salidas dependen **solo del estado actual**.
  - Ejemplo: en el semáforo anterior, cada estado tiene LEDs fijos.
- **Máquina de Mealy**:
  - Las salidas dependen del estado y de las entradas.
  - Ejemplo: una FSM que activa una señal solo cuando está en cierto estado y, además, se recibe un pulso externo.

En este repositorio no se enfatiza la diferencia formal, pero es útil saber que:

- Muchas FSM de control sencillo se implementan como Moore.
- Cuando se necesita reaccionar inmediatamente ante una entrada (sin esperar cambio de estado), se termina usando un estilo parecido a Mealy.

---

## 5. Relación con otras piezas del diseño

Las FSM aparecen constantemente combinadas con:

- **Contadores y divisores**:
  - Para medir cuánto tiempo se permanece en un estado (ejemplo: semáforo).
- **Debounce de botones**:
  - Para que las entradas sean pulsos limpios y no múltiples flancos con ruido.
- **Drivers de periféricos**:
  - TM1638, LCD, sensores: el control interno suele seguir una secuencia (enviar comando, esperar, leer dato, etc.).

Ejemplos concretos dentro del repositorio:

- FSM de semáforo y “sequence lock” en los labs básicos.
- Menús y modos de operación en labs con display TM1638 o LCD.
- Implementaciones finales (reloj digital, radar ultrasónico) donde se gestionan varios estados globales.

---

## 6. Buenas prácticas al diseñar FSM

Al implementar FSM en SystemVerilog se recomienda:

- Nombrar los estados de forma clara (`IDLE`, `WAIT`, `ERROR`, etc.).
- Usar `typedef enum logic [...]` en lugar de números “mágicos”.
- Separar:
  - Registro de estado (`always_ff`).
  - Lógica de siguiente estado y salidas (`always_comb`).
- Dar **valores por defecto** a salidas y `next_state` al inicio del `always_comb`.
- Usar `unique case` o `priority case` cuando aplique, para detectar estados no cubiertos.
- Evitar mezclar demasiada lógica no relacionada dentro de la misma FSM; es preferible tener varias FSM pequeñas pero claras.

Estos patrones aparecerán en:

- Labs con FSM de semáforo, cerradura y control de patrones.
- Implementaciones de proyectos con menús y modos de operación.
- Cualquier diseño donde se deba seguir una secuencia ordenada de acciones.

