# 3.1 AND / OR / NOT / XOR + Leyes de De Morgan

Este ejemplo muestra el uso básico de compuertas lógicas (`AND`, `OR`, `NOT`, `XOR`)  
y permite **verificar una de las leyes de De Morgan** usando los botones y LEDs de la Tang Nano 9K.

La idea es:

- Usar dos entradas binarias `A` y `B` (botones o teclas).
- Mostrar en diferentes LEDs el resultado de:
  - `A AND B`
  - `A OR B`
  - `A XOR B`
  - `~(A & B)`
  - `(~A) | (~B)`
- Comprobar que `~(A & B)` y `(~A) | (~B)` dan el mismo resultado para todas las combinaciones de `A` y `B`.

---

## Objetivo

Al finalizar el ejemplo, la persona usuaria podrá:

- Relacionar entradas físicas (botones) con señales lógicas `A` y `B`.
- Implementar compuertas lógicas básicas en SystemVerilog.
- Verificar experimentalmente una ley de De Morgan comparando dos expresiones lógicas equivalentes.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `fpga_top.sv`  
  Módulo tope sintetizable para la Tang Nano 9K.  
  Implementa las compuertas lógicas y las expresiones de De Morgan.

---

## Señales y pines

Se asume que el archivo de constraints `tang-nano-9k.cst` mapea:

- Botones a entradas lógicas:

  - `KEY[0]` → `B`
  - `KEY[1]` → `A`

- LEDs a salidas lógicas:

  - `LED[0]` → `A AND B`
  - `LED[1]` → `A OR B`
  - `LED[2]` → `A XOR B`
  - `LED[3]` → `~(A & B)`
  - `LED[4]` → `(~A) | (~B)`

En el código SystemVerilog se utilizan los vectores:

- `key[1:0]` como entradas (venidas de `KEY[1:0]`).
- `led[4:0]` como salidas (mapeadas a `LED[4:0]`).

A = `key[1]`  
B = `key[0]`

---

## Flujo sugerido de uso

1. **Revisar teoría asociada**

   Antes de este ejemplo, se recomienda leer en `1_2_Theory`:

   - `1_2_3_Modules_and_Ports.md`
   - `1_2_4_Combinational_vs_Sequential.md`

2. **Abrir el proyecto en Gowin**

   - Crear o abrir un proyecto en Gowin IDE para la Tang Nano 9K.
   - Añadir el archivo `fpga_top.sv` del ejemplo.
   - Verificar que el módulo tope sea `fpga_top` (o el nombre que se haya configurado).

3. **Verificar constraints**

   - Asegurarse de que el proyecto usa el archivo de constraints:

     `2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

   - Confirmar que `KEY[0]`, `KEY[1]` y `LED[4:0]` están asignados correctamente.

4. **Sintetizar y programar**

   - Ejecutar la síntesis y place & route en Gowin.
   - Programar la FPGA con el bitstream generado.

5. **Probar en la placa**

   - Probar todas las combinaciones de `A` y `B` (botones):

    | A (`KEY[1]`) | B (`KEY[0]`) | LED0 = A & B | LED1 = A \| B | LED2 = A ^ B | LED3 = ~(A & B) | LED4 = (~A) \| (~B) |
    |--------------|-------------|--------------|---------------|--------------|------------------|----------------------|
    |      0       |      0      |      0       |       0       |      0       |        1         |          1           |
    |      0       |      1      |      0       |       1       |      1       |        1         |          1           |
    |      1       |      0      |      0       |       1       |      1       |        1         |          1           |
    |      1       |      1      |      1       |       1       |      0       |        0         |          0           |


   - Observar que `LED3` y `LED4` siempre tienen el mismo valor:  
     esto verifica la ley de De Morgan:

     `~(A & B) = (~A) | (~B)`


## Relación con otros elementos del repositorio

- **Teoría:**  
  `1_docs/1_2_Theory/1_2_3_Modules_and_Ports.md`  
  `1_docs/1_2_Theory/1_2_4_Combinational_vs_Sequential.md`

