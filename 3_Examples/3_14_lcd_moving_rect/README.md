# 3.14 LCD – Rectángulo en movimiento

Este ejemplo es la **continuación directa** de `3_13_lcd` (figuras estáticas):

- Ahora el rectángulo **se mueve horizontalmente** sobre la pantalla.
- Se usa un módulo `strobe_gen` para generar un pulso lento (~30 Hz).
- Cada pulso incrementa un contador que desplaza el rectángulo.
- La posición del rectángulo se muestra en:
  - Los **LEDs** (8 bits menos significativos).
  - El **display de 7 segmentos**.

Es el primer paso hacia animaciones y mini-juegos en la LCD.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender cómo usar un **strobe** (pulso lento) para animar gráficos.
- Controlar la posición de una figura en función de un **contador**.
- Relacionar:
  - Lógica secuencial (contador).
  - Lógica combinacional (comparaciones con `x`, `y`).
  - Representación visual en la LCD.

---

## Señales y parámetros relevantes

### Entradas principales

- `clock`  
  Reloj principal de la FPGA (≈ 27 MHz).

- `slow_clock`  
  Reloj lento generado por el wrapper de la placa (no se usa en este ejemplo, pero se deja como puerto por compatibilidad con otros labs).

- `reset`  
  Reset asíncrono activo en alto.

- `key[7:0]`  
  Reservado para ejercicios posteriores (en este ejemplo no se utilizan las teclas).

### Salidas principales

- `led[7:0]`  
  Muestran los 8 bits menos significativos de la posición horizontal del rectángulo (`rect_offset[7:0]`).

- `abcdefgh[7:0]`, `digit[7:0]`  
  Salidas del display de 7 segmentos TM1638:

  - Se usa el módulo `seven_segment_display` para mostrar `rect_offset` como número.
  - `dots` se mantiene en 0 (`8'b0000_0000`) en este ejemplo.

- `red[4:0]`, `green[5:0]`, `blue[4:0]`  
  Color del píxel actual en la LCD:

  - Fondo negro por defecto.
  - Un rectángulo rojo que se mueve horizontalmente.

- `gpio[3:0]`  
  No se utilizan en este ejemplo (se pueden dejar desconectados o en alta impedancia según el wrapper).

### Coordenadas de la LCD

La lógica de video de la placa entrega:

- `x[8:0]` → coordenada horizontal del píxel actual (`0` a `479`).
- `y[8:0]` → coordenada vertical del píxel actual (`0` a `271`).

En este ejemplo se definen parámetros explícitos:

- `SCREEN_WIDTH  = 480`
- `SCREEN_HEIGHT = 272`

para dejar claro el tamaño de la pantalla.

---

## Strobe y contador de posición

Para mover el rectángulo sin hacerlo “demasiado rápido”, el diseño no incrementa la posición en **cada ciclo de reloj**, sino cuando llega un **pulso lento** (`pulse`) generado por `strobe_gen`.

En el código se usa algo equivalente a:

    strobe_gen #(
        .clk_mhz   (27),
        .strobe_hz (30)   // ~30 pulsos por segundo
    ) i_strobe_gen (
        .clk    (clock),
        .rst    (reset),
        .strobe (pulse)
    );

- `clk_mhz = 27` indica que el reloj de entrada es de aproximadamente 27 MHz.
- `strobe_hz = 30` genera un pulso alto (`pulse = 1`) unas 30 veces por segundo.
- Cada pulso se utiliza para avanzar la posición horizontal del rectángulo.

El contador de posición horizontal:

- Se implementa con una señal `rect_offset[8:0]`.
- Se incrementa solo cuando llega `pulse`.
- Cuando alcanza un límite (por ejemplo `SCREEN_WIDTH/2`), se reinicia a 0 para que el rectángulo vuelva al inicio.

Conceptualmente:

1. Si `reset` está activo:
   - `rect_offset` se pone en 0.
2. Si llega un `pulse`:
   - Si `rect_offset` ha llegado al límite, se vuelve a 0.
   - Si no, se incrementa en 1.

Esto crea un movimiento horizontal “serrucho”: avanza hasta cierto punto y luego regresa al inicio.

---

## Visualización de la posición en LEDs y 7 segmentos

La posición calculada (`rect_offset`) se reutiliza para mostrar información de depuración (debug):

- **LEDs**:  

  - `led = rect_offset[7:0];`  
    Permite ver en binario la parte baja del contador de posición.

- **Display de 7 segmentos**:

  - Se instancia `seven_segment_display` con `w_digit = 8` para usar los 8 dígitos del TM1638.
  - La entrada `number` recibe `rect_offset` (se extiende internamente).
  - `dots` se mantiene en `8'b0000_0000`.

Esto hace que la persona usuaria pueda:

- Ver en la LCD dónde está el rectángulo.
- Ver en el TM1638 el valor numérico de la posición.
- Ver en los LEDs la misma posición en binario.

---

## Parámetros del rectángulo en la LCD

El rectángulo rojo se define por:

- Un **ancho** (`RECT_WIDTH`), en píxeles.
- Una **altura** (`RECT_HEIGHT`), en píxeles.
- Una posición base en `x` (`RECT_X_BASE`).
- Una posición base en `y` (`RECT_Y_TOP`).

Luego se calcula la posición **efectiva** sumando el offset:

- `rect_x_left  = RECT_X_BASE + rect_offset;`
- `rect_x_right = rect_x_left + RECT_WIDTH;`

De esta forma:

- Cuando `rect_offset = 0`, el rectángulo está en `x ≈ RECT_X_BASE`.
- A medida que `rect_offset` aumenta, todo el rectángulo se desplaza a la derecha.

En vertical (`y`) se mantiene fijo, por ejemplo:

- De `RECT_Y_TOP` a `RECT_Y_TOP + RECT_HEIGHT`.

---

## Lógica de color

La lógica de color se implementa como un bloque puramente combinacional, típicamente con `always_comb`:

1. Primero se fija un **fondo negro**:

   - `red   = 0;`
   - `green = 0;`
   - `blue  = 0;`

2. Luego se verifica si el píxel actual `(x, y)` cae dentro del rectángulo:

   - Si `x` está entre `rect_x_left` y `rect_x_right`.
   - Y `y` está entre `RECT_Y_TOP` y `RECT_Y_TOP + RECT_HEIGHT`.

3. Si el píxel está dentro de ese rango, se sobrescribe el color:

   - `red   = 31;`  (rojo máximo)
   - `green = 0;`
   - `blue  = 0;`

Si se quisiera añadir otros elementos (barras, textos, etc.), se podrían ir agregando más condiciones, respetando la prioridad del último `if` que asigne el color.

---

## Relación con el ejemplo 3.13

Comparado con `3_13_lcd` (figuras estáticas):

- En `3_13` las figuras (barras, rectángulo central) son **fijas**:
  - Las regiones se definen solo con comparación de `x` y `y`.
  - No hay contadores ni strobes.
- En `3_14` se agrega:
  - Un **reloj lento** (`strobe_gen`) para mover las figuras a un ritmo controlado.
  - Un **contador** que modifica las comparaciones de `x`.
  - Visualización del estado interno (`rect_offset`) en LEDs y 7 segmentos.

La idea es que este ejemplo sirva como puente hacia:

- Animaciones más complejas.
- Mini-juegos en la LCD.
- Integración con entradas (teclas, sensores, encoder) para mover elementos según la interacción.

---

## Ideas para extender el ejemplo

Algunas variaciones posibles que se pueden proponer como ejercicios:

- Permitir que las teclas (`key`) cambien:
  - La **velocidad** de movimiento (`strobe_hz` o un divisor).
  - El **sentido** (izquierda/derecha).
- Añadir una **barra horizontal** fija (como en `3_13`) y hacer que el rectángulo colisione con ella.
- Cambiar el color del rectángulo según la posición o según alguna entrada externa (`gpio`).

---

Con este ejemplo, la persona usuaria ya tiene una base clara para combinar:

- Un **contador** guiado por un **strobe**.
- Lógica combinacional basada en `x`, `y` y otros parámetros.
- Representaciones en **pantalla**, **LEDs** y **7 segmentos** al mismo tiempo.
