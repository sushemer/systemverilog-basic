# 3.13 LCD – Figuras estáticas básicas

Este es el **primer ejemplo** de uso de la pantalla LCD 480×272 en la Tang Nano 9K.

La idea es mantenerlo **lo más simple posible**:

- El wrapper de la placa genera las coordenadas `(x, y)` del píxel que se está dibujando.
- Nuestro módulo `hackathon_top` decide el **color** de ese píxel:
  - Fondo negro.
  - Una barra vertical roja.
  - Una barra horizontal verde.
  - Un rectángulo amarillo en el centro de la pantalla.
- No hay movimiento, ni contadores, ni uso de teclas.

Es solo: **“si el píxel cae dentro de cierta zona, píntalo de cierto color”**.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender la idea básica de la interfaz LCD:
  - El sistema entrega `(x, y)` por cada píxel.
  - El diseño responde con un color (`red`, `green`, `blue`).
- Dibujar **regiones rectangulares** y barras en la pantalla usando comparaciones de `x` y `y`.
- Ver cómo la lógica combinacional se traduce en gráficos visibles en la LCD.

---

## Señales relevantes

### Entradas

- `x[8:0]`, `y[8:0]`  
  Coordenadas del píxel actual:

  - `x`: 0 … 479
  - `y`: 0 … 271

  Estas coordenadas las genera automáticamente la lógica de video de la placa (wrapper de la Tang Nano 9K).

### Salidas

- `red[4:0]`, `green[5:0]`, `blue[4:0]`  
  Color del píxel actual. Convención típica de 16 bits tipo RGB 5-6-5:

  - `red = 0`   → sin rojo, `red = 31` → rojo máximo.
  - `green = 0` → sin verde, `green = 63` → verde máximo.
  - `blue = 0`  → sin azul, `blue = 31` → azul máximo.

En este ejemplo, se usan:

- Fondo: `(0, 0, 0)` → negro.
- Barra vertical: `(31, 0, 0)` → rojo intenso.
- Barra horizontal: `(0, 50, 0)` → verde medio.
- Rectángulo central: `(31, 63, 0)` → amarillo (rojo + verde).

---

## Estructura interna del diseño

En este ejemplo, la parte gráfica no depende del reloj ni del reset para decidir el color; la lógica es puramente combinacional en función de `(x, y)`.

La estructura típica de `hackathon_top` para este ejemplo es:

1. **Parámetros de pantalla**

   Se definen constantes para facilitar la lectura del código:

   - `SCREEN_WIDTH  = 480`
   - `SCREEN_HEIGHT = 272`

   Opcionalmente, se pueden definir posiciones y tamaños de las figuras, por ejemplo:

   - `BAR_V_X = 100` y un ancho de unos pocos píxeles.
   - `BAR_H_Y = 50` y una altura de unos pocos píxeles.
   - Coordenadas de la esquina superior izquierda e inferior derecha del rectángulo central.

2. **Salidas no gráficas**

   En este ejemplo no se usan LEDs ni 7 segmentos ni GPIO, por lo que se suelen forzar a cero:

   - `led        = 8'b0000_0000`
   - `abcdefgh  = 8'b0000_0000`
   - `digit     = 8'b0000_0000`
   - `gpio      = 'z` (alta impedancia)

3. **Lógica de color (bloque combinacional)**

   Se implementa un `always_comb` que sigue este patrón lógico:

   - Paso 1: establecer un **fondo negro** para todos los píxeles:
     - `red   = 0`
     - `green = 0`
     - `blue  = 0`

   - Paso 2: si `(x, y)` cae dentro de la **barra vertical roja** (por ejemplo, un rango de `x` en torno a 100 y todo el rango de `y`):
     - Sobrescribir:
       - `red   = 31`
       - `green = 0`
       - `blue  = 0`

   - Paso 3: si `(x, y)` cae dentro de la **barra horizontal verde** (por ejemplo, un rango de `y` en torno a 50 y todo el rango de `x`):
     - Sobrescribir:
       - `red   = 0`
       - `green = 50` (u otro valor de verde)
       - `blue  = 0`

   - Paso 4: si `(x, y)` cae dentro del **rectángulo amarillo central**:
     - Sobrescribir:
       - `red   = 31`
       - `green = 63`
       - `blue  = 0`

   La prioridad de dibujo queda determinada por el orden de las condiciones:

   1. Fondo negro (valor por defecto).
   2. Barra vertical roja.
   3. Barra horizontal verde.
   4. Rectángulo central amarillo.

   Si un píxel cumple varias condiciones (por ejemplo, está en la intersección de la barra vertical y la horizontal, o dentro del rectángulo), prevalece la última asignación en el bloque combinacional, es decir, la figura “más importante” según el orden elegido en el código.

---

## Relación con otros ejemplos

- Este ejemplo se apoya en el wrapper de video usado en otros labs, donde el controlador de LCD ya genera las coordenadas `(x, y)` y las señales de sincronismo.
- Es un paso previo a ejemplos más avanzados donde:
  - Se usa el reloj para animar figuras.
  - Se dibujan textos, sprites o gráficos más complejos.
  - Se combinan entradas de teclado/sensores con lo que se muestra en la pantalla.

---

## Posibles extensiones

Algunas ideas para ampliar este ejemplo:

- Controlar el color de las barras usando botones (`key[7:0]`).
- Cambiar la posición de las figuras según un contador o un valor leído desde un sensor.
- Dividir la pantalla en cuadrantes con diferentes colores para practicar condiciones sobre `x` y `y`.
- Añadir un contorno diferente para el rectángulo central (por ejemplo, cambiar color solo en los bordes).

Este ejemplo sirve como base para entender cómo, a partir de las coordenadas `(x, y)` y lógica combinacional sencilla, se pueden construir gráficos en la pantalla LCD de la Tang Nano 9K.
