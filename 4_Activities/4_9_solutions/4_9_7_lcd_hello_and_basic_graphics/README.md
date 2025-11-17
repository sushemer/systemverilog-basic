<!-- File: 4_Activities/4_07_lcd_hello_and_basic_graphics/README.md -->

# 4.7 – LCD: “HELLO” y gráficas básicas

En esta actividad vas a usar el **LCD 480×272** de la Tang Nano 9K para dibujar:

- Un **marco** (borde) alrededor de la pantalla.
- Una **banda central** donde se mostrará la palabra **“HELLO”** usando bloques (rectángulos).
- Opcionalmente, una **barra de estado** en la parte inferior que cambie con las teclas.

La idea es practicar cómo usar las coordenadas `(x, y)` y las señales de color `red/green/blue` para construir gráficos simples.

---

## Objetivo

Al finalizar la actividad deberías poder:

- Entender cómo se generan las coordenadas `(x, y)` para cada píxel.
- Dibujar **regiones rectangulares** en el LCD usando comparaciones de `x` y `y`.
- Reservar una banda para texto y formar letras básicas con bloques.
- Combinar varias condiciones para crear gráficos simples (marcos, barras, letras).

---

## Señales clave

El módulo `hackathon_top.sv` recibe:

- `x[8:0]`, `y[8:0]`  
  Coordenadas del píxel actual que el controlador de LCD está pintando.
  - `x` va de `0` a `SCREEN_W-1` (0–479).
  - `y` va de `0` a `SCREEN_H-1` (0–271).

- `red[4:0]`, `green[5:0]`, `blue[4:0]`  
  Intensidad de color del píxel actual en formato 5-6-5 bits.

- `key[7:0]`  
  Teclas físicas de la placa. En esta actividad se usan, por ejemplo, para:
  - Encender los LEDs (`led = key`).
  - Cambiar el color de una barra de estado.

El display de 7 segmentos (`abcdefgh`, `digit`) **no es el foco** de esta actividad y se deja apagado, pero podrías reusarlo si quieres.

---

## Estructura del código base

La plantilla hace lo siguiente:

1. **Parámetros de pantalla**

   ```sv
   localparam int SCREEN_W = 480;
   localparam int SCREEN_H = 272;
   ```