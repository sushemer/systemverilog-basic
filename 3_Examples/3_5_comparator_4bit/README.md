# 3.5 Comparador de 4 bits (A vs B)

Este ejemplo muestra un **comparador de 4 bits** implementado de dos maneras
en SystemVerilog y permite verificar en hardware si un valor `A` es menor,
igual o mayor que otro valor `B`, usando los botones/teclas de la Tang Nano 9K.

La idea es:

- Formar dos números de 4 bits:
  - `A[3:0]` a partir de `key[3:0]`
  - `B[3:0]` a partir de `key[7:4]`
- Evaluar las tres condiciones:
  - `A == B`
  - `A > B`
  - `A < B`
- Implementar el comparador de dos formas distintas:
  - Usando los operadores relacionales (`==`, `>`, `<`).
  - Usando una comparación **bit a bit en cascada** (como en un comparador digital clásico).
- Mostrar las seis señales (dos versiones de eq/gt/lt) en los LEDs.

---

## Objetivo

Al finalizar el ejemplo, la persona usuaria podrá:

- Representar dos números de 4 bits usando las entradas `key[7:0]`.
- Entender el funcionamiento de un **comparador de magnitud** (A vs B).
- Ver la diferencia entre una descripción de alto nivel (`==`, `>`, `<`) y
  una implementación **estructural por bits**.
- Verificar que ambas implementaciones entregan el mismo resultado.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope sintetizable para la Tang Nano 9K en configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`.  
  Contiene:
  - Declaración de puertos estándar (`clock`, `reset`, `key[7:0]`, `led[7:0]`, etc.).
  - Cálculo de `A` y `B` a partir de `key`:
    - `A = key[3:0]`
    - `B = key[7:4]`
  - Implementación 0 (alto nivel) del comparador:
    - `eq0 = (A == B)`
    - `gt0 = (A >  B)`
    - `lt0 = (A <  B)`
  - Implementación 1 (bit a bit, cascada):
    - Revisión de bits de mayor a menor (`A[3]` vs `B[3]`, luego `A[2]`, etc.).
    - Señales `eq1`, `gt1`, `lt1`.
  - Mapeo de las 6 señales a los LEDs.

- `README.md`  
  Este archivo, con la explicación del ejemplo.

Opcionalmente, según tu estructura de repo:

- Scripts de automatización:
  - `01_clean.bash`
  - `02_simulate_rtl.bash`
  - `03_synthesize_for_fpga.bash`
  - `04_configure_fpga.bash`

---

## Señales y mapeo a LEDs

En el código se usa:

- Entradas:

  - `A[3:0] = key[3:0]`
  - `B[3:0] = key[7:4]`

- Salidas:

  - Implementación 0 (alto nivel):

    - `eq0` → `LED[0]`  (1 cuando `A == B`)
    - `gt0` → `LED[1]`  (1 cuando `A >  B`)
    - `lt0` → `LED[2]`  (1 cuando `A <  B`)

  - Implementación 1 (bit a bit):

    - `eq1` → `LED[3]`
    - `gt1` → `LED[4]`
    - `lt1` → `LED[5]`

  - `LED[6]` y `LED[7]` → no usados (0)

En cualquier combinación de `A` y `B`, se espera que:

- Solo una de estas tres combinaciones sea cierta en cada implementación:
  - `eqX = 1`, `gtX = 0`, `ltX = 0`  → A igual a B.
  - `eqX = 0`, `gtX = 1`, `ltX = 0`  → A mayor que B.
  - `eqX = 0`, `gtX = 0`, `ltX = 1`  → A menor que B.

Y que la implementación 0 y la implementación 1 den **el mismo patrón**:

- `(eq0, gt0, lt0) = (eq1, gt1, lt1)`.

---

## Flujo sugerido de uso

1. **Revisar teoría asociada**

   Antes de este ejemplo, se recomienda repasar:

   - Representación binaria de números.
   - Comparadores de magnitud (A == B, A > B, A < B).
   - Implementaciones estructurales por bits (como en comparadores 1-bit en cascada).

