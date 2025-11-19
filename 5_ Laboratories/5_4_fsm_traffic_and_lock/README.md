# Lab 5.4 – FSM: traffic light + sequence lock

## Objetivo

Diseñar, implementar y probar **dos máquinas de estados finitos (FSM)** en la Tang Nano 9K:

1. Un **semáforo** simple con tres estados: rojo, verde y amarillo.
2. Una **cerradura por secuencia** que solo se desbloquea al ingresar A-B-A-B.

Al final del lab debería poder:

- Expresar un comportamiento temporal como **FSM + temporizador**.
- Implementar una FSM de **control de secuencia de botones**.
- Mapear claramente estados a LEDs para depuración visual.

---

## Prerrequisitos

- Haber realizado:
  - **Lab 5.1 – blink_hello_world** (divisor / tiempos).
  - **Lab 5.3 – shift_register_patterns** (actualización de estado con ticks).

- Conocer:
  - `always_ff @(posedge clk ...)`
  - `typedef enum logic [...]` para codificar estados.
  - Detección de flancos simples (`pulse = btn & ~btn_q`).

---

## Mapeo de señales

### Semáforo

- **Reloj**: `slow_clock` (≈1 Hz, viene del wrapper de la placa).
- **Reset**: `reset` (activo en 1).
- **Estados**: `TRAFFIC_RED`, `TRAFFIC_GREEN`, `TRAFFIC_YELLOW`.
- **Tiempos**:
  - `T_RED    = 3`  (aprox. 3 s)
  - `T_GREEN  = 3`  (aprox. 3 s)
  - `T_YELLOW = 1`  (aprox. 1 s)
- **LEDs**:
  - `led[2]` → rojo
  - `led[1]` → amarillo
  - `led[0]` → verde

### Cerradura por secuencia

- **Botones**:
  - `btnA = key[4]`
  - `btnB = key[5]`
- **Secuencia válida**: `A → B → A → B`
- **FSM**:
  - `LOCK_IDLE`
  - `LOCK_A1`
  - `LOCK_A1B2`
  - `LOCK_A1B2A3`
  - `LOCK_OPEN`
- **Salida**:
  - `led[7]` → encendido cuando la secuencia correcta se completó.

---

## Procedimiento sugerido

1. **Estudia el bloque del semáforo**
   - Revisa el `typedef enum` y el `always_ff` que actualiza `traffic_state`.
   - Verifica cómo se usa `traffic_timer` para contar ticks de `slow_clock`.
   - Dibuja el diagrama de estados: RED → GREEN → YELLOW → RED.

2. **Analiza la detección de flancos (edge detect)**
   - Observa cómo `btnA_q` y `btnB_q` almacenan los valores anteriores.
   - Verifica que:
     - `pulseA = btnA & ~btnA_q`
     - `pulseB = btnB & ~btnB_q`
   - Esto genera un pulso de un tick de `slow_clock` cuando se presiona cada botón.

3. **Revisa la FSM de la cerradura**
   - Traza el diagrama de estados según el código:
     - `LOCK_IDLE` espera `A`.
     - `LOCK_A1` espera `B`.
     - `LOCK_A1B2` espera `A`.
     - `LOCK_A1B2A3` espera `B`.
     - `LOCK_OPEN` = secuencia completada (LED de lock encendido).
   - Cualquier botón incorrecto en cada etapa debe llevar a `LOCK_IDLE`.

4. **Síntesis y prueba en hardware**
   - Compila y programa la FPGA.
   - Observa el semáforo:
     - led[2] (rojo), led[1] (amarillo), led[0] (verde) deben ir cambiando con el tiempo.
   - Prueba la cerradura:
     - Ingresa la secuencia **A-B-A-B** (usando `key[4]` y `key[5]`).
     - El LED `led[7]` debe encenderse y permanecer así hasta hacer `reset`.

5. **Experimenta con los tiempos**
   - Cambia `T_RED`, `T_GREEN` y `T_YELLOW` para otros intervalos.
   - Observa cómo cambia el comportamiento en tiempo real.

---

## Checklist de pruebas

- [ ] Con `reset` activo y luego liberado, el semáforo inicia en **rojo** (`led[2]=1`).
- [ ] El semáforo sigue la secuencia: **rojo → verde → amarillo → rojo**.
- [ ] Los cambios de estado solo se dan en ticks de `slow_clock`.
- [ ] Presionando `A-B-A-B` (key[4], key[5]) en ese orden, `led[7]` se enciende.
- [ ] Cualquier error en la secuencia (ej. A-B-B, A-A-...) hace que la FSM vuelva a `LOCK_IDLE`.
- [ ] El LED de lock (`led[7]`) permanece encendido incluso si se siguen presionando botones, hasta que se haga `reset`.

---

## Extensiones opcionales

Ideas para seguir jugando con este lab:

- Agregar un **sensor de presencia** (otra tecla) que acelere el semáforo si hay “pocos coches”.
- Hacer que la **cerradura pueda volver a bloquearse** con otra secuencia (ej. B-A-B-A).
- Usar algunos LEDs intermedios (`led[6:3]`) para mostrar el **estado numérico** de cada FSM.

Este lab es buena base para cualquier sistema de control basado en máquinas de estados (semáforos reales, menús, protocolos, etc.).
