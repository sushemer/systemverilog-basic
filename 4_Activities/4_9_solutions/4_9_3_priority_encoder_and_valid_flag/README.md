# 4_9_3 – Priority encoder 3→2 + bandera `valid`

Actividad basada en `4_03_priority_encoder_and_valid_flag`, ahora incluida en la carpeta de soluciones `4_9_solutions`.

Esta solución muestra cómo implementar un **priority encoder** de 3 entradas con:

- Entradas de petición: `req[2:0]`
- Salida codificada: `idx[1:0]`
- Bandera de validez: `valid` (indica si hay al menos una petición activa)

La prioridad está definida como:

> `req[2]` > `req[1]` > `req[0]`

y todo se visualiza en los LEDs de la placa Tang Nano 9K.

---

## Objetivo

El diseño final:

1. Toma `req[2:0]` desde `key[2:0]`.
2. Determina **qué entrada gana** según la prioridad (2, luego 1, luego 0).
3. Produce:
   - `idx[1:0]` → índice de la entrada ganadora (0, 1 o 2).
   - `valid` → `1` si existe al menos una petición activa.
4. Muestra en LEDs:
   - Qué peticiones están activas.
   - Qué índice ha ganado.
   - Si hay o no una petición válida.

---

## Mapeo de señales

### Entradas (desde `key`)

- `req[2:0] = key[2:0]`  
  Cada bit representa una fuente que “pide servicio” (1 = petición activa).

En `hackathon_top.sv` típicamente:

    logic [2:0] req;
    logic [1:0] idx;
    logic       valid;

    assign req = key[2:0];

### Salidas (hacia `led`)

- `led[2:0] = req[2:0]`  
  Visualizan qué peticiones están activas.

- `led[4:3] = idx[1:0]`  
  Código binario del índice ganador.

- `led[7] = valid`  
  Indica si hay **al menos una** petición activa.

- `led[6:5]`  
  Quedan libres en esta solución (se pueden usar para extensiones o depuración).

Ejemplo habitual de asignación:

    assign led[2:0] = req;
    assign led[4:3] = idx;
    assign led[7]   = valid;
    assign led[6:5] = 2'b00;  // no usados en esta solución

---

## Comportamiento esperado

La prioridad se refleja en la siguiente tabla:

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

Observaciones:

- Si hay varias entradas activas, **gana siempre la de mayor índice**.
- `valid = 1` siempre que `req` sea distinto de 0.
- Cuando `req = 3'b000`, `valid = 0` y `idx` conserva su valor por defecto (recomendado: `2'd0`).

---

## Implementación lógica

La lógica principal se implementa en un bloque `always_comb` con:

- Valores por defecto (sin peticiones).
- Cadena de `if / else if` que respeta la prioridad.

### 1. Valores por defecto

Antes de revisar las peticiones, se inicializan las salidas:

    always_comb begin
        idx   = 2'd0;
        valid = 1'b0;

        // Lógica de prioridad...
    end

Esto asegura que, si no hay ninguna petición activa (`req = 3'b000`), el encoder deja:

- `idx = 2'd0` (valor de referencia)
- `valid = 1'b0`

### 2. Cadena de prioridad `if / else if`

El patrón de prioridad se implementa verificando primero la entrada de mayor prioridad:

    always_comb begin
        // Valores por defecto (sin petición)
        idx   = 2'd0;
        valid = 1'b0;

        if (req[2]) begin
            // Máxima prioridad: línea 2
            idx   = 2'd2;
            valid = 1'b1;
        end
        else if (req[1]) begin
            // Segunda prioridad: línea 1
            idx   = 2'd1;
            valid = 1'b1;
        end
        else if (req[0]) begin
            // Menor prioridad: línea 0
            idx   = 2'd0;
            valid = 1'b1;
        end
        // Si req = 3'b000, se conservan idx = 0 y valid = 0
    end

Con este patrón:

- La **primera condición verdadera** determina qué entrada gana.
- `valid` pasa a `1` en cuanto se detecta alguna petición.
- Si todas las condiciones son falsas (`req = 3'b000`), `valid` permanece en `0`.

---

## Conexión final a LEDs

Una vez calculados `idx` y `valid`, se conectan a los LEDs según el mapeo acordado:

    assign led[2:0] = req;   // peticiones actuales
    assign led[4:3] = idx;   // índice ganador
    assign led[7]   = valid; // bandera de validez
    assign led[6:5] = 2'b00; // libres en esta solución

De este modo, se tiene siempre en la placa una visualización coherente de:

- Qué líneas están pidiendo servicio (`led[2:0]`).
- Qué índice ha ganado (`led[4:3]`).
- Si el sistema tiene trabajo pendiente (`led[7]`).

---

## Pruebas sugeridas

Para comprobar que el priority encoder cumple con la tabla de verdad:

1. Forzar `req` mediante `key[2:0]` en todas las combinaciones de `3'b000` a `3'b111`.
2. Observar en la placa:

   - `led[2:0]` mostrando el patrón actual de `req`.
   - `led[4:3]` mostrando el valor de `idx`.
   - `led[7]` encendiéndose solo cuando `valid = 1`.

### Casos clave

- `req = 3'b001`  
  Se espera: `idx = 2'd0`, `valid = 1`.

- `req = 3'b010`  
  Se espera: `idx = 2'd1`, `valid = 1`.

- `req = 3'b011` (entradas 1 y 0 activas)  
  Debe ganar la de mayor prioridad (`req[1]`):  
  `idx = 2'd1`, `valid = 1`.

- `req = 3'b100`  
  Se espera: `idx = 2'd2`, `valid = 1`.

- `req = 3'b111` (todas activas)  
  Debe ganar `req[2]`:  
  `idx = 2'd2`, `valid = 1`.

- `req = 3'b000`  
  Se espera: `valid = 0` y `idx` en su valor por defecto (`2'd0`).

Si todos estos casos se observan correctamente, el priority encoder está funcionando según lo especificado.

---

## Extensiones opcionales

A partir de esta solución básica se pueden explorar varias mejoras:

- **Uso de `casez` con “don’t care”**  
  Implementar una versión alternativa del priority encoder utilizando `casez` y valores `x`/`z`, y verificar que produce la misma salida que la versión con `if / else if`.

- **Visualización adicional en LEDs**  
  Usar `led[6:5]` para mostrar, por ejemplo, una copia de `idx` o un indicador de modo de prueba.

- **Encoder de mayor tamaño**  
  Extender el concepto a un priority encoder de 4→2 o 8→3 entradas, analizando cómo crece la cadena de prioridad y cómo se estructura el código.

Con esta solución se ilustra un patrón muy común en diseños digitales: resolver conflictos de prioridad entre varias peticiones, generando un índice ganador y una bandera que indica si el sistema tiene trabajo pendiente.
