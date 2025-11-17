
# Constraints · Tang Nano 9K

La carpeta `constr` contiene el archivo de **constraints** utilizado para la Tang Nano 9K en este repositorio.

Su objetivo es proporcionar una configuración de pines **estable y compartida** para todos los Examples, Activities, Labs e Implementation que usen esta placa.

---

## Contenido

- `tang-nano-9k.cst`  
  Archivo de constraints estándar para la Tang Nano 9K.

Incluye asignaciones de pines para señales como:

- `CLK`
- `KEY[0]`, `KEY[1]`
- `LED[0]` … `LED[5]`
- `GPIO[0]` … `GPIO[5]`
- Señales asociadas a módulos más avanzados (LCD, audio, etc.), aunque no se usen en los primeros ejercicios.

---

## Lineamientos de uso

- Este archivo debe considerarse la **referencia principal de pines** para la Tang Nano 9K.
- Los proyectos del repositorio que trabajen con esta placa deben:
  - Añadir este `.cst` en Gowin IDE.
  - Usar los mismos nombres de señal (`CLK`, `LED[x]`, `KEY[x]`, `GPIO[x]`, etc.) en el código.
- No se recomienda:
  - Crear múltiples copias de `.cst` con ligeras variaciones.
  - Modificar el archivo sin actualizar la documentación correspondiente en `docs/pinout.md`.

Si en algún momento se requiere un mapeo alternativo (por ejemplo, para un laboratorio muy específico), se debe:

1. Documentar claramente el cambio en el README del ejemplo/lab.
2. Evitar sobreescribir este archivo sin una buena razón académica.

---

## Cómo añadir el `.cst` en Gowin IDE (resumen)

1. Abrir o crear un proyecto en Gowin IDE para la Tang Nano 9K.
2. En el panel de archivos del proyecto:
   - Añadir `tang-nano-9k.cst` al proyecto (Add Existing File / similar).
3. Asegurarse de que el archivo esté marcado como **Constraint File**.
4. Guardar el proyecto y continuar con:
   - Sintetizar.
   - Place & Route.
   - Generar el bitstream.
   - Programar la placa.

---

## Relación con otros archivos

- `docs/pinout.md`  
  Explica, en forma de tabla, cómo se mapean las señales lógicas del `.cst` a pines físicos de la FPGA.

- `docs/power_notes.md`  
  Incluye advertencias de voltaje y nivel lógico que complementan la información del `.cst`.

Si se modifica el `.cst`, es importante revisar si también se deben actualizar estos documentos.
