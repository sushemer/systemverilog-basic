# 4.3 – Priority encoder 3→2 con bandera de “valid”

En esta actividad vas a implementar un **codificador con prioridad (priority encoder)**:

- Tiene **3 entradas de petición** `req[2:0]`.
- Entrega:
  - un **índice codificado** `idx[1:0]` que indica qué entrada ganó,
  - una bandera `valid` que indica si **al menos una** entrada está activa.

La prioridad está definida como:

> `req[2]` tiene más prioridad que `req[1]`, que a su vez tiene más prioridad que `req[0]`.

---

## Objetivos

1. Implementar un **priority encoder 3→2** usando una cadena de `if / else if`.
2. Generar correctamente:
   - el código `idx[1:0]` de la entrada ganadora,
   - la bandera `valid` cuando exista al menos una petición.
3. Visualizar las peticiones, el índice y la bandera en los LEDs de la Tang Nano 9K.

---

## Mapeo sugerido de señales

Entradas desde `key`:

- `req[0] = key[0]`
- `req[1] = key[1]`
- `req[2] = key[2]`

> Supón que `1` = “petición activa” para cada línea.

Salidas a LEDs:

- `led[2:0]` → `req[2:0]` (qué entradas están activas).
- `led[4:3]` → `idx[1:0]` (resultado del priority encoder).
- `led[7]`   → `valid` (hay al menos una petición).

Los LEDs `led[6:5]` quedan libres para extensiones o depuración.

El display de 7 segmentos y la LCD no se utilizan en esta actividad.

---

## Comportamiento esperado

Tu prioridad debe cumplir:

| `req`    | Gana | `idx` | `valid` |
|----------|------|-------|---------|
| 3'b000   | –    | 0     | 0       |
| 3'b001   | 0    | 0     | 1       |
| 3'b010   | 1    | 1     | 1       |
| 3'b011   | 1    | 1     | 1       |
| 3'b100   | 2    | 2     | 1       |
| 3'b101   | 2    | 2     | 1       |
| 3'b110   | 2    | 2     | 1       |
| 3'b111   | 2    | 2     | 1       |

Observa:

- Si hay varias entradas activas, **gana siempre la de mayor índice**.
- `valid = 1` siempre que `req` no sea 0.
- Cuando `req = 0`, `idx` puede quedar en su valor por defecto (sugerido: `0`) y `valid = 0`.

---

## Pasos sugeridos

### 1. Revisar la plantilla

En `hackathon_top.sv` encontrarás:

```sv
logic [2:0] req;
logic [1:0] idx;
logic       valid;

assign req = key[2:0];

always_comb
begin
    idx   = 2'd0;
    valid = 1'b0;

    // TODO: lógica de prioridad
end
```