# 2.4 Common · Protoboard y cableado

La carpeta `2_4_Common` reúne notas generales sobre **protoboard**, **cableado** y **buenas prácticas** al conectar la Tang Nano 9K con los sensores y actuadores del repositorio.

No describe un dispositivo específico, sino reglas y recomendaciones que se aplican a:

- HC-SR04.
- Rotary encoder.
- Botones/switches.
- Displays de 7 segmentos.
- Módulo TM1638.
- LCD 16x2.

---

## 1. Protoboard · Idea general

El **protoboard** permite hacer conexiones temporales sin soldar.  
Reglas típicas (modelo estándar):

- Las **filas centrales** están unidas en grupos de 5 agujeros.
- Las **líneas laterales** (marcadas con + y −) suelen ser rieles de alimentación:
  - Una línea para **VCC**.
  - Una línea para **GND**.

Recomendaciones:

- Reservar un riel para **3.3 V** (lógica de la FPGA).
- Si se usa un módulo a 5 V (por ejemplo, HC-SR04), tener claro:
  - Dónde están los 5 V.
  - Cómo se adapta el nivel hacia la FPGA (especialmente en señales de entrada).

---

## 2. GND común

Regla básica para todo el repositorio:

> **Todos los módulos deben compartir la misma GND que la Tang Nano 9K.**

Esto aplica a:

- HC-SR04 (incluso si se alimenta a 5 V).
- TM1638.
- Rotary encoder.
- LCD 16x2.
- Cualquier otra placa o fuente auxiliar.

Sin GND común:

- Las referencias de voltaje no coinciden.
- Las señales que “parecen” 0/1 en un módulo pueden no ser interpretadas correctamente por la FPGA.

---

## 3. Voltajes típicos

- La **Tang Nano 9K** trabaja a **3.3 V** en sus pines de IO.
- Algunos módulos (como HC-SR04, ciertos TM1638 o LCD 16x2) suelen trabajar a **5 V**.

Regla general:

- **Nunca** conectar directamente una salida de 5 V a una entrada de la FPGA sin revisar:
  - Hoja de datos del módulo.
  - Recomendaciones de adaptación de nivel.

Ejemplo importante:

- **HC-SR04 → ECHO**:
  - Normalmente sale a 5 V.
  - Debe pasar por un divisor resistivo o level shifter antes de llegar a la FPGA.

---

## 4. Cables y organización

Para facilitar la reproducción de los ejemplos:

- Usar **cables cortos** cuando sea posible.
- Evitar que los cables crucen por encima de la placa sin necesidad.
- Mantener un código de colores aproximado (recomendado, no obligatorio):
  - **Rojo** → VCC.
  - **Negro** → GND.
  - Otros colores → señales (`clk`, `tm_clk`, `lcd_rs`, etc.).

Sugerencia práctica:

- Documentar en los READMEs de cada ejemplo/lab:
  - A qué riel va cada VCC/GND.
  - Qué color de cable se usó (opcional, pero ayuda en laboratorio).

---

## 5. Ejemplos típicos de montaje

### 5.1 HC-SR04

- `VCC` → riel de **5 V** (fuente o módulo regulador).
- `GND` → riel de **GND** común con la Tang Nano 9K.
- `TRIG` → pin GPIO de la FPGA (3.3 V).
- `ECHO` → pin GPIO **a través de** un divisor o level shifter.

### 5.2 Rotary encoder

- `VCC` → riel de **3.3 V** (si el módulo lo permite; revisar especificación).
- `GND` → riel de **GND**.
- `ENC_A`, `ENC_B`, `ENC_SW` → pines de entrada de la FPGA.

### 5.3 7 segmentos / TM1638 / LCD 16x2

- Alimentación según módulo (3.3 V o 5 V, revisar siempre).
- Señales de datos/control a pines GPIO de la Tang Nano 9K.
- En su README correspondiente se detallan:
  - Nombres de señales recomendados.
  - Pines sugeridos.
  - Notas adicionales (por ejemplo, brillo, contraste, etc.).

---

## 6. Archivos y assets comunes

En esta carpeta se pueden incluir:

- Esquemas simples de conexión (diagramas de protoboard).
- Fotos de montajes de referencia.
- Plantillas genéricas para wiring (por ejemplo, marcando rieles de 3.3 V, 5 V y GND).

Se recomienda mantener estos recursos ligeros y centrados en:

- Claridad visual.
- Reutilización en varios ejemplos y laboratorios.
