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
- Confirmar que los **LEDs** responden directamente a esas entradas.
- Ver cómo el valor de las teclas se refleja en el **display TM1638** como número hexadecimal usando el módulo `seven_segment_display`.

Este ejemplo sirve como **punto de partida** para todos los ejercicios con TM1638.

---

## Señales principales

### Entradas / salidas lógicas

En `hackathon_top.sv` se usan principalmente:

Entradas:

    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,
    input  logic [7:0] key,

Salidas hacia la tarjeta TM1638:

    output logic [7:0] led,
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

Salidas no usadas en este ejemplo (forzadas a 0 o alta impedancia):

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,
    inout  logic [3:0] gpio

En este quickstart:

- `red`, `green`, `blue` se fuerzan a cero (LCD apagada).
- `gpio` se deja en `'z` (sin uso).

---

## Comportamiento básico

### 1. Teclas → LEDs

El comportamiento mínimo suele ser:

- Reflejar el valor de las teclas directamente en los LEDs.

Ejemplo típico:

    assign led = key;

De esta forma:

- Si se activa solamente `key[0]`, se enciende únicamente `led[0]`.
- Si se activa `key = 8'b1111_0000`, se encienden `led[7:4]`.
- Se puede comprobar rápidamente que el escaneo de teclas y el cableado son correctos.

### 2. Teclas → valor numérico (para 7 segmentos)

Se toma el mismo vector `key[7:0]` como número a mostrar:

    logic [7:0] value;

    always_comb begin
        value = key;  // en este quickstart, “número” = patrón de teclas
    end

En ejemplos más avanzados, se podrían usar solo algunos bits, o bien combinar botones para formar un valor concreto.

---

## Uso del display TM1638

El TM1638 de la tarjeta hackathon se maneja indirectamente:

- El driver de la placa se encarga del protocolo TM1638.
- Tu módulo `hackathon_top` solo necesita producir:
  - `abcdefgh[7:0]` → segmentos a–h para el dígito activo.
  - `digit[7:0]`    → máscara one-hot del dígito activo (multiplexado).

En este quickstart se recomienda **no implementar el multiplexado a mano**, sino usar el módulo reutilizable `seven_segment_display`.

### 1. Módulo `seven_segment_display`

Instanciación típica:

    seven_segment_display #(
        .w_digit (8)   // 8 dígitos en el módulo TM1638 de la tarjeta
    ) i_7segment (
        .clk      (clock),
        .rst      (reset),
        .number   (value),          // número a mostrar (aquí, key[7:0])
        .dots     (8'b0000_0000),   // puntos decimales apagados
        .abcdefgh (abcdefgh),
        .digit    (digit)
    );

- `number` recibe el valor que se quiere mostrar (en este ejemplo, `value = key`).
- `dots` controla los puntos decimales (`h`) de cada dígito.
- El propio módulo:
  - Multiplexa los 8 dígitos.
  - Genera los patrones de segmentos correspondientes.

De esta manera, el quickstart se centra en:

- Proporcionar un valor a `number`.
- Ver el resultado en el TM1638.

---

## Apagado de la LCD y GPIO

Como en este ejemplo solo interesa el TM1638:

    assign red   = 5'd0;
    assign green = 6'd0;
    assign blue  = 5'd0;

    assign gpio  = 4'bz;

- La pantalla LCD permanece en negro.
- Los pines `gpio[3:0]` quedan disponibles para otros ejemplos o extensiones futuras.

---

## Resumen

- `key[7:0]` se usa como valor de prueba.
- `led[7:0]` refleja ese valor en binario.
- El módulo `seven_segment_display` convierte `value` (derivado de `key`) en segmentos para el TM1638.
- LCD y GPIO se mantienen sin uso para que el foco esté en el TM1638.

Este ejemplo permite verificar rápidamente que:

- El wiring de TM1638 está correcto.
- El reloj, reset y flujos básicos de `hackathon_top.sv` funcionan.
- Las bases para ejercicios posteriores con teclado, LEDs y displays de 7 segmentos están en su lugar.
