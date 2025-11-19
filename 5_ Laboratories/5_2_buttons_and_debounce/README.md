# Lab 5.2 – buttons_and_debounce

**Nivel:** Básico  
**Board:** Tang Nano 9K (configuración `tang_nano_9k_lcd_480_272_tm1638_hackathon`)  
**Archivo principal:** `hackathon_top.sv`

---

## 1. Objetivo

Controlar uno o varios LEDs a partir de botones, usando **lógica combinacional pura**:

- Asignaciones continuas (`assign`).
- Operadores lógicos sobre 1 bit: `~`, `&`.
- Mapeo directo de señales internas a salidas físicas.

Al final del lab deberías:

- Entender la diferencia entre `assign` (combinacional continuo) y `always_ff`.
- Poder mapear rápidamente botones a LEDs con distintas relaciones lógicas.
- Ver físicamente en la placa qué hace cada operación booleana.

---

## 2. Mapeo de señales

Sugerencia de mapeo (puedes ajustarla a tu wrapper):

- Entradas:
  - `btn = key[0]` → botón principal.
  - `en  = key[1]` → botón de habilitación (enable).

- Salidas:
  - `led[0]` → sigue directamente el botón (`btn`).
  - `led[1]` → encendido cuando el botón está SUELTO (`~btn`).
  - `led[2]` → encendido solo cuando `btn` y `en` son 1 (`btn & en`).
  - `led[7:3]` → apagados (`0`).

---

## 3. Pasos sugeridos

### Paso 1 – Abrir la plantilla

1. Ve a `5_Labs/5_2_comb_button_led/`.
2. Ubicar:
   - La sección donde se apagan `abcdefgh`, `digit`, `red`, `green`, `blue`.
   - El mapeo de `btn` y `en` desde `key`.
   - Las líneas `assign` marcadas como `TODO`.

### Paso 2 – Completar las asignaciones

En la plantilla verás:

```sv
assign led[7:3] = 5'b00000;

// assign led[0] = ...;
// assign led[1] = ...;
// assign led[2] = ...;
```