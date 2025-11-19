# labs_common – Módulos de uso compartido para los labs

Este directorio contiene **módulos SystemVerilog de uso común** para los laboratorios
del proyecto, especialmente para la placa **Tang Nano 9K** con la configuración  
`tang_nano_9k_lcd_480_272_tm1638_hackathon`.

En lugar de repetir el mismo código en cada lab, aquí se concentran bloques
reutilizables (drivers, helpers y utilidades) que luego se instancian desde
los distintos `hackathon_top.sv`.

> **Origen:** estos módulos se basan en el proyecto original de  
> **“basic-graphics” para FPGAs**, desarrollado por **Mr. Panchul**.  
> En ese proyecto se usan como “piezas base” para muchos ejemplos en
> diferentes boards.  
> En este repositorio se han **adaptado** para trabajar principalmente con
> la Tang Nano 9K, pero la autoría original de la idea y de gran parte del
> código base corresponde a **Mr. Panchul** y al proyecto *basic-graphics*.

---

## 1. Propósito del directorio

El objetivo de `labs_common` es:

- Proveer **bloques reutilizables** que se comparten entre varios labs
  (por ejemplo, el driver del display de 7 segmentos).
- Centralizar la lógica “genérica” para que:
  - Se mantenga en **un solo lugar**.
  - Sea más fácil corregir errores o mejorarla sin editar todos los labs.
- Mantener los archivos de cada lab (`5_1`, `5_2`, …) más limpios y enfocados
  en el concepto principal del ejercicio.

---

## 2. Contenido típico

La lista exacta de archivos puede variar según la versión del repositorio, pero en
general se encuentran módulos como:

- `seven_segment_display.sv`  
  Driver multiplexado de **display de 7 segmentos** (8 dígitos), tomado y
  adaptado del proyecto *basic-graphics*:
  - Recibe un bus `number` empaquetado en nibbles (4 bits por dígito).
  - Recibe un vector `dots` para controlar los puntos decimales.
  - Genera las señales `abcdefgh` y `digit` que se conectan al hardware.
  - Se usa en varias actividades y labs relacionados con 7 segmentos
    (por ejemplo, contadores hexadecimales y “playgrounds”).

- Otros módulos de apoyo reutilizables  
  (según la versión del proyecto pueden incluir, por ejemplo,
  pequeñas utilidades de división de reloj, empaquetado de dígitos, etc.).
  Todos siguen la filosofía de:
  - Tener **interfaces limpias y documentadas**.
  - Ser fáciles de conectar desde `hackathon_top.sv`.
  - Poderse reutilizar en múltiples ejemplos sin modificación.

Cuando se añada un nuevo módulo genérico, la recomendación es colocarlo aquí, en
`labs_common`, si se va a usar en más de un lab.

---

## 3. Uso desde los labs

En los archivos de laboratorio (`5_Labs/5_xx_*/hackathon_top.sv`) es común ver:

- Una **instanciación** de algún módulo de `labs_common`, por ejemplo:

    seven_segment_display #(.w_digit(8)) i_7segment (
        .clk      ( clock      ),
        .rst      ( reset      ),
        .number   ( number_reg ),
        .dots     ( dots_reg   ),
        .abcdefgh ( abcdefgh   ),
        .digit    ( digit      )
    );

- Algún bloque que prepara las señales de entrada para ese módulo, por ejemplo:

    // number_reg y dots_reg se preparan en hackathon_top
    // a partir de contadores, modos, lecturas de sensores, etc.

En los scripts de síntesis (`03_synthesize_for_fpga.bash` o el proyecto Tcl de Gowin)
los archivos de `labs_common` deben estar incluidos explícitamente para que el
sintetizador pueda encontrar las definiciones.

---

## 4. Buenas prácticas

Al trabajar con este directorio se recomienda:

- Mantener los módulos **lo más genéricos posible** y sin dependencias innecesarias.
- Documentar en comentarios:
  - Propósito del módulo.
  - Puertos de entrada y salida.
  - Parámetros configurables (`parameter`, `localparam`).
- No introducir lógica específica de un lab dentro de `labs_common`; si un cambio solo
  aplica a un ejercicio concreto, es mejor dejarlo en su `hackathon_top.sv`.

---

## 5. Relación con otros directorios

- `5_Labs/`  
  Contiene los **laboratorios individuales**, cada uno con su propio
  `hackathon_top.sv` que instancia módulos de `labs_common` y de otros directorios.

- `peripherals/`  
  Incluye módulos específicos de **hardware externo** (sensores, TM1638, etc.).
  Mientras que `labs_common` se centra en lógica de apoyo general, `peripherals`
  se enfoca en drivers de dispositivos concretos, muchos de ellos también
  originados o inspirados en el proyecto *basic-graphics* de Mr. Panchul.

- `scripts/`  
  Contiene scripts para **síntesis, lugar y ruta y programación** (por ejemplo,
  `03_synthesize_for_fpga.bash`), basados en la estructura de trabajo del
  proyecto *basic-graphics* y adaptados para este repositorio.

En conjunto, `labs_common` funciona como una **biblioteca de bloques reutilizables** que hace que los labs sean más cortos, claros y fáciles de mantener, manteniendo el reconocimiento al trabajo original de **Mr. Panchul** y del proyecto **basic-graphics**.
