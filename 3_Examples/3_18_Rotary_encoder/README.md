# 3.18 Rotary encoder (KY-040) + TM1638 + LCD helper

Este ejemplo integra tres elementos al mismo tiempo:

- Un **encoder rotatorio KY-040** conectado a `gpio[3:2]`.
- El módulo **TM1638** como display de 7 segmentos para mostrar el valor.
- La **pantalla LCD 480×272** como ayuda visual para entender el valor del encoder.

Configuración de placa:

> `tang_nano_9k_lcd_480_272_tm1638_hackathon`

El encoder se usa como un **control giratorio** que modifica un valor entero; dicho valor se muestra:

- En el display de 7 segmentos (TM1638).
- En los LEDs (como debug de los 8 bits menos significativos).
- En la LCD, como un “umbral” vertical: si `x > value`, se pinta azul.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender cómo conectar y leer un **encoder rotatorio KY-040** desde la FPGA.
- Ver la importancia de:
  - **Sincronizar** señales externas al reloj de la FPGA.
  - Aplicar **debouncing** a entradas mecánicas.
- Interpretar el valor del encoder:
  - Numéricamente en el display TM1638.
  - Como patrón binario en LEDs.
  - Como umbral gráfico en la pantalla LCD.
- Tener una base para proyectos donde el encoder controle parámetros (velocidades, posiciones, menús, etc.).

---

## Hardware y conexiones

### Encoder KY-040

Pines relevantes del módulo KY-040:

- `CLK` → Fase A del encoder.
- `DT`  → Fase B del encoder.
- (Opcional) `SW` → Pulsador integrado (no usado en este ejemplo).
- `VCC`, `GND` → Alimentación (según la tarjeta/módulo).

En este ejemplo:

- `gpio[3]` ← `CLK` (A).
- `gpio[2]` ← `DT`  (B).

Nota: La alimentación y masa del encoder deben compartir **GND común** con la Tang Nano 9K.

---

## Señales principales del módulo

En `hackathon_top.sv`:

- Entradas básicas de la placa:

  - `clock`  
    Reloj principal (≈ 27 MHz).

  - `slow_clock`  
    No se utiliza en este ejemplo (reservado para otros ejercicios).

  - `reset`  
    Reset asíncrono activo en alto.

  - `key[7:0]`  
    Reservado para futuras extensiones; no se utiliza aquí.

- TM1638:

  - `abcdefgh[7:0]`  
    Bits de segmentos para el display de 7 segmentos integrado en el TM1638.

  - `digit[7:0]`  
    Máscara one-hot para seleccionar cada dígito (controlado por `seven_segment_display`).

- LCD:

  - `x[8:0]`, `y[8:0]`  
    Coordenadas del píxel actual (0…479, 0…271).

  - `red[4:0]`, `green[5:0]`, `blue[4:0]`  
    Color del píxel actual.

- GPIO:

  - `gpio[3:0]`  
    Se usan únicamente `gpio[3:2]` para el encoder (CLK, DT).  
    El resto permanece libre.

- LEDs:

  - `led[7:0]`  
    Se usan como debug del valor decodificado (`value[7:0]`).

---

## Estructura interna del diseño

### 1. Sincronización y debouncing de las fases del encoder

Las señales del encoder llegan desde el mundo físico y no están alineadas al reloj de la FPGA.  
Por ello, se usa un módulo auxiliar `sync_and_debounce`:

- Sincroniza las entradas al reloj `clock` para evitar metastabilidad.
- Aplica un filtrado básico (debouncing) para reducir rebotes mecánicos.

Conexión lógica (descrito en texto):

- Entradas: `sw_in = gpio[3:2]`.
- Salidas: `sw_out = {b, a}`.

Después de este bloque, `a` y `b` son versiones más estables de las fases del encoder.

---

### 2. Decodificación del encoder rotatorio

Se usa el módulo `rotary_encoder`:

- Entradas:
  - `clk`, `reset`.
  - Señales de fase `a` y `b` ya sincronizadas y filtradas.
- Salida:
  - `value[15:0]` → valor entero que representa la posición relativa del encoder.

Este módulo:

- Interpreta los cambios de fase A/B para detectar:
  - Sentido horario (incremento).
  - Sentido antihorario (decremento).
- Acumula el resultado en un registro `value` de 16 bits.

Según su implementación concreta:

- El valor puede saturar en un rango fijo, o
- Hacer wrap-around (al pasar del máximo vuelve al mínimo).

---

### 3. Visualización del valor en TM1638

Para mostrar `value` en el display de 7 segmentos, se utiliza el módulo `seven_segment_display`:

- Parámetro:
  - `w_digit = 8` → se usan los 8 dígitos del TM1638.
- Señales:
  - `number` recibe `value` extendido a 32 bits (`32'(value)`).
  - `dots = '0` → no se enciende ningún punto decimal.
  - Salidas:
    - `abcdefgh` → segmentos.
    - `digit`    → máscara de dígitos (multiplexado).

Este módulo encapsula:

- La lógica de multiplexado entre dígitos.
- La decodificación de número → patrones de 7 segmentos.

---

### 4. LEDs como debug

Los LEDs muestran los 8 bits menos significativos de `value`:

- `led = value[7:0];`

Esto permite:

- Ver, en binario, cómo cambia el valor con cada giro del encoder.
- Depurar posibles problemas de lectura incluso sin mirar el display de 7 segmentos.

---

### 5. Ayuda visual en la LCD

La pantalla LCD se utiliza como una representación gráfica del valor del encoder.

Lógica conceptual de color:

1. Por defecto:
   - Fondo negro:
     - `red = 0`
     - `green = 0`
     - `blue = 0`

2. Para cada píxel con coordenadas `(x, y)`:
   - Si `x > value[8:0]`:
     - `blue = x[4:0]` (intensidad de azul proporcional a `x`).
   - En caso contrario, el píxel permanece negro.

Interpretación:

- El valor del encoder (`value`) define una **columna umbral** vertical.
- Para columnas a la derecha de ese umbral (`x > value`):
  - La pantalla se pinta en tonos de azul.
- Para columnas a la izquierda:
  - La pantalla queda negra.

A medida que se gira el encoder:

- El umbral se desplaza a izquierda o derecha.
- La frontera entre negro y azul se mueve, mostrando de forma intuitiva el valor.

La expresión `value[8:0]` recorta el valor a 9 bits para ajustarlo al rango horizontal (0…479).

---

## Flujo completo de datos

1. Encoder físico KY-040  
   → genera señales A/B (CLK, DT).

2. GPIO de la FPGA  
   → `gpio[3:2]` capturan esas señales.

3. `sync_and_debounce`  
   → sincroniza y filtra, produciendo `a` y `b`.

4. `rotary_encoder`  
   → decodifica el movimiento y actualiza `value[15:0]`.

5. Visualización:

   - **TM1638 (7 segmentos)**  
     `value` → `seven_segment_display` → `abcdefgh`, `digit`.

   - **LEDs**  
     `value[7:0]` → `led`.

   - **LCD**  
     `value[8:0]` se compara con `x` → decisión de color (fondo negro + zona azul).

---

## Comportamiento esperado

Tras sintetizar y cargar el bitstream de este ejemplo:

- Girar el encoder en un sentido:

  - Incrementa `value`.
  - La zona azul en la LCD se desplaza en una dirección.
  - El número mostrado en el TM1638 aumenta.
  - El patrón de LEDs cambia (representando el nuevo valor en binario).

- Girar el encoder en el sentido opuesto:

  - Decrementa `value`.
  - La zona azul se desplaza en la dirección contraria.
  - El número en el TM1638 disminuye.
  - El patrón de LEDs se actualiza.

Si `value` está implementado con wrap-around:

- Al sobrepasar el máximo vuelve a cero (y, a la inversa, del mínimo salta al máximo).

---

## Ideas de extensión (ejercicios)

1. **Ejercicio 1 – Control de rango**

   - Limitar `value` a un rango concreto (por ejemplo, 0–100).
   - Escalar ese rango para cubrir toda la pantalla:
     - 0–100 → 0–479.
   - Mostrar el valor en TM1638 en decimal en lugar de hexadecimal.

2. **Ejercicio 2 – Dos encoders para X e Y**

   - Conectar un segundo encoder a otros pines `gpio`.
   - Añadir otro bloque `sync_and_debounce` y otro `rotary_encoder`.
   - Usar uno para controlar la posición horizontal (X) y otro la vertical (Y).
   - Dibujar en la LCD un punto o rectángulo que se mueva en dos dimensiones.

3. **Ejercicio 3 – Menú interactivo**

   - Usar el encoder como selector de opciones de un menú.
   - Mostrar la opción seleccionada en el TM1638 y/o la LCD.
   - Usar el pulsador del encoder (`SW`) como “enter” o confirmación (requiere cableado adicional).

---

## Archivos relacionados

Dentro de `3_examples/3_18_rotary_encoder_tm1638_lcd_helper/`:
- `peripherals/rotary_encoder.sv`
- `labs/common/sync_and_debounce.sv`
- `labs/common/seven_segment_display.sv`

Ver también:

- `1_2_7_Finite_State_Machines.md`  
  Para extender la lógica a menús o FSM de control.

- `1_2_9_Buses_Overview.md`  
  Si se combinan encoders con otros periféricos comunicados por buses.

- `3_11_seven_segment_basics` y `3_12_seven_segment_hex_counter_multiplexed`  
  Para más contexto en el uso del display de 7 segmentos.
