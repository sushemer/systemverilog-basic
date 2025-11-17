# 3.xx Ultrasonic HC-SR04 distance demo

Este ejemplo muestra cómo usar el **sensor ultrasónico HC-SR04** con la placa:

> `tang_nano_9k_lcd_480_272_tm1638_hackathon`

Se apoya en un módulo auxiliar ya existente:

- `ultrasonic_distance_sensor.sv`  
  que genera el pulso `TRIG`, mide el pulso `ECHO` y entrega una medida proporcional de distancia.

---

## Objetivo

Al finalizar este ejemplo podrás:

- Conectar un sensor **HC-SR04** a la Tang Nano 9K usando pines GPIO.
- Usar un módulo de medición de distancia basado en tiempo de eco.
- Visualizar la lectura:
  - Como **barras** en los LEDs.
  - Como valor **hexadecimal** en el display de 7 segmentos (TM1638).

Este ejemplo es un punto de partida para luego:

- Calibrar la medida en **cm** o **mm**.
- Dibujar elementos gráficos en la **LCD** basados en la distancia.
- Implementar alarmas de proximidad.

---

## Archivos del ejemplo

En esta carpeta se usan, al menos:

- `hackathon_top.sv`  
  Módulo tope para la configuración `tang_nano_9k_lcd_480_272_tm1638_hackathon`.  
  Se encarga de:
  - Instanciar `ultrasonic_distance_sensor`.
  - Conectar `TRIG` y `ECHO` vía `gpio[1:0]`.
  - Mostrar el resultado en LEDs y display de 7 segmentos.
  - Apagar la salida RGB de la LCD (no usada en este demo).

Este ejemplo asume que en el repositorio existen:

- `ultrasonic_distance_sensor.sv`  
  Implementa la lógica de disparo y medición del HC-SR04.

- `seven_segment_display.sv`  
  Módulo genérico que muestra números en formato hexadecimal en varios dígitos 7-seg, usado en otros ejemplos (como `3_10_hex_counter_7seg`).

---

## Señales y conexiones

### En `hackathon_top.sv`

```sv
wire [15:0] distance;

ultrasonic_distance_sensor #(
    .clk_frequency           (27 * 1000 * 1000),
    .relative_distance_width ($bits(distance))
) i_sensor (
    .clk               (clock),
    .rst               (reset),
    .trig              (gpio[0]),
    .echo              (gpio[1]),
    .relative_distance (distance)
);
```