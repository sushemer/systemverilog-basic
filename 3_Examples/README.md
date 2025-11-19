# 3. Examples · Ejemplos

Esta carpeta contiene **ejemplos cortos y autocontenidos en SystemVerilog** para la combinación:

> Tang Nano 9K + LCD 480×272 + TM1638 (placa “hackathon”).

Cada ejemplo se enfoca en 1–2 ideas centrales (compuertas, muxes, contadores, displays, sensores, etc.) y está pensado para ser:

- Lo bastante pequeño como para leerse en una sola sesión.
- Fácil de sintetizar y probar directamente en la placa.
- Un puente entre la teoría (`1_docs`) y las carpetas de **Activities** (`4_activities`) y **Labs** (`5_labs`).

La mayoría de los ejemplos usan `hackathon_top` (o `lab_top`) como módulo de nivel superior, junto con el wrapper de tarjeta en:

`boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/`

---

## 3.1 `3_1_and_or_not_xor_demorgan`

**Tema:** compuertas lógicas básicas + leyes de De Morgan.  
**Qué hace:**

- Lee dos entradas `A`, `B` desde `key[1:0]`.
- Calcula `A & B`, `A | B`, `A ^ B` y los muestra en varios LEDs.
- Muestra `~(A & B)` y `(~A) | (~B)` en dos LEDs para que se pueda **verificar visualmente** que ambas expresiones coinciden siempre (ley de De Morgan).

---

## 3.2 `3_2_mux_2to1`

**Tema:** multiplexor 2:1 en distintos estilos de codificación.  
**Qué hace:**

- Usa bits de `key` como entradas de datos y señal de selección.
- Implementa un mux 2:1 con:
  - `if/else`
  - operador condicional `?:`
  - `case`
- Muestra la entrada seleccionada en un LED y también demuestra cómo usar `sel` para indexar un pequeño vector.

---

## 3.3 `3_3_decoder_2to4`

**Tema:** decodificador 2→4 (one-hot) en varias versiones.  
**Qué hace:**

- Toma una entrada de 2 bits desde teclas o switches.
- Genera una salida **one-hot** de 4 bits usando:
  - Suma de productos directa.
  - Un `case` clásico.
  - Un corrimiento (`4'b0001 << in`).
  - Una asignación indexada (`out[in] = 1`).
- Mapea todas las salidas a LEDs para probar fácilmente los casos `00..11`.

---

## 3.4 `3_4_priority_encoder`

**Tema:** codificador de prioridad de 3 entradas.  
**Qué hace:**

- Lee un vector de 3 bits desde las teclas/switches.
- Codifica el **‘1’ de mayor prioridad** en 2 bits usando:
  - `if/else` encadenados.
  - `casez` con bits don’t-care.
  - Separación en “árbitro de prioridad” + codificador normal.
  - Implementación basada en bucle.
- Empaqueta todas las salidas en los LEDs para comparar las distintas implementaciones.

---

## 3.5 `3_5_comparator_4bit`

**Tema:** comparador de magnitud de 4 bits.  
**Qué hace:**

- Usa switches/teclas para definir dos valores de 4 bits `A` y `B`.
- Los compara y enciende LEDs para indicar:
  - `A < B`
  - `A == B`
  - `A > B`
- Ilustra el uso de operadores relacionales y el diseño combinacional básico.

---

## 3.6 `3_6_adder_subtractor_3bit`

**Tema:** sumador/restador de 3 bits con bit de modo (A ± B).  
**Qué hace:**

- Lee dos operandos de 3 bits `A`, `B` desde `key[5:0]` y un bit de modo desde `key[7]`.
- Implementa dos variantes:
  - Implementación directa con operadores `+` y `-`.
  - Implementación unificada usando complemento a dos:

    `res = A + (B XOR M) + M`, donde `M = mode`.

- Muestra el resultado de 4 bits (3 bits de suma/resta + bit extra de carry/borrow) en grupos de LEDs para comparar ambas aproximaciones.

---

## 3.7 `3_7_binary_counter`

**Tema:** contadores binarios y división de reloj.  
**Qué hace:**

- Implementa un **contador libre** que se incrementa en cada ciclo de reloj.
- Usa los bits más altos para hacer parpadear LEDs a frecuencias visibles.
- Variante opcional: contador controlado por tecla, que incrementa solo al detectar flancos (edge detection).

---

## 3.8 `3_8_shift_register`

**Tema:** registro de desplazamiento + animaciones simples en LEDs.  
**Qué hace:**

- Implementa un registro de desplazamiento conectado a una barra de LEDs.
- Desplaza periódicamente los bits para crear una “luz en movimiento” (estilo KITT).
- Se puede modificar para cambiar la dirección, hacer que el patrón rebote o usar teclas para reiniciar/cambiar el comportamiento.

---

## 3.9 `3_9_seven_segment_letter`

**Tema:** letras en un solo dígito de 7 segmentos.  
**Qué hace:**

- Define codificaciones de segmentos para letras como `F`, `P`, `G`, `A` y un estado en blanco.
- Recorre los dígitos con un patrón one-hot y selecciona qué letra mostrar.
- Permite mostrar una palabra corta como “FPGA” escaneando los dígitos lo bastante rápido.

Las codificaciones de letras pueden ajustarse tomando como referencia alguna imagen o herramienta externa de “seven segment font editor”.

---

## 3.10 `3_10_hex_counter_7seg`

**Tema:** contador hexadecimal en display de 7 segmentos con velocidad ajustable.  
**Qué hace:**

- Crea un temporizador programable (`period`) que define la velocidad de conteo.
- Usa teclas para **aumentar/disminuir** la velocidad.
- Mantiene un contador de 32 bits y lo envía a un módulo multi-dígito de 7 segmentos.
- Muestra el conteo en **hexadecimal** a lo largo de los distintos dígitos.

---

## 3.11 `3_11_seven_segment_basics`

**Tema:** “hola mundo” del display de 7 segmentos.  
**Qué hace:**

- Controla directamente las líneas `abcdefgh` y `digit` sin usar drivers avanzados.
- Permite encender/apagar segmentos manualmente (mediante constantes o switches) para:
  - Confirmar el wiring (qué bit controla qué segmento).
  - Determinar si el display es common-anode o common-cathode.
- Es el punto de partida antes de usar módulos como `seven_segment_display`.

---

## 3.12 `3_12_seven_segment_hex_counter_multiplexed`

**Tema:** contador HEX de 32 bits con multiplexado manual en 7 segmentos.  
**Qué hace:**

- Implementa un contador de 32 bits (`hex_counter`).
- En cada instante, activa solo un dígito (máscara one-hot en `digit`) y le envía un nibble del contador.
- Recorre rápidamente los 8 dígitos del TM1638 para mostrar el valor completo en HEX.
- Separa la lógica en:
  - Contador lento (incrementa el valor).
  - Lógica de refresco rápido del display (selección de dígito).
  - Decodificación HEX → segmentos.

---

## 3.13 `3_13_lcd_basic_shapes`

**Tema:** primeros pasos con la LCD (figuras estáticas).  
**Qué hace:**

- Usa las coordenadas `x`, `y` que entrega el controlador de la LCD (0–479, 0–271).
- Define un fondo negro y dibuja:
  - Una barra vertical roja.
  - Una barra horizontal verde.
  - Un rectángulo amarillo centrado.
- Todo se realiza con lógica combinacional que compara rangos de `x` y `y` y asigna los valores de `red`, `green`, `blue`.

---

## 3.14 `3_14_lcd_moving_rectangle`

**Tema:** rectángulo en movimiento sobre la LCD.  
**Qué hace:**

- Extiende el ejemplo estático anterior (`3_13`) añadiendo:
  - Un módulo `strobe_gen` que genera un pulso lento (~30 Hz).
  - Un contador que, al recibir cada pulso, actualiza la posición horizontal del rectángulo.
- Muestra la posición del rectángulo:
  - Numéricamente en el display de 7 segmentos.
  - En binario en los LEDs.
  - Gráficamente en la LCD como un rectángulo rojo que se desplaza.

---

## 3.15 `3_15_pot_read_demo`

**Tema:** demo de lectura de “potenciómetro” y representación en múltiples salidas (simulado).  
**Qué hace:**

- Usa `key[7:0]` como **potenciómetro simulado** (valor de 0–255).
- Interpreta ese valor como si viniera de un ADC externo.
- Muestra el valor:
  - En LEDs (patrón binario).
  - En el display de 7 segmentos (número).
  - En la LCD como una **barra horizontal** cuya longitud es proporcional al valor.
- Es una base para, más adelante, reemplazar `key` por un ADC real.

---

## 3.16 `3_16_tm1638_quickstart`

**Tema:** “hola mundo” con el módulo TM1638.  
**Qué hace:**

- Verifica el funcionamiento básico del TM1638 en la configuración de hackathon:
  - Lectura de teclas (`key[7:0]`).
  - Encendido de LEDs (`led[7:0]`).
  - Visualización de un valor en el display de 7 segmentos mediante `seven_segment_display`.
- Permite comprobar rápidamente que la comunicación con el TM1638 y el wiring están correctos antes de usarlo en ejemplos más complejos.

---

## 3.17 `3_17_ultrasonic_hcsr04_measure_demo`

**Tema:** medición de distancia con sensor ultrasónico HC-SR04.  
**Qué hace:**

- Instancia el módulo `ultrasonic_distance_sensor` (en `peripherals/`), conectando:
  - `trig` y `echo` a pines `gpio`.
  - Un ancho de pulso medido que se traduce en una **distancia relativa** (`relative_distance`).
- Muestra la distancia:
  - En el display de 7 segmentos (valor numérico).
  - Opcionalmente en la LCD como una barra o región cuya longitud depende de la distancia medida.
- Demuestra el flujo completo: pulso de trigger → eco medido → valor digital → visualización.

---

## 3.18 `3_18_rotary_encoder`

**Tema:** encoder rotatorio (KY-040) + TM1638 + ayuda visual en la LCD.  
**Qué hace:**

- Conecta un encoder KY-040 a `gpio[3:2]`:
  - `gpio[3]` = CLK (fase A).
  - `gpio[2]` = DT  (fase B).
- Usa `sync_and_debounce` para sincronizar y filtrar las señales del encoder.
- Usa `rotary_encoder` para convertir los pulsos en un valor entero `value`.
- Muestra `value`:
  - En el display de 7 segmentos (TM1638).
  - En los LEDs (8 bits menos significativos).
  - En la LCD como un “umbral” vertical: para `x > value`, la región se pinta en azul.
- Sirve como base para controles interactivos (menús, ajustes de parámetros, etc.) usando el encoder como entrada principal.

---
