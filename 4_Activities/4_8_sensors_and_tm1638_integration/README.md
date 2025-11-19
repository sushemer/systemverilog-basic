# 4.8 – Integración de sensores y TM1638

En esta actividad se integran **sensores físicos** con el módulo **TM1638**:

- Se lee al menos un sensor (ultrasonido HC-SR04 y/o encoder rotatorio KY-040).
- Se muestra el valor en el **display de 7 segmentos** (TM1638).
- Se representa el valor como una **barra** usando los **8 LEDs** del TM1638.
- Se usan **teclas** para cambiar de modo, sensor o escala.

La intención es juntar varias piezas ya vistas en los ejemplos: sensores, drivers y lógica combinacional/secuencial sencilla.

---

## Objetivo

Al terminar la actividad la persona usuaria debería poder:

- Instanciar uno o más módulos de sensor (ultrasonido, encoder).
- Seleccionar qué valor mostrar usando teclas (`key`).
- Actualizar el display de 7 segmentos con un número de hasta 16 bits.
- Dibujar una barra de nivel en los LEDs en función del valor leído.
- Diseñar distintos modos de operación (por ejemplo: “distancia”, “encoder”, “mixto”).

---

## Hardware asumido

- **Placa:** Tang Nano 9K con configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`.
- **TM1638** conectado (8 dígitos de 7 segmentos + 8 LEDs + teclas).
- **GPIO [3:0]** conectados a los sensores:
  - `gpio[0]` → TRIG del HC-SR04.
  - `gpio[1]` → ECHO del HC-SR04.
  - `gpio[3]` → A (CLK) del KY-040.
  - `gpio[2]` → B (DT) del KY-040.

Si no se cuenta con ambos sensores, la actividad puede realizarse solo con uno y adaptar la lógica de selección.

---

## Archivos / módulos necesarios

Es importante verificar que los siguientes módulos se encuentren incluidos en el proyecto (Tcl / script de síntesis):

- `ultrasonic_distance_sensor.sv`  
  (módulo para HC-SR04, ya utilizado en el ejemplo de ultrasonido).
- `rotary_encoder.sv`
- `sync_and_debounce.sv`
- `sync_and_debounce_one.sv`
- `seven_segment_display.sv`
- `hackathon_top.sv` (archivo principal de la actividad).

Regla general: si un módulo se instancia dentro de `hackathon_top.sv`, su archivo `.sv` debe estar agregado al proyecto.

---

## Qué hace la plantilla de `hackathon_top.sv`

La plantilla típica de esta actividad incluye, al menos, los bloques siguientes.

### 1) Ultrasonido HC-SR04

Se instancia el módulo `ultrasonic_distance_sensor` con:

- Entradas:
  - `clk` y `rst` conectados al reloj y reset del sistema.
  - `trig` y `echo` conectados a `gpio[0]` y `gpio[1]` (según el mapeo acordado).
- Salida principal:
  - `relative_distance` conectada a una señal de 16 bits, por ejemplo  
    `distance_rel` de tipo `logic [15:0]`.

La salida `distance_rel` no está en centímetros reales, sino en una unidad **relativa al tiempo de eco**, pero aumenta con la distancia, lo cual resulta suficiente para la visualización en esta actividad.

---

### 2) Encoder rotatorio KY-040

Se toman las señales crudas del encoder:

- `enc_a_raw = gpio[3]`
- `enc_b_raw = gpio[2]`

Luego se usa `sync_and_debounce` para **sincronizar y eliminar rebotes**:

- Entradas del módulo: `sw_in = {enc_b_raw, enc_a_raw}`.
- Salidas: señales depuradas `enc_a_deb` y `enc_b_deb`.

Después se instancia `rotary_encoder`:

- Entradas: `clk`, `reset`, `a = enc_a_deb`, `b = enc_b_deb`.
- Salida: `value` conectada a una señal de 16 bits, por ejemplo  
  `encoder_value` de tipo `logic [15:0]`.

Esta salida representa el conteo del encoder (positivo/negativo según la implementación) y permite observar giros y dirección.

---

### 3) Selección del valor a mostrar

Se define un **modo de operación** a partir de algunas teclas, por ejemplo:

- `mode = key[1:0]` (2 bits para cuatro modos posibles).

Se declara una señal intermedia:

- `sensor_value` de tipo `logic [15:0]`.

En un bloque combinacional (`always_comb`) se selecciona el valor según el modo:

- Si `mode = 2'b00` → `sensor_value = distance_rel` (solo ultrasonido).
- Si `mode = 2'b01` → `sensor_value = encoder_value` (solo encoder).
- Si `mode = 2'b10` → `sensor_value = distance_rel - encoder_value` (modo “mixto” o de prueba).
- En cualquier otro caso (`2'b11` u otros) → `sensor_value = 16'd0` (reservado o modo de depuración).

La señal `sensor_value` se utiliza como base para:

- El número que se mostrará en el display de 7 segmentos.
- La barra de nivel representada en los 8 LEDs.

---

### 4) Mostrar el valor en el TM1638 (7 segmentos)

Se reutiliza el módulo `seven_segment_display` ya usado en otras actividades.

Parámetros típicos:

- `W_DIGITS = 8`
- `W_NUM    = W_DIGITS * 4 = 32`

Se declara un bus de 32 bits para el número y 8 bits para los puntos:

- `number` de tipo `logic [31:0]`.
- `dots` de tipo `logic [7:0]`.

Forma habitual de empaquetar el valor del sensor:

- `number = {16'd0, sensor_value}`  
  (los 4 dígitos menos significativos muestran `sensor_value` en hexadecimal).
- `dots   = 8'b0000_0000`  
  (puntos decimales apagados, o configurados según el modo).

Después se conectan `number` y `dots` a la instancia de `seven_segment_display`, cuyas salidas `abcdefgh` y `digit` se dirigen al TM1638.

De esta forma, el valor del sensor aparece en hexadecimal en los dígitos del TM1638; se puede limitar la interpretación visual a los 4 dígitos menos significativos si así se desea.

---

### 5) Barra de nivel en los LEDs del TM1638

Los 8 LEDs del TM1638 se usan como una **barra de nivel** (similar a un “VU meter”).

#### 5.1 Normalizar el valor

Se puede extraer una parte de `sensor_value` como nivel:

- `bar_level` de tipo `logic [7:0]`.
- Por ejemplo: `bar_level = sensor_value[15:8]`.

Si `sensor_value` recorre un rango amplio, también se puede saturar `bar_level` o aplicar un pequeño reescalado, para que la barra recorra razonablemente los 8 LEDs.

#### 5.2 Construir la barra

Opciones comunes:

- **Barra acumulativa** (llenado de izquierda a derecha):

  - Se inicializa una señal `led_bar = 8'b0000_0000`.
  - Si `bar_level > 0`, se enciende el bit 0 (`led_bar[0] = 1`).
  - Si `bar_level > 1`, se enciende `led_bar[1]`, y así hasta el bit 7.

- **Barra directa por bits**:

  - `led_bar = bar_level`.
  - Cada bit de `bar_level` controla directamente uno de los LEDs.

#### 5.3 Asignar a la salida

La señal `led_bar` se conecta a los LEDs del TM1638.  
Si la plantilla también expone los LEDs de la propia Tang Nano 9K, se puede:

- Usar los LEDs del TM1638 como **barra principal**.
- Usar los LEDs de la placa como **debug** del valor crudo (por ejemplo, `sensor_value[15:8]`).

---

### 6) Organización típica del bloque de salida

Una organización clara del bloque de salida (`always_comb`) suele seguir estos pasos:

1. Inicializar valores por defecto:
   - `number   = 32'h0000_0000`
   - `dots     = 8'b0000_0000`
   - `led_bar  = 8'b0000_0000`

2. Usar `case (mode)` para ajustar el comportamiento según el modo:

   - Modo `2'b00` (ultrasonido):
     - `number   = {16'd0, distance_rel}`
     - `led_bar  = función_bar(distance_rel)`

   - Modo `2'b01` (encoder):
     - `number   = {16'd0, encoder_value}`
     - `led_bar  = función_bar(encoder_value)`

   - Modo `2'b10` (combinado / experimento):
     - `number   = {16'd0, sensor_value}`
     - `led_bar  = función_bar(sensor_value)`

   - Otros casos (`2'b11`, etc.):
     - `number   = 32'h0000_0000`
     - `led_bar  = 8'b0000_0000`

   (Aquí “función_bar” representa la lógica que traduce cualquier valor de 16 bits en un patrón de 8 LEDs, según lo descrito en la sección anterior).

Adicionalmente, los LEDs de la placa pueden servir como ayuda visual, por ejemplo:

- `led[1:0]  = mode`  (modo actual).
- `led[7:2]  = sensor_value[7:2]` o alguna otra parte del valor o de un contador de depuración.

---

## Pruebas sugeridas

### 1) Modo ultrasonido

- Colocar la mano u objetos a diferentes distancias frente al HC-SR04.
- Verificar cómo:
  - Cambia el número que se muestra en el TM1638.
  - Cambia la barra de LEDs (por ejemplo: valor bajo con objeto cercano, valor alto con objeto lejano, según el diseño elegido).

### 2) Modo encoder

- Girar el encoder lentamente en ambos sentidos.
- Comprobar:
  - Incrementos y decrementos del valor mostrado en el display.
  - Desplazamiento de la barra de LEDs hacia la derecha o hacia la izquierda.

### 3) Cambios de modo con teclas

- Cambiar `mode` con `key[1:0]`.
- Confirmar que el sistema cambia de comportamiento sin comportamientos extraños.
- Probar combinaciones de teclas adicionales para:
  - Invertir la barra.
  - Cambiar de escala.
  - Activar o desactivar modos de depuración.

### 4) Pruebas de límites

- Forzar valores muy altos o muy bajos en `sensor_value`:
  - Alejando mucho el objeto del sensor ultrasónico.
  - Girando el encoder muchas vueltas.
- Verificar que:
  - La barra de LEDs no se desborda (no aparecen patrones inesperados).
  - El número mostrado se mantiene coherente (sin valores claramente erróneos por overflow, salvo que forme parte del experimento).

---

## Extensiones opcionales

Algunas ideas para extender la actividad:

- **Escala ajustable**  
  Usar bits adicionales de `key` para cambiar la escala de la barra (por ejemplo, ganancias ×1, ×2, ×4).

- **Indicadores con puntos decimales**  
  Usar `dots` del TM1638 para indicar:
  - El modo actual.
  - Estados de error o fuera de rango.
  - Un “latido” visual (punto que parpadea) mientras el sistema está activo.

- **Umbral de alarma**  
  Encender el último LED de la barra solo si el valor supera un umbral determinado y, opcionalmente, mostrar también alguna indicación especial en el display (por ejemplo, un patrón fijo en los dígitos superiores).

- **Promediado / filtrado**  
  Implementar un filtro sencillo (por ejemplo, un promedio móvil) del valor del sensor antes de mostrarlo, para estabilizar la lectura y reducir ruido.

Con esta actividad se consolida el uso de sensores, módulos de soporte (debounce, encoder, ultrasonido) y el TM1638 como interfaz de visualización, acercándose a una aplicación de medición y monitoreo más completa sobre la FPGA.
