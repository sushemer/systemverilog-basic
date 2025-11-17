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

## Archivos del ejemplo

En esta carpeta se utilizan:

- `hackathon_top.sv`  
  Módulo tope sintetizable para la Tang Nano 9K en configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`.  
  Incluye:
  - Puertos estándar (`clock`, `slow_clock`, `reset`, `key[7:0]`, `led[7:0]`, etc.).
  - Declaración de `in[2:0]` a partir de `key[2:0]`.
  - Cuatro implementaciones internas del priority encoder:
    - `enc0`: if/else.
    - `enc1`: casez.
    - `enc2`: árbitro + encoder.
    - `enc3`: for-loop.
  - Empaquetado de todas las salidas en el vector `led`.

- `README.md`  
  Este archivo, con la explicación del ejemplo.

Opcional (según tu repo):

- Scripts para automatizar el flujo:

  - `01_clean.bash`
  - `02_simulate_rtl.bash` (si tienes testbench)
  - `03_synthesize_for_fpga.bash`
  - `04_configure_fpga.bash`

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