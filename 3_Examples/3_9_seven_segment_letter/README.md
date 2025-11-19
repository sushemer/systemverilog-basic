# 3.9 Seven-segment letters (FPGA)

Este ejemplo muestra cómo **escribir letras en un display de 7 segmentos** usando:

- Un **registro de corrimiento one-hot** para seleccionar el dígito activo.
- Una **tabla de codificación** para las letras `F`, `P`, `G`, `A`.
- Multiplexeo rápido para que el ojo humano vea la palabra **"FPGA"** sólida.

---

## Objetivo

Al finalizar el ejemplo, la persona usuaria podrá:

- Entender cómo funciona el multiplexeo de un display de 7 segmentos.
- Implementar un **registro de corrimiento** para seleccionar dígitos.
- Crear una tabla de **patrones de segmentos** para mostrar letras.
- Ajustar la frecuencia de refresco hasta que las letras se vean “continuas”.

![Mapa de segmentos](Mult/seven_segment_font_editor.jpg)

---

## Señales y mapeo

### Entradas

- `clock`  
  Reloj principal de la FPGA (~27 MHz en esta configuración).

- `reset`  
  Reset asíncrono (activa en alto) para contador y registro de corrimiento.

- `key[7:0]`  
  No se utilizan en la versión básica, pero pueden servir para ejercicios posteriores
  (cambiar letras, velocidad, etc.).

### Salidas

- `abcdefgh[7:0]`  
  Bits de control de segmentos:

  - `a` → bit 7  
  - `b` → bit 6  
  - `c` → bit 5  
  - `d` → bit 4  
  - `e` → bit 3  
  - `f` → bit 2  
  - `g` → bit 1  
  - `h` → bit 0 (punto decimal u otro uso)

  Los patrones se definen con un `typedef enum`:

  ```sv
  typedef enum bit [7:0]
  {
      F     = 8'b1000_1110,
      P     = 8'b1100_1110,
      G     = 8'b1011_1100,
      A     = 8'b1110_1110,
      space = 8'b0000_0000
  } seven_seg_encoding_e;
  ```
