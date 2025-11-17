# 3.13 LCD – Figuras estáticas básicas

Este es el **primer ejemplo** de uso de la pantalla LCD 480×272 en la Tang Nano 9K.

La idea es **lo más simple posible**:

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
- Ver cómo la lógica combinacional se traduce en gráficos.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope para la configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon` que:
  - Apaga LEDs y display de 7 segmentos.
  - Usa solo `(x, y)` para decidir el color de cada píxel.
  - Dibuja:
    - Fondo negro.
    - Barra vertical roja.
    - Barra horizontal verde.
    - Rectángulo amarillo central.

El proyecto asume que el repositorio ya contiene:

- El wrapper de LCD para la Tang Nano 9K.
- El `board_specific_top.sv` que conecta el LCD con `x`, `y`, `red`, `green`, `blue`.

---

## Señales relevantes

### Entradas

- `x[8:0]`, `y[8:0]`  
  Coordenadas del píxel:

  - `x`: 0 … 479
  - `y`: 0 … 271

  Las genera automáticamente la lógica de video de la placa.

### Salidas

- `red[4:0]`, `green[5:0]`, `blue[4:0]`  
  Color del píxel actual. Convención típica:

  - `red = 0` → sin rojo, `red = 31` → rojo máximo.
  - `green = 0` → sin verde, `green = 63` → verde máximo.
  - `blue = 0` → sin azul, `blue = 31` → azul máximo.

En este ejemplo:

- Fondo: `(0, 0, 0)` → negro.
- Barra vertical: `(31, 0, 0)` → rojo.
- Barra horizontal: `(0, 50, 0)` → verde.
- Rectángulo central: `(31, 63, 0)` → amarillo.

---

## Estructura interna del diseño

No se usa el reloj ni el reset para la parte gráfica en este ejemplo, solo:

1. **Parámetros de pantalla**  
   Se definen `SCREEN_WIDTH = 480` y `SCREEN_HEIGHT = 272`.

2. **Salidas no gráficas**  
   - `led`, `abcdefgh`, `digit` se ponen en cero.
   - `gpio` no se usa.

3. **Lógica de color**  
   Un único bloque `always_comb`:

   - Primero define un **fondo negro**.
   - Luego, según el rango de `x` y `y`, va “sobre-escribiendo” el color si el píxel cae dentro de:
     - Una **barra vertical roja** en torno a `x ≈ 100`.
     - Una **barra horizontal verde** en torno a `y ≈ 50`.
     - Un **rectángulo amarillo** centrado.

La prioridad de dibujo es:

1. Fondo.
2. Barra vertical.
3. Barra horizontal.
4. Rectángulo central.

Si el píxel cae en varias regiones, prevalece el último `if`.

---
