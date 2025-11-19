# 3.6 Adder/Subtractor de 3 bits (A ± B)

Este ejemplo implementa un **adder/subtractor de 3 bits** de dos maneras:

- **Implementación 0**: uso directo de los operadores aritméticos `+` y `-`.
- **Implementación 1**: uso de un único sumador con la fórmula de **complemento a dos**:


`res = A + (B ⊕ M) + M`

donde `M = mode` (bit de modo).

La placa Tang Nano 9K se utiliza en la configuración  
`tang_nano_9k_lcd_480_272_tm1638_hackathon`.

---

## 1. Idea general

Se usan los botones `key[7:0]` para construir dos números de 3 bits y un bit de modo:

- `A[2:0] = key[2:0]`
- `B[2:0] = key[5:3]`
- `mode   = key[7]`

El comportamiento es:

- Si `mode = 0` → **suma**:  `A + B`
- Si `mode = 1` → **resta**: `A - B`

El resultado se maneja como un número de **4 bits** (`[3:0]`):

- 3 bits para el valor (0–7).
- 1 bit extra para **carry/borrow**.

Cada implementación produce un resultado de 4 bits, que se muestra en un grupo distinto de LEDs.

> Nota: `key[6]` no se utiliza en este ejemplo.

---

## 2. Objetivo del ejemplo

Al completar este ejemplo se busca que la persona usuaria pueda:

- Representar dos números de 3 bits a partir de los botones de la placa.
- Entender dos formas de implementar un **adder/subtractor**:
  - implementación directa con `+` y `-`, y
  - implementación unificada con un solo sumador y complemento a dos.
- Comparar ambas implementaciones observando los resultados en los LEDs.

---

## 3. Señales principales

### Entradas

- `A[2:0]` ← `key[2:0]`
- `B[2:0]` ← `key[5:3]`
- `mode`  ← `key[7]` (`0` = sumar, `1` = restar)

### Salidas (resumen)

- **Implementación 0** → `res0[3:0]`
  - `res0[2:0]`: resultado de 3 bits.
  - `res0[3]`  : bit de carry/borrow.
- **Implementación 1** → `res1[3:0]`
  - `res1[2:0]`: resultado de 3 bits.
  - `res1[3]`  : bit de carry/borrow.

---

## 4. Implementación 0 – Operadores aritméticos (`+` y `-`)

En esta versión se usa la lógica “de alto nivel”:

- Si `mode = 0` → `res0 = A + B`
- Si `mode = 1` → `res0 = A - B`

Se obtienen 4 bits:

- `s0[2:0] = res0[2:0]`
- `c0      = res0[3]`

Mapeo a LEDs:

- `LED[0]` ← `s0[0]`
- `LED[1]` ← `s0[1]`
- `LED[2]` ← `s0[2]`
- `LED[3]` ← `c0`

Este grupo de LEDs muestra el resultado “tal cual” lo entrega el operador aritmético del lenguaje.

---

## 5. Implementación 1 – Adder/Subtractor con complemento a dos

En esta versión se fuerza el uso de **un único sumador**, tanto para suma como para resta, aplicando complemento a dos sobre `B` cuando corresponde.

La ecuación utilizada es:

`res1 = A + (B ⊕ {3{mode}}) + mode`

Intuición:

- Si `mode = 0`:
  - `B ⊕ 000 = B`
  - `res1 = A + B + 0 = A + B`
- Si `mode = 1`:
  - `B ⊕ 111 = ~B`
  - `res1 = A + (~B) + 1 = A - B` (suma de complemento a dos)

De nuevo, se obtienen 4 bits:

- `s1[2:0] = res1[2:0]`
- `c1      = res1[3]`

Mapeo a LEDs:

- `LED[4]` ← `s1[0]`
- `LED[5]` ← `s1[1]`
- `LED[6]` ← `s1[2]`
- `LED[7]` ← `c1`

---

## 6. Lectura de resultados en la placa

En ejecución:

- Los **LEDs 0–3** muestran el resultado de la **implementación 0**.
- Los **LEDs 4–7** muestran el resultado de la **implementación 1**.

Esto permite:

- Ver que ambos enfoques producen el mismo valor para todas las combinaciones de `A`, `B` y `mode`.
- Estudiar cómo cambia el bit de carry/borrow cuando se pasa de suma a resta.
