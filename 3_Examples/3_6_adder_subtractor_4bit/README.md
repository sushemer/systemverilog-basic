# 3.6 Adder/Subtractor de 3 bits (A ± B)

Este ejemplo implementa un **adder/subtractor de 3 bits** de dos formas distintas:

- **Implementación 0**: usando directamente los operadores `+` y `-`.
- **Implementación 1**: usando un único sumador y la fórmula de **complemento a dos**:

  \[
  \text{res} = A + (B \oplus M) + M
  \]

donde `M = mode` (bit de modo).

La placa Tang Nano 9K se usa en configuración  
`tang_nano_9k_lcd_480_272_tm1638_hackathon`.

---

## Idea general

Usamos los botones `key[7:0]` para formar dos números de 3 bits y un bit de modo:

- `A[2:0] = key[2:0]`  
- `B[2:0] = key[5:3]`  
- `mode   = key[7]`

El comportamiento es:

- Si `mode = 0` → **suma**:  `A + B`
- Si `mode = 1` → **resta**: `A - B`

El resultado es de 3 bits (0 a 7) más un bit extra de carry/borrow;
por eso internamente se usan **4 bits** (`[3:0]`).

Cada implementación genera un resultado de 4 bits y se muestran
en dos grupos de LEDs.

---

## Objetivo

Al terminar este ejemplo, la persona usuaria podrá:

- Representar dos números de 3 bits con los botones de la placa.
- Ver cómo se implementa un **adder/subtractor**:
  - de forma “directa” (usando `+` y `-`), y
  - de forma **unificada** con un solo sumador y complemento a dos.
- Comparar ambas implementaciones viendo cómo los resultados
  aparecen en diferentes grupos de LEDs.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope para la Tang Nano 9K (`tang_nano_9k_lcd_480_272_tm1638_hackathon`), que contiene:
  - Declaración de puertos estándar (`clock`, `reset`, `key[7:0]`, `led[7:0]`, etc.).
  - Decodificación de entradas:
    - `A[2:0] = key[2:0]`
    - `B[2:0] = key[5:3]`
    - `mode   = key[7]`
  - Implementación 0 (alto nivel, `+` y `-`).
  - Implementación 1 (adder-subtractor con complemento a dos).
  - Mapeo de resultados a los LEDs.

- `README.md`  
  Este archivo, con la explicación del ejemplo.

Opcionalmente, según tu repo:

- Scripts de automatización:

  - `01_clean.bash`
  - `02_simulate_rtl.bash`
  - `03_synthesize_for_fpga.bash`
  - `04_configure_fpga.bash`

---

## Señales y mapeo a LEDs

### Entradas

- `A[2:0]` ← `key[2:0]`
- `B[2:0]` ← `key[5:3]`
- `mode`  ← `key[7]` (`0` = sumar, `1` = restar)

`key[6]` no se usa en este ejemplo.

### Implementación 0 – Alto nivel (`+` y `-`)

Se calcula un resultado de 4 bits:

- `res0[2:0]` → parte baja del resultado (3 bits).
- `res0[3]`   → bit extra (carry/borrow).

Se mapea a:

- `LED[0]` ← `s0[0] = res0[0]`
- `LED[1]` ← `s0[1] = res0[1]`
- `LED[2]` ← `s0[2] = res0[2]`
- `LED[3]` ← `c0    = res0[3]`

### Implementación 1 – Adder-subtractor (2’s complement)

Se aplica:

\[
\text{res1} = A + (B \oplus \{3{mode}\}) + mode
\]

- Si `mode = 0` → `res1 = A + B`
- Si `mode = 1` → `res1 = A + (~B) + 1 = A - B`

De nuevo, 4 bits:

- `res1[2:0]` → resultado.
- `res1[3]`   → bit extra.

Se mapea a:

- `LED[4]` ← `s1[0] = res1[0]`
- `LED[5]` ← `s1[1] = res1[1]`
- `LED[6]` ← `s1[2] = res1[2]`
- `LED[7]` ← `c1    = res1[3]`

---
