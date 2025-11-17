# Pinout · Tang Nano 9K

Este documento resume la relación entre **señales lógicas** usadas en el repositorio y los **pines físicos** de la FPGA en la Tang Nano 9K.

La asignación está definida en el archivo de constraints:

`2_devices/2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

> Nota: aquí solo se listan las señales más relevantes para los ejemplos, actividades y laboratorios.  
> El archivo `.cst` puede contener señales adicionales para usos más avanzados.

---

## 1. Pines básicos para el curso

Estos son los pines más utilizados en ejemplos y labs iniciales: reloj, botones, LEDs y líneas GPIO de uso general.

### 1.1 Reloj

| Señal lógica | Pin FPGA | Descripción               |
|--------------|---------:|---------------------------|
| `CLK`        | 52       | Reloj principal de la placa |

Esta señal se usa en la mayoría de los ejemplos como:

- Entrada `input CLK`
- Fuente para contadores, divisores, FSM, etc.

---

### 1.2 Botones (KEY)

| Señal lógica | Pin FPGA | Descripción      |
|--------------|---------:|------------------|
| `KEY[0]`     | 4        | Botón 0 (input)  |
| `KEY[1]`     | 3        | Botón 1 (input)  |

Uso típico:

- Entradas de usuario para cambiar modo, resetear contadores, avanzar estados en una FSM, etc.

---

### 1.3 LEDs de usuario

| Señal lógica | Pin FPGA | Descripción      |
|--------------|---------:|------------------|
| `LED[0]`     | 10       | LED 0 (output)   |
| `LED[1]`     | 11       | LED 1 (output)   |
| `LED[2]`     | 13       | LED 2 (output)   |
| `LED[3]`     | 14       | LED 3 (output)   |
| `LED[4]`     | 15       | LED 4 (output)   |
| `LED[5]`     | 16       | LED 5 (output)   |

Se utilizan para:

- Pruebas rápidas de lógica combinacional.
- Contadores, secuencias (ej. KITT).
- Indicadores de estado en FSM.

---

### 1.4 GPIO para módulos externos

Las primeras líneas `GPIO[x]` se usan, en este repositorio, principalmente para el módulo **TM1638** (display 7 segmentos + LEDs + teclas).

| Señal lógica | Pin FPGA | Uso en el curso                      |
|--------------|---------:|--------------------------------------|
| `GPIO[0]`    | 25       | TM1638 – DIO (datos)                 |
| `GPIO[1]`    | 26       | TM1638 – CLK (reloj)                 |
| `GPIO[2]`    | 27       | TM1638 – STB (strobe / latch)        |
| `GPIO[3]`    | 28       | GPIO general (reservado / futuro)    |
| `GPIO[4]`    | 29       | GPIO general (reservado / futuro)    |
| `GPIO[5]`    | 30       | GPIO general (reservado / futuro)    |

Cuando se conecten otros sensores/actuadores a estos pines, se debe documentar en el README correspondiente del dispositivo y del ejemplo/lab.

---

## 2. Pines para LCD grande (LARGE_LCD)

Estos pines se usan en el material original de **basics-graphics-music** para controlar un LCD gráfico grande.  
En este repositorio pueden reservarse como recurso para prácticas avanzadas.

| Señal lógica        | Pin FPGA |
|---------------------|---------:|
| `LARGE_LCD_DE`      | 33       |
| `LARGE_LCD_VS`      | 34       |
| `LARGE_LCD_HS`      | 40       |
| `LARGE_LCD_CK`      | 35       |
| `LARGE_LCD_INIT`    | 63       |
| `LARGE_LCD_BL`      | 86       |
| `LARGE_LCD_R[3]`    | 75       |
| `LARGE_LCD_R[4]`    | 74       |
| `LARGE_LCD_R[5]`    | 73       |
| `LARGE_LCD_R[6]`    | 72       |
| `LARGE_LCD_R[7]`    | 71       |
| `LARGE_LCD_G[2]`    | 70       |
| `LARGE_LCD_G[3]`    | 69       |
| `LARGE_LCD_G[4]`    | 68       |
| `LARGE_LCD_G[5]`    | 57       |
| `LARGE_LCD_G[6]`    | 56       |
| `LARGE_LCD_G[7]`    | 55       |
| `LARGE_LCD_B[3]`    | 54       |
| `LARGE_LCD_B[4]`    | 53       |
| `LARGE_LCD_B[5]`    | 51       |
| `LARGE_LCD_B[6]`    | 42       |
| `LARGE_LCD_B[7]`    | 41       |

---

## 3. UART y almacenamiento

| Señal lógica | Pin FPGA | Descripción                   |
|--------------|---------:|-------------------------------|
| `UART_RX`    | 18       | Recepción UART desde PC/módulo |
| `UART_TX`    | 17       | Transmisión UART hacia PC/módulo |

| Señal lógica  | Pin FPGA | Descripción        |
|---------------|---------:|--------------------|
| `FLASH_CLK`   | 59       | Reloj memoria flash |
| `FLASH_CSB`   | 60       | Chip select flash   |
| `FLASH_MOSI`  | 61       | MOSI flash          |
| `FLASH_MISO`  | 62       | MISO flash          |

En las prácticas básicas normalmente **no se modifican** las señales de flash.

---

## 4. Pines para módulos de audio / I2S

En el curso original se reutilizan pines etiquetados como `SMALL_LCD_*` y `TF_*` para módulos de audio (PCM5102) y micrófono (INMP441).  
En este repositorio pueden reservarse para contenidos avanzados.

| Señal lógica          | Pin FPGA | Comentario                       |
|-----------------------|---------:|----------------------------------|
| `TF_CS`               | 38       | INMP441: LR / chip select SPI    |
| `TF_MOSI`             | 37       | INMP441: WS                      |
| `TF_SCLK`             | 36       | INMP441: SCK                     |
| `TF_MISO`             | 39       | INMP441: SD                      |
| `SMALL_LCD_DATA`      | 77       | PCM5102: SCK / MCLK              |
| `SMALL_LCD_CLK`       | 76       | PCM5102: BCK / BCLK              |
| `SMALL_LCD_RESETN`    | 47       | Reset módulo pequeño / audio     |
| `SMALL_LCD_CS`        | 48       | PCM5102: DIN / SDATA             |
| `SMALL_LCD_RS`        | 49       | PCM5102: LRCK / LRCLK            |

---

## 5. Pines no utilizados (1.8 V)

En el `.cst` original hay pines marcados como **1.8 V**, que se dejan sin usar en los ejemplos del curso para evitar problemas de niveles lógicos.

Ejemplo:

```text
# IO_LOC "GPIO_1_8_V_UNUSED[0]" 85;
# IO_LOC "GPIO_1_8_V_UNUSED[1]" 84;
...
```