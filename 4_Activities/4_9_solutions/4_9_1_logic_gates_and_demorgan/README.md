# 4_9_1 – Solución: compuertas lógicas, De Morgan y funciones combinacionales

Esta solución completa las 3 tareas descritas en el archivo de actividad original `hackathon_top.sv`.

## Entradas

Desde los switches de la placa:

- `A = key[1]`
- `B = key[0]`
- `C = key[2]`
- `EN = key[3]` (habilitación)

## Tarea 1 – Compuertas básicas + De Morgan (2 entradas)

Se implementan las siguientes expresiones:

- `and_ab     = A & B`
- `or_ab      = A | B`
- `xor_ab     = A ^ B`
- `demorgan_1 = ~(A & B)`
- `demorgan_2 = (~A) | (~B)`

Mapeo a LEDs:

- `led[0]` → `and_ab`
- `led[1]` → `or_ab`
- `led[2]` → `xor_ab`
- `led[3]` → `demorgan_1`
- `led[4]` → `demorgan_2`

## Tarea 2 – Funciones con 3 entradas (A, B, C)

Se definen dos funciones combinacionales:

1. **Mayoría** (`majority_abc`): al menos dos entradas en 1  

   ```sv
   majority_abc = (A & B) | (A & C) | (B & C);
   ```