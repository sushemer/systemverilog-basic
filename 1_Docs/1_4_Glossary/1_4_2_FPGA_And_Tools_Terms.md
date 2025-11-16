# 1.4.2 FPGA and tools terms

Términos relacionados con FPGAs, recursos internos y flujo de herramientas (toolchain).

---

### FPGA (Field Programmable Gate Array)

Circuito integrado configurable que contiene bloques lógicos, registros, memoria y recursos de interconexión.  
Permite implementar hardware digital personalizado después de fabricar el chip.  
La placa principal de este repositorio, Tang Nano 9K, integra una FPGA de Gowin.

---

### Fabric / logic fabric

Conjunto de recursos programables de la FPGA (LUTs, flip-flops, rutas de interconexión) donde se mapean los módulos RTL.  
Es el “tejido” interno que se configura a partir del bitstream.

---

### LUT (Look-Up Table)

Bloque de lógica programable que implementa funciones combinacionales.  
Recibe varias entradas y produce una salida según una tabla de verdad almacenada internamente.  
Las herramientas de síntesis traducen expresiones lógicas a redes de LUTs.

---

### IO / IO pin / IO bank

- **IO pin**: pin físico de entrada/salida de la FPGA, que puede conectarse a periféricos externos.  
- **IO bank**: grupo de pines que comparten características eléctricas (tensión, estándares).  

En este repositorio se documentan pines de la Tang Nano 9K en `2_devices/tang-nano-9k/`.

---

### Constraints / constraints file

Restricciones que indican a las herramientas cómo mapear señales lógicas a pines físicos, y requisitos de reloj/timing.  
En este repositorio se usan archivos de constraints (por ejemplo `.cst`) como fuente única de verdad para la asignación de pines y configuraciones básicas.

---

### Toolchain

Conjunto de herramientas que se usan en cadena:

1. Editor / entorno de edición de código.
2. Síntesis RTL.
3. Place & Route.
4. Generación de bitstream.
5. Programador de la FPGA.

En este proyecto se utiliza la toolchain asociada a la FPGA de Tang Nano 9K (por ejemplo, Gowin EDA y su programador).

---

### Synthesis (síntesis)

Proceso en el que el código RTL (SystemVerilog) se traduce a una red de componentes lógicos (LUTs, flip-flops, etc.).  
La herramienta de síntesis verifica el diseño y genera una representación intermedia para el Place & Route.

---

### Place & Route (P&R)

Fase donde:

- Se decide **dónde** colocar cada recurso lógico (place).
- Se determinan las rutas físicas de interconexión (route).

El resultado debe cumplir restricciones de timing (frecuencia de reloj) y uso de recursos.

---

### Bitstream

Archivo de configuración que se carga a la FPGA para programarla con el diseño definido.  
Es el resultado final del flujo de síntesis + Place & Route.  
Al programar la Tang Nano 9K, se envía este bitstream a la FPGA.

---

### Programmer / programming cable

Herramienta o módulo (a veces integrado) que permite transferir el bitstream desde el PC a la FPGA vía USB u otra interfaz.  
En la Tang Nano 9K suele estar integrado en la propia placa.

---

### Timing analysis

Análisis que verifica si las rutas de señal en el diseño cumplen con los tiempos requeridos para la frecuencia de reloj especificada.  
Busca detectar posibles violaciones de setup/hold y otros problemas de temporización.

---

### Clock domain

Conjunto de lógica (registros, FF, etc.) que comparte el mismo reloj.  
Múltiples dominios de reloj pueden requerir técnicas especiales de sincronización.  
En este repositorio se recomienda mantener diseños sencillos preferentemente con un solo dominio de reloj al inicio.

---

### Simulation

Ejecución del diseño en un entorno simulado (sin hardware real) para observar su comportamiento.  
Permite verificar lógica y FSM antes de sintetizar y programar la FPGA.  
Aunque este repositorio se centra en pruebas en placa, la simulación es una herramienta complementaria útil.

---

### Testbench

Módulo de verificación usado en simulación que:

- Genera estímulos (entradas) para el diseño bajo prueba.
- Observa y comprueba las salidas.

No se sintetiza a hardware; solo sirve para probar el diseño en simulación.

---

### IP core / IP block

Bloque de propiedad intelectual (IP) reutilizable que implementa una función específica:  
por ejemplo, controlador de memoria, módulo de comunicación o PWM parametrizable.  
En este repositorio, los bloques reutilizables más sencillos pueden considerarse IPs internos dentro de `ip_blocks/`.

---

### Resource utilization

Medida de cuántos recursos de la FPGA (LUTs, flip-flops, memoria, etc.) usa un diseño.  
Las herramientas la reportan tras la síntesis y P&R.  
En diseños académicos iniciales suele no ser un problema, pero es un concepto importante.

---

### Device / part number

Identificador específico del modelo de FPGA (familia, tamaño, encapsulado).  
En la herramienta EDA se debe seleccionar el **device** adecuado para la Tang Nano 9K, ya que afecta mapeo de recursos y bitstream generado.
