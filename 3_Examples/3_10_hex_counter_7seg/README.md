# 3.10 Hex counter en display de 7 segmentos

Este ejemplo implementa un **contador hexadecimal de 32 bits** y lo muestra en los  
**8 dígitos de un display de 7 segmentos**. La velocidad del conteo se puede ajustar  
en tiempo real usando dos teclas (`key[0]` y `key[1]`).

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender cómo controlar la **frecuencia** de un contador usando un registro `period`.
- Implementar un contador de 32 bits (`cnt_2`) que se incrementa con un periodo variable.
- Visualizar el valor del contador en formato **hexadecimal** en un display de 7 segmentos.
- Reutilizar el módulo genérico `seven_segment_display` del repositorio.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope sintetizable para la Tang Nano 9K (configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`), que contiene:
  - Control del periodo (`period`) con dos teclas.
  - Un contador descendente (`cnt_1`) que genera un “tick”.
  - El contador principal (`cnt_2`) de 32 bits.
  - El mapeo de `cnt_2` al display de 7 segmentos a través de `seven_segment_display`.
  - Los 8 LEDs como salida de debug (`cnt_2[7:0]`).

- `labs/common/seven_segment_display.sv`  
  Módulo reutilizable que:
  - Recibe un número binario.
  - Lo descompone en campos de 4 bits.
  - Muestra cada nibble como dígito hexadecimal en los 7 segmentos, usando multiplexeo.

- `README.md`  
  Este archivo con la explicación del ejemplo.

---

## Señales y pines

### Entradas

- `clock`  
  Reloj principal de la FPGA (≈ 27 MHz en esta board).

- `reset`  
  Reset asíncrono activo en alto; pone en cero `period`, `cnt_1` y `cnt_2` (según lógica).

- `key[7:0]`  
  Se usan solo dos bits:

  - `key[0]` → Aumenta el periodo → contador más lento.
  - `key[1]` → Disminuye el periodo → contador más rápido.

  Los demás bits pueden usarse para extensiones o se ignoran.

### Salidas

- `led[7:0]`  
  Muestran los 8 bits menos significativos de `cnt_2`:

  ```sv
  assign led = cnt_2[7:0];
  ```