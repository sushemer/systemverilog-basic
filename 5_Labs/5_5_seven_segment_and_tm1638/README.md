# Lab 5.5 – Seven-segment + TM1638 playground

## Objetivo

Practicar el uso del módulo `seven_segment_display` del repositorio y entender cómo:

- Mapear un valor binario de 32 bits a **8 dígitos HEX**.
- Usar las teclas (`key[7:0]`) como **entrada** y los puntos decimales (`dots`) como **indicadores**.
- Usar los LEDs (`led[7:0]`) del TM1638 como salida adicional para depuración.

Al terminar este lab deberías sentirte cómodo:

- Configurando el driver de 7 segmentos (`w_digit`, `number`, `dots`).
- Dividiendo números en **nibbles** (4 bits por dígito).
- Diseñando pequeños “modos” de visualización controlados por teclas.

---

## Prerrequisitos

- Haber visto o realizado:

  - **Lab 5.1 – blink_hello_world** (divisor de frecuencia).
  - **Actividad 4.6 – seven_segment_playground** (si ya la trabajaste).

- Conocer:

  - Cómo funciona un display de 7 segmentos multiplexado.
  - La relación nibble ↔ dígito HEX.

---

## Mapeo de señales

- `mode = key[1:0]`  
  Selecciona el modo de visualización del display:

  - `00` → **Modo 0**: contador HEX.
  - `01` → **Modo 1**: nibbles desde `key[7:0]`.
  - `10` → **Modo 2**: patrón fijo `DEAD_BEEF`.
  - `11` → **Modo 3**: número invertido `~counter`.

- `hex_counter[31:0]`  
  Contador libre que incrementa con cada `tick`.

- `number_reg[31:0]`  
  Valor que va al display de 7 segmentos (8 dígitos HEX).

- `dots_reg[7:0]`  
  Puntos decimales; el lab base los iguala a `key[7:0]`.

- `led[7:0]` (TM1638 LEDs):

  - `led[1:0]` → modo activo (copia de `mode`).
  - `led[7:2]` → bits bajos de `hex_counter` (patrón decorativo).

---

## Descripción de los modos

### Modo 0 – Contador HEX

- `mode = 2'b00` (`key[1:0] = 00`).
- `number_reg <= hex_counter;`
- El display muestra un conteo hexadecimal libre de 32 bits
  (de `0000_0000` hasta `FFFF_FFFF` y vuelve a empezar).

### Modo 1 – Playground manual con key

- `mode = 2'b01`.
- `number_reg <= { 24'h0, key[7:4], key[3:0] };`
- Solo se usan los dos dígitos menos significativos:

  - D0 muestra `key[3:0]`.
  - D1 muestra `key[7:4]`.
  - D2..D7 = 0.

Sirve para ver rápidamente cómo cambian los dígitos al modificar `key`.

### Modo 2 – Patrón fijo DEAD_BEEF

- `mode = 2'b10`.
- `number_reg <= 32'hDEAD_BEEF;`
- El display muestra `DEAD_BEEF` permanentemente.
- Útil como patrón de prueba y para acostumbrarte a leer HEX en 7 segmentos.

### Modo 3 – Número invertido

- `mode = 2'b11`.
- `number_reg <= ~hex_counter;`
- Muestra el complemento bit a bit del contador.
- Te permite comparar visualmente Modo 0 vs Modo 3.

---

## Procedimiento sugerido

1. **Revisa el divisor de frecuencia**

   - Observa el bloque con `W_DIV`, `div_cnt` y `tick`.
   - Cambia `W_DIV` y verifica cómo cambia la velocidad del contador en el display.

2. **Estudia el mapping de modos**

   - Localiza el `case (mode)` en `always_ff`.
   - Dibuja una tabla con:
     - `mode`, `number_reg`, significado en texto.
   - Asegúrate de entender cómo se construye cada patrón.

3. **Relaciona nibbles con dígitos**

   - Recuerda: cada dígito HEX son 4 bits (`0–F`).
   - Fíjate cómo `DEAD_BEEF` se reparte en 8 dígitos:

     - D7 = D, D6 = E, D5 = A, D4 = D, D3 = B, D2 = E, D1 = E, D0 = F.

4. **Prueba en hardware**

   - Sintetiza y programa la FPGA.
   - Cambia `mode` variando `key[1:0]` y observa:
     - Cambio de patrón en el display.
     - Cambio en `led[1:0]`.
   - Presiona distintas combinaciones de `key[7:0]` y mira cómo:
     - Modo 1 actualiza los dos dígitos bajos.
     - Los puntos decimales siguen el patrón exacto de `key`.

5. **Juega con dots**

   - Usa `dots_reg <= key;` como base.
   - Cambia el código para que:
     - Solo cierto modo use puntos decimales.
     - O un bit específico de `key` encienda todos los dots.

---

## Checklist de pruebas

- [ ] El diseño sintetiza y programa en la Tang Nano 9K sin errores.
- [ ] En **Modo 0**, el valor del display cambia de forma continua (contador HEX).
- [ ] En **Modo 1**, los dos dígitos menos significativos reflejan `key[7:4]` y `key[3:0]`.
- [ ] En **Modo 2**, se muestra `DEAD_BEEF` y permanece estable.
- [ ] En **Modo 3**, el patrón cambia pero de forma distinta al Modo 0 (complemento).
- [ ] `led[1:0]` coinciden con `mode` para todos los modos.
- [ ] Los puntos decimales cambian al modificar `key[7:0]`.

---

## Extensiones opcionales

Si quieres exprimir más este lab:

- Implementa un modo donde el valor mostrado provenga de un **sensor** (ej. potenciómetro o ultrasónico), reusando lógica de otros labs.
- Cambia la visualización a **decimal**: por ejemplo, mostrar `0000`–`9999` en cuatro dígitos (requiere conversión binario→BCD).
- Usa algunos bits de `hex_counter` para hacer un efecto tipo “barra” usando los puntos decimales.

Este lab te prepara directo para el siguiente, donde podrás combinar 7 segmentos + TM1638 + sensores en algo más cercano a un mini panel de instrumentación. 😎
