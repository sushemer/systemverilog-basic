# Programación de la Tang Nano 9K con Gowin IDE

Este documento describe el flujo básico para:

1. Crear o abrir un proyecto en **Gowin IDE**.
2. Asociar el archivo de constraints `tang-nano-9k.cst`.
3. Sintetizar, implementar y generar el bitstream.
4. Programar la **Tang Nano 9K**.

No sustituye la documentación oficial de Gowin, pero sirve como guía rápida para los ejemplos y labs de este repositorio.

---

## 1. Preparación

Antes de empezar, verificar:

- Gowin IDE instalado (versión **Education** para tu sistema).
- Drivers / Programmer instalados.
- Repositorio `systemverilog-basic` clonado o descargado.
- Archivo de constraints disponible en:  
  `2_devices/2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`
- Tang Nano 9K conectada por USB al equipo.

---

## 2. Crear un proyecto nuevo (ejemplo)

1. Abrir **Gowin IDE**.
2. Ir a **File → New → Project…**.
3. Elegir una carpeta de proyecto (se recomienda evitar rutas con espacios).
4. Dar un nombre al proyecto (ej. `counter_hello_world`).
5. Seleccionar el dispositivo correspondiente a la Tang Nano 9K  
   (consultar documentación oficial o plantilla del curso si es necesario).
6. Finalizar el asistente.

Después:

- Añadir uno o más archivos de código fuente (`.v` / `.sv`) con tu diseño:
  - Ejemplo: `src/counter_hello_world.v`.

---

## 3. Añadir el archivo de constraints

1. En el panel de archivos del proyecto, localizar la sección/ carpeta de constraints o el árbol general del proyecto.
2. Hacer clic derecho → **Add Existing File…** (o similar).
3. Navegar hasta:

   `2_devices/2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

4. Añadir el archivo al proyecto.
5. Verificar que aparece listado como **Constraint File**.

A partir de aquí, se puede usar en el código:

- `input CLK`
- `output [5:0] LED`
- `input [1:0] KEY`
- `inout [2:0] GPIO`  

y se mapearán a los pines físicos según `tang-nano-9k.cst`.

---

## 4. Flujo de síntesis e implementación

Con el código y el `.cst` ya en el proyecto:

1. Guardar todos los archivos.
2. Ejecutar **Synthesis**:
   - En el menú principal o desde el flujo de tareas.
3. Si la síntesis termina sin errores, ejecutar **Place & Route**.
4. Una vez completado, generar el **bitstream**:
   - Normalmente una opción como **Generate Bitstream** o parte del flujo automático.

Si hay errores:

- Revisar mensajes de síntesis (ej. señales sin conectar, sintaxis, etc.).
- Revisar que los nombres de las señales en el `.v/.sv` coincidan con los del `.cst` (`CLK`, `LED[0]`, etc.).

---

## 5. Programar la Tang Nano 9K

1. Conectar la placa Tang Nano 9K al PC vía cable USB.
2. Abrir la herramienta de programación de Gowin:
   - Desde Gowin IDE o como aplicación separada (Gowin Programmer).
3. Seleccionar la interfaz de programación (por ejemplo, USB).
4. Detectar el dispositivo:
   - Si no aparece, revisar cable, drivers y permisos.
5. Cargar el archivo de bitstream generado:
   - Generalmente un `.fs` o formato compatible según la versión de Gowin.
6. Iniciar la programación:
   - Esperar a que el proceso termine sin errores.
7. Verificar en la placa:
   - Que el LED, display o periférico configurado responda como indica el ejemplo/lab.

---

## 6. Prueba rápida recomendada (“smoke test”)

Para confirmar que todo el flujo funciona:

1. Usar el lab o ejemplo más sencillo (por ejemplo `counter_hello_world`):
   - Un LED parpadeando cerca de 1 Hz usando `CLK` y un contador.
2. Programar la placa siguiendo los pasos anteriores.
3. Confirmar físicamente:
   - Si el LED asociado a `LED[0]` parpadea como se espera.

Si esta prueba funciona, el entorno de desarrollo (Gowin + constraints + programación) está correctamente configurado.

---

## 7. Problemas frecuentes

- **El dispositivo no aparece en el Programmer**:
  - Revisar:
    - Cable USB.
    - Drivers instalados.
    - Usar otro puerto USB.
    - En Linux, permisos de dispositivo (a veces requiere reglas `udev`).

- **Errores de síntesis por pines no encontrados**:
  - Verificar que los nombres de las señales en el código coinciden exactamente con los del `.cst` (`LED[0]` vs `LED0`, por ejemplo).
  - Revisar que el archivo `tang-nano-9k.cst` está añadido al proyecto correcto.

- **El diseño se programa pero la placa “no hace nada”**:
  - Confirmar:
    - Que se está usando el constraint correcto.
    - Que el ejemplo realmente usa las señales mapeadas (por ejemplo, `LED[0]`).
    - Que no haya conflictos de pines con otros módulos.

---

## 8. Relación con otros documentos

- `pinout.md`  
  Muestra qué señal lógica corresponde a cada pin físico.

- `power_notes.md`  
  Explica las consideraciones de alimentación y niveles lógicos al conectar módulos externos.

Ambos documentos complementan este flujo de programación para trabajar de forma segura y consistente con la Tang Nano 9K.
