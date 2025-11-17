# 2.3.3 LCD 16x2 · Display de texto

El **LCD 16x2** es un display de texto de **2 filas** por **16 caracteres**.  
Normalmente está basado en el controlador **HD44780** o compatible.

En este repositorio se utiliza para:

- Mostrar mensajes y estados del sistema.
- Visualizar mediciones (por ejemplo, distancia del HC-SR04).
- Crear pequeñas interfaces de usuario con menús sencillos.

---

## Modos de conexión típicos

### Modo paralelo (4 bits)

El LCD se controla con varias líneas:

- `LCD_RS` → Register Select (comando/datos).
- `LCD_EN` → Enable (latch).
- `LCD_D[3:0]` → 4 líneas de datos.
- `VCC`, `GND` → alimentación.
- `VO` → contraste (normalmente a través de un potenciómetro).

En el código se pueden usar señales como:

- `lcd_rs`
- `lcd_en`
- `lcd_data[3:0]`

Este modo requiere más pines de la FPGA, pero el control es directo.

### Modo con backpack I²C

Algunos módulos traen un pequeño PCB que convierte I²C a las señales del HD44780.

En ese caso:

- Se usan solo `SCL` y `SDA` hacia el backpack.
- Internamente el backpack maneja `RS`, `EN` y `D[3:0]`.

> La elección de modo (4 bits o I²C) depende del hardware disponible.  
> La asignación exacta de pines se documenta en `pinout.md` y en el archivo `.cst`.

---

## Conceptos clave

### Inicialización

El LCD requiere una **secuencia de inicialización**:

- Modo de datos (4 bits).
- Número de líneas.
- Encendido de display y cursor.
- Limpieza de pantalla.

Esta secuencia debe respetar ciertos tiempos entre comandos.

### Escribir texto

Una vez inicializado, se puede:

- Enviar comandos para posicionar el cursor (por ejemplo, inicio de línea 1 o 2).
- Enviar caracteres ASCII para que aparezcan en pantalla.

Ejemplos de uso:

- Línea 1 → mensaje fijo (“DISTANCIA:”).
- Línea 2 → valor numérico y unidades (“  23 cm”).

---

## Señales y pines lógicos

Ejemplo de señales lógicas (modo 4 bits):

- `lcd_rs`
- `lcd_en`
- `lcd_d[3:0]`

La asignación a pines físicos concretos se documenta en:

- `2_1_Boards/2_1_1_Tang_Nano_9K/docs/pinout.md`
- `2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

---

## Relación con la teoría

Este dispositivo se apoya en:

- `1_2_3_Modules_and_Ports.md`  
  Organización del módulo controlador del LCD.

- `1_2_4_Combinational_vs_Sequential.md`  
  Lógica secuencial para enviar comandos en orden.

- `1_2_5_Registers_and_Clock.md`  
  Almacenamiento de datos a imprimir y control de tiempos.

- `1_2_6_Timing_and_Dividers.md`  
  Delays entre comandos de inicialización y escritura.

- `1_2_13_LCD_HD44780_Basics.md`  
  Explica más detalles del protocolo y ejemplos simples.

---

## Ejemplos, actividades y laboratorios relacionados

Ideas típicas:

- **Examples**
  - Mostrar “HELLO” en la línea 1.
  - Mostrar un contador que se incrementa cada cierto tiempo.

- **Activities**
  - Mostrar distancia medida por HC-SR04 en la línea 2.
  - Crear un mensaje que cambie según el estado de una FSM.

- **Labs / Implementation**
  - Mini-proyecto con menú en línea 1 y valor en línea 2 (por ejemplo, modos o parámetros controlados por botones o encoder).

Los nombres exactos de Examples/Activities/Labs se definirán más adelante.

---

## Checklist de uso rápido

Antes de usar el LCD 16x2 en un proyecto:

- Confirmar el tipo de módulo (directo o con backpack).
- Conectar correctamente:
      - Alimentación (VCC, GND).
      - Contraste (VO).
      - Señales lógicas (RS, EN, D[3:0] o SCL/SDA).
