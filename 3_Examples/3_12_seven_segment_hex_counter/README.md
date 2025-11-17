# 3.12 Seven-segment HEX counter (multiplexado)

Este ejemplo muestra cómo implementar **un contador hexadecimal de 32 bits** en el display de 7 segmentos del TM1638, haciendo **el multiplexado “a mano”**:

- El contador `hex_counter` es de 32 bits.
- Cada dígito de 7 segmentos muestra 4 bits (un nibble) del contador.
- Se usan los 8 dígitos del display para mostrar el valor completo en HEX.
- Los LEDs muestran el byte menos significativo del contador como debug.

Es el siguiente paso natural después de:

- **3_11_seven_segment_basics** (un solo dígito, sin multiplex).
- **3_10_hex_counter_7seg** (usa el módulo `seven_segment_display` ya hecho).

Aquí tú controlas explícitamente:

- Qué dígito está activo (one-hot en `digit`).
- Qué nibble va a segmentos según el dígito activo.
- La velocidad de conteo y de refresco del display.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender el **principio de multiplexado** de displays de 7 segmentos.
- Implementar un contador HEX de 32 bits mostrado en 8 dígitos.
- Separar claramente:
  - Lógica de conteo (contador lento).
  - Lógica de refresco de display (contador rápido).
  - Lógica de decodificación HEX → 7 segmentos.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope sintetizable para la Tang Nano 9K (configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`), que contiene:

  - Un **tick lento** (`tick_100ms`) para incrementar el contador cada ~100 ms.
  - Un contador de 32 bits `hex_counter` que se muestra en HEX.
  - Un contador rápido `refresh_cnt` para multiplexar los 8 dígitos.
  - La función `hex_to_7seg` que convierte un nibble (0–F) a segmentos `abcdefgh`.

---

## Señales y pines relevantes

### Entradas

- `clock`  
  Reloj principal (≈ 27 MHz).

- `reset`  
  Reset asíncrono activo en alto.

- `key[7:0]`  
  No se usa en la lógica principal de este ejemplo (puedes extenderlo en ejercicios).

### Salidas

- `led[7:0]`  
  `led = hex_counter[7:0];`  
  Muestra el byte menos significativo del contador en binario.

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
  `1` = segmento encendido, `0` = apagado.  
  El punto decimal (h) se deja apagado (`segs[0] = 0`).

- `digit[7:0]`  

  Selección **one-hot** del dígito activo:

  | `digit`         | Dígito activo |
  |-----------------|---------------|
  | `0000_0001`     | Dígito 0      |
  | `0000_0010`     | Dígito 1      |
  | `0000_0100`     | Dígito 2      |
  | `0000_1000`     | Dígito 3      |
  | `0001_0000`     | Dígito 4      |
  | `0010_0000`     | Dígito 5      |
  | `0100_0000`     | Dígito 6      |
  | `1000_0000`     | Dígito 7      |

- `red`, `green`, `blue`  
  Forzados a 0 (LCD apagado en este ejemplo).

- `gpio[3:0]`  
  Alta impedancia (`'z`).

---

## Estructura interna del diseño

### 1. Tick lento para el contador

Se genera un pulso (`tick_100ms`) aproximadamente cada 100 ms:

```sv
localparam int unsigned CLK_HZ   = 27_000_000;
localparam int unsigned TICK_HZ  = 10;          // 10 incrementos/seg
localparam int unsigned TICK_MAX = CLK_HZ / TICK_HZ;

logic [31:0] tick_cnt;
logic        tick_100ms;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        tick_cnt    <= 32'd0;
        tick_100ms  <= 1'b0;
    end else if (tick_cnt == TICK_MAX - 1) begin
        tick_cnt    <= 32'd0;
        tick_100ms  <= 1'b1;
    end else begin
        tick_cnt    <= tick_cnt + 32'd1;
        tick_100ms  <= 1'b0;
    end
end
```