# Instalación en Windows · Tang Nano 9K + SystemVerilog

Este documento describe un flujo sugerido para dejar listo el entorno en Windows:

1. Instalar las herramientas de desarrollo.
2. Instalar los drivers de la placa.
3. Probar la conexión con la Tang Nano 9K usando un ejemplo mínimo.

> Nota: los nombres exactos de las versiones recomendadas pueden ajustarse según la experiencia del equipo.  
> Se pueden registrar detalles adicionales en `1_5_Reference/`.

---

## 1. Requisitos previos

- Windows 10 o superior.
- Permisos de instalación de software.
- Conexión a internet para descargar herramientas.
- Cable USB compatible con la Tang Nano 9K.

Opcional pero recomendable:

- Git instalado para clonar el repositorio.
- Editor de texto / IDE (por ejemplo, VS Code) para revisar archivos `.sv` y `.v`.

---

## 2. Instalación de la herramienta de diseño (EDA)

1. Descargar la versión recomendada de la herramienta de diseño para la FPGA utilizada por la Tang Nano 9K  
   (por ejemplo, Gowin EDA).

2. Ejecutar el instalador:
   - Seguir los pasos del asistente.
   - Aceptar los términos de licencia.
   - Seleccionar la ruta de instalación (por defecto suele ser suficiente).

3. Verificar al final:
   - Que el programa se pueda abrir desde el menú de inicio.
   - Que exista una opción para crear un proyecto nuevo y seleccionar el dispositivo correspondiente a la Tang Nano 9K.

> Se puede incluir una nota específica sobre el modelo exacto de FPGA y la familia en un apartado adicional o en `2_devices/tang-nano-9k/`.

---

## 3. Instalación de drivers y reconocimiento de la placa

1. Conectar la **Tang Nano 9K** al puerto USB de la computadora.

2. Si el instalador de la herramienta EDA ofrece instalar drivers de programación:
   - Aceptar la instalación.
   - Si Windows solicita permisos adicionales, confirmarlos.

3. Verificar en el **Administrador de dispositivos** que la placa aparezca correctamente:
   - Como dispositivo de programación/USB adecuado.
   - Sin íconos de alerta (signos de exclamación).

4. Si es necesario un driver específico del programador:
   - Consultar la documentación incluida con la herramienta EDA o con la placa.
   - Documentar el nombre del driver y la fuente de descarga dentro de esta carpeta (`1_3_1_Windows/`).

---

## 4. Clonar o descargar el repositorio

Hay dos opciones principales:

- **Clonar con Git** (recomendado para desarrollo activo):
  ```bash
  git clone https://github.com/sushemer/systemverilog-basic
  ```