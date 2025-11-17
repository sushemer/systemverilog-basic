# 4_9_4 – Mini ALU de 4 bits

Actividad basada en `4_04_mini_alu_4bit`, ahora incluida en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Implementar una **mini ALU de 4 bits** con:

- Dos operandos: `A[3:0]` y `B[3:0]`
- Selector de operación: `op[1:0]`
- Operaciones soportadas:
  - `op = 2'b00` → `A + B`
  - `op = 2'b01` → `A - B`
  - `op = 2'b10` → `A & B`
  - `op = 2'b11` → `A ^ B`
- Banderas:
  - `carry` → acarreo/borrow en suma/resta
  - `zero`  → vale 1 cuando el resultado es 0

El resultado y las banderas se visualizan en los LEDs de la placa.

---

## Mapeo de señales

### Entradas

En esta solución se mapean las teclas `key` como si fueran switches:

- `sw = key`
- `A = sw[3:0] = key[3:0]`
- `B = sw[7:4] = key[7:4]`
- `op = key[1:0]` (selector de operación)

> Nota: Los bits `key[1:0]` afectan tanto parte de `A` como a `op`.  
> Es una simplificación para poder usar solo `key` en esta actividad.

### Salidas (LEDs)

- `led[3:0] = result[3:0]`  
  Resultado de la operación de la ALU.

- `led[4] = carry`  
  Acarreo en la suma o bit extra de la resta (borrow simplificado).

- `led[5] = zero`  
  Bandera de **resultado cero** (`1` cuando `result == 0`).

- `led[7:6] = op[1:0]`  
  Muestran qué operación está activa.

---

## Comportamiento de la ALU

### Operaciones aritméticas

- **Suma (`op = 2'b00`)**

  ```sv
  sum_ext = {1'b0, A} + {1'b0, B};
  result  = sum_ext[3:0];
  carry   = sum_ext[4];
  ```