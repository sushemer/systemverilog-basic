# 4_9_6 – Seven Segment Playground

Actividad basada en `4_06_seven_segment_playground`, incluida en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Jugar con el módulo `seven_segment_display` del repo para:

- Mostrar distintos **patrones en los 8 dígitos** del display de 7 segmentos.
- Cambiar contenido y **puntos decimales** usando las teclas (`key`).
- Practicar:
  - Manejo de números hexadecimales por nibbles.
  - Animaciones con un **tick lento** generado desde el reloj principal.
  - Distintos modos de operación controlados por `key`.

---

## Mapeo de señales

### Entradas

- `clock`  
  Reloj principal de la FPGA (~27 MHz).

- `reset`  
  Reset del sistema.

- `key[1:0]` → selección de modo:

  ```
  mode = key[1:0]

  00 → Contador hexadecimal libre
  01 → Playground manual (key[7:4] en D0)
  10 → “Barra” / dígito 0xF que recorre los 8 dígitos
  11 → Patrón fijo 0xDEAD_BEEF
  ```