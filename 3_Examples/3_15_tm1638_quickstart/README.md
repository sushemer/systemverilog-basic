# 3.15 TM1638 quickstart

Este ejemplo es un **“hola mundo” con el módulo TM1638** en la configuración:

> `tang_nano_9k_lcd_480_272_tm1638_hackathon`

La idea es tener la forma más simple de verificar:

- Lectura de teclas (`key[7:0]`).
- Encendido de LEDs (`led[7:0]`).
- Uso básico del display de 7 segmentos (TM1638) mediante las señales
  `abcdefgh` y `digit`.

No se usa la LCD en este ejemplo; se mantiene apagada.

---

## Objetivo

Al terminar este ejemplo, la persona usuaria podrá:

- Confirmar que las **entradas digitales** (teclas / switches) llegan correctamente al FPGA.
- Confirmar que los **LEDs** responden a esas entradas.
- Ver cómo el valor de las teclas se refleja en el **display TM1638** como número hexadecimal usando el módulo `seven_segment_display`.

Este ejemplo sirve como **punto de partida** para todos los ejercicios con TM1638.

---

## Señales principales

### Entradas / salidas lógicas

En `hackathon_top.sv` (vista simplificada):

```sv
input  logic       clock,
input  logic       slow_clock,
input  logic       reset,

input  logic [7:0] key,
output logic [7:0] led,

output logic [7:0] abcdefgh,
output logic [7:0] digit,

input  logic [8:0] x,
input  logic [8:0] y,
output logic [4:0] red,
output logic [5:0] green,
output logic [4:0] blue,

inout  logic [3:0] gpio
```

- `key[7:0]`  
  Entradas digitales (botones / switches de la tarjeta hackathon).

- `led[7:0]`  
  Salidas a LEDs discretos en la misma tarjeta.

- `abcdefgh[7:0]`, `digit[7:0]`  
  Salidas hacia el módulo TM1638 (7 segmentos + punto + selección de dígitos).

- `red`, `green`, `blue`  
  Salidas de la LCD (no se usan aquí, se fuerzan a 0).

- `gpio[3:0]`  
  Pines genéricos (no usados en este ejemplo).

---

## Estructura interna del ejemplo

La lógica de este quickstart es deliberadamente sencilla y se puede describir en tres bloques conceptuales.

### 1. Eco directo de teclas a LEDs

La forma más simple de comprobar que las entradas funcionan es **reflejar directamente** el valor de `key` en `led`:

```sv
assign led = key;
```

Interpretación:

- Si se activa `key[0]` → se enciende `led[0]`.
- Si se activan varias teclas, se encienden varios LEDs.

Esto permite verificar rápidamente que:

- Las teclas están cableadas correctamente.
- El reset no está bloqueando el flujo.
- El archivo de constraints está aplicando los pines adecuados.

### 2. Visualización en el TM1638 (7 segmentos)

Para mostrar un valor en el display TM1638 se utiliza el módulo reutilizable `seven_segment_display`.  
En este ejemplo se suele usar algo equivalente a:

```sv
logic [7:0] value_for_display;

assign value_for_display = key;  // por ejemplo, mostrar directamente key[7:0]

seven_segment_display #(
    .w_digit (8)   // 8 dígitos disponibles en el módulo TM1638
) i_7segment (
    .clk      (clock),
    .rst      (reset),
    .number   (value_for_display),
    .dots     (8'b0000_0000),   // todos los puntos decimales apagados
    .abcdefgh (abcdefgh),
    .digit    (digit)
);
```

Puntos importantes:

- `number` puede ser un bus de hasta 32 bits; el módulo se encarga de partirlo en nibbles y mostrarlo en HEX.
- En este quickstart, una opción simple es usar `key` como entrada:
  - Si se activa `key[3:0]`, se verá el valor 0–15 en HEX.
  - Si se usa todo `key[7:0]`, se verá un valor 0–255 en HEX (ocupando varios dígitos).
- `dots` se deja en cero para no encender puntos decimales.

Esto confirma que:

- La ruta lógica `FPGA → TM1638` funciona.
- La multiplexación interna del TM1638 y su driver están operativos.

### 3. Desactivar LCD y GPIO

Para evitar interferencias y dejar claro que este ejemplo es solo sobre TM1638, se fuerzan a valores fijos las salidas no usadas:

```sv
assign red   = '0;
assign green = '0;
assign blue  = '0;

assign gpio  = 4'bz;   // o '0, según la convención del wrapper
```

De este modo:

- La pantalla LCD permanece apagada (negro).
- `gpio` queda libre para otros ejemplos o hardware adicional.

---

## Flujo típico del `hackathon_top.sv`

Un posible esqueleto simplificado del archivo es:

```sv
// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
module hackathon_top (
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,

    inout  logic [3:0] gpio
);

    // 1) Eco de teclas a LEDs
    assign led = key;

    // 2) Valor para el display de 7 segmentos (ejemplo simple)
    logic [7:0] value_for_display;
    assign value_for_display = key;

    seven_segment_display #(
        .w_digit (8)
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   (value_for_display),
        .dots     (8'b0000_0000),
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

    // 3) LCD apagada
    assign red   = '0;
    assign green = '0;
    assign blue  = '0;

    // 4) GPIO sin uso
    assign gpio = 4'bz;

endmodule
```

---

## Qué observar en la tarjeta

Con el bitstream cargado:

1. Presionar diversas teclas / switches de `key[7:0]`:
   - Los LEDs deben encenderse según el patrón de teclas activas.
2. Mirar el módulo TM1638:
   - El valor de `key` debe reflejarse en el display como un número hexadecimal.
   - Si se modifican `key[3:0]`, se verá claramente el cambio en el dígito menos significativo.
3. Verificar que:
   - La LCD permanece en negro.
   - No hay comportamiento extraño en otros periféricos.

---

## Ideas para extender el ejemplo

Algunas variaciones que se pueden proponer como ejercicios:

- Mostrar por 7 segmentos **solo las teclas presionadas** en cierto rango (por ejemplo, `key[3:0]`).
- Encender los puntos decimales (`dots`) para marcar qué bits están activos.
- Usar una **FSM sencilla** que:
  - Cambie el modo de visualización según alguna tecla.
  - Por ejemplo, modo “HEX”, modo “binario desplazado”, modo “contador”.

Este quickstart está diseñado para que sea fácil verificar, en pocos minutos, que el camino:

> **Teclas → FPGA → LEDs/TM1638**

funciona correctamente antes de pasar a ejemplos más complejos.
