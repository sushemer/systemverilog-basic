# 4_9_3 – Priority encoder 3→2 + bandera `valid`

Actividad basada en `4_03_priority_encoder_and_valid_flag`, ahora incluida en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Implementar un **priority encoder** de 3 entradas a 2 bits de salida con una bandera de validez:

- Entradas de petición: `req[2:0]`
- Salida de índice: `idx[1:0]`
- Bandera: `valid` (indica si hay al menos una petición activa)

La prioridad es:

> `req[2]` > `req[1]` > `req[0]`

y se visualiza todo en los LEDs de la placa.

---

## Mapeo de señales

### Entradas (desde `key`)

- `req[2:0] = key[2:0]`  
  Cada bit representa una fuente que “pide servicio”.

### Salidas (hacia `led`)

- `led[2:0] = req[2:0]`  
  Muestran qué peticiones están activas.

- `led[4:3] = idx[1:0]`  
  Código binario del índice seleccionado por el priority encoder.

- `led[7] = valid`  
  Indica si hay **al menos una** petición (`req != 0`).

- `led[6:5]`  
  No se usan en esta actividad (libres para extensiones).

---

## Comportamiento esperado

### Casos básicos

- `req = 3'b001` → solo bit 0 activo  
  - `idx = 2'd0`  
  - `valid = 1`

- `req = 3'b010` → solo bit 1 activo  
  - `idx = 2'd1`  
  - `valid = 1`

- `req = 3'b100` → solo bit 2 activo  
  - `idx = 2'd2`  
  - `valid = 1`

### Casos con múltiples peticiones (prioridad)

- `req = 3'b011` → bits 1 y 0 activos  
  - Gana `req[1]`  
  - `idx = 2'd1`, `valid = 1`

- `req = 3'b110` → bits 2 y 1 activos  
  - Gana `req[2]`  
  - `idx = 2'd2`, `valid = 1`

- `req = 3'b111` → todos activos  
  - Gana `req[2]`  
  - `idx = 2'd2`, `valid = 1`

### Sin peticiones

- `req = 3'b000`  
  - `idx = 2'd0` (valor por defecto)  
  - `valid = 0`

---

## Implementación lógica

En el `always_comb` se usan:

- Valores por defecto:

```sv
idx   = 2'd0;
valid = 1'b0;
```