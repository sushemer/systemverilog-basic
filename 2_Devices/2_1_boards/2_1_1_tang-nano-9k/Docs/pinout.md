# Pinout · Tang Nano 9K

This document summarizes the relationship between **logical signals** used in the repository and the **physical FPGA pins** on the Tang Nano 9K.

The assignment is defined in the constraints file:

`2_devices/2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

> Note: only the most relevant signals for the examples, activities, and labs are listed here.  
> The `.cst` file may contain additional signals for more advanced uses.

---

## 1. Basic pins for the course

These are the most frequently used pins in early examples and labs: clock, buttons, LEDs, and general-purpose GPIO lines.

### 1.1 Clock

| Logical signal | FPGA Pin | Description               |
|----------------|----------:|---------------------------|
| `CLK`          | 52        | Main board clock          |

This signal is used in most examples as:

- Input `input CLK`
- Source for counters, dividers, FSM, etc.

---

### 1.2 Buttons (KEY)

| Logical signal | FPGA Pin | Description      |
|----------------|----------:|------------------|
| `KEY[0]`       | 4         | Button 0 (input) |
| `KEY[1]`       | 3         | Button 1 (input) |

Typical use:

- User inputs to change mode, reset counters, advance FSM states, etc.

---

### 1.3 User LEDs

| Logical signal | FPGA Pin | Description    |
|----------------|----------:|----------------|
| `LED[0]`       | 10        | LED 0 (output) |
| `LED[1]`       | 11        | LED 1 (output) |
| `LED[2]`       | 13        | LED 2 (output) |
| `LED[3]`       | 14        | LED 3 (output) |
| `LED[4]`       | 15        | LED 4 (output) |
| `LED[5]`       | 16        | LED 5 (output) |

Used for:

- Quick combinational logic tests.
- Counters, sequences (e.g., KITT).
- State indicators in FSMs.

---

### 1.4 GPIO for external modules

The first `GPIO[x]` lines are used mainly for the **TM1638** module (7-segment display + LEDs + keys).

| Logical signal | FPGA Pin | Use in the course                |
|----------------|----------:|----------------------------------|
| `GPIO[0]`      | 25        | TM1638 – DIO (data)              |
| `GPIO[1]`      | 26        | TM1638 – CLK (clock)             |
| `GPIO[2]`      | 27        | TM1638 – STB (strobe / latch)    |
| `GPIO[3]`      | 28        | General GPIO (reserved / future) |
| `GPIO[4]`      | 29        | General GPIO (reserved / future) |
| `GPIO[5]`      | 30        | General GPIO (reserved / future) |

When connecting other sensors/actuators to these pins, the corresponding README for the device and the example/lab must be updated.

---

## 2. Pins for large LCD (LARGE_LCD)

These pins are used in the original **basics-graphics-music** material to control a large graphical LCD.  
In this repository, they may be reserved for advanced practices.

| Logical signal     | FPGA Pin |
|--------------------|----------:|
| `LARGE_LCD_DE`     | 33        |
| `LARGE_LCD_VS`     | 34        |
| `LARGE_LCD_HS`     | 40        |
| `LARGE_LCD_CK`     | 35        |
| `LARGE_LCD_INIT`   | 63        |
| `LARGE_LCD_BL`     | 86        |
| `LARGE_LCD_R[3]`   | 75        |
| `LARGE_LCD_R[4]`   | 74        |
| `LARGE_LCD_R[5]`   | 73        |
| `LARGE_LCD_R[6]`   | 72        |
| `LARGE_LCD_R[7]`   | 71        |
| `LARGE_LCD_G[2]`   | 70        |
| `LARGE_LCD_G[3]`   | 69        |
| `LARGE_LCD_G[4]`   | 68        |
| `LARGE_LCD_G[5]`   | 57        |
| `LARGE_LCD_G[6]`   | 56        |
| `LARGE_LCD_G[7]`   | 55        |
| `LARGE_LCD_B[3]`   | 54        |
| `LARGE_LCD_B[4]`   | 53        |
| `LARGE_LCD_B[5]`   | 51        |
| `LARGE_LCD_B[6]`   | 42        |
| `LARGE_LCD_B[7]`   | 41        |

---

## 3. UART and storage

| Logical signal | FPGA Pin | Description                  |
|----------------|----------:|------------------------------|
| `UART_RX`      | 18        | UART reception from PC/module |
| `UART_TX`      | 17        | UART transmission to PC/module |

| Logical signal | FPGA Pin | Description       |
|----------------|----------:|-------------------|
| `FLASH_CLK`    | 59        | Flash clock       |
| `FLASH_CSB`    | 60        | Flash chip select |
| `FLASH_MOSI`   | 61        | Flash MOSI        |
| `FLASH_MISO`   | 62        | Flash MISO        |

Flash signals are not normally modified in basic exercises.

---

## 4. Pins for audio / I2S modules

In the original course, pins labeled `SMALL_LCD_*` and `TF_*` are reused for audio modules (PCM5102) and microphone (INMP441).  
In this repository, they may be reserved for advanced content.

| Logical signal       | FPGA Pin | Comment                           |
|----------------------|----------:|-----------------------------------|
| `TF_CS`              | 38        | INMP441: LR / SPI chip select     |
| `TF_MOSI`            | 37        | INMP441: WS                       |
| `TF_SCLK`            | 36        | INMP441: SCK                      |
| `TF_MISO`            | 39        | INMP441: SD                       |
| `SMALL_LCD_DATA`     | 77        | PCM5102: SCK / MCLK               |
| `SMALL_LCD_CLK`      | 76        | PCM5102: BCK / BCLK               |
| `SMALL_LCD_RESETN`   | 47        | Reset for small LCD / audio       |
| `SMALL_LCD_CS`       | 48        | PCM5102: DIN / SDATA              |
| `SMALL_LCD_RS`       | 49        | PCM5102: LRCK / LRCLK             |

---

## 5. Unused pins (1.8 V)

In the original `.cst`, some pins are marked as **1.8 V**, which are left unused in the course examples to avoid logic-level issues.

Example:

# IO_LOC "GPIO_1_8_V_UNUSED[0]" 85;  
# IO_LOC "GPIO_1_8_V_UNUSED[1]" 84;  
...
