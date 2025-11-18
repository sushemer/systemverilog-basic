# 1.5.3 How to run – Cómo simular, sintetizar y programar

Este documento explica **cómo correr los ejemplos** del repositorio:

- Simular (cuando haya testbench).
- Sintetizar para la Tang Nano 9K.
- Programar la FPGA y ver el resultado.

La idea es que puedas ir a **cualquier actividad/lab/implementación** y saber:

- Qué script usar.
- Desde qué carpeta ejecutarlo.
- Qué esperar como resultado.

---

## 0. Antes de empezar

### Requisitos básicos

- Repo clonado en tu PC (por ejemplo en `C:\Users\TU_USUARIO\Documentos\GitHub\systemverilog-basic`).
- Tang Nano 9K conectada por USB.
- **Gowin EDA** instalada (por ejemplo en `C:\Gowin\Gowin_V1.9.xx...`).
- Una terminal tipo **Git Bash / MSYS2 / WSL** donde puedas correr:
  - `bash ...`
  - herramientas de Gowin (`gw_sh.exe`, `programmer_cli.exe`) a través de los scripts.

> Nota: El script de síntesis (`03_synthesize_for_fpga.bash`) suele detectar automáticamente la instalación de Gowin en `C:\Gowin\...`. Si la tienes en otro lugar, deberás ajustar el script.

---

## 1. Dónde pararte (carpeta correcta)

Cada **actividad/lab/implementación** tiene su propia carpeta, por ejemplo:

- `4_Activities/4_9_1_logic_gates_and_demorgan`
- `4_Activities/4_9_8_sensors_and_tm1638_integration`
- `5_Labs/5_1_counter_hello_world`
- `6_Implementation/6_1_clock` (cuando exista)

Dentro de esa carpeta normalmente encontrarás:

- `hackathon_top.sv` → TU módulo principal para esa práctica.
- `fpga_project.tcl` → Proyecto de Gowin (usado por los scripts).
- Scripts tipo:
  - `03_synthesize_for_fpga.bash`
  - `04_program_fpga.bash` (si está presente)
- A veces:
  - `01_simulate.bash`, `02_simulate_and_view.bash` (si hay testbench).

**Regla práctica:**  
Para correr algo de una práctica, **abre la terminal en la carpeta de esa práctica**.

Ejemplo:

```bash
cd /c/Users/TU_USUARIO/Documentos/GitHub/systemverilog-basic/4_Activities/4_9_8_sensors_and_tm1638_integration
```

---

## 2. Flujo típico (rápido)

El flujo más habitual es:

1. (Opcional) Simular: `bash 01_simulate.bash`
2. Sintetizar: `bash 03_synthesize_for_fpga.bash`
3. Programar FPGA: `bash 04_program_fpga.bash`  
4. Probar en la placa: mover teclas, sensores, etc.

No todas las carpetas tienen todos los scripts, pero **síntesis (03)** casi siempre está.

---

## 3. Simulación (si la práctica la usa)

Algunas actividades o labs tienen testbench (`tb_*.sv`) y scripts para simular.  
Cuando veas un script de simulación, el uso típico es:

```bash
bash 01_simulate.bash
```

Ese script normalmente hace algo como:

- Llamar a un simulador (por ejemplo Icarus Verilog / iverilog).
- Compilar:
  - `hackathon_top.sv`
  - módulos auxiliares (`labs/common/*.sv`, `peripherals/*.sv`)
  - el testbench (`tb_*.sv`).
- Generar un archivo de ondas (`.vcd`) para ver en GTKWave.

Si existe un script `02_simulate_and_view.bash`, puede hacer:

```bash
bash 02_simulate_and_view.bash
```

y abrir directamente GTKWave con la traza.

> Si la práctica **no tiene testbench** ni scripts `01_*.bash`, simplemente pasa directo a síntesis.

---

## 4. Síntesis para FPGA (Gowin)

Este es el paso que **siempre** harás para ver algo en la placa.

1. Abre tu terminal (Git Bash / MSYS2 / WSL).
2. Ve a la carpeta de la práctica, por ejemplo:

   ```bash
   cd /c/Users/TU_USUARIO/Documentos/GitHub/systemverilog-basic/4_Activities/4_9_8_sensors_and_tm1638_integration
   ```

3. Ejecuta:

   ```bash
   bash 03_synthesize_for_fpga.bash
   ```

### ¿Qué hace internamente?

- Llama a `gw_sh.exe` de Gowin.
- Carga `fpga_project.tcl`.
- Añade los archivos necesarios:
  - `hackathon_top.sv`
  - `board_specific_top.sv` adecuado para Tang Nano 9K
  - `peripherals/*.sv`, `labs/common/*.sv`, etc.
- Corre:
  - Sintetizador
  - Place & route
  - Generación del bitstream (`.fs` o similar)

### ¿Qué debes observar?

En la terminal verás algo como:

- `GowinSynthesis start`
- Listado de archivos analizados (`Analyzing Verilog file ...`)
- `Compiling module ...`
- Al final, algo tipo `GowinSynthesis finish`

Si hay problemas:

- **WARN** → advertencias (puede seguir, pero conviene revisar).
- **ERROR** → se detiene, no se genera bitstream.

Para entender errores típicos, revisa luego `1_5_4_pitfalls` (precauciones y errores comunes).

---

## 5. Programar la Tang Nano 9K

Si la carpeta tiene un script de programación (por ejemplo `04_program_fpga.bash`), el flujo típico es:

1. **Conectar la placa** Tang Nano 9K por USB.
2. Confirmar que la síntesis ya terminó sin errores.
3. Correr:

   ```bash
   bash 04_program_fpga.bash
   ```

### ¿Qué hace internamente?

- Llama a `programmer_cli.exe` (Gowin Programmer en modo línea de comandos).
- Usa el bitstream generado en el paso de síntesis.
- Detecta la placa conectada (a veces por serie/USB).
- Descarga el diseño a la FPGA.

Si todo sale bien, la placa:

- Se reinicia con el nuevo diseño.
- Deberías ver:
  - LEDs cambiar según `hackathon_top.sv`.
  - TM1638 mostrando valores si la práctica lo usa.
  - LCD con gráficos si aplica.

> Nota: Si falla la detección de la placa, revisa cables, drivers USB y que **solo** una Tang Nano esté conectada.

---

## 6. ¿Cómo sé que elegí la práctica correcta?

Cuando programes y no veas lo que esperas, revisa:

1. Estás en la carpeta correcta:

   - `pwd` en la terminal (o mira la barra de ruta en tu editor).
   - Debe coincidir con la práctica que estás modificando.

2. El `hackathon_top.sv` que editas es el que `fpga_project.tcl` incluye.  
   (En este repositorio, cada carpeta tiene su propio `hackathon_top.sv` ligado a su `fpga_project.tcl`).

3. No dejaste errores de sintaxis (`ERROR (EX...)` en la salida de Gowin).

---

## 7. Combinar con otros howto

- Para ver **qué va conectado a qué pin**:
  - usa `1_5_1_connections` (imágenes y descripción de cableado).
- Para entender **cómo se conectan los módulos** (`board_specific_top`, `hackathon_top`, `peripherals`):
  - usa `1_5_2_code_flow`.
- Para revisar **errores típicos y problemas reales** que ya salieron:
  - usa `1_5_4_pitfalls` (cuando esté escrito).

Este documento (`1_5_3_how_to_run`) se centra en:  
**“Qué scripts usar y en qué orden para ver algo en la tarjeta”.**

---

## 8. Resumen exprés

1. Abre terminal en la carpeta de tu práctica:
   ```bash
   cd .../4_Activities/4_9_8_sensors_and_tm1638_integration
   ```

2. (Opcional) Simula si hay script:
   ```bash
   bash 01_simulate.bash
   ```

3. Sintetiza:
   ```bash
   bash 03_synthesize_for_fpga.bash
   ```

4. Programa la FPGA (si tienes script):
   ```bash
   bash 04_program_fpga.bash
   ```

5. Juega con:
   - `key[7:0]` (botones del módulo/placa),
   - `gpio[3:0]` (sensores: ultrasónico, encoder, potenciómetro vía ADC, etc.),
   - y mira las salidas en `led`, TM1638 y/o LCD según la práctica.

Si sigues estos pasos, deberías poder **correr cualquier actividad, lab o implementación** del repo sin perderte.
