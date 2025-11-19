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

- Repo clonado en tu PC (por ejemplo en `C:\Users\USUARIO\Documentos\GitHub\systemverilog-basic`).
- Tang Nano 9K conectada por USB.
- **Gowin EDA** instalada (por ejemplo en `C:\Gowin\Gowin_V1.9.xx...`).
- Una terminal tipo **Git Bash / MSYS2 / WSL** donde puedas correr:
  - `bash ...`
  - herramientas de Gowin (`gw_sh.exe`, `programmer_cli.exe`) a través de los scripts.

> Nota: El script de síntesis (`03_synthesize_for_fpga.bash`) suele detectar automáticamente la instalación de Gowin en `C:\Gowin\...`. Si la tiene en otro lugar, deberá ajustar el script.

---

## 1. Dónde parar (carpeta correcta)

Cada **actividad/lab/implementación** tiene su propia carpeta, por ejemplo:

- `4_Activities/4_9_1_logic_gates_and_demorgan`
- `4_Activities/4_9_8_sensors_and_tm1638_integration`
- `5_Labs/5_1_counter_hello_world`

Dentro de esa carpeta normalmente encontrará:

- `hackathon_top.sv` → TU módulo principal para esa práctica.
- `fpga_project.tcl` → Proyecto de Gowin (usado por los scripts).
- Scripts tipo:
  - `01_simulate.bash`, `02_simulate_and_view.bash`
  - `03_synthesize_for_fpga.bash`
  - `04_program_fpga.bash` 
  - `05_run_gui_for_fpga_synthesis`

**Regla práctica:**  
Para correr algo de una práctica, **abre la terminal en la carpeta de esa práctica**.

Ejemplo:

```bash
cd /c/Users/USUARIO/Documentos/GitHub/systemverilog-basic/4_Activities/4_9_8_sensors_and_tm1638_integration
```

---

## 2. Flujo típico (rápido)

El flujo más habitual es:
1. Sintetizar: `bash 03_synthesize_for_fpga.bash`
2. Probar en la placa: mover teclas, sensores, etc.

---

## 3. Síntesis para FPGA (Gowin)

Este es el paso que **siempre** harás para ver algo en la placa.

1. Abra su terminal (Git Bash / MSYS2 / WSL).
2. Vaya a la carpeta de la práctica, por ejemplo:

   ```bash
   cd /c/Users/TU_USUARIO/Documentos/GitHub/systemverilog-basic/4_Activities/4_9_8_sensors_and_tm1638_integration
   ```

3. Ejecute:

   ```bash
   bash 03_synthesize_for_fpga.bash
   ```

### ¿Qué debe observar?

En la terminal verá algo como:

- `GowinSynthesis start`
- Listado de archivos analizados (`Analyzing Verilog file ...`)
- `Compiling module ...`
- Al final, algo tipo `GowinSynthesis finish`

Si hay problemas:

- **WARN** → advertencias (puede seguir, pero conviene revisar).
- **ERROR** → se detiene, no se genera bitstream.

Para entender errores típicos, revisa luego `1_5_4_pitfalls` (precauciones y errores comunes).

---

