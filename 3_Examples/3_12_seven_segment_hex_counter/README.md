# 3.12 Seven-segment HEX counter (multiplexado)

Este ejemplo muestra cómo implementar **un contador hexadecimal de 32 bits** en el display de 7 segmentos del TM1638, haciendo **el multiplexado “a mano”**:

- El contador `hex_counter` es de 32 bits.
- Cada dígito de 7 segmentos muestra 4 bits (un nibble) del contador.
- Se usan los 8 dígitos del display para mostrar el valor completo en HEX.
- Los LEDs muestran el byte menos significativo del contador como debug.

Es el siguiente paso natural después de:

- `3_11_seven_segment_basics` (un solo dígito, sin multiplex).
- `3_10_hex_counter_7seg` (usa el módulo `seven_segment_display` ya hecho).

Aquí la persona usuaria controla explícitamente:

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

## Señales y pines relevantes

### Entradas

- `clock`  
  Reloj principal (≈ 27 MHz en la Tang Nano 9K).

- `reset`  
  Reset asíncrono activo en alto.

- `key[7:0]`  
  No se usa en la lógica principal de este ejemplo (queda disponible para extensiones).

### Salidas

- `led[7:0]`  

  - `led = hex_counter[7:0];`  
    Muestra el byte menos significativo del contador en binario, útil como depuración rápida.

- `abcdefgh[7:0]`  

  Bits de segmentos:

    Bit 7 → a  
    Bit 6 → b  
    Bit 5 → c  
    Bit 4 → d  
    Bit 3 → e  
    Bit 2 → f  
    Bit 1 → g  
    Bit 0 → h (punto decimal)

  Convención (en este ejemplo):

  - `1` = segmento encendido.
  - `0` = segmento apagado.

  El punto decimal (h) se deja apagado en todos los dígitos (`segs[0] = 1'b0`).

- `digit[7:0]`  

  Selección **one-hot** del dígito activo:

    0000_0001 → Dígito 0  
    0000_0010 → Dígito 1  
    0000_0100 → Dígito 2  
    0000_1000 → Dígito 3  
    0001_0000 → Dígito 4  
    0010_0000 → Dígito 5  
    0100_0000 → Dígito 6  
    1000_0000 → Dígito 7  

  En cada instante solo un bit de `digit` está en 1; los demás permanecen en 0.

- `red`, `green`, `blue`  
  Forzados a 0 (LCD apagado en este ejemplo).

- `gpio[3:0]`  
  Alta impedancia (`'z`), sin uso.

---

## Estructura interna del diseño

A grandes rasgos, el diseño se organiza en varios bloques:

1. Generación de un **tick lento** para incrementar el contador HEX.
2. Contador de 32 bits `hex_counter`.
3. Lógica de **refresco rápido** para multiplexado (selección de dígito).
4. Selección del nibble a mostrar según el dígito activo.
5. Decodificador HEX → 7 segmentos.
6. Construcción de las señales `abcdefgh` y `digit`.

---

### 1. Tick lento para el contador

Se genera un pulso (`tick_100ms`) aproximadamente cada 100 ms usando el reloj principal:

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

- `tick_cnt` cuenta ciclos de `clock`.
- Cuando `tick_cnt` llega a `TICK_MAX - 1`, se genera un pulso de un ciclo en `tick_100ms` y se reinicia el contador.
- `tick_100ms` es la **señal de enable** para el contador de 32 bits.

Se puede cambiar `TICK_HZ` para hacer el conteo más rápido o más lento.

---

### 2. Contador hexadecimal de 32 bits

Usando el tick lento como enable, se implementa el contador principal:

logic [31:0] hex_counter;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        hex_counter <= 32'h0000_0000;
    end else if (tick_100ms) begin
        hex_counter <= hex_counter + 32'd1;
    end
end

- `hex_counter` incrementa una vez cada `tick_100ms` (≈ cada 100 ms con los parámetros de ejemplo).
- El valor de `hex_counter` es el que se mostrará en los 8 dígitos en formato hexadecimal.
- El byte menos significativo (`hex_counter[7:0]`) se refleja en `led[7:0]`.

---

### 3. Refresco rápido para el multiplexado

Para que el ojo humano vea los 8 dígitos “encendidos a la vez”, se enciende cada uno muy rápido, uno por uno.  
Se usa un pequeño contador rápido para seleccionar el dígito activo:

logic [15:0] refresh_cnt;
logic [2:0]  digit_index;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        refresh_cnt <= 16'd0;
        digit_index <= 3'd0;
    end else begin
        refresh_cnt <= refresh_cnt + 16'd1;
        digit_index <= refresh_cnt[15:13]; // usar bits altos como índice
    end
end

- `refresh_cnt` incrementa en cada ciclo de `clock`.
- Los bits altos de `refresh_cnt` se usan como `digit_index` (0–7).
- Debido a la rapidez del reloj, cada dígito se muestra por un tiempo muy corto, pero al recorrer los 8 dígitos continuamente el efecto visual es que todos están encendidos.

La elección de bits (`[15:13]`) puede variar según cuánto parpadeo se desee; se pueden ajustar para obtener más o menos tiempo por dígito.

---

### 4. Selección del nibble según el dígito activo

Según el `digit_index`, se selecciona qué grupo de 4 bits de `hex_counter` se enviará al decodificador de 7 segmentos:

logic [3:0] active_nibble;

always_comb begin
    unique case (digit_index)
        3'd0: active_nibble = hex_counter[ 3: 0];  // nibble menos significativo
        3'd1: active_nibble = hex_counter[ 7: 4];
        3'd2: active_nibble = hex_counter[11: 8];
        3'd3: active_nibble = hex_counter[15:12];
        3'd4: active_nibble = hex_counter[19:16];
        3'd5: active_nibble = hex_counter[23:20];
        3'd6: active_nibble = hex_counter[27:24];
        3'd7: active_nibble = hex_counter[31:28];  // nibble más significativo
        default: active_nibble = 4'h0;
    endcase
end

- Para cada `digit_index`, se toma un nibble distinto de `hex_counter`.
- De esta forma, mientras se recorre `digit_index` = 0…7, se van mostrando los 8 nibbles del contador.

---

### 5. Decodificador HEX → 7 segmentos

Se reutiliza la idea del ejemplo `3_11_seven_segment_basics`, pero sin usar el punto decimal (se fija en 0):

logic [6:0] seg_7bits;  // a-g

always_comb begin
    unique case (active_nibble)
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

- `seg_7bits` codifica qué segmentos (`a`–`g`) se encienden para el nibble actual.
- El orden de bits debe corresponder al usado al construir `abcdefgh`.

---

### 6. Construcción de `abcdefgh` y `digit`

Primero se empaquetan los segmentos:

logic [7:0] segments;

always_comb begin
    segments[7:1] = seg_7bits; // a-g
    segments[0]   = 1'b0;      // h (punto decimal apagado)
end

assign abcdefgh = segments;

Luego se crea la máscara one-hot para el dígito activo a partir de `digit_index`:

logic [7:0] digit_int;

always_comb begin
    // one-hot a partir del índice
    digit_int = 8'b0000_0001 << digit_index;
end

assign digit = digit_int;

- Solo un bit de `digit` está en 1 a la vez.
- El dígito seleccionado muestra el `active_nibble` correspondiente con el patrón `segments`.

---

## Relación con otros ejemplos

- `3_11_seven_segment_basics`  
  Introduce la idea de decodificar un nibble y mostrarlo en un solo dígito.

- `3_10_hex_counter_7seg`  
  Usa un módulo ya preparado (`seven_segment_display`) que se encarga del multiplexado internamente.

- En algunos labs posteriores se reutiliza la idea de multiplexado para mostrar:
  - Contadores.
  - Estados de FSM.
  - Valores de sensores (por ejemplo, distancia o posición).

---

## Posibles extensiones y ejercicios

Algunas ideas para experimentar sobre este ejemplo:

- Cambiar el periodo de `tick_100ms` para hacer el conteo más rápido o más lento.
- Usar un botón (`key[...]`) para pausar/reanudar el contador o para hacer reset a `hex_counter`.
- Aprovechar el punto decimal (`h`) para marcar el nibble que se está “leyendo” o para indicar un modo especial.
- Mostrar solo 4 dígitos (por ejemplo, el valor menos significativo de 16 bits) y usar los otros 4 dígitos para mostrar otra información.
- Combinar el valor de un ADC con parte del contador, para visualizar datos de sensores junto con un índice de tiempo.

Este ejemplo proporciona una base clara para entender cómo multiplexar 8 dígitos de 7 segmentos y cómo estructurar el código para separar conteo, refresco y decodificación.
