# Buses overview

Este documento ofrece una introducción general a los **buses de comunicación** más relevantes para este repositorio:

- Buses **paralelos** simples.
- Buses **seriales** básicos (SPI e I²C) desde el punto de vista de la FPGA.

No entra en todos los detalles de protocolos específicos, pero da el contexto necesario para entender por qué se usan y cómo se relacionan con los ejemplos.

---

## ¿Qué es un bus?

Un **bus** es un conjunto de líneas (señales) que se utilizan para transmitir información entre:

- La FPGA y un periférico externo.
- Módulos dentro de un sistema digital.

Puede ser:

- **Paralelo**: varios bits al mismo tiempo.
- **Serial**: los bits se envían uno tras otro por una o pocas líneas.

---

## Buses paralelos simples

Ejemplos de este repositorio:

- Conexión a displays de 7 segmentos:
  - `seg[6:0]` → 7 líneas para segmentos.
  - `en_digit[n:0]` → líneas de habilitación de dígitos.
- Conexión a LEDs:
  - `led[7:0]`.

Características:

- Fáciles de entender: cada bit tiene su propio cable.
- Pueden requerir muchos pines de la FPGA.
- Adecuados cuando el número de señales es razonable.

En estos casos, el “protocolo” suele ser muy sencillo:

- El valor del bus refleja directamente la información que se quiere mostrar.

---

## Buses seriales: motivación

Cuando:

- Se incrementa el número de periféricos.
- Se quiere ahorrar pines de FPGA.
- Se usan dispositivos comerciales (sensores, ADC, expansores, etc.).

es común recurrir a buses **seriales**, donde la información se envía bit por bit usando menos líneas.

En este repositorio, los más relevantes son:

- **SPI**
- **I²C**

---

## SPI (Serial Peripheral Interface)

Características generales:

- Modelo típico: un **master** (la FPGA) y uno o varios **slaves** (dispositivos).
- Líneas principales:
  - `SCK` (clock de serie).
  - `MOSI` (Master Out, Slave In).
  - `MISO` (Master In, Slave Out).
  - `CS` o `SS` (Chip Select / Slave Select).

Flujo simplificado:

1. La FPGA (master) baja `CS` del dispositivo con el que quiere hablar.
2. Genera pulsos de `SCK`.
3. En cada pulso envía un bit por `MOSI` y recibe un bit por `MISO` (cuando aplica).
4. Cuando termina la transacción, sube `CS`.

Usos típicos en este repositorio:

- Comunicación con algunos ADC externos.
- Módulos específicos que requieren envío/recepción de tramas seriales.

---

## I²C (Inter-Integrated Circuit)

Características generales:

- Usa solo dos líneas:
  - `SCL` (clock).
  - `SDA` (datos bidireccionales).
- Todos los dispositivos comparten estas dos líneas.
- Cada dispositivo tiene una **dirección**.

Flujo simplificado:

1. El master (FPGA) genera una **condición de start**.
2. Envía la dirección del dispositivo y el bit de lectura/escritura.
3. El dispositivo responde con un bit de **ACK/NACK**.
4. Se envían o reciben uno o más bytes de datos.
5. El master genera una **condición de stop**.

Usos típicos en este repositorio:

- Módulos como:
  - Algunos ADC (por ejemplo, ADS1115).
  - Expanders tipo PCF8574 para teclas/LEDs/LCD.
- Interfaz con periféricos que usan I²C como estándar.

---

## Relación con la FPGA en este proyecto

En este repositorio, la FPGA actúa típicamente como **master**:

- Genera el clock (`SCK` o `SCL`).
- Controla cuándo se envía y se recibe cada bit.
- Implementa en SystemVerilog la lógica que genera:
  - Secuencias de reloj.
  - Bits de datos.
  - Estados de `CS`, `SDA`, etc.

La lógica concreta para cada dispositivo (tiempos, comandos, direcciones) se detalla en:

- La documentación de `2_devices/`.
- Ejemplos y labs que usen esos periféricos.

---

## Conexión con otros temas de teoría

Los buses interactúan con varios conceptos vistos antes:

- **FSM**:  
  - Muchas implementaciones de SPI/I²C usan una máquina de estados para recorrer las fases del protocolo.
- **Timing y divisores**:  
  - La frecuencia de `SCK` o `SCL` suele ser mucho menor que la frecuencia de `clk`, por lo que se usan contadores para generar ticks de comunicación.
- **Registros**:  
  - Los datos que se envían o reciben pasan por registros de desplazamiento internos.

---

## Relación con ejemplos y labs

Archivos de teoría relacionados:

- `1_2_6_Timing_and_Dividers.md`
- `1_2_7_Finite_State_Machines.md`
- `1_2_11_ADC_Basics.md`
- `1_2_15_Potentiometer_ADC_Basics.md`

Examples / Activities / Labs donde suelen aparecer buses:

- `pot_read_demo` (cuando se usa ADC por SPI o I²C).
- Actividades con PCF8574 (expansor I²C).
- Labs de integración con LCD vía I²C o TM1638 (aunque TM1638 tiene su propio protocolo sencillo, conceptualmente se parece a un bus serial).
