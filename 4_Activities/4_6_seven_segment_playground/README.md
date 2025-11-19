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

`number_reg` contiene el valor a mostrar, empaquetado como 8 dígitos hex (`W_NUM = 32` bits).  
`dots_reg` controla los puntos decimales de cada dígito (1 bit por dígito).

---

## Estructura general sugerida

En `hackathon_top.sv` se suele tener:

```sv
logic [1:0]       mode;
logic [31:0]      counter;
logic [W_NUM-1:0] number_reg;
logic [7:0]       dots_reg;

assign mode = key[1:0];
```
Además, se puede incluir un divisor de frecuencia para generar un tick lento (tick) que controle la velocidad de las animaciones:
```sv
localparam int unsigned CLK_HZ   = 27_000_000;
localparam int unsigned TICK_HZ  = 10;               // 10 actualizaciones por segundo
localparam int unsigned TICK_MAX = CLK_HZ / TICK_HZ;

logic [31:0] tick_cnt;
logic        tick;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        tick_cnt <= 32'd0;
        tick     <= 1'b0;
    end
    else if (tick_cnt == TICK_MAX - 1) begin
        tick_cnt <= 32'd0;
        tick     <= 1'b1;
    end
    else begin
        tick_cnt <= tick_cnt + 32'd1;
        tick     <= 1'b0;
    end
end
```
Además, se puede incluir un divisor de frecuencia para generar un tick lento (tick) que controle la velocidad de las animaciones:
```sv
localparam int unsigned CLK_HZ   = 27_000_000;
localparam int unsigned TICK_HZ  = 10;               // 10 actualizaciones por segundo
localparam int unsigned TICK_MAX = CLK_HZ / TICK_HZ;

logic [31:0] tick_cnt;
logic        tick;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        tick_cnt <= 32'd0;
        tick     <= 1'b0;
    end
    else if (tick_cnt == TICK_MAX - 1) begin
        tick_cnt <= 32'd0;
        tick     <= 1'b1;
    end
    else begin
        tick_cnt <= tick_cnt + 32'd1;
        tick     <= 1'b0;
    end
end
```

`tick` vale `1` aproximadamente `TICK_HZ` veces por segundo.  
Ese pulso se puede usar para incrementar contadores o desplazar patrones sin que vayan demasiado rápido.

---

## Modos sugeridos de visualización

A continuación se describen algunos modos que se pueden implementar utilizando `mode = key[1:0]`.

### Modo 0 – Contador hexadecimal libre

- `mode = 2'b00`.
- Se utiliza un contador de 32 bits que incrementa cada vez que `tick = 1`:

```sv
always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        counter <= 32'd0;
    end
    else if (tick) begin
        counter <= counter + 32'd1;
    end
end
```
Luego, se mapea directamente:
```sv
always_comb begin  
    number_reg = counter;      // 32 bits → 8 dígitos hex  
    dots_reg   = 8'b0000_0000; // puntos apagados  
end  
```
Resultado:

- El display muestra un contador hexadecimal que avanza de forma continua.  
- Es útil para verificar el multiplexado y el refresco del TM1638.  

---

### Modo 1 – Edición manual de un dígito
```sv
mode = 2'b01.  
```
Se toma key[7:4] como un nibble manual:

logic [3:0] manual_nibble;  
assign manual_nibble = key[7:4];  

Se puede, por ejemplo, replicar ese nibble en todos los dígitos para observarlo en diferentes posiciones:
```sv
always_comb begin  
    if (mode == 2'b01) begin  
        number_reg = {8{manual_nibble}};   // mismo nibble en los 8 dígitos  
        dots_reg   = 8'b0000_0000;  
    end  
end  

O, de forma alternativa, colocar el nibble solo en el dígito menos significativo:

always_comb begin  
    if (mode == 2'b01) begin  
        number_reg = {28'd0, manual_nibble}; // dígito 0 = manual_nibble  
        dots_reg   = 8'b0000_0001;           // ejemplo: encender el punto del dígito 0  
    end  
end  
```
Este modo permite probar manualmente diferentes valores hex (0–F) y ver cómo se codifican en segmentos.

---

### Modo 2 – Patrón que se desplaza (scrolling)
```sv
mode = 2'b10.  
```
Se puede diseñar un patrón fijo (por ejemplo, la palabra FACE_CAFE o 1234_ABCD) y desplazarlo.

Ejemplo básico: patrón base de 8 dígitos, más un shift controlado por tick:
```sv
localparam [31:0] BASE_PATTERN = 32'h1234_ABCD; // ejemplo  

logic [2:0] shift_pos;  

always_ff @(posedge clock or posedge reset) begin  
    if (reset) begin  
        shift_pos <= 3'd0;  
    end  
    else if (tick) begin  
        shift_pos <= shift_pos + 3'd1;  
    end  
end  
```
Luego, según shift_pos, se puede rotar los dígitos manualmente o, de forma más simple, usar diferentes secciones de un registro más grande (por ejemplo, duplicando el patrón). Como aproximación sencilla:
```sv
logic [63:0] extended_pattern;  
assign extended_pattern = {BASE_PATTERN, BASE_PATTERN}; // 16 dígitos  

always_comb begin  
    if (mode == 2'b10) begin  
        // Seleccionar una ventana de 8 dígitos dentro de extended_pattern  
        // (shift_pos decide el desplazamiento en múltiplos de 4 bits)  
        number_reg = extended_pattern >> (shift_pos * 4);  
        dots_reg   = 8'b0000_0000;  
    end  
end  
```
De esta forma el texto hex se desplaza de derecha a izquierda.

---

### Modo 3 – Uso de puntos decimales como indicadores
```sv
mode = 2'b11.  
```
En este modo se pueden usar los puntos decimales para indicar, por ejemplo:

- el modo actual,  
- estados de error,  
- o un patrón de “barrido” en los puntos.  

Ejemplo: encender alternadamente los puntos según counter:
```sv
always_comb begin  
    if (mode == 2'b11) begin  
        number_reg = 32'h0000_0000;         // se pueden dejar los dígitos en 0  
        dots_reg   = counter[7:0];          // usar el byte menos significativo como patrón de puntos  
    end  
end  
```
---

## Integración de modos en un único bloque

Una forma ordenada de combinar todos los modos es:
```sv
always_comb begin  
    // Valores por defecto  
    number_reg = 32'h0000_0000;  
    dots_reg   = 8'b0000_0000;  

    unique case (mode)  
        2'b00: begin  
            // Contador hex libre  
            number_reg = counter;  
            dots_reg   = 8'b0000_0000;  
        end  

        2'b01: begin  
            // Edición manual de un nibble  
            number_reg = {28'd0, manual_nibble};  
            dots_reg   = 8'b0000_0001; // encender punto del dígito 0  
        end  

        2'b10: begin  
            // Patrón desplazado  
            number_reg = extended_pattern >> (shift_pos * 4);  
            dots_reg   = 8'b0000_0000;  
        end  

        2'b11: begin  
            // Puntos decimales como indicadores  
            number_reg = 32'h0000_0000;  
            dots_reg   = counter[7:0];  
        end  

        default: begin  
            number_reg = 32'h0000_0000;  
            dots_reg   = 8'b0000_0000;  
        end  
    endcase  
end  
```
Los LEDs se pueden usar como ayuda visual adicional:
```sv
always_comb begin  
    led       = 8'b0000_0000;  
    led[1:0]  = mode;          // modo actual  
    led[7:2]  = counter[7:2];  // parte baja del contador como “debug”  
end  
```
---

## Pruebas sugeridas

Modo 0 – Contador hex:

- Ajustar TICK_HZ hasta que la cuenta sea visible pero no excesivamente lenta.  
- Observar cómo los dígitos menos significativos cambian más rápido.  

Modo 1 – Nibble manual:

- Cambiar key[7:4] por todas las combinaciones (0000–1111).  
- Confirmar que se muestran correctamente los símbolos 0–9, A–F.  

Modo 2 – Desplazamiento:

- Verificar que el patrón se mueve de forma suave.  
- Probar diferentes patrones en BASE_PATTERN.  

Modo 3 – Puntos decimales:

- Confirmar que dots_reg enciende y apaga los puntos de forma distinta a los segmentos normales.  
- Probar otras lógicas para dots_reg (por ejemplo, barras de progreso).  

---

## Extensiones opcionales

- Añadir control de velocidad dinámica con key[3:2] (por ejemplo, seleccionar distintos valores de TICK_HZ).  
- Usar el TM1638 para mostrar simultáneamente:  
  - en el display: el contador o los patrones,  
  - en los LEDs del TM1638: un estado adicional (modo, errores, etc.).  
- Probar a mostrar valores provenientes de otros módulos:  
  - lectura de sensores,  
  - resultados de otras actividades (ALU, encoder, etc.).  

Con esta actividad se obtiene un entorno flexible para practicar el uso del módulo seven_segment_display y diseñar distintos tipos de visualización en un display multiplexado de 7 segmentos.
