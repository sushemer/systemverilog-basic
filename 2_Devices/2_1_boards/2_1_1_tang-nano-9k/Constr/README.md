
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
## Relación con otros archivos

- `docs/pinout.md`  
  Explica, en forma de tabla, cómo se mapean las señales lógicas del `.cst` a pines físicos de la FPGA.

- `docs/power_notes.md`  
  Incluye advertencias de voltaje y nivel lógico que complementan la información del `.cst`.

Si se modifica el `.cst`, es importante revisar si también se deben actualizar estos documentos.
