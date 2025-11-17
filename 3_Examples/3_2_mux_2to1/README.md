# 3.2 Multiplexor 2:1 (mux 2:1)

Este ejemplo muestra un **multiplexor 2:1** implementado de varias maneras
en SystemVerilog y permite **verificar que todas las implementaciones son equivalentes**
usando los botones y LEDs de la Tang Nano 9K.

La idea es:

- Usar tres entradas binarias:
  - `d0` (dato de entrada 0)
  - `d1` (dato de entrada 1)
  - `sel` (señal de selección)
- Implementar el mux 2:1 de cuatro formas:
  - `always_comb` + `if / else`
  - Operador condicional `?:`
  - Sentencia `case`
  - Expresión con compuertas lógicas (`&`, `|`, `~`)
- Comprobar que todas las salidas son iguales para cualquier combinación de `d0`, `d1` y `sel`.

---

## Objetivo

Al finalizar el ejemplo, la persona usuaria podrá:

- Relacionar entradas físicas (switches / teclas) con señales lógicas `d0`, `d1` y `sel`.
- Entender el comportamiento de un **multiplexor 2:1**.
- Implementar la misma función combinacional de diferentes maneras en SystemVerilog.
- Verificar experimentalmente que todas las implementaciones de un mux 2:1 son equivalentes.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope sintetizable para la Tang Nano 9K (configuración `tang_nano_9k_lcd_480_272_tm1638_hackathon`).  
  Contiene:
  - Declaración de puertos estándar (clock, reset, `key[7:0]`, `led[7:0]`, etc.).
  - Lógica del mux 2:1 implementada de cuatro maneras.
  - Asignación de las señales a los LEDs de la placa.

- `README.md`  
  Este archivo, con la descripción y guía de uso del ejemplo.

Opcionalmente (según tu repo):

- Scripts de automatización:
  - `01_clean.bash`
  - `02_simulate_rtl.bash`
  - `03_synthesize_for_fpga.bash`
  - `04_configure_fpga.bash`

---

## Señales y pines

En el código SystemVerilog se utilizan los vectores:

- `key[7:0]` como entradas (conectadas a llaves / botones físicos).
- `led[7:0]` como salidas (conectadas a LEDs en la placa).

En este ejemplo se hace el siguiente mapeo lógico:

- Entradas del mux:

  - `d0` ← `key[0]`
  - `d1` ← `key[1]`
  - `sel` ← `key[7]` (selector)

- Salidas mostradas en LEDs:

  - `LED[0]` → `d0`
  - `LED[1]` → `d1`
  - `LED[2]` → `sel`
  - `LED[3]` → salida del mux implementado con `if / else` (`y_if`)
  - `LED[4]` → salida del mux implementado con operador ternario `?:` (`y_tern`)
  - `LED[5]` → salida del mux implementado con `case` (`y_case`)
  - `LED[6]` → salida del mux implementado con compuertas lógicas (`y_gate`)
  - `LED[7]` → no se usa (puede quedar en 0)

A nivel de comportamiento, el mux 2:1 cumple:

- Si `sel = 0` → salida `y = d0`
- Si `sel = 1` → salida `y = d1`

Si todas las implementaciones son correctas, los LEDs 3, 4, 5 y 6 **siempre deberán tener el mismo valor**.

---

## Flujo sugerido de uso

1. **Revisar teoría asociada**

   Antes de este ejemplo, se recomienda leer en la parte de teoría:

   - Introducción a módulos y puertos (`Modules and Ports`).
   - Diferencia entre lógica combinacional y secuencial (`Combinational vs Sequential`).
   - Opcional: un apartado de multiplexores si existe en tu repo (`Multiplexers`).

2. **Abrir el proyecto en Gowin / flujo de scripts**

   Opción A – Gowin IDE:

   - Crear o abrir un proyecto para la Tang Nano 9K.
   - Añadir el archivo `hackathon_top.sv`.
   - Configurar el módulo top como `hackathon_top`.
   - Asegurarse de que la board seleccionada corresponde a la configuración
     `tang_nano_9k_lcd_480_272_tm1638_hackathon` (o la equivalente en tu entorno).

   Opción B – Scripts `.bash` (si los tienes configurados):

   - Desde la carpeta del ejemplo:

     ```bash
     bash 01_clean.bash
     bash 03_synthesize_for_fpga.bash
     bash 04_configure_fpga.bash
     ```

3. **Verificar constraints**

   - Confirmar que el archivo de constraints de tu placa (CST/SDC) mapea correctamente:
     - `key[0]`, `key[1]`, `key[7]` a entradas físicas accesibles (switches/botones).
     - `led[7:0]` a los LEDs que vas a observar.

4. **Sintetizar y programar**

   - Ejecutar síntesis, place & route y generación del bitstream.
   - Programar la FPGA con el bitstream generado.

5. **Probar en la placa**

   - Probar varias combinaciones de `d0`, `d1` y `sel`:

     | d0 (`key[0]`) | d1 (`key[1]`) | sel (`key[7]`) | y esperada (`mux`) |
     |---------------|---------------|----------------|--------------------|
     |      0        |      0        |      0         |         0          |
     |      0        |      1        |      0         |         0          |
     |      1        |      0        |      0         |         1          |
     |      1        |      1        |      0         |         1          |
     |      0        |      0        |      1         |         0          |
     |      0        |      1        |      1         |         1          |
     |      1        |      0        |      1         |         0          |
     |      1        |      1        |      1         |         1          |

   - En todos los casos, verifica en la placa que:

     - `LED[0]` y `LED[1]` coinciden con `d0` y `d1`.
     - `LED[2]` coincide con `sel`.
     - `LED[3]`, `LED[4]`, `LED[5]` y `LED[6]` **siempre tienen el mismo valor**.

---

## Relación con otros elementos del repositorio

- **Teoría (docs sugeridos):**
  - Conceptos básicos de módulos y puertos.
  - Lógica combinacional vs secuencial.
  - Multiplexores y otras funciones combinacionales.

- **Ejemplos relacionados:**
  - `3.1 AND / OR / NOT / XOR + Leyes de De Morgan`  
    (introduce compuertas básicas y equivalencias lógicas).
  - Posibles futuros ejemplos:
    - `3
