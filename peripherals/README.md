# peripherals – Drivers y módulos para hardware externo

Este directorio contiene **módulos SystemVerilog específicos de hardware**  
(sensores, displays, placas de E/S, etc.) usados en las actividades y labs,
principalmente con la placa **Tang Nano 9K** en la configuración:

    tang_nano_9k_lcd_480_272_tm1638_hackathon

Aquí se agrupan los **drivers de dispositivos reales** (periféricos) para no
mezclarlos con la lógica de los ejercicios (`hackathon_top.sv`) ni con los
módulos genéricos de `labs_common`.

> Origen: la mayoría de estos módulos están basados o derivados del proyecto  
> **“basic-graphics” para FPGAs**, desarrollado por **Mr. Panchul**.  
> En ese proyecto se usan como drivers y bloques de apoyo para múltiples
> boards (Gowin, Altera, etc.).  
> En este repositorio se han **adaptado** para trabajar con Tang Nano 9K,
> pero la autoría original de la idea y de gran parte del código base
> corresponde a **Mr. Panchul** y al proyecto *basic-graphics*.
>  
> Este README solo documenta cómo se usan y cómo se integran en los labs,
> no reclama autoría sobre los archivos de este directorio.

---

## 1. Propósito del directorio

El objetivo de `peripherals` es:

- Reunir **todos los módulos que hablan directamente con hardware externo**:
  sensores, encoder, TM1638, LCD, etc.
- Mantener la lógica de cada lab/actividad más limpia, delegando aquí:
  - Timings específicos del dispositivo.
  - Protocolos de comunicación simples (señales, multiplexado, escaneo).
- Permitir **reutilizar** los mismos drivers en varias actividades sin copiar
  código.

En resumen, mientras `labs_common` contiene bloques más “genéricos” y de apoyo,
`peripherals` contiene los **drivers específicos de cada periférico físico**.

---

## 2. Contenido típico

La lista exacta de archivos puede variar según la versión del repositorio, pero
normalmente encontrarás módulos como:

- ultrasonic_distance_sensor.sv  
  Driver para el **sensor de ultrasonido HC-SR04**:
  - Genera el pulso de `TRIG`.
  - Mide el ancho de `ECHO` usando el reloj de la FPGA.
  - Entrega un valor de distancia relativa (`relative_distance`, por ejemplo de 16 bits)
    que luego se puede mapear a LEDs, LCD, TM1638, etc.
  - Se usa en actividades como:
    - Examples de ultrasonido.
    - Labs/activities de integración de sensores (LCD, TM1638).

- rotary_encoder.sv  
  Driver para el **encoder rotatorio KY-040**:
  - Recibe señales A/B (CLK/DT) ya sincronizadas y con debounce.
  - Detecta pasos en sentido horario/antihorario.
  - Mantiene un contador (por ejemplo `value[15:0]`) que aumenta/disminuye.
  - Se usa para ajustar parámetros, seleccionar modos, etc.

- sync_and_debounce.sv  
  Módulo genérico de **sincronización y eliminación de rebotes** (multi-bit):
  - Recibe un vector de entradas “lentas” (botones, líneas del encoder).
  - Las pasa por una cadena de flip-flops y lógica de filtro.
  - Entrega un vector limpio y sincronizado al reloj de la FPGA.
  - Uso típico:
    - Limpiar `key`, líneas A/B del encoder, señales de switches externos, etc.

- sync_and_debounce_one.sv  
  Variante de **un solo bit** (1-bit) de `sync_and_debounce`:
  - Más simple cuando solo se necesita limpiar una señal puntual.
  - Se usa, por ejemplo, para un solo botón de “step” o “reset externo”.

- Módulos TM1638 (nombre puede variar, p.ej. tm1638_board, tm1638_controller, etc.)  
  Drivers para la **placa TM1638** (8 dígitos 7seg + 8 LEDs + 8 teclas):
  - Implementan el protocolo de comunicación serie del TM1638.
  - Reciben:
    - Datos para los dígitos (nibbles hex).
    - Un patrón para los LEDs.
  - Entregan:
    - Lectura del estado de las teclas de la placa TM1638.
  - Se usan en actividades de:
    - Contadores en 7 segmentos.
    - Integración sensores + bar graph en los LEDs.

- Módulos de apoyo para LCD (nombres típicos en basic-graphics)  
  Dependiendo de cómo esté organizado el repositorio, pueden existir aquí
  componentes de apoyo para el LCD de 480x272 (o estar en otro directorio
  específico). En general:
  - Reciben coordenadas x/y y señales de sincronización.
  - Generan patrones de color, fondos, barras, etc.
  - Sirven como base para ejercicios tipo “HELLO” y gráficas simples.

Nota: los nombres concretos de archivo deben consultarse en el árbol del
repositorio, pero todos los módulos de este directorio comparten la idea de
ser **drivers de periféricos físicos**, muchos de ellos originalmente tomados
de *basic-graphics* y adaptados.

---

## 3. Uso desde labs y actividades

En los distintos `hackathon_top.sv` (por ejemplo, en:

- 4_Activities/4_xx_*/hackathon_top.sv
- 5_Labs/5_xx_*/hackathon_top.sv

es habitual ver instanciaciones de módulos de `peripherals`. Algunos ejemplos
típicos (escritos aquí a modo ilustrativo):

1) Uso de `ultrasonic_distance_sensor`:

    wire [15:0] distance_rel;

    ultrasonic_distance_sensor
    #(
        .clk_frequency           ( 27 * 1000 * 1000 ),
        .relative_distance_width ( 16 )
    )
    i_ultrasonic
    (
        .clk               ( clock        ),
        .rst               ( reset        ),
        .trig              ( gpio[0]      ),
        .echo              ( gpio[1]      ),
        .relative_distance ( distance_rel )
    );

2) Uso de `sync_and_debounce` + `rotary_encoder`:

    wire enc_a_raw = gpio[3];
    wire enc_b_raw = gpio[2];

    wire enc_a_deb;
    wire enc_b_deb;

    sync_and_debounce #(.w(2)) i_sync_and_debounce
    (
        .clk    ( clock                   ),
        .reset  ( reset                   ),
        .sw_in  ( { enc_b_raw, enc_a_raw }),
        .sw_out ( { enc_b_deb, enc_a_deb })
    );

    logic [15:0] encoder_value;

    rotary_encoder i_rotary_encoder
    (
        .clk   ( clock         ),
        .reset ( reset         ),
        .a     ( enc_a_deb     ),
        .b     ( enc_b_deb     ),
        .value ( encoder_value )
    );

En todos los casos, la lógica de alto nivel (selección de modo, escalado,
visualización en LEDs/LCD/TM1638) se implementa en `hackathon_top.sv`, mientras
que la **interacción de bajo nivel con el hardware** se delega a los módulos
de `peripherals`.

---

## 4. Inclusión en los scripts de síntesis

Para que Gowin (u otra toolchain) pueda usar estos módulos, es necesario:

- Incluir explícitamente los archivos de `peripherals`:
  - En el script `03_synthesize_for_fpga.bash`, o
  - En el archivo de proyecto Tcl (`fpga_project.tcl`), o
  - En el proyecto del IDE.

Si al sintetizar aparece un error del tipo:

    ERROR (EX3937) : Instantiating unknown module 'ultrasonic_distance_sensor'

o similar con `rotary_encoder`, `sync_and_debounce`, `tm1638_*`, etc., casi
siempre significa que **falta añadir el archivo correspondiente** de `peripherals`
al proyecto de síntesis.

Regla general:

- Si se instancia un módulo de `peripherals` en `hackathon_top.sv`,  
  su archivo `.sv` debe estar listado en los scripts/proyecto.

---

## 5. Buenas prácticas

Al trabajar con este directorio, se recomienda:

- Tratar estos módulos como una **biblioteca de drivers**:
  - No mezclar aquí lógica de un lab concreto.
  - Evitar “parchar” código localmente para un solo ejercicio; si se necesita
    un cambio específico, documentarlo o crear una variante clara.
- Mantener los comentarios en inglés (siguiendo el estilo de basic-graphics)
  o bilingües, pero sin borrar el crédito original.
- Si se agrega soporte para **un nuevo periférico**:
  - Crear un archivo nuevo en `peripherals` (por ejemplo `my_new_sensor.sv`).
  - Añadir una breve descripción en este README.
  - Actualizar los scripts de síntesis para incluirlo.

---

## 6. Relación con otros directorios

- boards/  
  Descripciones y soporte para distintas placas FPGA (pinouts, constraints, etc.),
  también inspiradas en el repositorio *basic-graphics*.

- labs_common/  
  Módulos genéricos reutilizables (por ejemplo, driver para display de 7 segmentos),
  independientes de un periférico físico concreto.

- 4_Activities/, 5_Labs/  
  Ejercicios y laboratorios que **instancian** los drivers de `peripherals`
  y los bloques de `labs_common` para construir ejemplos completos.

- scripts/  
  Scripts de automatización (síntesis, place&route, programación) basados en la
  estructura de trabajo de *basic-graphics* y adaptados a este repo.

En conjunto, `peripherals` aporta la “capa de hardware real” con sensores, displays y módulos externos, apoyándose en el trabajo previo de **Mr. Panchul** y del proyecto **basic-graphics**, y sirviendo como base para los labs y actividades de este repositorio.
