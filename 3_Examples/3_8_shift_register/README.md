# 3.8 Shift register (registro de corrimiento)

Este ejemplo implementa un **registro de corrimiento de 8 bits** usando:

- Un contador que genera un pulso de habilitación lento (`enable`) a partir del reloj rápido.
- Un registro `shift_reg[7:0]` que se desplaza cuando `enable = 1`.
- Un bit de entrada (`button_on`) que se carga en un extremo del registro.

Los LEDs muestran el contenido del registro, de modo que puede verse un patrón
que “se mueve” lentamente.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender el concepto de **registro de corrimiento** (`shift register`).
- Implementar un **divisor de frecuencia** simple con un contador.
- Observar cómo el patrón de bits se desplaza en el tiempo.
- Usar entradas (botones) para inyectar bits al registro.

---

## Señales principales y mapeo

### Entradas

- `clock`  
  Reloj principal de la FPGA (≈ 27 MHz en esta configuración de board).

- `reset`  
  Reset asíncrono activo en alto para el contador y el registro.

- `key[7:0]`  
  Teclas/botones de entrada.  
  Se combinan con un OR para formar una sola señal:

  ```sv
  wire button_on = |key;
  ```