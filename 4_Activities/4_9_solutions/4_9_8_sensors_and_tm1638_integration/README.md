# 4_9_8 – Integración de sensores + TM1638

Actividad basada en `4_8_sensors_and_tm1638_integration`, ubicada en `4_9_solutions/4_9_8_sensors_and_tm1638_integration`.

## Objetivo

Integrar **sensores físicos** con la tarjeta **TM1638**, de manera que:

- Se lean el **HC-SR04** (ultrasonido) y el **KY-040** (encoder rotatorio).
- Se muestre un valor numérico en el **display de 7 segmentos** del TM1638.
- Se represente una **barra (bar graph)** en los **8 LEDs** del TM1638.
- Se cambie el modo de visualización con las teclas (`key[1:0]`).

La solución aprovecha módulos ya disponibles en el repositorio (sensores, sincronización de entradas, y driver de 7 segmentos).

---

## Conexiones de sensores (GPIO)

Se asume el siguiente mapeo en `gpio`:

**HC-SR04 (ultrasonido)**  
- `gpio[0]` → `TRIG` (salida desde la FPGA hacia el sensor).  
- `gpio[1]` → `ECHO` (entrada desde el sensor hacia la FPGA).

**KY-040 (encoder rotatorio)**  
- `gpio[3]` → canal A (`CLK`).  
- `gpio[2]` → canal B (`DT`).

Módulos involucrados:

- `ultrasonic_distance_sensor`: entrega un valor relativo de distancia  
  `distance_rel : logic [15:0]`.
- `sync_and_debounce`: sincroniza y limpia rebotes de las señales del encoder.
- `rotary_encoder`: entrega un contador cuadratura  
  `encoder_value : logic [15:0]`.

En la solución, las señales del encoder (`A`, `B`) se pasan primero por `sync_and_debounce` para obtener versiones estables antes de alimentar a `rotary_encoder`.

---

## TM1638 y señales principales

Además de los GPIO hacia los sensores, se utilizan las señales del TM1638:

- Líneas de control hacia el TM1638 (según el wrapper de la placa).
- Salida de **segmentos** (internamente manejada por `seven_segment_display`).
- **8 LEDs** integrados en el TM1638, que se usan como “barra” de nivel.

En el lado del diseño, lo relevante es:

- Un valor de 16 bits `sensor_value` que representa el dato seleccionado (distancia o encoder).
- Un registro `number` (típicamente 4 nibbles BCD o hex) que alimenta al módulo de 7 segmentos.
- Un patrón de 8 bits `led_bar` que se mapea a los LEDs del TM1638.

---

## Módulos necesarios

Para que la solución sintetice correctamente, deben incluirse (además del wrapper de la placa):

- `peripherals/ultrasonic_distance_sensor.sv`
- `peripherals/rotary_encoder.sv`
- `peripherals/sync_and_debounce.sv`
- `peripherals/sync_and_debounce_one.sv`
- `peripherals/seven_segment_display.sv`
- `hackathon_top.sv` correspondiente a esta actividad (en `4_9_solutions/4_9_8_...`)

Es importante verificar que todos estos archivos aparezcan en el script de síntesis o en el proyecto de Gowin.

---

## Modos de operación (`key[1:0]`)

Se usa `key[1:0]` como selector de modo:

- `mode = key[1:0];`

La solución propone, por ejemplo, los modos:

- `mode = 2'b00` → **Modo distancia**  
  Se toma `sensor_value = distance_rel`.  
  El display muestra la distancia (en formato hex o escalado), y los LEDs forman una barra proporcional a dicha distancia.

- `mode = 2'b01` → **Modo encoder**  
  Se toma `sensor_value = encoder_value`.  
  El display muestra el valor del encoder (positivo/negativo, típicamente en hex) y la barra refleja el valor absoluto o una porción alta del contador.

- `mode = 2'b10` → **Modo mixto o debug**  
  Se muestra una combinación de ambos valores, por ejemplo:  
  mitad alta del display = distancia, mitad baja = encoder, o alguna mezcla que facilite depuración.

- `mode = 2'b11` → **Modo libre**  
  Reservado para extensiones (congelar valor, mostrar escala fija, probar patrones en LEDs, etc.).

La implementación exacta puede variar, pero la solución incluida en `4_9_8` sigue esta idea general: un multiplexor sobre `sensor_value` controlado por `mode`.

---

## Flujo general de la solución

La lógica del diseño puede resumirse en los siguientes pasos:

1. **Lectura de sensores**

   - El módulo `ultrasonic_distance_sensor` genera `distance_rel` a partir de las señales `TRIG` y `ECHO`.
   - El módulo `sync_and_debounce` recibe `gpio[3:2]` y entrega señales estabilizadas al `rotary_encoder`.
   - `rotary_encoder` genera `encoder_value`, un contador incremental/decremental según el giro del encoder.

2. **Selección del valor (multiplexor por modo)**

   Se define un registro o lógica combinacional:

   - Para `mode = 00` → `sensor_value = distance_rel`.
   - Para `mode = 01` → `sensor_value = encoder_value`.
   - Para `mode = 10` → alguna función de ambos (por ejemplo `distance_rel - encoder_value`).
   - Para `mode = 11` → un valor fijo o de prueba (por ejemplo 0).

   De esta manera, la lógica posterior (display + LEDs) trabaja siempre sobre `sensor_value`.

3. **Escalado para display de 7 segmentos**

   A partir de `sensor_value` (16 bits), se forma un número que el módulo de 7 segmentos pueda mostrar:

   - Opción simple: mostrar `sensor_value` directamente en **hexadecimal** (4 dígitos).  
     Por ejemplo, se empaquetan los 16 bits en `number[15:0]` y se rellenan los dígitos restantes con 0 si el TM1638 tiene 8 dígitos.
   - Opción alternativa: realizar una conversión a **decimal** (BCD) si se desea mostrar valores más “humanos”, aunque esto agrega un poco de lógica extra.

   En la solución típica de este repositorio se prefiere el método sencillo (hex), ya que resulta compacto y directo.

4. **Generación de la barra en LEDs**

   Para construir un bar graph de 8 niveles:

   - Se toma un subconjunto de bits de `sensor_value` (por ejemplo los 8 bits más altos).
   - Se define un umbral o escala y se traduce a un nivel de 0 a 8.
   - A partir del nivel se construye un patrón del tipo:

     - Nivel 0 → `8'b0000_0000`
     - Nivel 1 → `8'b0000_0001`
     - Nivel 2 → `8'b0000_0011`
     - ...
     - Nivel 8 → `8'b1111_1111`

   Esta barra se envía a los LEDs del TM1638, proporcionando una representación visual rápida de la magnitud del valor.

5. **Manejo de teclas adicionales (opcional)**

   - Bits de `key` adicionales (por ejemplo `key[7:2]`) pueden usarse para:
     - Cambiar la escala de la barra (zoom).
     - Activar modos de prueba.
     - Congelar el valor actual de un sensor.
   - En la solución base se prioriza mantener el ejemplo sencillo, dejando estos bits libres para extensiones.

---

## Pruebas sugeridas

1. **Modo distancia (`mode = 00`)**

   - Colocar el sensor HC-SR04 apuntando a un objeto a distintas distancias.
   - Observar cómo:
     - El número en el display cambia al acercar/alejar el objeto.
     - La barra de LEDs del TM1638 crece o disminuye de acuerdo con la distancia relativa.

2. **Modo encoder (`mode = 01`)**

   - Girar el encoder KY-040 lentamente en un sentido y luego en el contrario.
   - Confirmar que:
     - El valor del display aumenta o disminuye según el sentido de giro.
     - La barra refleja la magnitud del valor (por ejemplo el valor absoluto, o un rango recortado).

3. **Cambios rápidos de modo**

   - Alternar entre `mode = 00` y `mode = 01` para comprobar que el sistema conmute correctamente entre ultrasonido y encoder.
   - Verificar que no existan valores “extraños” ni parpadeos inesperados en el display.

4. **Modo mixto y modo libre (`10` y `11`)**

   - Probar la lógica definida en la solución (combinación de sensores, valores fijos, etc.).
   - Ajustar el código si se desea experimentar con otras combinaciones o comportamientos.

---

## Extensiones opcionales

Algunas ideas para ampliar esta actividad:

- Añadir una **escala de unidades** (por ejemplo centímetros o pasos) y documentarla en comentarios.
- Usar el TM1638 para:
  - Mostrar el valor de un sensor en los dígitos más a la derecha.
  - Mostrar el de otro sensor en los dígitos más a la izquierda.
- Implementar un sencillo **sistema de menú** con las teclas del TM1638 para seleccionar:
  - Sensor activo.
  - Tipo de visualización (hex / decimal).
  - Tipo de barra (lineal, logarítmica, etc.).
- Integrar esta funcionalidad con el LCD:
  - Dibujar una barra en la pantalla que siga el mismo valor que los LEDs.
  - Mostrar en texto el modo actual y la lectura aproximada.

Esta solución reúne varias piezas vistas en actividades previas (sensores, debounce, encoder, 7 segmentos, barras de LEDs) y muestra cómo coordinarlas para construir un panel de lectura sencillo pero completo sobre la Tang Nano 9K + TM1638.
