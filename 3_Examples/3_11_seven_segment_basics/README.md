# 3.11 Seven-segment basics

Este ejemplo introduce lo más básico del **display de 7 segmentos**:

- Cómo encender y apagar segmentos individuales.
- Cómo mapear un valor hexadecimal (0–F) a un patrón de segmentos.
- Cómo activar **un solo dígito** del display.
- Cómo controlar el **punto decimal** (segmento `h`).

Es la versión mínima para entender el “alfabeto” del display antes de usar módulos más avanzados como `seven_segment_display`.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Relacionar un nibble (`value` de 4 bits) con un símbolo mostrado en 7 segmentos.
- Entender la convención de bits de `abcdefgh`:
  - `a, b, c, d, e, f, g` + `h` (punto).
- Activar un único dígito del display usando una máscara one-hot en `digit`.
- Encender y apagar el punto decimal desde una entrada digital.

---

## Señales y pines

### Entradas

- `clock`  
  Reloj principal de la FPGA (≈ 27 MHz en la Tang Nano 9K).

- `reset`  
  Reset asíncrono activo en alto.

- `key[7:0]`  
  Se usan:

  - `key[3:0]` → valor hexadecimal `value` (0–15) a mostrar.
  - `key[4]`   → bandera `dp` para encender el **punto decimal** (segmento `h`).
  - `key[7:5]` → sin uso en este ejemplo (disponibles para modificaciones).

### Salidas

- `led[7:0]`  

  - `led[3:0]` = `value` (el mismo nibble que se está convirtiendo a 7-seg).
  - `led[4]`   = `dp` (estado del punto decimal).
  - `led[7:5]` = 0.

  Esto permite ver, directamente, qué valor se está enviando al display.

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

  Convención (para este ejemplo):

  - `1` → segmento encendido.
  - `0` → segmento apagado.

  El orden y la polaridad final pueden ajustarse en los drivers reales de `peripherals/` o `labs/common/`, según el hardware (TM1638, placa, etc.).

- `digit[7:0]`  

  - `digit = 8'b0000_0001` → solo un dígito activo (bit 0).
  - Los demás dígitos permanecen apagados.

  Dependiendo de la tarjeta, este dígito puede corresponder al más significativo o al menos significativo del módulo de 7 segmentos.

- `red`, `green`, `blue`  
  Forzadas a 0 (no se usa el LCD en este ejemplo).

- `gpio[3:0]`  
  Alta impedancia (`'z`), sin uso.

---

## Estructura interna

### 1. Lectura de entradas

En el código se separan las entradas en señales internas:

logic [3:0] value;
logic       dp;

assign value = key[3:0];
assign dp    = key[4];

- `value` es el nibble que representa el número hexadecimal (0–F).
- `dp` indica si el punto decimal debe estar encendido (`1`) o apagado (`0`).

Además, `value` y `dp` suelen reflejarse en `led[3:0]` y `led[4]` para depuración visual.

---

### 2. Decodificador hexadecimal → segmentos

El núcleo del ejemplo es un **decodificador** que convierte `value` en un patrón de 7 segmentos (`a`–`g`):

logic [6:0] seg_7bits;  // a-g

always_comb begin
    unique case (value)
        4'h0: seg_7bits = 7'b1111110;
        4'h1: seg_7bits = 7'b0110000;
        4'h2: seg_7bits = 7'b1101101;
        4'h3: seg_7bits = 7'b1111001;
        4'h4: seg_7bits = 7'b0110011;
        4'h5: seg_7bits = 7'b1011011;
        4'h6: seg_7bits = 7'b1011111;
        4'h7: seg_7bits = 7'b1110000;
        4'h8: seg_7bits = 7'b1111111;
        4'h9: seg_7bits = 7'b1111011;
        4'hA: seg_7bits = 7'b1110111;
        4'hB: seg_7bits = 7'b0011111;
        4'hC: seg_7bits = 7'b1001110;
        4'hD: seg_7bits = 7'b0111101;
        4'hE: seg_7bits = 7'b1001111;
        4'hF: seg_7bits = 7'b1000111;
        default: seg_7bits = 7'b0000000;
    endcase
end

Detalles:

- Cada patrón en `seg_7bits` enciende o apaga segmentos para formar la cifra deseada.
- El orden de bits (`a`–`g`) debe coincidir con el usado al construir `abcdefgh`.

---

### 3. Construcción del bus `abcdefgh`

Una vez calculados los 7 segmentos (`a`–`g`), se agrega el punto `h` usando `dp`:

logic [7:0] abcdefgh_int;

always_comb begin
    // seg_7bits = {a, b, c, d, e, f, g}
    abcdefgh_int[7:1] = seg_7bits; // a-g
    abcdefgh_int[0]   = dp;        // h (punto decimal)
end

assign abcdefgh = abcdefgh_int;

En este ejemplo:

- `dp = 1` → el punto decimal se enciende.
- `dp = 0` → el punto decimal se apaga.

---

### 4. Activación de un solo dígito

Para simplificar, se activa **un único dígito** del display usando una máscara one-hot fija:

assign digit = 8'b0000_0001;

- Solo el bit 0 está en 1; los demás están en 0.
- Dependiendo del hardware, este dígito puede ser el más significativo o el menos significativo.

En ejemplos más avanzados se implementa un **multiplexado** por tiempo, activando varios dígitos de forma alternada y rápida.  
Aquí se evita esa complejidad para centrarse en la relación `value → segmentos`.

---

### 5. LEDs, LCD y GPIO

Para mantener el ejemplo simple y autoexplicativo:

- `led[3:0]` muestran el valor `value`.
- `led[4]` muestra `dp`.
- `led[7:5]` se fuerzan a 0.
- `red`, `green`, `blue` se fuerzan a 0 (LCD apagado).
- `gpio[3:0]` se dejan en alta impedancia (`'z`).

Esto permite concentrarse solo en el comportamiento del display de 7 segmentos.

---

## Relación con otros archivos

- `1_2_8_Seven_Segment_Basics.md`  
  Explica, desde el punto de vista teórico, cómo funcionan los displays de 7 segmentos.

- Otros ejemplos / labs:
  - Ejemplos donde se multiplexan varios dígitos.
  - Labs que usan `seven_segment_display` para mostrar contadores, estados de FSM, etc.

---

## Posibles extensiones

A partir de este ejemplo base, se pueden explorar variaciones como:

- Mostrar un contador que incremente automáticamente en lugar de leer `key[3:0]`.
- Multiplexar varios dígitos usando un divisor de reloj y una pequeña FSM.
- Cambiar la tabla del decodificador para mostrar letras específicas (por ejemplo, `H`, `E`, `L`, `P`).
- Combinar el valor de un ADC (potenciómetro) con el decodificador para mostrar mediciones en el display.

Este ejemplo sirve como “Hello, world” del display de 7 segmentos dentro del repositorio.
