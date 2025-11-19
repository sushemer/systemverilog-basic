# 3.x Priority Encoder 3→2 (codificador con prioridad)

Este ejemplo muestra un **priority encoder 3→2** implementado de varias formas en SystemVerilog
y permite observar cómo, cuando hay varias entradas activas, solo se codifica el índice
de la que tiene **mayor prioridad**.

En este diseño:

- Hay **3 entradas** `in[2:0]` que vienen de `key[2:0]`.
- La salida son **2 bits** que codifican el índice de la entrada activa seleccionada.
- La prioridad está definida como:

  - Bit 0 → prioridad más alta  
  - Luego bit 1  
  - Luego bit 2  

Si más de una entrada está en `1` al mismo tiempo, gana la de **mayor prioridad**.

---

## Idea general

- Entradas:
  - `in[0]` ← `key[0]`  (mayor prioridad)
  - `in[1]` ← `key[1]`
  - `in[2]` ← `key[2]`  (menor prioridad)

- Salidas codificadas (2 bits):

  | Entradas activas (prioridad) | Salida (código) |
  |------------------------------|------------------|
  | `in[0] = 1`                  | `00`             |
  | `in[0] = 0`, `in[1] = 1`     | `01`             |
  | `in[0] = 0`, `in[1] = 0`, `in[2] = 1` | `10`    |
  | Ninguna entrada activa       | `00` (por convención) |

- Se implementan 4 versiones internas del mismo priority encoder:

  1. Cadena de `if / else if`.
  2. `casez` con patrones y don’t care.
  3. Separación en:
     - Árbitro de prioridad (genera un vector one-hot).
     - Encoder “normal” sin prioridad sobre ese vector.
  4. For-loop que recorre el vector de entrada.

Todas las implementaciones reciben el mismo vector `in` y generan un código de 2 bits.

---

## Señales y mapeo a LEDs

En el código se usa:

- Entradas:
  - `key[2:0]` → `in[2:0]`

- Salidas hacia LEDs:

  El vector final se arma como:

  ```systemverilog
  assign led = { enc0, enc1, enc2, enc3 };
   ```