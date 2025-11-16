# Finite state machines (FSM)

Este documento introduce las **máquinas de estados finitos (FSM)**,  
una herramienta clave para controlar secuencias, menús, protocolos y lógica de decisión.

---

## ¿Qué es una FSM?

Una **FSM (Finite State Machine)** es un modelo donde:

- El sistema se encuentra siempre en **un estado actual** de un conjunto finito de estados posibles.
- Según:
  - El **estado actual** y
  - Las **entradas**,
  la FSM decide:
  - El **siguiente estado**.
  - Las **salidas** asociadas.

Ejemplos típicos:

- Semáforos (Rojo → Verde → Amarillo → Rojo).
- Cerraduras de combinación.
- Menús con botones (arriba/abajo/OK).
- Control de protocolos (I²C, SPI, UART, etc., en versiones más avanzadas).

---

## Componentes básicos de una FSM

1. **Conjunto de estados**  
   Por ejemplo: `IDLE`, `READ`, `WAIT`, `DONE`.

2. **Estado actual**  
   Se guarda en un registro (lógica secuencial).

3. **Lógica de siguiente estado**  
   Decide a qué estado se debe pasar en el siguiente ciclo de reloj.

4. **Lógica de salidas**  
   Calcula las salidas de la FSM (dependiendo del estado y, a veces, de las entradas).

---

## Representación en SystemVerilog

En este repositorio se recomienda:

- Definir los estados con `typedef enum`.
- Usar:
  - Un `always_ff` para el **estado actual**.
  - Un `always_comb` para el **siguiente estado** y, si aplica, las salidas.

Ejemplo simplificado de FSM de semáforo:

```systemverilog
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

    // Estado actual (registro)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= RED;
        else
            state <= next_state;
    end

    // Lógica de siguiente estado y salidas
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