# Windows install guide · Visual Studio Code, Git (Git Bash), repositorio y Gowin IDE

Este documento describe cómo preparar el entorno en **Windows** para trabajar con este repositorio:

1. Instalar **Visual Studio Code**.
2. Instalar **Git** (incluye **Git Bash**).
3. Descargar o clonar el **repositorio** de este proyecto:  
   <https://github.com/sushemer/systemverilog-basic>
4. Instalar **Gowin IDE** (versión educativa).
5. Verificar la instalación con una prueba básica en la Tang Nano 9K.

---

## 1. Visual Studio Code (VSC)

### 1.1 Descargar VSC

1. Ingresar al sitio oficial:  
   <https://code.visualstudio.com/download>
2. Seleccionar el instalador correspondiente a **Windows**.
3. Descargar el archivo `.exe`.

![alt text](mult/image.png)

### 1.2 Configuración inicial

Durante la instalación:

- Aceptar los términos y condiciones.
- Opcionalmente activar:
  - Crear acceso directo en el escritorio.
  - Agregar “Open with Code” al menú contextual.
  - Asociar archivos de texto/código con VSC.

![alt text](mult/image-1.png)
### 1.3 Finalizar instalación

1. Seleccionar **Install** en el asistente.
2. Esperar a que termine la instalación.
3. Abrir **Visual Studio Code** para confirmar que inicia correctamente.

![alt text](mult/image-4.png)
---

## 2. Git y Git Bash

En Windows, la forma más sencilla de obtener una terminal tipo Unix (bash) es instalar **Git for Windows**, que incluye **Git Bash**.

### 2.1 Descargar e instalar Git

1. Ingresar a:  
   <https://git-scm.com/downloads>
2. Descargar el instalador para Windows.
3. Ejecutar el instalador.

### 2.2 Opciones recomendadas durante la instalación

- Aceptar la mayoría de opciones por defecto.
- Asegurarse de:
  - Permitir que se instale **Git Bash**.
  - Agregar Git al **PATH del sistema**  
    (opción “Git from the command line and also from 3rd-party software” o similar).

![alt text](mult/image-10.png)

Con esto podrá:

- Usar el comando `git` desde cualquier terminal.
- Usar **Git Bash**, que se comporta de forma similar a una terminal Linux y será útil para comandos de este repositorio.

### 2.3 Verificar instalación

Abrir:

- **Git Bash** (desde el menú Inicio), o
- **PowerShell / Símbolo del sistema**.

Escribir:

```bash
git --version
```
## 3. Descargar o clonar el repositorio del proyecto

> Se recomienda guardar el proyecto en una carpeta **sin espacios en la ruta** para evitar problemas con algunas herramientas.

Repositorio principal de este proyecto:

https://github.com/sushemer/systemverilog-basic

Ejemplos de rutas:

- ✅ C:\ProyectosFPGA\systemverilog-basic  
- ❌ C:\Mis proyectos FPGA\systemverilog-basic

---

### 3.1 Clonar desde la línea de comandos (recomendado)

Esta opción requiere tener **Git** instalado y permite actualizar el proyecto más adelante con `git pull`.

1. Abrir Git Bash (o una terminal donde `git` funcione).
2. Crear una carpeta de trabajo sin espacios y entrar en ella, por ejemplo:
    ```
    mkdir -p /c/ProyectosFPGA
    cd /c/ProyectosFPGA
    ```
3. Clonar el repositorio:
    ```
    git clone https://github.com/sushemer/systemverilog-basic.git
    cd systemverilog-basic
    ```

---

### 3.2 Descargar como ZIP (sin usar comandos)
![alt text](mult/image-5.png)
1. Abrir en el navegador:  
   https://github.com/sushemer/systemverilog-basic
2. Hacer clic en **Code → Download ZIP**.
3. Guardar el archivo ZIP en una carpeta sin espacios, por ejemplo:

   C:\ProyectosFPGA\

4. Extraer el ZIP:
   - Clic derecho sobre el archivo → **Extraer todo…**
   - Elegir como destino, por ejemplo:

     C:\ProyectosFPGA\systemverilog-basic

5. Abrir Visual Studio Code.
6. Ir a **File → Open Folder…**.
7. Seleccionar la carpeta:

   C:\ProyectosFPGA\systemverilog-basic

8. Verificar que dentro de la carpeta se encuentran, al menos, las siguientes carpetas:

   - 1_docs  
   - 2_devices  
   - 3_examples  
   - 4_activities  
   - 5_labs  
   - 6_implementation

## 4. Instalación de Gowin IDE (Windows)

> Los nombres de versión pueden cambiar (por ejemplo `V1.9.9.x Education`).  
> Se recomienda usar la versión **Education** más reciente que soporte la Tang Nano 9K.

### 4.1 Registro en Gowin

1. Ingresar a:  
   <https://www.gowinsemi.com/en/support/download_eda/>
2. Hacer clic en **Register** para crear una cuenta (si aún no se tiene).
3. Completar el formulario (se puede indicar uso educativo).
4. Confirmar la cuenta desde el correo enviado por Gowin.
![alt text]mult/(image-6.png)
### 4.2 Descarga de la versión educativa

1. Iniciar sesión con la cuenta creada.
2. Ir a la sección **Downloads**.
3. Descargar la versión **Education** para Windows (archivo `.exe`).
4. Guardar el instalador en una carpeta conocida (por ejemplo `Descargas`).
![alt text](mult/image-7.png)
### 4.3 Instalación de Gowin IDE

1. Ejecutar el instalador como **Administrador**  
   (clic derecho → *Run as administrator*).
2. En el asistente:
   - Clic en **Next** en la pantalla de bienvenida.
   - Aceptar el acuerdo de licencia.
3. Seleccionar todos los componentes:
   - **Designer** (IDE principal).
   - **Gowin Programmer**.
   - Herramientas adicionales incluidas.
   
   ![alt text](mult/image-8.png)
4. Usar la ruta por defecto, por ejemplo:

   ```text
   C:\Gowin
   ```

   ![alt text](mult/image-9.png)