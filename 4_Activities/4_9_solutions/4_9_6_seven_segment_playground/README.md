# 4_9_6 – Seven Segment Playground

Actividad basada en `4_06_seven_segment_playground`, incluida en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Trabajar con el módulo `seven_segment_display` del repositorio para:

- Mostrar distintos **patrones en los 8 dígitos** del display de 7 segmentos.
- Cambiar contenido y **puntos decimales** usando las teclas (`key`).
- Practicar:
  - Manejo de números hexadecimales por nibbles.
  - Animaciones con un **tick lento** generado desde el reloj principal.
  - Diferentes modos de operación controlados por `key`.

---

## Mapeo de señales

### Entradas

- `clock`  
  Reloj principal de la FPGA (~27 MHz).

- `reset`  
  Reset global del sistema.

- `key[1:0]` → selección de modo:

      mode = key[1:0]

      00 → Contador hexadecimal libre
      01 → Playground manual (key[7:4] en D0)
      10 → “Barra” / dígito 0xF que recorre los 8 dígitos
      11 → Patrón fijo 0xDEAD_BEEF

- `key[7:4]`  
  Nibble manual de entrada para el modo playground.

### Salidas

- `abcdefgh[7:0]`  
  Líneas de segmentos del display (a–g + punto).

- `digit[7:0]`  
  Selección de dígito activo (multiplexado por `seven_segment_display`).

- `led[7:0]`  
  Se usan como indicadores auxiliares:
  - `led[1:0]` → modo actual (`mode`).
  - Resto de bits → parte baja del contador o estado interno (debug).

---

## Señales internas y módulo `seven_segment_display`

En la solución se declara:

- Número de dígitos:

      localparam int W_DIGITS = 8;

- Ancho total del número en bits (4 bits por dígito):

      localparam int W_NUM = W_DIGITS * 4;  // 32 bits

- Registros de datos y puntos decimales:

      logic [W_NUM-1:0]   number_reg;
      logic [W_DIGITS-1:0] dots_reg;

Luego se instancia el módulo común:

- `number_reg` contiene el valor a mostrar, empaquetado como 8 dígitos hex (32 bits).
- `dots_reg` controla los puntos decimales de cada dígito (1 bit por dígito).

La lógica de multiplexado (activación de dígitos, tiempos, etc.) se maneja internamente dentro de `seven_segment_display`.

---

## Generación de tick lento

Para evitar que las animaciones vayan demasiado rápidas, se genera un pulso lento (`tick`) a partir del reloj principal:

- Parámetros típicos:

      localparam int unsigned CLK_HZ   = 27_000_000;
      localparam int unsigned TICK_HZ  = 10;               // 10 actualizaciones por segundo
      localparam int unsigned TICK_MAX = CLK_HZ / TICK_HZ;

- Registros:

      logic [31:0] tick_cnt;
      logic        tick;

- Comportamiento:
  - En `reset`, `tick_cnt = 0`, `tick = 0`.
  - En cada flanco de reloj, `tick_cnt` se incrementa.
  - Cuando `tick_cnt == TICK_MAX - 1`, se reinicia a 0 y se genera `tick = 1` durante un ciclo.
  - En los demás ciclos, `tick = 0`.

El pulso `tick` sirve para:

- Incrementar contadores.
- Avanzar posiciones de desplazamiento.
- Actualizar patrones sin depender directamente del reloj de 27 MHz.

---

## Estructura general del playground

En `hackathon_top.sv` se utilizan, de forma típica, las siguientes señales internas:

- Selección de modo:

      logic [1:0] mode;
      assign mode = key[1:0];

- Contador general de 32 bits:

      logic [31:0] counter;

- Registros de patrón para el display:

      logic [W_NUM-1:0] number_reg;
      logic [7:0]       dots_reg;

- Nibble manual:

      logic [3:0] manual_nibble;
      assign manual_nibble = key[7:4];

- Indice de desplazamiento (para modo “barra”):

      logic [2:0] shift_pos;

- Patrón fijo:

      localparam [31:0] FIXED_PATTERN = 32'hDEAD_BEEF;

Con estas señales se construyen los distintos modos de visualización.

---

## Descripción de modos

### Modo 0 – Contador hexadecimal libre (`mode = 2'b00`)

- `counter` se incrementa cada vez que `tick = 1`:

      - En reset: `counter <= 32'd0`.
      - Cuando `tick = 1`: `counter <= counter + 32'd1`.

- Mapeo al display:

      number_reg = counter;       // 32 bits → 8 dígitos hex
      dots_reg   = 8'b0000_0000;  // puntos apagados

Efecto:

- El display muestra un contador hexadecimal que avanza de forma continua.
- Sirve para verificar que el display está funcionando y que el multiplexado es correcto.

### Modo 1 – Playground manual (`mode = 2'b01`)

- Se toma `manual_nibble = key[7:4]` como valor manual (0–F).

Posibles estrategias, por ejemplo:

1) Colocar el nibble solo en el dígito menos significativo:

      number_reg = {28'd0, manual_nibble};  // D0 = manual_nibble
      dots_reg   = 8'b0000_0001;            // encender el punto del dígito 0

2) Replicar el nibble en todos los dígitos (otra posible variante):

      number_reg = {8{manual_nibble}};      // mismo nibble en los 8 dígitos
      dots_reg   = 8'b0000_0000;

En la solución típica se usa la primera opción (nibble en D0 y punto encendido en D0) para visualizar claramente qué dígito se está editando.

Este modo permite probar manualmente todas las combinaciones `0000–1111` y observar los símbolos `0–9`, `A–F` en el display.

### Modo 2 – “Barra” que recorre los dígitos (`mode = 2'b10`)

En este modo se representa una especie de “barra” como un dígito `0xF` que se desplaza a lo largo de los 8 dígitos.

- Se utiliza un índice de posición:

      shift_pos: contador de 3 bits (0–7) que avanza con `tick`.

- Comportamiento típico:

  - En `reset`: `shift_pos <= 3'd0`.
  - En cada `tick = 1`: `shift_pos <= shift_pos + 3'd1`.

- Construcción de `number_reg`:
  - Todos los dígitos se cargan con `0x0`, excepto el dígito en posición `shift_pos`, que se carga con `0xF`.
  - Conceptualmente:

        Para cada dígito i = 0..7:
          si i == shift_pos → nibble_i = 4'hF
          en otro caso      → nibble_i = 4'h0

  - En la práctica, se puede construir `number_reg` concatenando los nibbles de forma adecuada o generándolo con lógica combinacional en función de `shift_pos`.

- `dots_reg` puede permanecer en 0 (`8'b0000_0000`) en esta solución básica.

Efecto:

- Parece una “barra completa” moviéndose de izquierda a derecha y repitiéndose cíclicamente.

### Modo 3 – Patrón fijo 0xDEAD_BEEF (`mode = 2'b11`)

En este modo se muestra un patrón constante en el display (útil para probar texto y estilos hex):

- Patrón fijo:

      FIXED_PATTERN = 32'hDEAD_BEEF;

- Mapeo directo:

      number_reg = FIXED_PATTERN;
      dots_reg   = 8'b0000_0000;

No requiere el uso de `tick`, ya que no hay animación en esta solución básica (aunque se podría modificar para parpadear puntos u otros efectos).

---

## Integración de los modos

Toda la lógica de selección se puede reunir en un único bloque combinacional:

1. Inicializar `number_reg` y `dots_reg` con valores por defecto (por ejemplo, todo a 0).
2. Seleccionar el comportamiento según `mode`:

   - `mode = 2'b00`: usar contador.
   - `mode = 2'b01`: usar nibble manual.
   - `mode = 2'b10`: usar “barra” desplazada.
   - `mode = 2'b11`: usar patrón fijo.

De esta forma, se garantiza que siempre existe un valor definido para `number_reg` y `dots_reg`.

Los LEDs (`led[7:0]`) se pueden utilizar como apoyo visual:

- `led[1:0] = mode` para ver rápidamente qué modo está activo.
- El resto de bits (`led[7:2]`) se pueden asociar, por ejemplo, a los bits menos significativos del contador (`counter[7:2]`), de modo que se dispone de una referencia visual adicional.

---

## Pruebas sugeridas

1. **Modo 0 – Contador hex**

   - Seleccionar `mode = 2'b00`.
   - Ajustar la frecuencia del tick (`TICK_HZ`) hasta que la cuenta sea visible pero no excesivamente lenta.
   - Observar cómo los dígitos menos significativos cambian rápido y los más significativos cambian más lento.

2. **Modo 1 – Playground manual**

   - Seleccionar `mode = 2'b01`.
   - Recorrer todas las combinaciones posibles de `key[7:4]` (0000–1111).
   - Confirmar que en el dígito 0 aparecen correctamente `0–9` y `A–F`.
   - Verificar que el punto decimal del dígito 0 se mantiene encendido (según la configuración elegida).

3. **Modo 2 – Barra desplazada**

   - Seleccionar `mode = 2'b10`.
   - Verificar que el dígito 0xF recorre los 8 dígitos repetidamente.
   - Probar con diferentes valores de `TICK_HZ` para obtener velocidades de desplazamiento distintas.

4. **Modo 3 – Patrón fijo**

   - Seleccionar `mode = 2'b11`.
   - Confirmar que se muestra el patrón `DEAD_BEEF`.
   - Opcionalmente, modificar el patrón fijo para mostrar otros textos hex (por ejemplo, `CAFEBABE`).

---

## Extensiones opcionales

Algunas ideas para ampliar el playground:

- Controlar la velocidad:
  - Usar `key[3:2]` para seleccionar entre varios valores de `TICK_HZ` (lento, medio, rápido).

- Ampliar el modo manual:
  - Permitir seleccionar qué dígito se edita con `key[3:2]` (por ejemplo, D0–D3).
  - Combinar varios nibbles para formar un número completo.

- Mejorar la animación de la barra:
  - En lugar de un solo dígito `0xF`, mostrar una “barra” de varios dígitos encendidos.
  - Añadir un efecto ping-pong (que la barra recorra de ida y vuelta).

- Integración con otros módulos:
  - Mostrar en el display valores de la ALU de 4 bits (expandida a 8 dígitos).
  - Mostrar valores de sensores (distancia del HC-SR04, posición del encoder, etc.).

Con esta solución se obtiene un entorno flexible para practicar el uso del módulo `seven_segment_display` y diseñar diferentes modos de visualización y animación en un display de 7 segmentos multiplexado.
