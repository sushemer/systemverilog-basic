# 4_9_solutions · Soluciones del Módulo 4

Este directorio contiene las **soluciones de referencia** para las actividades del módulo 4.

Cada subcarpeta corresponde a una actividad de `4_Activities` y suele contener:

- `hackathon_top.sv` → versión **resuelta** de la actividad.
- `README.md` → explicación breve de la solución, modos y decisiones de diseño.

> **Recomendación:**  
> Usa estas soluciones solo **después** de intentar resolver la actividad en `4_Activities`.  
> El objetivo es aprender comparando tu enfoque con uno de referencia, no solo copiar código.

---

## Mapeo actividades ↔ soluciones

| Solución                                   | Basado en actividad                          | Descripción rápida                                |
|-------------------------------------------|----------------------------------------------|---------------------------------------------------|
| `4_9_1_logic_gates_and_demorgan/`         | `4_01_logic_gates_and_demorgan`              | Compuertas, De Morgan, funciones de 3 entradas y EN |
| `4_9_2_mux_and_decoder_composition/`      | `4_02_mux_and_decoder_composition`           | Decoder 2→4 + mux 4→1 con AND/OR + visualización en LEDs |
| `4_9_3_priority_encoder_and_valid_flag/`  | `4_03_priority_encoder_and_valid_flag`       | Priority encoder 3→2 con bandera `valid`          |
| `4_9_4_mini_alu_4bit/`                    | `4_04_mini_alu_4bit`                         | Mini ALU 4 bits (suma, resta, lógicas, carry, zero) |
| `4_9_5_counters_and_shift_patterns/`      | `4_05_counters_and_shift_patterns`           | Divisor de frecuencia + patrones de LEDs (counter/shift) |
| `4_9_6_seven_segment_playground/`         | `4_06_seven_segment_playground`              | Experimentos con display de 7 segmentos y modos   |
| `4_9_7_lcd_hello_and_basic_graphics/`     | `4_07_lcd_hello_and_basic_graphics`          | Marco en LCD + franja “HELLO” en bloques + barra inferior |
| `4_9_8_sensors_and_tm1638_integration/`   | `4_08_sensors_and_tm1638_integration`        | HC-SR04 + KY-040 + bar graph en LEDs + TM1638 en HEX |

---

## Convenciones de nombres

- Carpeta de solución:  
  `4_9_X_nombre_de_la_actividad/`

- Archivo principal:  
  `hackathon_top.sv` (mismo nombre que en `4_Activities`, pero ya resuelto).

- En muchos casos hay también:  
  `README.md` con:
  - Descripción de los modos (`key`, `switches`, `gpio`).
  - Explicación de cómo se usan displays, LEDs, LCD, etc.
  - Ideas de extensiones o mejoras.

---

## Cómo usar estas soluciones

1. **Resuelve primero la actividad en `4_Activities`.**
2. Luego abre la solución correspondiente en `4_9_solutions/`.
3. Compara:
   - Cómo se mapean las señales (`key`, `led`, `gpio`).
   - Cómo se estructuran los `always_comb` y `always_ff`.
   - Cómo se implementan:
     - decoders/mux,
     - prioridad,
     - ALU,
     - divisores de frecuencia,
     - drivers de display,
     - integración de sensores.

4. Si algo no se entiende, puedes:
   - Hacer un diff (por ejemplo, con Git o un editor tipo VS Code).
   - Agregar comentarios propios sobre el código de referencia.

---

## Ejemplo: solución 4_9_8 (sensores + TM1638)

- Integra:
  - `ultrasonic_distance_sensor` (HC-SR04).
  - `sync_and_debounce` + `rotary_encoder` (KY-040).
  - `seven_segment_display` (TM1638).

- Modos (`key[1:0]`):
  - `00`: distancia relativa.
  - `01`: valor del encoder.
  - `10`: combinación (distancia + encoder).
  - `11`: apagado/0.

- Visualización:
  - LEDs: barra de nivel basada en bits altos de `sensor_value`.
  - 7 segmentos: `sensor_value` en HEX.

Este patrón (sensores → valor → visualización en LEDs + display) es reutilizable para otros proyectos.

---

## Nota final

Estas soluciones están pensadas como **material de estudio**, no solo como “respuesta”.  
Puedes:

- Tomarlas como base para proyectos más grandes.
- Modificar constantes, modos y mapeos de pines.
- Añadir nuevas funciones (más operaciones en la ALU, más patrones de LEDs, textos en LCD, etc.).

La idea es que el módulo 4 sea tu “caja de herramientas” inicial para seguir jugando con SystemVerilog + FPGA 
