# 1.5.4 Troubleshooting and Pitfalls – Errores típicos y cómo evitarlos

Este documento resume los **problemas más comunes** al trabajar con este repositorio y con la Tang Nano 9K, más **precauciones** para evitarlos.

La idea es que, cuando algo “no funcione”, puedas revisar primero aquí antes de volverte loco 😅.

---

## 0. Mapa rápido

- [1. Errores típicos de síntesis (Gowin)](#1-errores-típicos-de-síntesis-gowin)
- [2. Problemas de conexiones / hardware](#2-problemas-de-conexiones--hardware)
- [3. Problemas al correr los scripts `.bash`](#3-problemas-al-correr-los-scripts-bash)
- [4. Pitfalls de lógica en SystemVerilog](#4-pitfalls-de-lógica-en-systemverilog)
- [5. Errores reales que ya han pasado](#5-errores-reales-que-ya-han-pasado)
- [6. Checklist rápido antes de pedir ayuda](#6-checklist-rápido-antes-de-pedir-ayuda)

---

## 1. Errores típicos de síntesis (Gowin)

### 1.1 `ERROR (EX3937) : Instantiating unknown module '...'`

**Qué significa:**  
Estás instanciando un módulo (por ejemplo `sync_and_debounce`, `rotary_encoder`, `ultrasonic_distance_sensor`) pero **Gowin no encuentra su definición**.

**Causas comunes:**

- El archivo `.sv` de ese módulo no está incluido en:
  - tu `fpga_project.tcl`, o
  - el script `03_synthesize_for_fpga.bash`.
- Copiaste `hackathon_top.sv` de otra actividad, pero **no copiaste** los módulos de soporte (por ejemplo, de `3_18_*`).

**Cómo arreglarlo:**

1. Busca el módulo en el repo:
   - `peripherals/` (sensores, TM1638, LCD)
   - `labs/common/` (seven_segment, contadores, etc.)
   - alguna actividad anterior (`3_17`, `3_18`, etc.) si lo estás reciclando.
2. Asegúrate de que el archivo `.sv` aparece en la lista de:
   - `add new file: "..."` que imprime `03_synthesize_for_fpga.bash`, o
   - en el `fpga_project.tcl` correspondiente.

> Regla de oro: **Si lo instancias, tiene que estar añadido al proyecto**.

---

### 1.2 `Module 'hackathon_top' remains a black box due to errors in its contents`

**Qué significa:**  
Hay errores dentro de `hackathon_top.sv` (o módulos que instancia), así que para la herramienta ese módulo es “caja negra” y no puede seguir.

**Causas típicas:**

- Errores de sintaxis (`;` faltante, `end`/`endcase`/`endfunction` mal alineados).
- Módulos desconocidos (ver 1.1).
- Señales mal declaradas.

**Qué hacer:**

- Revisa los errores anteriores en el log; casi siempre hay una línea antes con la causa real.
- Abre `hackathon_top.sv` y corrige los `TODO` incompletos, asignaciones, etc.

---

### 1.3 `WARN (EX3791) : Expression size X truncated to fit in target size Y`

**Qué significa:**  
Estás asignando un valor de **más bits** a un vector de **menos bits**. La herramienta recorta (trunca) los bits más altos.

Ejemplo típico:

```sv
localparam int W_DIV = 24;
logic [W_DIV-1:0] div_cnt;   // 24 bits
logic [22:0] algo;           // 23 bits

assign algo = div_cnt;       // Warning: 24 → 23
```
