# Linux install guide · Visual Studio Code, Git, repositorio y Gowin IDE

Este documento describe cómo preparar el entorno en **Linux** para trabajar con este repositorio:

1. Instalar **Visual Studio Code**.
2. Instalar **Git**.
3. Descargar o clonar el **repositorio** de este proyecto:  
   https://github.com/sushemer/systemverilog-basic
4. Instalar **Gowin IDE** (versión educativa para Linux).
5. Configurar variables de entorno.
6. Verificar la instalación con una prueba básica.

Más adelante se pueden añadir capturas de pantalla específicas por distribución (Ubuntu, Debian, etc.).

---

## 1. Visual Studio Code (VSC)

> Los pasos pueden variar ligeramente según la distribución.  
> Aquí se muestra una opción genérica usando el paquete .deb (para distribuciones tipo Debian/Ubuntu).  
> En otras distros se puede usar el repositorio oficial o paquete .rpm.

### 1.1 Descargar Visual Studio Code

1. Abrir el navegador y entrar a:  
   https://code.visualstudio.com/download
2. Seleccionar el paquete adecuado:
   - `.deb` para Debian / Ubuntu.
   - `.rpm` para Fedora / openSUSE.
3. Descargar el archivo en la carpeta `Descargas` (o similar).

### 1.2 Instalar VSC (ejemplo con .deb en Debian/Ubuntu)

Abrir una terminal y ejecutar:

    cd ~/Descargas
    sudo dpkg -i code_*.deb
    sudo apt-get -f install    # Corrige dependencias si hace falta

Si usas otra distribución, puedes seguir las instrucciones específicas de la página oficial de Visual Studio Code.

### 1.3 Verificar instalación

En una terminal:

    code --version

Si aparece un número de versión (por ejemplo `1.xx.x`), Visual Studio Code está instalado.

---

## 2. Git

En la mayoría de distribuciones Linux, Git está disponible desde los repositorios oficiales.

### 2.1 Instalar Git

En Debian / Ubuntu:

    sudo apt-get update
    sudo apt-get install git

En Fedora:

    sudo dnf install git

En Arch Linux:

    sudo pacman -S git

### 2.2 Verificar instalación

    git --version

Si se muestra una versión (`git version 2.x.x`), Git está listo.

---

## 3. Descargar o clonar el repositorio del proyecto

Repositorio principal de este proyecto:

    https://github.com/sushemer/systemverilog-basic

Se recomienda usar una carpeta **sin espacios** en la ruta, por ejemplo:

- ✅ `/home/usuario/ProyectosFPGA/systemverilog-basic`  
- ❌ `/home/usuario/Mis proyectos FPGA/systemverilog-basic`

### 3.1 Clonar con Git (recomendado)

1. Abrir una terminal.
2. Crear una carpeta de trabajo y entrar en ella:

       mkdir -p ~/ProyectosFPGA
       cd ~/ProyectosFPGA

3. Clonar el repositorio:

       git clone https://github.com/sushemer/systemverilog-basic.git
       cd systemverilog-basic

4. (Opcional) Abrir la carpeta en Visual Studio Code:

       code .

### 3.2 Descargar como ZIP (sin usar Git)

1. Abrir en el navegador:  
   https://github.com/sushemer/systemverilog-basic
2. Hacer clic en **Code → Download ZIP**.
3. Guardar el archivo en `~/Descargas` (o similar).
4. Extraer el ZIP, por ejemplo:

       mkdir -p ~/ProyectosFPGA
       cd ~/ProyectosFPGA
       unzip ~/Descargas/systemverilog-basic-main.zip
       mv systemverilog-basic-main systemverilog-basic

5. Abrir la carpeta en Visual Studio Code:

       cd ~/ProyectosFPGA/systemverilog-basic
       code .

---

## 4. Instalación de Gowin IDE (Linux)

> Los nombres de versión y la ruta exacta del archivo `.tar.gz` pueden cambiar.  
> Aquí se muestra un ejemplo con un nombre típico:  
> `Gowin_V1.9.9.03_Education_linux.tar.gz`.

### 4.1 Descarga de Gowin IDE

1. Ir a la página de descargas de Gowin:  
   https://www.gowinsemi.com/en/support/download_eda/
2. Crear una cuenta o iniciar sesión si ya se tiene.
3. Buscar la versión **Education** para **Linux**.
4. Descargar el archivo `.tar.gz` (por ejemplo):  
   `Gowin_V1.9.9.03_Education_linux.tar.gz`  
   y guardarlo en `~/Descargas`.

### 4.2 Extraer el archivo

En la terminal:

    cd ~/Descargas
    tar -xvzf Gowin_V1.9.9.03_Education_linux.tar.gz

Esto creará una carpeta con el IDE, por ejemplo:

    Gowin_V1.9.9.03_Education_linux

### 4.3 Mover a un directorio fijo (por ejemplo `~/gowin`)

    rm -rf ~/gowin
    mv ~/Descargas/Gowin_V1.9.9.03_Education_linux ~/gowin

Si la carpeta tiene un nombre distinto, ajustarlo en el comando `mv`.

---

## 5. Configurar variables de entorno

Para poder llamar a las herramientas de Gowin desde cualquier terminal, se recomienda añadirlas al `PATH`.

### 5.1 Editar `.bashrc` (o el archivo de configuración de tu shell)

Abrir el archivo `.bashrc` con tu editor preferido, por ejemplo:

    nano ~/.bashrc

Al final del archivo, añadir la línea:

    export PATH="$PATH:$HOME/gowin/IDE/bin:$HOME/gowin/Programmer/bin"

Guardar y cerrar.

### 5.2 Aplicar cambios

    source ~/.bashrc

O cerrar la sesión y volver a entrar.

---

## 6. Verificación de Gowin en Linux

### 6.1 Verificar consola de Gowin (gw_sh)

En la terminal:

    gw_sh

Si la instalación es correcta, deberá abrirse la consola TCL de Gowin.

### 6.2 Verificar interfaz gráfica (gw_ide)

En la terminal:

    gw_ide &

Esto debería abrir la interfaz gráfica del IDE Gowin.  
En el primer inicio, puede solicitar configuración de licencia:

- Seleccionar **Education License** si se muestra esa opción.
- Confirmar que el IDE abre sin errores críticos.

---
