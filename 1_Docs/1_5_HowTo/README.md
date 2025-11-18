# 1.5 Howto – Guías rápidas para no perderte

La carpeta `1_5_howto` reúne **guías prácticas y cortas** para ayudarte a:

- Saber **cómo conectar** tu hardware.
- Entender **cómo fluye el código** entre módulos.
- **Correr** simulación, síntesis y programación sin adivinar.
- Salir de errores típicos con un **checklist de troubleshooting**.

La idea es que, cuando abras cualquier actividad, lab o implementación, tengas aquí un “manual de uso rápido” del repositorio.

---

## 0. Contenido de esta carpeta

Dentro de `1_5_howto` encontrarás:

- `1_5_1_connections/`  
  **Qué es:** Guía de conexiones físicas.  
  **Para qué sirve:**  
  - Ver cómo conectar Tang Nano 9K con:
    - TM1638  
    - Sensor ultrasónico HC-SR04  
    - Encoder rotatorio KY-040  
    - Potenciómetro / ADC  
    - LCD 480×272  
  - Incluye una subcarpeta `Mult/` con la conexión “todo junto”.  
  **Úsalo cuando:**  
  - No recuerdes qué va en cada pin.  
  - Estés montando el hardware por primera vez.

- `1_5_2_code_flow/`  
  **Qué es:** Explicación de **cómo fluye el código** dentro del repo.  
  **Para qué sirve:**  
  - Entender la relación entre:
    - `board_specific_top.sv` (top real del FPGA)  
    - `hackathon_top.sv` (tu código en Activities/Labs/Implementation)  
    - Módulos de `peripherals/` y `labs/common/`.  
  - Saber de dónde salen señales como `clock`, `slow_clock`, `x`, `y`, `abcdefgh`, `digit`, `gpio`.  
  **Úsalo cuando:**  
  - No sepas “dónde escribir” tu lógica.  
  - Quieras seguir el camino desde un botón/sensor hasta los LEDs/LCD.

- `1_5_3_how_to_run/`  
  **Qué es:** Paso a paso para **simular, sintetizar y programar**.  
  **Para qué sirve:**  
  - Saber qué script correr en cada carpeta:
    - `01_simulate.bash` (si existe)  
    - `03_synthesize_for_fpga.bash`  
    - `04_program_fpga.bash`  
  - Entender desde qué carpeta se ejecuta cada script.  
  **Úsalo cuando:**  
  - Sea la primera vez que corres una práctica.  
  - No recuerdes el orden: simular → sintetizar → programar.

- `1_5_4_troubleshooting_and_pitfalls/`  
  **Qué es:** Lista de **errores típicos y precauciones**.  
  **Para qué sirve:**  
  - Interpretar mensajes de Gowin (`EX3937`, “unknown module…”, “black box…”, etc.).  
  - Detectar problemas de:
    - Módulos no añadidos al proyecto.  
    - Conexiones de hardware (GND, 3.3 V vs 5 V, pines equivocados).  
    - Scripts `.bash` en Windows (Git Bash, rutas, Gowin no encontrado).  
    - Pitfalls de SystemVerilog (latches, `always_comb`, tamaños de buses).  
  - Incluye un **checklist** antes de pedir ayuda.  
  **Úsalo cuando:**  
  - Algo no funciona y no sabes si es código, síntesis o hardware.  
  - Quieras ver errores reales que ya ocurrieron y cómo se corrigieron.

---

## 1. Cómo usar estas guías en la práctica

Una forma sencilla de aprovechar `1_5_howto` es:

1. **Antes de conectar nada:**  
   Lee rápidamente `1_5_1_connections`  
   → te ahorra invertir VCC/GND o usar mal un pin.

2. **Antes de modificar código grande:**  
   Revisa `1_5_2_code_flow`  
   → te dice dónde va tu lógica (`hackathon_top.sv`) y qué módulos ya existen para reutilizar.

3. **Antes de correr scripts:**  
   Mira `1_5_3_how_to_run`  
   → te indica desde qué carpeta correr `bash 03_synthesize_for_fpga.bash` y qué esperar.

4. **Cuando algo revienta o no hace nada en la placa:**  
   Abre `1_5_4_troubleshooting_and_pitfalls`  
   → usa el checklist de errores típicos y revisa conexiones/síntesis antes de seguir.

---

## 2. Cuándo NO necesitas leer todo

No es necesario leer las cuatro guías completas cada vez.  
Piensa así:

- **Solo hardware / cableado nuevo:**  
  → `1_5_1_connections`.

- **Duda de “quién instancia a quién”:**  
  → `1_5_2_code_flow`.

- **Quiero correr una práctica que ya está lista:**  
  → `1_5_3_how_to_run` (ver sección de scripts).

- **Algo falla y no sé por qué:**  
  → `1_5_4_troubleshooting_and_pitfalls`.

---

## 3. Relación con otras carpetas del repo

`1_5_howto` está pensado como un **puente** entre:

- `Docs/Overview` / teoría general, y  
- las carpetas de trabajo real:
  - `4_Activities/`
  - `5_Labs/`
  - `6_Implementation/`

La idea es que:

- No tengas que adivinar cómo se corre cada cosa.
- No repitas errores de conexiones o de síntesis que ya se documentaron.
- Puedas moverte de una práctica a otra con una **base común de uso del repositorio**.

---

## 4. Resumen rápido

- `1_5_1_connections` → **Cómo cablear todo** (Tang + TM1638 + sensores + LCD).  
- `1_5_2_code_flow` → **Cómo se conectan los módulos** (`board_specific_top` → `hackathon_top` → peripherals).  
- `1_5_3_how_to_run` → **Qué scripts usar y en qué orden** para ver algo en la placa.  
- `1_5_4_troubleshooting_and_pitfalls` → **Errores típicos, precauciones y checklist** cuando nada funciona.

Si antes de empezar cada tema pasas 2–3 minutos revisando la guía correspondiente, vas a ahorrar mucho tiempo de prueba y error después.
