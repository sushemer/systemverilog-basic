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

req se toma directamente de `key[2:0]`.

`idx` y `valid` se inicializan con valores por defecto (sin petición activa).

## 2. Implementar la lógica del priority encoder

Dentro del `always_comb` se debe completar la lógica de prioridad usando una cadena de `if / else if`, siguiendo el orden:

- Primero se verifica `req[2]`.
- Si `req[2]` no está activo, se verifica `req[1]`.
- Si tampoco está activo, se verifica `req[0]`.
- Si ninguna entrada está activa, se mantienen los valores por defecto (`idx = 0`, `valid = 0`).

La estructura general recomendada:

```sv
always_comb begin
    idx   = 2'd0;
    valid = 1'b0;

    if (req[2]) begin
        idx   = 2'd2;
        valid = 1'b1;
    end
    else if (req[1]) begin
        idx   = 2'd1;
        valid = 1'b1;
    end
    else if (req[0]) begin
        idx   = 2'd0;
        valid = 1'b1;
    end
    // Si req = 3'b000, se conservan los valores por defecto
end
```

Con este patrón:

- La primera condición verdadera define qué entrada gana.  
- `valid` se pone en `1` siempre que exista al menos una petición.  
- Si todas las condiciones son falsas, `valid` se mantiene en `0`.

Luego, típicamente se asigna:

- `assign led[2:0] = req;`  
- `assign led[4:3] = idx;`  
- `assign led[7]   = valid;`  

---

## 3. Pruebas sugeridas

Para verificar que el diseño cumple con la tabla de verdad:

- Se fuerza `req` mediante `key[2:0]` en todas sus combinaciones de `000` a `111`.
- Se observa en la placa:
  - `led[2:0]` mostrando el patrón actual de `req`.
  - `led[4:3]` mostrando el código `idx`.
  - `led[7]` encendiéndose solo cuando `valid = 1`.

Casos clave:

- `req = 3'b001`  
  → Se espera: `idx = 2'd0`, `valid = 1`.

- `req = 3'b010`  
  → Se espera: `idx = 2'd1`, `valid = 1`.

- `req = 3'b011` (entradas 1 y 0 activas)  
  → Debe ganar la de mayor prioridad (`req[1]`):  
  `idx = 2'd1`, `valid = 1`.

- `req = 3'b100`  
  → Se espera: `idx = 2'd2`, `valid = 1`.

- `req = 3'b111` (todas activas)  
  → Debe ganar `req[2]`:  
  `idx = 2'd2`, `valid = 1`.

- `req = 3'b000`  
  → Se espera: `valid = 0` y `idx` en su valor por defecto (por ejemplo `0`).

Si todos estos casos se observan correctamente en los LEDs, el priority encoder está funcionando según lo esperado.

---

## 4. Extensiones opcionales

Si se desea experimentar más a partir de esta actividad, se pueden realizar, por ejemplo, las siguientes extensiones:

- Usar `led[6:5]` para mostrar directamente `idx[1:0]` (dejando `led[4:3]` para otra variante del encoder).
- Implementar una versión alternativa del priority encoder usando `casez` y valores `x/z` para manejar “don’t care”, y comparar que la salida coincide con la versión de `if / else if`.
- Añadir comentarios en `hackathon_top.sv` con una pequeña tabla de verdad que documente, para cada combinación de `req`, el valor esperado de `idx` y `valid`.
- Extender el concepto a un priority encoder de más bits (por ejemplo 4→2 o 8→3) y analizar cómo cambia la estructura del código.

Con esta actividad se introduce un patrón muy común en diseños digitales: resolver conflictos de prioridad entre varias peticiones, generando un índice ganador y una bandera que indica si el sistema tiene trabajo pendiente.
