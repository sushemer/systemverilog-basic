# 3.11 Seven-segment basics

Este ejemplo introduce lo más básico del **display de 7 segmentos**:

- Cómo encender y apagar segmentos individuales.
- Cómo mapear un valor hexadecimal (0–F) a un patrón de segmentos.
- Cómo activar **un solo dígito** del display.
- Cómo controlar el **punto decimal** (segmento `h`).

Es la versión mínima para entender el “alfabeto” del display antes de usar módulos más avanzados como `seven_segment_display`.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Relacionar un nibble (`value` de 4 bits) con un símbolo mostrado en 7 segmentos.
- Entender la convención de bits de `abcdefgh`:
  - `a, b, c, d, e, f, g` + `h` (punto).
- Activar un único dígito del display usando una máscara one-hot en `digit`.
- Encender y apagar el punto decimal desde una entrada digital.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope sintetizable para la Tang Nano 9K (configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`), que contiene:

  - Lectura de `key[3:0]` como valor hexadecimal `value`.
  - Lectura de `key[4]` como control del **punto decimal** `dp`.
  - Una función `hex_to_7seg` que codifica `value` en `abcdefgh`.
  - Activación de **un solo dígito** del display mediante `digit = 8'b0000_0001`.
  - Visualización de `value` y `dp` en los LEDs como debug.

- `README.md`  
  Este archivo con la explicación del ejemplo.

Los módulos de soporte del repositorio (board, TM1638, etc.) se cargan desde la carpeta de `boards` y `labs/common` a través de `board_specific_top.sv`, como en los demás ejemplos.

---

## Señales y pines

### Entradas

- `clock`  
  Reloj principal de la FPGA (≈ 27 MHz en la Tang Nano 9K).

- `reset`  
  Reset asíncrono activo en alto.

- `key[7:0]`  
  Se usan:

  - `key[3:0]` → valor hexadecimal `value` (0–15) a mostrar.
  - `key[4]` → bandera `dp` para encender el **punto decimal** (segmento `h`).
  - `key[7:5]` → sin uso en este ejemplo (disponibles para modificaciones).

### Salidas

- `led[7:0]`  

  - `led[3:0]` = `value` (el mismo nibble que se está convirtiendo a 7-seg).
  - `led[4]`   = `dp` (estado del punto decimal).
  - `led[7:5]` = 0.

  Esto permite ver, directamente, qué valor se está enviando al display.

- `abcdefgh[7:0]`  

  Bits de segmentos:

  | Bit | Segmento |
  |-----|----------|
  | 7   | a        |
  | 6   | b        |
  | 5   | c        |
  | 4   | d        |
  | 3   | e        |
  | 2   | f        |
  | 1   | g        |
  | 0   | h (punto)|

  Convención:

  - `1` → segmento encendido.
  - `0` → segmento apagado.

- `digit[7:0]`  

  - `digit = 8'b0000_0001` → sólo un dígito activo (bit 0).
  - Los demás dígitos permanecen apagados.

  Dependiendo de la tarjeta, ese dígito puede ser el más a la izquierda o el más a la derecha.

- `red`, `green`, `blue`  
  Forzados a 0 (no usamos el LCD en este ejemplo).

- `gpio[3:0]`  
  Alta impedancia (`'z`), sin uso.

---

## Estructura interna

### 1. Lectura de entradas

En el código:

```sv
logic [3:0] value;
logic       dp;

assign value = key[3:0];
assign dp    = key[4];
```