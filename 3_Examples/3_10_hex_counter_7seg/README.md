# 3.10 Hex counter en display de 7 segmentos

Este ejemplo implementa un **contador hexadecimal de 32 bits** y lo muestra en los   **8 dígitos de un display de 7 segmentos**. La velocidad del conteo se puede ajustar  en tiempo real usando dos teclas (`key[0]` y `key[1]`).

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender cómo controlar la **frecuencia** de un contador usando un registro `period`.
- Implementar un contador de 32 bits (`cnt_2`) que se incrementa con un periodo variable.
- Visualizar el valor del contador en formato **hexadecimal** en un display de 7 segmentos.
- Reutilizar el módulo genérico `seven_segment_display` del repositorio.

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