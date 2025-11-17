# Módulo 4 · Activities  
**Board:** `tang_nano_9k_lcd_480_272_tm1638_hackathon`

Este directorio contiene las **plantillas de las actividades** del módulo 4.  
Cada subcarpeta incluye un `hackathon_top.sv` con comentarios y `TODOs` para que el estudiante complete la lógica.

La idea es que **primero intentes resolver las actividades aquí** y, solo después, revises las soluciones en `4_9_solutions`.

---

## Lista de actividades

| Carpeta                                  | Tema principal                                                |
|------------------------------------------|----------------------------------------------------------------|
| `4_01_logic_gates_and_demorgan`          | Compuertas lógicas, ley de De Morgan, funciones combinacionales |
| `4_02_mux_and_decoder_composition`       | Decoder 2→4 + composición con mux 4→1                          |
| `4_03_priority_encoder_and_valid_flag`   | Priority encoder 3→2 + bandera `valid`                         |
| `4_04_mini_alu_4bit`                     | Mini ALU de 4 bits (suma, resta, AND, XOR/OR, flags)           |
| `4_05_counters_and_shift_patterns`       | Contadores, divisores de frecuencia, patrones de desplazamiento en LEDs |
| `4_06_seven_segment_playground`          | Playground con display de 7 segmentos y animaciones            |
| `4_07_lcd_hello_and_basic_graphics`      | Gráficos básicos en LCD 480×272 + texto “HELLO” en bloques     |
| `4_08_sensors_and_tm1638_integration`    | Integración de sensores (HC-SR04, encoder) + TM1638            |

> Los nombres pueden variar ligeramente según el repositorio original, pero la estructura y el propósito se mantienen.

---

## Estructura típica de cada actividad

Dentro de cada carpeta encontrarás:

- `hackathon_top.sv`  
  Plantilla principal de la actividad.  
  Incluye:
  - Comentarios con el **objetivo**.
  - Mapeo de señales a `key`, `led`, `gpio`, etc.
  - Secciones marcadas con `// TODO:` para que completes la lógica.

- (Opcional) Otros módulos de apoyo  
  En la mayoría de los casos se reusan módulos compartidos desde:
  - `labs/common/`
  - `peripherals/`
  - `boards/`

---

## Cómo trabajar con estas actividades

1. **Lee el encabezado de `hackathon_top.sv`**  
   Ahí se explica el objetivo de la práctica y el mapeo de pines.

2. **Completa las secciones `// TODO:`**  
   - Empieza por las partes más simples (compuertas, asignaciones).
   - Luego pasa a composición (mux/decoder), ALU, etc.

3. **Simula (si aplica)**  
   - Si hay testbench, úsalo.  
   - Revisa que la lógica se comporte como esperas antes de sintetizar.

4. **Sintetiza y prueba en la FPGA**  
   Normalmente con los scripts del repo:
   - `01_simulate_*.bash` (si existe)
   - `03_synthesize_for_fpga.bash`

5. **Solo después** compara con las soluciones  
   Revisa `4_9_solutions` cuando ya tengas tu propia versión funcional.

---

## Sugerencia de orden pedagógico

1. `4_01_logic_gates_and_demorgan`  
2. `4_02_mux_and_decoder_composition`  
3. `4_03_priority_encoder_and_valid_flag`  
4. `4_04_mini_alu_4bit`  
5. `4_05_counters_and_shift_patterns`  
6. `4_06_seven_segment_playground`  
7. `4_07_lcd_hello_and_basic_graphics`  
8. `4_08_sensors_and_tm1638_integration`

Las últimas actividades (LCD y sensores) combinan varias ideas de las anteriores, por eso es recomendable avanzar en orden.
