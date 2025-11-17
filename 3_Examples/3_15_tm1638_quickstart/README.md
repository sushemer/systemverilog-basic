# 3.15 TM1638 quickstart

Este ejemplo es un **“hola mundo” con el módulo TM1638** en la configuración:

> `tang_nano_9k_lcd_480_272_tm1638_hackathon`

La idea es tener la forma más simple de verificar:

- Lectura de teclas (`key[7:0]`).
- Encendido de LEDs (`led[7:0]`).
- Uso básico del display de 7 segmentos (TM1638) mediante las señales
  `abcdefgh` y `digit`.

No usamos la LCD en este ejemplo; se mantiene apagada.

---

## Objetivo

Al terminar este ejemplo podrás:

- Confirmar que las **entradas digitales** (teclas / switches) llegan correctamente al FPGA.
- Confirmar que los **LEDs** responden a esas entradas.
- Ver cómo el valor de las teclas se refleja en el **display TM1638** como número hexadecimal usando el módulo `seven_segment_display`.

Este ejemplo sirve como **punto de partida** para todos los ejercicios con TM1638.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope específico de la configuración de placa
  `tang_nano_9k_lcd_480_272_tm1638_hackathon` que:

  - Refleja `key[7:0]` directamente en `led[7:0]`.
  - Usa `seven_segment_display` para mostrar el valor de `key` en el TM1638.
  - Apaga la salida RGB de la LCD (no utilizada).

Este ejemplo asume que el repositorio ya contiene:

- `seven_segment_display.sv`  
  (u otro módulo equivalente usado en ejemplos anteriores como `3_10_hex_counter_7seg`).

Y que el wrapper de la placa (`board_specific_top.sv`) ya se encarga de:

- Conectar `abcdefgh` y `digit` a las líneas del TM1638.
- Conectar `led` y `key` a los pines físicos de la placa y/o del módulo TM1638.

---

## Señales principales

### Entradas / salidas lógicas

En `hackathon_top.sv`:

```verilog
input  logic [7:0] key,
output logic [7:0] led,

output logic [7:0] abcdefgh,
output logic [7:0] digit,
