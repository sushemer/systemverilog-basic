# 4_9_5 – Contadores y patrones de desplazamiento en LEDs

Actividad basada en `4_05_counters_and_shift_patterns`, incluida en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Practicar:

- Uso de un **divisor de frecuencia** para obtener un paso lento (`step_en`) a partir del reloj de la FPGA.
- Implementación de **patrones secuenciales** en un vector de 8 LEDs:
  - Contador binario (`free-running counter`).
  - Registro de desplazamiento (“running light”).
  - Patrón tipo **ping-pong** (bit que rebota entre extremos).
- Selección de patrones mediante bits de entrada (`key`).

---

## Mapeo de señales

### Entradas

- `clock`  
  Reloj principal de la FPGA (~27 MHz en Tang Nano 9K).

- `reset`  
  Reset síncrono/asíncrono (según wrapper de la placa) para inicializar los contadores.

- `key[1:0]`  
  Selección de modo/patrón de LEDs:

  ```sv
  mode = key[1:0]

  00 → contador binario
  01 → desplazamiento circular
  10 → ping-pong (rebote)
  11 → mezcla XOR de contador y shift circular
  ```