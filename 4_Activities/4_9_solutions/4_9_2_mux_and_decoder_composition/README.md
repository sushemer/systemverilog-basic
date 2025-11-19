# 4_9_2 – Mux 4→1 + Decoder 2→4 (composición)

Esta solución corresponde a la actividad basada en `4_02_mux_and_decoder_composition`, pero ubicada en la carpeta de soluciones `4_9_solutions`.

Su propósito es mostrar una implementación completa y ordenada de:

- Un **decoder 2→4 one-hot**.
- Un **multiplexor 4→1** construido a partir de:
  - Las salidas one-hot del decoder.
  - Compuertas AND.
  - Una OR final.

---

## Objetivo

Practicar la **composición de bloques combinacionales**, pasando de señales de selección simples (`sel[1:0]`) a:

1. Un vector one-hot `dec_out[3:0]` (decoder 2→4).
2. Un mux 4→1 que usa ese one-hot para elegir uno de los bits de `data[3:0]`.

Todo ello se visualiza en los LEDs de la placa para facilitar la verificación.

---

## Mapeo de señales

### Entradas desde `key`

- `sel[1:0] = key[1:0]`  
  Bits de selección del canal del mux (índice entre 0 y 3).

- `data[3:0] = key[5:2]`  
  Datos de entrada al mux; cada bit representa un canal independiente.

En el código típico dentro de `hackathon_top.sv`:

    logic [1:0] sel;
    logic [3:0] data;

    assign sel  = key[1:0];
    assign data = key[5:2];

### Salidas hacia `led`

- `led[3:0] = dec_out[3:0]`  
  Muestran la salida del **decoder 2→4** (código one-hot).

- `led[4] = mux_y`  
  Indica la salida del **mux 4→1**.

- `led[7:5]`  
  No se usan en esta solución (quedan libres para extensiones o depuración).

Ejemplo de asignación final:

    assign led[3:0] = dec_out;
    assign led[4]   = mux_y;
    assign led[7:5] = 3'b000;  // libres en esta solución

---

## Diseño lógico

### 1. Decoder 2→4 one-hot

El decoder toma `sel[1:0]` y genera `dec_out[3:0]` con codificación one-hot:

- `sel = 2'b00 → dec_out = 4'b0001`
- `sel = 2'b01 → dec_out = 4'b0010`
- `sel = 2'b10 → dec_out = 4'b0100`
- `sel = 2'b11 → dec_out = 4'b1000`

Es importante inicializar `dec_out` a cero y luego asignar exactamente un bit en 1.  
Una implementación típica en `always_comb` es:

    logic [3:0] dec_out;

    always_comb begin
        dec_out = 4'b0000;  // valor por defecto

        unique case (sel)
            2'b00: dec_out = 4'b0001;
            2'b01: dec_out = 4'b0010;
            2'b10: dec_out = 4'b0100;
            2'b11: dec_out = 4'b1000;
            default: dec_out = 4'b0000;
        endcase
    end

Con esto se garantiza que, para cada valor válido de `sel`, solo un bit de `dec_out` está en 1.

---

### 2. Mux 4→1 construido con decoder + AND + OR

El mux 4→1 se construye **sin** usar directamente el operador condicional `?:` ni un `case` sobre `sel`.  
En su lugar, se usan:

1. Las salidas one-hot del decoder (`dec_out[3:0]`).
2. Compuertas AND por cada canal.
3. Una OR final para combinar los términos.

Idea lógica:

- `and0 = dec_out[0] & data[0]`
- `and1 = dec_out[1] & data[1]`
- `and2 = dec_out[2] & data[2]`
- `and3 = dec_out[3] & data[3]`
- `mux_y = and0 | and1 | and2 | and3`

Esto se puede escribir así:

    logic and0, and1, and2, and3;
    logic mux_y;

    always_comb begin
        and0 = dec_out[0] & data[0];
        and1 = dec_out[1] & data[1];
        and2 = dec_out[2] & data[2];
        and3 = dec_out[3] & data[3];

        mux_y = and0 | and1 | and2 | and3;
    end

La clave es que, como `dec_out` es one-hot, **solo uno** de los términos AND puede ser 1 a la vez.  
Por lo tanto, `mux_y` equivale a `data[sel]`, pero implementado mediante la composición:

> selección (`sel`) → decoder 2→4 → AND con datos → OR final.

---

## Resumen de la solución

La solución en `4_9_2` para `hackathon_top.sv` sigue típicamente este flujo:

1. **Lectura de entradas desde `key`:**
   - `sel` y `data` se obtienen de bits específicos de `key`.

2. **Decoder 2→4:**
   - `always_comb` con `case (sel)` para generar `dec_out` en formato one-hot.
   - Resultado visible en `led[3:0]`.

3. **Mux 4→1:**
   - Uso de `dec_out` y `data` para formar términos AND.
   - OR de todos los términos para obtener `mux_y`.
   - Resultado visible en `led[4]`.

4. **LEDs restantes (`led[7:5]`):**
   - En esta solución se dejan en 0, pero se pueden usar para:
     - Mostrar `sel`.
     - Mostrar una copia de `data`.
     - Añadir una señal de habilitación u otros estados de depuración.

---

## Cómo probar en la placa

1. Programar la Tang Nano 9K con el bitstream de esta solución.
2. Ajustar las entradas:
   - Cambiar `sel` con `key[1:0]` para elegir el canal (0–3).
   - Cambiar los valores de `data[3:0]` con `key[5:2]`.

3. Observar los LEDs:
   - `led[3:0]`: muestran qué **canal está activo** según `sel` (salida del decoder one-hot).
   - `led[4]`: muestra el bit de `data` seleccionado (`mux_y`).

### Ejemplo de prueba

- Si `data = 4'b1010` y `sel = 2'b10`:
  - `dec_out = 4'b0100`
  - El canal seleccionado es `data[2]`.
  - `mux_y = data[2] = 1`
  - En la placa:
    - `led[2] = 1` (indica que el tercer canal está activo en el decoder).
    - `led[4] = 1` (salida del mux).

Así se puede verificar rápidamente que:

- El decoder 2→4 genera el patrón one-hot correcto.
- El mux 4→1, implementado mediante composición (decoder + AND + OR), selecciona el bit adecuado de `data`.
