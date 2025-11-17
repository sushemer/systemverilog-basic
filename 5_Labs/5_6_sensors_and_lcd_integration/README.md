# Lab 5.6 – Sensors + LCD integration

## Objetivo

Integrar **sensores físicos** con la **pantalla LCD 480×272** de la Tang Nano 9K para crear un pequeño “panel de nivel”:

- Leer:
  - Distancia relativa de un **HC-SR04**.
  - Conteo de un **encoder rotatorio KY-040**.
- Seleccionar el origen del dato con `key[1:0]`.
- Visualizar el valor:
  - Como una **barra vertical (gauge)** en el LCD.
  - Como un patrón en `led[7:0]` (byte alto del valor).

Al final del lab deberías:

- Sentirte cómodo instanciando y conectando módulos de sensores.
- Entender cómo escalar un valor de 16 bits a una altura de píxeles.
- Usar `(x, y)` para dibujar gráficos simples dependientes de sensores.

---

## Prerrequisitos

- Haber realizado o revisado:

  - **Lab 5.1 – blink_hello_world** (divisor de reloj).
  - **Lab 5.3 – shift_register_patterns** (patrones en LEDs).
  - Actividades con **LCD básico** (ej. `4_7_lcd_hello_and_basic_graphics`).
  - Actividad de sensores + TM1638 (`4_8_sensors_and_tm1638_integration`).

- Entender a nivel básico:

  - Cómo el controlador de LCD genera `x` y `y`.
  - Qué hace `ultrasonic_distance_sensor` y `rotary_encoder`.

---

## Hardware usado

- Tang Nano 9K con módulo **LCD 480×272**.
- Módulos/sensores:
  - **HC-SR04** (ultrasonido).
  - **KY-040** (encoder rotatorio).

### Mapeo sugerido (gpio)

- `gpio[0]` → TRIG (HC-SR04).
- `gpio[1]` → ECHO (HC-SR04).
- `gpio[3]` → A (encoder).
- `gpio[2]` → B (encoder).

Revisa esquemáticos/pines de tu placa para confirmar.

---

## Señales y modos

- `mode = key[1:0]`:

  - `00` → usar `distance_rel` (ultrasonido).
  - `01` → usar `encoder_value`.
  - `10` → usar `distance_rel - encoder_value` (solo para probar).
  - `11` → `sensor_value = 0`.

- `sensor_value[15:0]`:

  - Bus común que alimenta el gauge y los LEDs.

- `led[7:0]`:

  - `led = sensor_value[15:8]` (byte alto del valor del sensor).

- `bar_height` (0..271):

  - Versión escalada de `sensor_value` para mapear a la altura de la pantalla.
  - Se toma `sensor_value[15:7]` y se recorta a `0..SCREEN_H-1`.

---

## Lógica de dibujo en el LCD

1. **Marco**  
   Se dibuja un borde blanco de 2 píxeles alrededor de toda la pantalla.

2. **Fondo**  
   Dentro del marco, un fondo con un **degradado suave** (ligeramente dependiente de `y`).

3. **Barra vertical (gauge)**

   - Región de X:

     - `BAR_X0 = 400`, `BAR_X1 = 440`.

   - Altura:

     - Desde la parte inferior (`y ≈ 271`) hacia arriba, según `bar_height`.

   - Colores:

     - Si `bar_height < THRESH_LOW`  → **verde** (nivel bajo).
     - Si `bar_height < THRESH_HIGH` → **amarillo** (nivel medio).
     - Si no                        → **rojo** (nivel alto).

---

## Procedimiento sugerido

1. **Revisa las instancias de sensores**

   - Ubica `ultrasonic_distance_sensor` y `rotary_encoder` en el código.
   - Confirma que el repo tiene sus archivos y que están incluidos en el proyecto.

2. **Entiende `sensor_value`**

   - Mira el `case (mode)` que asigna `sensor_value`.
   - Prueba mentalmente algunos casos:
     - Solo ultrasónico.
     - Solo encoder.
     - Combinación (resta).

3. **Analiza el escalado a `bar_height`**

   - Observa cómo se toman los bits altos `sensor_value[15:7]`.
   - Entiende por qué se recorta a `SCREEN_H-1`.
   - Piensa: “si el sensor crece, la barra puede crecer hasta llenar la pantalla”.

4. **Revisa la lógica de dibujo**

   - Sigue el `always_comb` de RGB:
     - Marco → fondo → barra.
   - Identifica la condición de la barra:

     ```verilog
     if ((x >= BAR_X0) && (x < BAR_X1))
       if (y >= SCREEN_H_9B - bar_height)
         // colorear según nivel
     ```

5. **Sintetiza y prueba en hardware**

   - Compila y programa la FPGA.
   - Selecciona modo:

     - `mode = 00` → mueve un objeto delante del HC-SR04.
     - `mode = 01` → gira el encoder en CW/CCW.
     - `mode = 10` → experimenta con la combinación.

   - Observa:
     - Cambios en el **tamaño** y **color** de la barra.
     - Patrón en `led[7:0]`.

---

## Checklist de pruebas

- [ ] El diseño sintetiza sin errores y programa la Tang Nano 9K.
- [ ] Con `mode = 00`, mover un objeto frente al HC-SR04 cambia la barra.
- [ ] Con `mode = 01`, girar el encoder modifica la barra de forma estable.
- [ ] El color de la barra cambia (verde → amarillo → rojo) al variar el nivel.
- [ ] `led[7:0]` cambia consistentemente con el nivel del sensor.
- [ ] La pantalla muestra un marco blanco y un fondo uniforme cuando el sensor está “quieto”.

---

## Extensiones opcionales

Si quieres llevarlo más lejos:

- Mostrar el valor del sensor también en el **TM1638** (reutilizando `seven_segment_display`).
- Dibujar **dos barras**: una para ultrasónico y otra para encoder.
- Añadir una pequeña “zona segura” en verde y zonas de alerta en rojo en la pantalla.
- Usar `slow_clock` para hacer parpadeos cuando el valor supere cierto umbral.

Este lab es básicamente tu primer “instrument panel” simple: sensores reales + gráficos en pantalla. A partir de aquí ya puedes imaginar velocímetros, barras de volumen, indicadores de proximidad, etc. 