<!-- File: 4_Activities/4_06_seven_segment_playground/README.md -->

# 4.6 – Playground de display de 7 segmentos

En esta actividad vas a usar el módulo **`seven_segment_display`** ya disponible en el repositorio para experimentar con el display de 7 segmentos de la placa (8 dígitos).

La idea es que este ejemplo funcione como un **“parque de juegos” (playground)** donde pruebes:

- Contadores hexadecimales.
- Actualización manual de dígitos.
- Patrones que se desplazan de un lado a otro.
- Uso de puntos decimales (`dots`) como indicadores extra.
- Tus propios efectos visuales.

---

## Objetivo

Al terminar esta actividad deberías ser capaz de:

- Entender cómo se representa un número con múltiples dígitos hex en `number`.
- Usar las teclas (`key`) para seleccionar modos y modificar el contenido del display.
- Implementar al menos **dos modos de visualización** distintos (idealmente tres o cuatro).
- Ajustar la velocidad de animación con un divisor de frecuencia.

---

## Señales y módulos clave

### Entradas y salidas relevantes

- `clock` → reloj principal (~27 MHz).
- `reset` → reset síncrono.
- `key[7:0]` → se usan como:
  - `key[1:0]` → selección de **modo** (`mode`).
  - `key[7:4]` → nibble manual para probar dígitos (sugerido).
- `abcdefgh[7:0]` → segmentos del display (a–g + punto).
- `digit[7:0]` → selección de dígito activo (multiplexado).
- `led[7:0]` → puedes usarlos como indicador de modo o de estado.

### Módulo `seven_segment_display`

En el código se instancia:

```sv
localparam int W_DIGITS = 8;
localparam int W_NUM    = W_DIGITS * 4;  // 32 bits

logic [W_NUM-1:0]   number_reg;
logic [W_DIGITS-1:0] dots_reg;

seven_segment_display #(.w_digit(W_DIGITS)) i_7segment (
    .clk      ( clock      ),
    .rst      ( reset      ),
    .number   ( number_reg ),
    .dots     ( dots_reg   ),
    .abcdefgh ( abcdefgh   ),
    .digit    ( digit      )
);
```