# 3.18 Rotary encoder (KY-040) + TM1638 + LCD

En este ejemplo usamos un **encoder rotatorio** tipo KY-040 como “perilla digital”:

- El giro del encoder se traduce en un valor entero (`value`).
- Ese valor se muestra:
  - En el **display de 7 segmentos (TM1638)** como número.
  - Como **umbral horizontal** en la LCD (zona azul depende de `value`).
- Además, los **8 LEDs** muestran los 8 bits menos significativos de `value`.

Es un buen puente entre señales **mecánicas ruidosas** (encoder) y su uso en lógica digital y gráficos.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria será capaz de:

- Conectar y usar un **rotary encoder KY-040** con la Tang Nano 9K.
- Entender el uso de un **módulo de sincronización + anti-rebote** (`sync_and_debounce`).
- Entender la lógica básica de un **decodificador de encoder cuadratura** (`rotary_encoder`).
- Visualizar el valor del encoder:
  - Como número en 7 segmentos.
  - Como elemento gráfico (barra / umbral) en la pantalla LCD.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope para la placa `tang_nano_9k_lcd_480_272_tm1638_hackathon`.  
  Conecta el encoder (vía GPIO), usa `sync_and_debounce` y `rotary_encoder`,  
  y muestra el resultado en LEDs, TM1638 y LCD.

Además, se requieren estos módulos auxiliares (reutilizables en otros labs):

- `labs/common/rotary_encoder.sv`  
  Implementa un decoder de cuadratura para el KY-040 y similares.

- `labs/common/sync_and_debounce.sv`  
  Wrapper para aplicar sincronización y anti-rebote a N señales.

- `labs/common/sync_and_debounce_one.sv`  
  Implementación de un canal individual de sincronización + anti-rebote.

Y el módulo ya existente en el repositorio:

- `labs/common/seven_segment_display.sv`  
  Driver genérico para displays de 7 segmentos multiplexados.

---

## Conexiones del rotary encoder (KY-040)

El módulo asume:

- Encendedor KY-040 conectado a GPIO:

  - `gpio[3]` → **CLK / A**  
  - `gpio[2]` → **DT / B**

- Otros pines del encoder:
  - `+` a 3V3.
  - `GND` a tierra común de la placa.

Dentro de `hackathon_top.sv`:

- `sync_and_debounce` limpia y sincroniza las dos señales mecánicas.
- `rotary_encoder` recibe `a`, `b` y produce un `value` de 16 bits.

---

## Comportamiento del diseño

### 1. Módulo `rotary_encoder`

- Observa flancos de subida en `a`.
- En cada flanco, revisa el estado de `b`:
  - Si `b = 1` → incrementa `value`.
  - Si `b = 0` → decrementa `value`.
- Es un esquema clásico de lectura de encoder en cuadratura.

> Nota: El valor inicial se fija en `-1` (comentario en código original).  
> Es un detalle de implementación original que se deja tal cual para mantener compatibilidad.

---

### 2. Módulo `sync_and_debounce`

- Sincroniza la señal mecánica al reloj del sistema.
- Aplica un contador de **anti-rebote**:
  - Solo cambia la salida (`sw_out`) cuando la entrada ha permanecido estable  
    el tiempo suficiente (controlado por `depth`).

En este ejemplo se usa:

```systemverilog
sync_and_debounce #(.w(2)) i_sync_and_debounce (...);
