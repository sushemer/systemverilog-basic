# 4_9_1 – Solución: compuertas lógicas, De Morgan y funciones combinacionales

Esta solución completa las 3 tareas descritas en el archivo de actividad original `hackathon_top.sv`.

---

## Entradas

Desde los switches/teclas de la placa (según el wrapper):

- `A  = key[1]`
- `B  = key[0]`
- `C  = key[2]`
- `EN = key[3]`  (señal de habilitación general)

La idea es partir de estas señales para construir expresiones combinacionales y luego decidir qué se muestra en cada LED.

---

## Tarea 1 – Compuertas básicas + De Morgan (2 entradas)

Se implementan las siguientes expresiones a partir de `A` y `B`:

- `and_ab     = A & B`
- `or_ab      = A | B`
- `xor_ab     = A ^ B`
- `demorgan_1 = ~(A & B)`
- `demorgan_2 = (~A) | (~B)`

En código, de forma combinacional:

    and_ab     = A & B;
    or_ab      = A | B;
    xor_ab     = A ^ B;
    demorgan_1 = ~(A & B);
    demorgan_2 = (~A) | (~B);

### Mapeo a LEDs

Se usa el siguiente mapeo:

- `led[0]` → `and_ab`
- `led[1]` → `or_ab`
- `led[2]` → `xor_ab`
- `led[3]` → `demorgan_1`
- `led[4]` → `demorgan_2`

De esta forma, al recorrer las combinaciones de `A` y `B` con los switches, se puede observar cómo cambian las salidas y, en particular, verificar visualmente que:

- `demorgan_1` y `demorgan_2` siempre tienen el mismo valor  
  (es decir, se cumple la primera ley de De Morgan).

---

## Tarea 2 – Funciones con 3 entradas (A, B, C)

Se definen dos funciones combinacionales a partir de `A`, `B` y `C`.

### 2.1 Función de mayoría (`majority_abc`)

La función de mayoría vale 1 cuando **al menos dos** de las tres entradas son 1.

Definición:

    majority_abc = (A & B) | (A & C) | (B & C);

Observaciones:

- Si exactamente dos entradas son 1 → la salida es 1.
- Si las tres entradas son 1 → la salida también es 1.
- Solo vale 0 cuando hay **0 o 1** entradas activas.

### 2.2 Función de paridad (`parity_abc`)

Como segunda función se define una **paridad impar** de tres bits: vale 1 cuando hay un número impar de unos (1, 3).

Definición:

    parity_abc = A ^ B ^ C;

Comportamiento:

- Si hay 0 o 2 entradas activas → `parity_abc = 0`.
- Si hay 1 o 3 entradas activas → `parity_abc = 1`.

### Mapeo a LEDs para Tarea 2

Se usan dos LEDs adicionales:

- `led[5]` → `majority_abc`
- `led[6]` → `parity_abc`

Con esto:

- `led[2:0]` muestran las peticiones simples `A`, `B`, `C` si se desea reutilizar parte del mapeo.
- `led[5]` indica cuándo hay mayoría de 1s.
- `led[6]` indica cuándo hay paridad impar.

(El mapeo exacto puede variar, pero esta asignación aprovecha bien los 8 LEDs).

---

## Tarea 3 – Habilitación global con `EN`

La señal `EN` actúa como **habilitación general**. Cuando `EN = 0`, las salidas a LEDs se fuerzan a 0 (apagadas).  
Cuando `EN = 1`, se muestran los resultados calculados en las Tareas 1 y 2.

### 3.1 Lógica de habilitación

Una forma ordenada de implementarlo es:

1. Calcular primero todas las señales internas:

    and_ab, or_ab, xor_ab, demorgan_1, demorgan_2,
    majority_abc, parity_abc

2. Construir un vector intermedio con el “resultado sin habilitación”, por ejemplo:

    logic [7:0] led_raw;

    led_raw[0] = and_ab;
    led_raw[1] = or_ab;
    led_raw[2] = xor_ab;
    led_raw[3] = demorgan_1;
    led_raw[4] = demorgan_2;
    led_raw[5] = majority_abc;
    led_raw[6] = parity_abc;
    led_raw[7] = EN;      // opcional: LED que refleja el estado de habilitación

3. Aplicar la habilitación en un bloque combinacional:

    if (EN) begin
        led = led_raw;
    end
    else begin
        led = 8'b0;
    end

Con este patrón:

- Cuando `EN = 0` → todos los LEDs quedan apagados.
- Cuando `EN = 1` → se muestran las salidas correspondientes a las funciones implementadas.

---

## Resumen de la solución

- Se definen correctamente las compuertas básicas (`and_ab`, `or_ab`, `xor_ab`) y las dos formas de la ley de De Morgan (`demorgan_1`, `demorgan_2`).
- Se implementan dos funciones de 3 entradas:
  - `majority_abc` (mayoría de A, B, C).
  - `parity_abc` (paridad impar).
- Se asigna cada resultado a un LED específico para facilitar la verificación visual.
- Se introduce una habilitación global `EN` que controla si las salidas se propagan o se fuerzan a 0.

De esta manera, el archivo `hackathon_top.sv` correspondiente a `4_9_1` muestra una solución completa a las 3 tareas combinacionales, y sirve como referencia para depurar o comparar la implementación realizada en la actividad original.
