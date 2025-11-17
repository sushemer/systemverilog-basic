<!-- File: 4_Activities/4_02_mux_and_decoder_composition/README.md -->

# 4.2 – Composición: decoder 2→4 + mux 4→1

En esta actividad vas a **componer bloques combinacionales**:

- Un **decoder 2→4** que genera una salida one-hot.
- Un **multiplexor 4→1** construido a partir de ese decoder y compuertas `AND`/`OR`.

La idea es ver cómo, a partir de bloques sencillos, se pueden construir funciones más complejas.

Se usa la placa **Tang Nano 9K** con la configuración  
`tang_nano_9k_lcd_480_272_tm1638_hackathon` y el módulo tope `hackathon_top`.

---

## Objetivos

1. Implementar un **decoder 2→4** con salidas one-hot usando `case` y `always_comb`.
2. Construir un **mux 4→1** usando:
   - salidas del decoder 2→4,
   - compuertas `AND`,
   - y una `OR` final.
3. Visualizar tanto el decoder como la salida del mux en los LEDs de la placa.

---

## Mapeo de señales (sugerido)

Entradas desde los botones `key`:

- Selectores (para decoder y mux):
  - `sel[1:0] = key[1:0]`
- Datos del mux (4 canales de 1 bit):
  - `data[3:0] = key[5:2]`

Salidas a LEDs:

- `led[3:0]` → salidas del decoder (`dec_out[3:0]`), formato one-hot.
- `led[4]`   → salida del mux 4→1 (`mux_y`).
- `led[7:5]` → libres para extensiones o depuración.

El display de 7 segmentos y la LCD no se usan en esta actividad.

---

## Descripción de la actividad

### 1. Implementar el decoder 2→4 (one-hot)

En el archivo `hackathon_top.sv` encontrarás una plantilla con:

```systemverilog
logic [1:0] sel;
logic [3:0] dec_out;

always_comb
begin
    dec_out = 4'b0000;

    // TODO: implementar el decoder
end
