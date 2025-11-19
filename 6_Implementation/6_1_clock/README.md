# 6.1 – Clock (digital 12/24 h)

## Objetivo

Implementar un **reloj digital** que:

1. Genere una base de tiempo de **1 segundo** a partir del clock de la FPGA (≈27 MHz).
2. Lleve contadores de:
   - segundos (0–59),
   - minutos (0–59),
   - horas (modo 24 h y/o 12 h).
3. Permita **ajustar los minutos** con pasos:
   - ±1 minuto,
   - ±5 minutos,
   - ±10 minutos.
   usando botones (o encoder) con **debounce y edge detection**.
4. Muestre la hora en un **display de 7 segmentos** o en el **TM1638**, sin parpadeos visibles.
5. Mantenga los **rollovers correctos**:
   - 59 → 00 en segundos/minutos.
   - 23 → 00 (modo 24 h).
   - Lógica adecuada en modo 12 h (si se implementa AM/PM).

---

## Hardware sugerido

- **FPGA:** Tang Nano 9K.
- **Display:**
  - 4 dígitos de 7 segmentos **o**
  - módulo TM1638 (recomendado por integración existente).
- **Entradas:**
  - 3–4 botones (por ejemplo):
    - `BTN_MODE` → cambiar entre 12/24 h u otros modos.
    - `BTN_UP`   → incrementar minutos.
    - `BTN_DOWN` → decrementar minutos.
    - `BTN_STEP` → seleccionar paso (±1 / ±5 / ±10).
  - **o** un encoder rotatorio (valor de minutos) + botón de click.
- Protoboard / jumpers según conexión.

---

## Conceptos que integra

- Divisor de frecuencia (clock divider) estable.
- Contadores con rollover (segundos, minutos, horas).
- Máquina de estados simple para modos (12/24 h y ajuste).
- Debounce y detección de flanco para botones.
- Multiplexado / manejo de display 7 segmentos o TM1638.
- Diseño sin glitches visibles en la salida.

---

## Comportamiento propuesto

### 1. Base de tiempo (1 Hz)

- Partir del clock de la FPGA (~27 MHz).
- Implementar un contador grande que genere un pulso `tick_1s`.
- Usar `tick_1s` para incrementar el contador de segundos.

### 2. Contadores de tiempo

- `sec` : 0–59  
- `min` : 0–59  
- `hour`:  
  - 0–23 en modo 24 h,  
  - 1–12 en modo 12 h (AM/PM).

Rollover encadenado:

- `sec == 59` y llega `tick_1s` → `sec = 0`, `min++`.
- `min == 59` y incrementa → `min = 0`, `hour++`.
- `hour == 23` y incrementa (modo 24 h) → `hour = 0`.

### 3. Ajuste de minutos

- Botones con debounce y edge detection.
- Lógica propuesta:
  - `BTN_STEP` selecciona el paso (1, 5, 10).
  - `BTN_UP` incrementa minutos según el paso.
  - `BTN_DOWN` decrementa minutos según el paso (opcional).
- Asegurar que el ajuste también respete los rollovers:
  - Ej. 58 + 5 → 03 (y hour++).
  - 02 − 5 → 57 (y hour--).

### 4. Modos 12 / 24 h

- `BTN_MODE` conmute el modo de visualización:
  - Internamente puedes llevar siempre 0–23.
  - En modo 12 h, transformar para el display:
    - 0 → 12 (AM),
    - 13 → 1 PM,
    - etc.

### 5. Visualización en display

- Para **4 dígitos**:
  - HH:MM (sin segundos).
  - Mostrar `hour` y `min` con dos dígitos cada uno.

---

