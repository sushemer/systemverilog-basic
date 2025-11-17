# 3.14 LCD – Rectángulo en movimiento

Este ejemplo es la **continuación directa** de `3_13_lcd` (figuras estáticas):

- Ahora el rectángulo **se mueve horizontalmente** sobre la pantalla.
- Usamos un módulo `strobe_gen` para generar un pulso lento (~30 Hz).
- Cada pulso incrementa un contador que desplaza el rectángulo.
- La posición del rectángulo se muestra en:
  - Los **LEDs** (8 bits menos significativos).
  - El **display de 7 segmentos**.

Es el primer paso hacia animaciones y mini-juegos en la LCD.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender cómo usar un **strobe** (pulso lento) para animar gráficos.
- Controlar la posición de una figura en función de un **contador**.
- Relacionar:
  - Lógica secuencial (contador).
  - Lógica combinacional (comparaciones con `x`, `y`).
  - Representación visual en la LCD.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope para la configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon` que:

  - Instancia el módulo `strobe_gen` (pulso a 30 Hz).
  - Implementa un contador de posición `rect_offset`.
  - Usa `(x, y)` y `rect_offset` para dibujar:
    - Fondo negro.
    - Barra horizontal verde fija.
    - Rectángulo rojo en movimiento.
  - Muestra `rect_offset` en LEDs y en el display de 7 segmentos.

El proyecto asume que ya existen en el repositorio:

- `strobe_gen.sv` o equivalente (en `labs/common` o `peripherals`).
- `seven_segment_display.sv`.
- El wrapper y archivos de board para la Tang Nano 9K con LCD.

---

## Señales y parámetros relevantes

### Parámetros de pantalla

En el código se definen:

- `SCREEN_WIDTH  = 480`
- `SCREEN_HEIGHT = 272`

para el panel LCD 480×272.

### Strobe y contador

- `strobe_gen`:

  ```sv
  strobe_gen #(
      .clk_mhz   (27),
      .strobe_hz (30)
  ) i_strobe_gen (
      .clk    (clock),
      .rst    (reset),
      .strobe (pulse)
  );
  ```