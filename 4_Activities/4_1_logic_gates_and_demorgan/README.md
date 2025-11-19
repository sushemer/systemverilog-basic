# 4.1 – Compuertas lógicas, De Morgan y funciones combinacionales

En esta actividad trabajarás con compuertas lógicas básicas,  verificarás una ley de De Morgan y diseñarás funciones combinacionales sencillas.

Se usa la placa **Tang Nano 9K** con el wrapper `hackathon_top`  para la configuración `tang_nano_9k_lcd_480_272_tm1638_hackathon`.

---

## Objetivos

1. Implementar compuertas `AND`, `OR`, `XOR` y una ley de De Morgan con 2 entradas.
2. Extender la idea a 3 entradas (`A`, `B`, `C`) para diseñar funciones “mayoría” y “exactamente una en 1”.
3. Agregar una entrada de habilitación (`EN`) que permita apagar/encender el bloque combinacional completo.

---

## Señales

Entradas:

- `A = key[1]`
- `B = key[0]`
- `C = key[2]` (Tarea 2)
- `EN = key[3]` (Tarea 3)

Salidas (sugeridas):

- `led[0]` → `A AND B`
- `led[1]` → `A OR  B`
- `led[2]` → `A XOR B`
- `led[3]` → `~(A & B)`
- `led[4]` → `(~A) | (~B)`
- `led[5]` → “mayoría” de (A,B,C) → al menos dos entradas = 1
- `led[6]` → “exactamente una entrada en 1” de (A,B,C)
- `led[7]` → indicador de habilitación (`EN`)

El display de 7 segmentos y la LCD no se usan en esta actividad.

---

## Tareas

### Tarea 1 – Compuertas básicas + De Morgan (2 entradas)

1. Conecta `A` y `B` a `key[1:0]`.
2. Implementa:
   - `led[0] = A & B`
   - `led[1] = A | B`
   - `led[2] = A ^ B`
   - `led[3] = ~(A & B)`
   - `led[4] = (~A) | (~B)`
3. Verifica en la placa que, para todas las combinaciones de `A` y `B`,  
   los LEDs `3` y `4` siempre tienen el mismo valor.

---

### Tarea 2 – Funciones con 3 entradas (A, B, C)

1. Define `C = key[2]`.
2. Diseña e implementa:
   - `led[5]` = función “mayoría”: se enciende si **al menos dos** entre A,B,C son 1.
   - `led[6]` = función “exactamente una en 1”: se enciende si solo una de A,B,C es 1.
3. Comprueba en la placa que el comportamiento coincide con tu intuición:
   - Por ejemplo, para A=1, B=1, C=0 → mayoría = 1, exactamente una = 0.

---

### Tarea 3 – Habilitación (EN)

1. Define `EN = key[3]`.
2. Modifica las salidas para que:
   - Si `EN = 0` → `led[6:0] = 0`.
   - Si `EN = 1` → `led[6:0]` muestren las funciones de las Tareas 1 y 2.
3. Usa `led[7]` como indicador de que `EN` está activo (por ejemplo `led[7] = EN`).

---

