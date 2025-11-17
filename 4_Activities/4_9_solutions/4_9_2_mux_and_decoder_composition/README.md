# 4_9_2 – Mux 4→1 + Decoder 2→4 (composición)

Actividad basada en `4_02_mux_and_decoder_composition`, pero ubicada en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Practicar la **composición de bloques combinacionales** construyendo un:

- **Decoder 2→4 one-hot** a partir de 2 bits de selección.
- **Multiplexor 4→1** usando:
  - Salidas del decoder (one-hot)
  - Compuertas AND
  - Una OR final.

Además, visualizar el comportamiento en los LEDs de la placa.

---

## Mapeo de señales

### Entradas desde `key`

- `sel[1:0] = key[1:0]`  
  Bits de selección del canal del mux.

- `data[3:0] = key[5:2]`  
  Datos de entrada al mux (cada bit es un "canal").

### Salidas hacia `led`

- `led[3:0] = dec_out[3:0]`  
  Muestran la salida del **decoder 2→4** (código one-hot).

- `led[4] = mux_y`  
  Muestra la salida del **mux 4→1**.

- `led[7:5]`  
  No se usan en esta solución (libres para extensiones o debug).

---

## Diseño lógico

### 1. Decoder 2→4 one-hot

A partir de `sel[1:0]` se genera `dec_out[3:0]`:

- `sel = 2'b00 → dec_out = 4'b0001`
- `sel = 2'b01 → dec_out = 4'b0010`
- `sel = 2'b10 → dec_out = 4'b0100`
- `sel = 2'b11 → dec_out = 4'b1000`

Esto se implementa con un `always_comb` y un `case(sel)`.

### 2. Composición decoder + AND + OR (mux 4→1)

Se construye el mux 4→1 así:

- `and_terms[i] = dec_out[i] & data[i]` para `i = 0..3`
- `mux_y = |and_terms;`  
  (OR de todos los términos AND)

De esta forma, solo **un** canal `data[i]` pasa a la salida, según qué bit de `dec_out` está en 1.

---

## Cómo probar en la placa

1. Cargar el bitstream generado por esta actividad a la `Tang Nano 9K`.
2. Usar los switches / teclas como sigue:
   - Cambia `sel` con `key[1:0]` para elegir el canal (0–3).
   - Cambia los valores de `data[3:0]` con `key[5:2]`.

3. Observa los LEDs:
   - `led[3:0]`: indican qué **canal está activo** según `sel` (one-hot).
   - `led[4]`: muestra el bit seleccionado del vector `data`.

Ejemplo rápido:

- Si `data = 4'b1010` y `sel = 2'b10`:
  - `dec_out = 4'b0100`
  - Se selecciona `data[2]` → `mux_y = data[2] = 1`
  - `led[2] = 1` (decoder) y `led[4] = 1` (salida del mux).

---

## Ideas de extensiones

- Agregar una entrada de **enable** para el mux y apagar la salida cuando `EN = 0`.
- Mostrar también `sel` y `data` en otros LEDs para debug visual.
- Reescribir el mux 4→1 usando un `case(sel)` y comparar con la versión **decoder + AND + OR**.
