# 4_9_7 – LCD "HELLO" + gráficas básicas

Actividad basada en `4_7_lcd_hello_and_basic_graphics`, incluida en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Practicar gráficos básicos en el LCD (480×272) utilizando únicamente:

- Coordenadas de píxel (`x`, `y`).
- Comparaciones y rangos sobre `x` y `y`.
- Asignaciones a las salidas de color `red`, `green`, `blue`.

El módulo de solución:

- Dibuja un **marco blanco** alrededor de toda la pantalla.
- Usa un **fondo azul/gris suave** en el interior.
- Reserva una banda central para escribir **“HELLO”** con letras hechas de bloques rectangulares.
- Muestra una **barra de estado inferior** que cambia de color según `key[0]`.
- Refleja el valor de `key` en los LEDs (`led = key`).

---

## Mapeo de señales

### Entradas

- `clock`  
  Reloj principal de la FPGA.

- `reset`  
  Reset global del sistema.

- `key[7:0]`  
  Línea de teclas de la placa:
  - `key[0]` se usa para cambiar el color de la barra de estado.
  - El vector completo se refleja en `led[7:0]`.

- `x[8:0]`, `y[8:0]`  
  Coordenadas del píxel actual generadas por el controlador de LCD:
  - `x` en el rango `0 .. 479`.
  - `y` en el rango `0 .. 271`.

### Salidas

- `red[4:0]`, `green[5:0]`, `blue[4:0]`  
  Componentes de color en formato 5-6-5 del píxel actual.

- `led[7:0]`  
  Salidas de LEDs; en esta solución se asignan directamente:

      led = key;

- `abcdefgh` y `digit`  
  Se mantienen en 0 (display de 7 segmentos apagado), ya que el foco está en el LCD.

---

## Estructura general del dibujo

En la solución se sigue un esquema tipo:

1. Inicialización a negro (fondo por defecto).
2. Dibujo de **marco** (borde blanco).
3. Relleno del **fondo interior** (degradado azul/gris).
4. Definición de una **banda central** donde se coloca la palabra “HELLO”.
5. Dibujo de cada letra con bloques rectangulares.
6. Dibujo de la **barra de estado inferior** con color dependiente de `key[0]`.

Todo se implementa en un único bloque combinacional:

- Primero se asignan valores base (fondo).
- Después se aplican condiciones más específicas (marco, banda, letras, barra) que sobrescriben los colores cuando la condición se cumple.

---

## 1. Parámetros de pantalla y banda central

Se definen parámetros para ancho y alto de la pantalla:

- `SCREEN_W = 480`
- `SCREEN_H = 272`

Se reservan constantes para la banda central donde se colocan las letras, por ejemplo:

- Región vertical de texto:

      TEXT_Y_TOP    ≈ SCREEN_H / 3
      TEXT_Y_BOTTOM ≈ 2 * SCREEN_H / 3

- Cada letra ocupa un ancho aproximado y se define por rangos en `x`, por ejemplo:

      REGION_H_X0, REGION_H_X1
      REGION_E1_X0, REGION_E1_X1
      ...

La solución agrupa estos rangos en condiciones para dibujar bloques rectangulares que forman las letras.

---

## 2. Marco (borde) blanco

El marco blanco se dibuja comprobando si el píxel está cerca de los bordes:

- Condición típica:

      borde_si:
        (x < 2) o (x >= SCREEN_W - 2) o
        (y < 2) o (y >= SCREEN_H - 2)

- Si se cumple, se asigna color blanco:

      red   = valor_máximo (5 bits)
      green = valor_máximo (6 bits)
      blue  = valor_máximo (5 bits)

Este marco rodea la pantalla y ayuda a visualizar los límites útiles del área de dibujo.

---

## 3. Fondo interior (azul/gris suave)

Cuando el píxel **no** está en el borde, se aplica un fondo suave:

- Se usa un color base con azul y algo de verde:

      red   = valor pequeño (por ejemplo 1 o 2)
      green = función suave de y (por ejemplo, algunos bits de y)
      blue  = valor intermedio (por ejemplo 5 o 6)

El uso de `y` en `green` genera un ligero degradado vertical, que hace que el fondo se vea menos plano.

---

## 4. Banda central para "HELLO"

Se define una banda horizontal donde se colocan las letras:

- Condición de banda:

      dentro_de_banda_si:
        (y >= TEXT_Y_TOP) y (y <= TEXT_Y_BOTTOM)

Dentro de esa banda:

- Se puede oscurecer o aclarar el fondo para que el texto destaque, por ejemplo aumentando el componente azul o reduciendo el verde.
- A continuación, en la misma banda, se agregan condiciones más específicas para cada letra.

---

## 5. Letras "HELLO" con bloques rectangulares

Cada letra se construye combinando varios bloques rectangulares:

- Para cada letra se definen sub-regiones, por ejemplo:

  - Para la H:
    - Dos columnas verticales (piernas) en los extremos.
    - Una barra horizontal en el centro.

  - Para la E:
    - Una columna vertical a la izquierda.
    - Tres barras horizontales (arriba, centro, abajo).

  - Para la L:
    - Una columna vertical a la izquierda.
    - Una barra horizontal en la parte inferior.

- Cada bloque se define con comparaciones simples de `x` y `y`, por ejemplo:

      bloque_H_pierna_izquierda_si:
        x en [H_X0, H_X0 + ancho_pierna) y
        y en [TEXT_Y_TOP, TEXT_Y_BOTTOM]

      bloque_H_pierna_derecha_si:
        x en [H_X1 - ancho_pierna, H_X1) y
        y en [TEXT_Y_TOP, TEXT_Y_BOTTOM]

      bloque_H_barra_central_si:
        x en [H_X0, H_X1) y
        y en [Y_MID - grosor/2, Y_MID + grosor/2]

- Cuando un píxel está dentro de alguna de estas regiones, se le asigna un color distinto (por ejemplo, blanco o amarillo):

      red   = valor alto
      green = valor alto
      blue  = valor bajo o medio

La combinación de todos estos bloques forma la palabra “HELLO” claramente visible en la banda central.

---

## 6. Barra de estado inferior

En la parte inferior de la pantalla se dibuja una barra de estado:

- Región típica:

      y en [SCREEN_H - ALTURA_BARRA, SCREEN_H)

  donde `ALTURA_BARRA` es una constante (por ejemplo 20–30 píxeles).

- El color de la barra depende de `key[0]`:

  - Si `key[0] = 0` → barra de un color (por ejemplo verde).
  - Si `key[0] = 1` → barra de otro color (por ejemplo rojo o amarillo).

Condiciones típicas:

- Dentro de la región de la barra, se sobrescriben los valores de `red`, `green` y `blue` según el estado de `key[0]`.

---

## 7. LEDs y display de 7 segmentos

- `led[7:0]`:

      led = key;

  De esta forma queda visible el estado de todas las teclas al mismo tiempo que se observa el resultado en el LCD.

- `abcdefgh` y `digit`:
  - Se mantienen en cero (`'0`) para dejar el display de 7 segmentos apagado.
  - La actividad se centra exclusivamente en el uso del LCD.

---

## Pruebas sugeridas

1. **Verificar el marco**

   - Con el diseño cargado, observar que existe un marco blanco rodeando toda la pantalla.
   - Confirmar que el interior tiene el degradado o color de fondo previsto.

2. **Verificar la palabra “HELLO”**

   - Comprobar que en la banda central aparece claramente la palabra “HELLO”.
   - Verificar que las letras se mantienen estáticas y bien definidas.

3. **Barra de estado inferior**

   - Observar la barra de estado en la parte inferior.
   - Cambiar `key[0]` y confirmar que la barra cambia de color según el valor del bit.

4. **LEDs**

   - Activar distintas teclas y comprobar que `led[7:0]` sigue el mismo patrón que `key[7:0]`.

---

## Extensiones opcionales

Algunas ideas para ampliar la actividad:

- Cambiar la palabra “HELLO” por otra (por ejemplo, “FPGA” o “HACK”) ajustando las regiones de bloques.
- Hacer que la barra de estado muestre un patrón de “carga” animado, usando un contador y comparaciones con `x`.
- Añadir una segunda banda de texto o un pequeño icono (por ejemplo, un corazón o un cuadrado animado) usando el mismo enfoque de bloques.
- Introducir cambios de color en el texto según alguna tecla (`key[1]`, `key[2]`, etc.).

Con esta solución, se consolidan las ideas básicas de dibujo en el LCD: uso de coordenadas `(x, y)`, rangos rectangulares y asignación de colores, construyendo gráficos simples pero expresivos como marcos, barras y texto compuesto por bloques.
