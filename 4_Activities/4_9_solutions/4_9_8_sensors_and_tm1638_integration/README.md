# 4_9_8 – Integración de sensores + TM1638

Actividad basada en `4_8_sensors_and_tm1638_integration`, ubicada en `4_9_solutions/4_9_8_sensors_and_tm1638_integration`.

## Objetivo

Integrar **sensores físicos** con la tarjeta **TM1638**:

- Leer **HC-SR04** (ultrasonido) y **KY-040** (encoder rotatorio).
- Mostrar un valor numérico en el **display de 7 segmentos**.
- Visualizar una **barra (bar graph)** en los **8 LEDs** del TM1638.
- Cambiar el modo de visualización con las teclas (`key[1:0]`).

---

## Conexiones de sensores (GPIO)

Se asume el siguiente mapeo en `gpio`:

- **HC-SR04 (ultrasonido)**
  - `gpio[0]` → `TRIG` (salida desde la FPGA hacia el sensor).
  - `gpio[1]` → `ECHO` (entrada desde el sensor hacia la FPGA).

- **KY-040 (encoder rotatorio)**
  - `gpio[3]` → canal A (`CLK`).
  - `gpio[2]` → canal B (`DT`).

Los módulos utilizados:

- `ultrasonic_distance_sensor`: entrega un valor relativo de distancia (`distance_rel : [15:0]`).
- `sync_and_debounce`: sincroniza y limpia rebotes de las señales del encoder.
- `rotary_encoder`: entrega un contador (`encoder_value : [15:0]`).

---

## Modos de operación (key[1:0])

Se usa `key[1:0]` como selector de modo:

```sv
mode = key[1:0];
```