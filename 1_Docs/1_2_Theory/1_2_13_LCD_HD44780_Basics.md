# LCD HD44780 basics

Este documento introduce los conceptos básicos de los **LCD de caracteres**   basados en el controlador **HD44780** (típicamente 16x2, 20x4, etc.),   tal como se usan en este repositorio.

---

## ¿Qué es un LCD de caracteres?

Un LCD de caracteres:

- Muestra texto en una matriz de posiciones (por ejemplo, 16 columnas x 2 filas).
- No dibuja gráficos libres (como una pantalla gráfica), sino caracteres predefinidos:
  - Letras, números, símbolos.
  - Algunos caracteres personalizados (en cantidad limitada).

Ejemplos de usos en este repositorio:

- Mostrar mensajes (“HELLO”, “READY”, “ERROR”).
- Mostrar contadores, medidas de sensor, estados de una FSM.
- Menús sencillos (línea 1: título; línea 2: valor/estado).

---

## Controlador HD44780

El **HD44780** (o compatibles) es el controlador interno del LCD:

- Se encarga de:
  - Generar las señales adecuadas para los píxeles.
  - Guardar los caracteres a mostrar en la memoria interna.
  - Interpretar comandos (limpiar pantalla, mover cursor, etc.).

Desde la FPGA se ve como un dispositivo con:

- Entradas de control.
- Un bus de datos (4 u 8 bits).
- Algunas líneas adicionales (contraste, backlight) que suelen manejarse fuera de la FPGA.

---

## Señales principales

En modo paralelo clásico, las señales relevantes son:

- `RS` (Register Select)
  - `0` → se enviará un **comando** (clear, set cursor, etc.).
  - `1` → se enviará **datos** (caracteres a mostrar).

- `E` (Enable)
  - Pulso que indica al LCD que debe **capturar** los bits presentes en el bus de datos.

- `D[7:0]` (datos)
  - Bus de 8 bits para comandos y datos.
  - En muchos diseños se usa **solo 4 bits** (`D[7:4]`) para ahorrar pines.

- `R/W`
  - Selecciona lectura/escritura.
  - En diseños simples se suele fijar a escritura (por ejemplo, conectado a GND) y no se lee desde el LCD.

Además:

- Pines de alimentación (VCC, GND).
- Pin de contraste (a menudo controlado con potenciómetro).
- Pines de backlight (para encender la iluminación trasera).

En este repositorio, la configuración concreta (4 bits, 8 bits o I²C) se detalla en:

- `2_devices/` → sección de LCD HD44780 / backpack I²C.

---

## Modos de conexión: 8 bits vs 4 bits vs I²C

1. **Modo paralelo 8 bits**
   - Se usan `D[7:0]` completos.
   - Permite transferir comandos/datos en un solo ciclo de escritura.
   - Requiere más pines de la FPGA.

2. **Modo paralelo 4 bits**
   - Se usan solo `D[7:4]`.
   - Cada byte se envía en **dos partes** (nibble alto y nibble bajo).
   - Ahorra pines a costa de lógica ligeramente más compleja.

3. **Backpack I²C (por ejemplo, con PCF8574)**
   - El LCD se conecta a un expansor como PCF8574.
   - La FPGA se comunica con el PCF8574 por I²C (`SCL`, `SDA`).
   - El PCF8574 maneja las líneas `RS`, `E` y `D[7:4]`.
   - Ahorra muchos pines de la FPGA: solo se usan las dos líneas de I²C.

Este repositorio puede utilizar cualquiera de estos esquemas según el hardware disponible.

---

## Inicialización básica

Antes de mostrar texto, el LCD requiere una **secuencia de inicialización**, que incluye:

- Configuración del modo (4 bits / 8 bits, número de líneas, tamaño de caracteres).
- Encendido/apagado de display y cursor.
- Limpieza de pantalla.
- Posicionamiento inicial del cursor.

Aunque los detalles exactos dependen del modo, la idea general es:

1. Esperar el tiempo mínimo después de encender el LCD.
2. Enviar una secuencia de comandos específicos.
3. A partir de ahí, se puede escribir texto enviando:
   - `RS = 1` + datos para caracteres.
   - `RS = 0` + comandos para mover cursor o limpiar.

En los ejemplos y labs del repositorio:

- La secuencia de inicialización suele encapsularse en un **módulo controlador** (driver) para simplificar.

---

## Escribir texto y mover el cursor

Dos operaciones esenciales:

- **Escribir caracteres:**
  - Seleccionar `RS = 1`.
  - Enviar el código ASCII (o del mapa del LCD) del carácter.
  - Repetir para cada posición.

- **Posicionar cursor:**
  - Seleccionar `RS = 0`.
  - Enviar comandos como:
    - “Set DDRAM address” (dirección interna para fila/columna).
    - “Clear display”.

La relación entre (fila, columna) y direcciones internas la maneja el driver; en este repositorio se intenta encapsular esta complejidad.

---

## Uso típico en este repositorio

Ejemplos y labs:

- `lcd` (example/activity):
  - Mostrar “HELLO” en la primera línea.
  - Mostrar un contador o un valor de sensor en la segunda línea.

- `lcd_menu_system` (lab avanzado):
  - Usar la pantalla para un menú navegable:
    - Botones ↑/↓/OK.
    - Estados de la FSM que deciden qué texto mostrar.
    - Visualización de medidas de potenciómetro, distancia, etc.

---

## Relación con otros archivos de teoría

- `1_2_6_Timing_and_Dividers.md`  
  → manejo de tiempos de espera entre comandos.
- `1_2_7_Finite_State_Machines.md`  
  → FSM para secuencias de inicialización y actualización de pantalla.
- `1_2_9_Buses_Overview.md`  
  → contexto sobre I²C cuando se usa con backpack PCF8574.

La documentación de pines, wiring y ejemplos concretos se complementa en:

- `2_devices/` → sección de LCD HD44780.
