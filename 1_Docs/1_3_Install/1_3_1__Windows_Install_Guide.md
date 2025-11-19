# Windows install guide · Visual Studio Code, Git (Git Bash), repository and Gowin IDE

This document describes how to prepare the environment on **Windows** to work with this repository:

1. Install **Visual Studio Code**.
2. Install **Git** (includes **Git Bash**).
3. Download or clone the **repository** of this project:  
   https://github.com/sushemer/systemverilog-basic
4. Install **Gowin IDE** (education version).
5. Verify the installation with a basic test on the Tang Nano 9K.

---

## 1. Visual Studio Code (VSC)

### 1.1 Download VSC

1. Go to the official website:  
   https://code.visualstudio.com/download
2. Select the installer corresponding to **Windows**.
3. Download the `.exe` file.

![alt text](mult/image.png)

### 1.2 Initial configuration

During installation:

- Accept the terms and conditions.
- Optionally enable:
  - Create desktop shortcut.
  - Add “Open with Code” to the context menu.
  - Associate text/code files with VSC.

![alt text](mult/image-1.png)

### 1.3 Finish installation

1. Click **Install** in the wizard.
2. Wait for the installation to complete.
3. Open **Visual Studio Code** to confirm it starts correctly.

![alt text](mult/image-4.png)

---

## 2. Git and Git Bash

On Windows, the easiest way to obtain a Unix-style terminal (bash) is to install **Git for Windows**, which includes **Git Bash**.

### 2.1 Download and install Git

1. Go to:  
   https://git-scm.com/downloads
2. Download the installer for Windows.
3. Run the installer.

### 2.2 Recommended options during installation

- Accept most default options.
- Make sure to:
  - Allow **Git Bash** to be installed.
  - Add Git to the **system PATH**
    (option “Git from the command line and also from 3rd-party software” or similar).

![alt text](mult/image-10.png)

With this you will be able to:

- Use the `git` command from any terminal.
- Use **Git Bash**, which behaves similarly to a Linux terminal and will be useful for commands in this repository.

### 2.3 Verify installation

Open:

- **Git Bash** (from the Start menu), or  
- **PowerShell / Command Prompt**.

Type:

git --version

---

## 3. Download or clone the project repository

> It is recommended to store the project in a folder **without spaces in the path** to avoid issues with some tools.

Main repository of this project:

https://github.com/sushemer/systemverilog-basic

Examples of paths:

- ✅ C:\ProyectosFPGA\systemverilog-basic  
- ❌ C:\Mis proyectos FPGA\systemverilog-basic

---

### 3.1 Clone from the command line (recommended)

This option requires **Git** installed and allows updating the project later with `git pull`.

1. Open Git Bash (or a terminal where `git` works).
2. Create a workspace folder without spaces and enter it, for example:

mkdir -p /c/ProyectosFPGA  
cd /c/ProyectosFPGA

3. Clone the repository:

git clone https://github.com/sushemer/systemverilog-basic.git  
cd systemverilog-basic

---

### 3.2 Download as ZIP (without using commands)

![alt text](mult/image-5.png)

1. Open in the browser:  
   https://github.com/sushemer/systemverilog-basic
2. Click **Code → Download ZIP**.
3. Save the ZIP file in a folder without spaces, for example:

C:\ProyectosFPGA\

4. Extract the ZIP:
   - Right-click on the file → **Extract All…**
   - Choose destination, for example:

C:\ProyectosFPGA\systemverilog-basic

5. Open Visual Studio Code.
6. Go to **File → Open Folder…**.
7. Select the folder:

C:\ProyectosFPGA\systemverilog-basic

8. Verify that the folder contains at least the following subfolders:

- 1_docs  
- 2_devices  
- 3_examples  
- 4_activities  
- 5_labs  
- 6_implementation

---

## 4. Installation of Gowin IDE (Windows)

> Version names may vary (for example, `V1.9.9.x Education`).  
> It is recommended to use the most recent **Education** version that supports the Tang Nano 9K.

### 4.1 Register on Gowin

1. Go to:  
   https://www.gowinsemi.com/en/support/download_eda/
2. Click **Register** to create an account (if you do not already have one).
3. Complete the form (you can indicate educational use).
4. Confirm your account from the email sent by Gowin.

![alt text](mult/(image-6.png))

### 4.2 Download the education version

1. Log in with the created account.
2. Go to the **Downloads** section.
3. Download the **Education** version for Windows (`.exe` file).
4. Save the installer in a known folder (for example, `Downloads`).

![alt text](mult/image-7.png)

### 4.3 Install Gowin IDE

1. Run the installer as **Administrator**
   (right-click → *Run as administrator*).
2. In the wizard:
   - Click **Next** on the welcome screen.
   - Accept the license agreement.
3. Select all components:
   - **Designer** (main IDE).
   - **Gowin Programmer**.
   - Additional included tools.

![alt text](mult/image-8.png)

4. Use the default path, for example:

C:\Gowin

![alt text](mult/image-9.png)
