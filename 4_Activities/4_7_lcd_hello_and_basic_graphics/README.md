# 4.7 – LCD: “HELLO” y gráficas básicas

En esta actividad se usa el **LCD 480×272** de la Tang Nano 9K para dibujar:

- Un **marco** (borde) alrededor de la pantalla.
- Una **banda central** donde se mostrará la palabra **“HELLO”** usando bloques (rectángulos).
- Opcionalmente, una **barra de estado** en la parte inferior que cambie con las teclas.

La idea es practicar cómo usar las coordenadas `(x, y)` y las señales de color `red/green/blue` para construir gráficos simples.

---

## Objetivo

Al finalizar la actividad la persona usuaria podrá:

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
  Teclas físicas de la placa. En esta actividad se pueden usar, por ejemplo, para:
  - Encender los LEDs (`led = key`).
  - Cambiar el color de una barra de estado.

El display de 7 segmentos (`abcdefgh`, `digit`) **no es el foco** de esta actividad y se deja apagado, aunque se puede reutilizar si se desea.

---

## Estructura del código base

La plantilla hace, en líneas generales, lo siguiente:

1. **Parámetros de pantalla**

   Se declaran constantes con el ancho y alto del LCD:
    ```sv
   localparam int SCREEN_W = 480;  
   localparam int SCREEN_H = 272;
    ```
2. **Inicialización de salidas no gráficas**

   - `led` suele conectarse directamente a `key` como debug simple:
      ```sv
     led = key;
      ```
   - `abcdefgh` y `digit` se ponen en cero para apagar el TM1638:
      ```sv
     abcdefgh = '0;  
     digit    = '0;
    ```
3. **Lógica de video (bloque combinacional)**

   Un único `always_comb` decide el color del píxel según `(x, y)`:
  ```sv
   always_comb begin  
       // Color por defecto (fondo)  
       red   = 5'd0;  
       green = 6'd0;  
       blue  = 5'd0;  

       // A partir de aquí se añaden condiciones:
       // - marco
       // - banda central
       // - letras "HELLO"
       // - barra de estado, etc.
   end
  ```
Toda la actividad consiste en ir añadiendo condiciones dentro de este bloque para “pintar” zonas concretas de la pantalla.

---

## Pasos sugeridos

### 1. Dibujar fondo y marco

Primero se recomienda definir un **fondo** (por ejemplo, un azul oscuro suave) y un **marco** blanco delgado alrededor de la pantalla.

1. Fondo base (dentro de `always_comb`):

   - Color por defecto, por ejemplo:
    ```sv
     red   = 5'd0;  
     green = 6'd0;  
     blue  = 5'd4;
    ```
   Esto hará que, si no se cumple ninguna condición especial, toda la pantalla sea azul oscuro.

2. Marco blanco:

   - Se puede usar una condición que detecte “cerca de los bordes”:
    ```sv
     if (x < 3 || x > SCREEN_W - 4 || y < 3 || y > SCREEN_H - 4) begin  
         red   = 5'b11111;  
         green = 6'b111111;  
         blue  = 5'b11111;  
     end
    ```
   - Con esto se dibuja un rectángulo fino alrededor de toda la pantalla.

**Sugerencia:** Probar solo con fondo + marco antes de pasar al texto, para confirmar que la lógica básica funciona.

---

### 2. Reservar la banda central para el texto

Para escribir “HELLO” se recomienda reservar una **banda horizontal** en el centro de la pantalla:

- Por ejemplo, tomar un rango de `y` alrededor de la mitad de la pantalla:

  - Centro aproximado: `SCREEN_H / 2` → 136.  
  - Banda: de `y ≈ 90` a `y ≈ 180` (los valores exactos son a elección).

Dentro de esa banda se pueden usar colores diferentes (por ejemplo, fondo más claro) para que destaque el texto:
```sv
if (y >= Y_BAND_TOP && y <= Y_BAND_BOTTOM) begin  
    // Fondo de la banda (por ejemplo, azul claro)  
    red   = 5'd2;  
    green = 6'd16;  
    blue  = 5'd10;  
end
```
Se recomienda:

- Definir constantes para los límites de la banda, por ejemplo:
  ```sv
  localparam int Y_BAND_TOP    = 90;  
  localparam int Y_BAND_BOTTOM = 180;
  ```
- Usarlas en el bloque combinacional para mantener el código más legible.

---

### 3. Formar la palabra “HELLO” con bloques

La palabra “HELLO” se puede dibujar como una fuente muy simple de tipo “pixel art”, usando **rectángulos** para las barras verticales y horizontales de cada letra.

Una forma práctica de organizar el espacio es:

- Dividir la banda en “celdas” para cada letra.
- Dejar un pequeño espacio entre letras.

Por ejemplo:

- Definir un ancho de letra:
  ```sv
  localparam int LETTER_W = 40;  
  localparam int LETTER_SPACING = 10;
  ```
- Calcular posiciones en X para cada letra:

  - Letra H: desde X_H_START hasta X_H_END.  
  - Letra E: a continuación, dejando `LETTER_SPACING`.  
  - Letra L1, L2, O: igual.

Para cada letra se pueden usar condiciones separadas, por ejemplo:

- **Letra H**:

  - Dos barras verticales: izquierda y derecha.
  - Una barra horizontal en el centro de la banda.
  ```sv
  if (x en la zona de la H  
      y en la banda central  
      y coincide con barras verticales u horizontal)  
      → color de texto (por ejemplo, amarillo).
  ```
- **Letra E**:

  - Barra vertical izquierda.
  - Tres barras horizontales: arriba, centro y abajo.

- **Letra L**:

  - Barra vertical izquierda + barra horizontal inferior.

- **Letra O**:

  - Rectángulo “hueco”: barras izquierda, derecha, arriba y abajo.

Para el color del texto se puede usar, por ejemplo:

- Amarillo:  
  ```sv
  red   = 5'b11111;  
  green = 6'b111111;  
  blue  = 5'd0;
  ```
**Orden de prioridad dentro del always_comb:**

1. Fondo.
2. Banda central.
3. Marco (si se quiere que tape la banda en los bordes).
4. Letras “HELLO”.

El último bloque que cumple la condición sobrescribe el color anterior.

---

### 4. Barra de estado opcional

En la parte inferior de la pantalla se puede agregar una **barra de estado** que dependa de `key`, por ejemplo:

- Rango de `y`:

  - Barra: de `SCREEN_H - 30` a `SCREEN_H - 1`.

- Color según alguna tecla:

  - Si `key[0] == 1` → barra verde.
  - Si `key[1] == 1` → barra roja.
  - Si ninguna tecla está activa → barra gris.

Ejemplo de lógica:
```sv
if (y >= SCREEN_H - 30) begin  
    // Barra de estado  
    if (key[0]) begin  
        red   = 5'd0;  
        green = 6'b111111;  
        blue  = 5'd0;  
    end  
    else if (key[1]) begin  
        red   = 5'b11111;  
        green = 6'd0;  
        blue  = 5'd0;  
    end  
    else begin  
        red   = 5'd8;  
        green = 6'd8;  
        blue  = 5'd8;  
    end  
end
```
Esta barra permite comprobar visualmente que las teclas están llegando correctamente al diseño.

---

## Pruebas sugeridas

1. **Fondo y marco**

   - Compilar y cargar el diseño solo con:
     - Fondo de un color uniforme.
     - Marco blanco alrededor.
   - Verificar que:
     - No hay parpadeos extraños.
     - El marco rodea correctamente los cuatro bordes.

2. **Banda central sin texto**

   - Activar la banda central con un color diferente.
   - Verificar que la banda aparece en la zona esperada de la pantalla.

3. **Texto “HELLO”**

   - Añadir la lógica de las letras.
   - Ajustar las coordenadas hasta que cada letra tenga forma razonable.
   - Verificar que la palabra se mantiene centrada y legible.

4. **Barra de estado con teclas**

   - Presionar `key[0]`, `key[1]` y combinaciones.
   - Confirmar que el color de la barra inferior cambia según el patrón definido.

---

## Extensiones opcionales

Si se desea experimentar más:

- Cambiar la palabra “HELLO” por otra (por ejemplo, “FPGA”, “HACK”, “DOJO”).
- Añadir una segunda banda con otra palabra o símbolo.
- Crear un pequeño “icono” (por ejemplo, un cuadrado que represente un personaje) y moverlo en X o Y con `key`.
- Implementar un modo “invertido” donde, al presionar cierta tecla, se inviertan los colores de fondo y texto.
- Usar el display de 7 segmentos para mostrar un contador de “frames” o un modo actual de dibujo.

Con esta actividad se refuerza la idea de que **cada píxel** del LCD se decide a partir de comparaciones sobre `(x, y)` y de la lógica combinacional en `hackathon_top.sv`, lo que sienta las bases para gráficos más complejos y animaciones en la FPGA.
