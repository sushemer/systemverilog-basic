# 1.5.4 Troubleshooting and Pitfalls – Errores típicos y cómo evitarlos

Este documento resume los **problemas más comunes** al trabajar con este repositorio y con la Tang Nano 9K, más **precauciones** para evitarlos.

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
  - su `fpga_project.tcl`, o
  - el script `03_synthesize_for_fpga.bash`.
- Copio `hackathon_top.sv` de otra actividad, pero **no copio** los módulos de soporte (por ejemplo, de `3_18_*`).

**Cómo arreglarlo:**

1. Busque el módulo en el repo:
   - `peripherals/` (sensores, TM1638, LCD)
   - `labs/common/` (seven_segment, contadores, etc.)
   - alguna actividad anterior (`3_17`, `3_18`, etc.) si lo está reciclando.
2. Asegúrase de que el archivo `.sv` aparece en la lista de:
   - `add new file: "..."` que imprime `03_synthesize_for_fpga.bash`, o
   - en el `fpga_project.tcl` correspondiente.

---

### 1.2 `Module 'hackathon_top' remains a black box due to errors in its contents`

**Qué significa:**  
Hay errores dentro de `hackathon_top.sv` (o módulos que instancia), así que para la herramienta ese módulo es “caja negra” y no puede seguir.

**Causas típicas:**

- Errores de sintaxis (`;` faltante, `end`/`endcase`/`endfunction` mal alineados).
- Módulos desconocidos (ver 1.1).
- Señales mal declaradas.

**Qué hacer:**

- Revisar los errores anteriores en el log; casi siempre hay una línea antes con la causa real.
- Abrir `hackathon_top.sv` y corregir .

---

### 1.3 `WARN (EX3791) : Expression size X truncated to fit in target size Y`

**Qué significa:**  
Está asignando un valor de **más bits** a un vector de **menos bits**. La herramienta recorta (trunca) los bits más altos.

Ejemplo típico:

```sv
localparam int W_DIV = 24;
logic [W_DIV-1:0] div_cnt;   // 24 bits
logic [22:0] algo;           // 23 bits

assign algo = div_cnt;       // Warning: 24 → 23
```

## 3. Problemas al correr los scripts `.bash`

En este repositorio es habitual usar scripts como:

- `00_run_all.bash`
- `01_simulate_*.bash`
- `02_build_bitstream.bash`
- `03_synthesize_for_fpga.bash`

para automatizar simulación, síntesis y programación.

### 3.1 `00_run_all.bash` / “run all” falla de forma general

**Síntoma:**

- Al ejecutar `00_run_all.bash` (o el script “run all” equivalente) aparece un error genérico:
  - El script termina con código distinto de 0.
  - Solo se ve un mensaje final de fallo, sin detalles claros.

**Qué significa:**

- Alguna de las etapas internas (simulación, síntesis, empaquetado, etc.) falló.
- El script “run all” solo refleja que **algo** salió mal, pero no siempre muestra la causa directa al final.

**Qué hacer:**

1. Revisar el log completo del script:
   - Desplazarse hacia arriba en la terminal.
   - Buscar la **primera aparición** de `ERROR`, `FATAL` o mensajes de Gowin.
2. Ejecutar por separado la etapa problemática:
   - Por ejemplo:
     - `03_synthesize_for_fpga.bash`, o
     - `02_build_bitstream.bash`.
   - Esto suele mostrar mensajes más claros y manejables.
3. Volver a la guía de troubleshooting y comparar el mensaje con las secciones de errores de síntesis y lógica.

### 3.2 Scripts que no se ejecutan en absoluto

**Síntomas:**

- Mensaje tipo `permission denied` al intentar ejecutar `.bash`.
- En Windows/PowerShell, los scripts parecen no hacer nada.

**Revisar:**

- Permisos de ejecución en sistemas tipo Unix:
  - `chmod +x 00_run_all.bash`
- Ruta correcta:
  - Estar ubicado en la carpeta donde está el script, o usar la ruta completa.
- En Windows:
  - Considerar usar **WSL** o Git Bash para ejecutar scripts `.bash`.
  - Verificar que los finales de línea sean estilo Unix (LF) si aparecen problemas extraños.

---

## 4. Pitfalls de lógica en SystemVerilog

### 4.1 Asignaciones bloqueantes vs no bloqueantes

En lógica secuencial (dentro de `always_ff`) se recomienda usar **asignaciones no bloqueantes** (`<=`):

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0;
        end
        else begin
            q <= d;
        end
    end

Errores comunes:

- Usar `=` dentro de `always_ff` y mezclarlo con `<=` en el mismo bloque:
  esto puede generar simulaciones que no coinciden con el hardware.
- Usar `<=` dentro de `always_comb`:
  no siempre es error fatal, pero confunde la intención (es preferible `=`).

Regla práctica:

- `always_ff` → usar **`<=`** (no bloqueante).
- `always_comb` → usar **`=`** (bloqueante).

---

### 4.2 Lógica combinacional incompleta → latches

Ejemplo típico:

    always_comb begin
        if (sel)
            y = a;
        // Falta el caso 'else' → y mantiene valor anterior (latch)
    end

Síntoma:

- El sintetizador puede advertir sobre latches inferidos.
- El comportamiento en hardware se vuelve difícil de razonar.

Soluciones:

- Asignar un valor por defecto al inicio del `always_comb`, o cubrir todos los casos:

      always_comb begin
          y = '0;       // valor por defecto
          if (sel)
              y = a;
      end

- Usar `unique case` o `priority case` cuando corresponda y asegurarse de que todos los valores posibles de la entrada están cubiertos (incluyendo `default` cuando tiene sentido).

---

### 4.3 Condiciones con rangos y errores “off-by-one”

Al dibujar en la LCD o al usar comparaciones con contadores, es fácil cometer errores “off-by-one”:

    if (x >= 100 && x <= 150) begin
        // ¿incluye realmente todos los píxeles deseados?
    end

Sugerencias:

- Tener claro si el límite debe ser `<` o `<=`.
- Comprobar con ejemplos concretos de `x` y `y` en papel.
- Usar constantes bien nombradas (`RECT_X_LEFT`, `RECT_X_RIGHT`, etc.) para evitar confusiones.
- Revisar el ancho de los vectores: si `x` es de 9 bits, asegurarse de que las constantes también tengan el rango adecuado.

---

### 4.4 Uso de clocks y resets

Pitfalls frecuentes:

- Crear “clocks derivados” usando lógica combinacional en lugar de usar **enables** o divisores internos.
- Mezclar resets síncronos y asíncronos sin una razón clara.
- No sincronizar señales que vienen del exterior (botones, sensores) al dominio de reloj principal.

Recomendaciones:

- Mantener, en lo posible, **un solo dominio de reloj principal** (`clock`).
- Generar ticks o enables lentos usando contadores, en lugar de nuevos relojes.
- Sincronizar entradas externas con un par de flip-flops antes de usarlas en lógica secuencial.

---

## 5. Errores reales que ya han pasado

Algunos problemas que ya se han visto en prácticas reales:

- Olvidar la **tierra común** entre Tang Nano y módulos externos:  
  resultado: sensores que no responden o lecturas inestables.
- Conectar señales de **5 V directamente** a pines de **3.3 V**:  
  puede dañar pines o provocar comportamientos erráticos en entradas/salidas.
- Copiar `hackathon_top.sv` de otro ejemplo sin ajustar los **puertos**:  
  el diseño compila, pero los pines no corresponden con el cableado real.
- Modificar el archivo `.cst` a mitad del proyecto sin actualizar la documentación:  
  el código parece correcto, pero la tarjeta está cableada para la asignación anterior.
- Ejecutar `run_all` en la carpeta equivocada:  
  el script no encuentra los archivos esperados y falla con mensajes confusos (por ejemplo, que no existe el `board_specific_top` o que faltan fuentes).

La intención de este listado es que, si algo suena familiar, se pueda revisar esa parte antes de asumir que el problema está en la herramienta o en la FPGA.

---

## 6. Checklist rápido antes de pedir ayuda

Antes de solicitar apoyo a otra persona, se recomienda:

1. **Revisar el log de síntesis / `run_all`**  
   - Localizar el **primer** error o warning importante (muchas veces los mensajes posteriores son consecuencia de ese primer fallo).

2. **Verificar módulos instanciados**  
   - Confirmar que todos los archivos `.sv` correspondientes están añadidos al proyecto o a los scripts:
     - `03_synthesize_for_fpga.bash`
     - `fpga_project.tcl`
   - Comprobar nombres de módulo vs. nombres de archivo.

3. **Comprobar conexiones básicas de hardware**  
   - Alimentación y GND común.
   - Wiring de sensores, TM1638, LCD y demás periféricos.
   - Que no haya cables sueltos o invertidos (por ejemplo, `TRIG` y `ECHO` cruzados).

4. **Probar un ejemplo conocido**  
   - Ejecutar alguno de los ejemplos de referencia:
     - `3_16_tm1638_quickstart`
     - `3_13_lcd_basic_shapes`
     - otro que ya se haya verificado en clase.
   - Si el ejemplo de referencia tampoco funciona, probablemente el problema sea de **hardware / constraints / entorno**, no de tu lógica.

5. **Revisar la lógica básica en el código propio**  
   - Uso coherente de `always_ff` / `always_comb`.
   - Asignaciones bloqueantes vs no bloqueantes.
   - Rangos de comparaciones (`<` vs `<=`).
   - Anchos de buses y posibles truncamientos (warnings de tipo `Expression size X truncated...`).

6. **Verificar entorno y scripts**  
   - Confirmar que se está usando WSL / Git Bash (cuando aplique).
   - Revisar permisos de ejecución de los `.bash` (`chmod +x *.bash` si es necesario).
   - Asegurarse de estar en la carpeta correcta antes de correr `./run_all`.
   - Si `run_all` falla, revisar en qué paso lo hace (simulación, síntesis, programación).

Si después de seguir este checklist el problema continúa, será más sencillo recibir ayuda si se comparte:

- El mensaje de error **exacto** (copiado del log o terminal).
- Una breve descripción de lo que se esperaba ver en la tarjeta.
- El ejemplo o actividad específica donde ocurre el fallo.

Correo: diego.peralta52@uabc.edu.mx