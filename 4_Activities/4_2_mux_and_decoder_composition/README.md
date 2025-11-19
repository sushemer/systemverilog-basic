# 4.2 – Composición: decoder 2→4 + mux 4→1

En esta actividad se van a **componer bloques combinacionales** para construir un circuito más completo a partir de piezas sencillas:

- Un **decoder 2→4** que genera una salida one-hot.
- Un **multiplexor 4→1** construido a partir de:
  - las salidas del decoder,
  - compuertas `AND`,
  - y una compuerta `OR` final.

Se usa la placa **Tang Nano 9K** con la configuración  
`tang_nano_9k_lcd_480_272_tm1638_hackathon` y el módulo tope `hackathon_top`.

---

## Objetivos de la actividad

Al finalizar, la persona usuaria será capaz de:

1. Implementar un **decoder 2→4** con salidas one-hot usando `always_comb` y `case`.
2. Construir un **mux 4→1** a partir del decoder y compuertas lógicas.
3. Visualizar tanto las salidas del decoder como la salida del mux en los LEDs de la placa.
4. Relacionar:
   - representación one-hot,
   - selección de canales de datos,
   - y salida de un multiplexor.

---

## Mapeo de señales (sugerido)

Entradas desde los botones `key`:

- Selectores (compartidos por decoder y mux):  
  `sel[1:0] = key[1:0]`
- Datos del mux (4 canales de 1 bit):  
  `data[3:0] = key[5:2]`

Salidas hacia los LEDs:

- `led[3:0]` → salidas del decoder (`dec_out[3:0]`), en formato **one-hot**.
- `led[4]`   → salida del mux 4→1 (`mux_y`).
- `led[7:5]` → libres para extensiones o depuración.

El display de 7 segmentos (`abcdefgh`, `digit`) y la LCD (`red`, `green`, `blue`) **no se usan** en esta actividad y se pueden dejar en cero.

---

## Descripción general del flujo

1. Las líneas `key[1:0]` se interpretan como `sel`, el selector de 2 bits.
2. El **decoder 2→4** convierte `sel` en un patrón one-hot `dec_out[3:0]`.
3. Las **entradas de datos** del mux (`data[3:0]`) provienen de `key[5:2]`.
4. El mux 4→1 se implementa combinando:
   - `dec_out` con `data` mediante compuertas `AND`.
   - una compuerta `OR` final que reúne esos productos lógicos.

Resultado visible:

- `dec_out[3:0]` se muestra en `led[3:0]`.
- La salida del mux (`mux_y`) se muestra en `led[4]`.

---

## Paso 1: implementar el decoder 2→4 (one-hot)

En el archivo `hackathon_top.sv` se encontrará una plantilla parecida a:

    logic [1:0] sel;
    logic [3:0] dec_out;

    always_comb begin
        dec_out = 4'b0000;

        // TODO: implementar el decoder 2→4
    end

La tarea consiste en completar el `always_comb` para que:

- Cuando `sel = 2'b00` → `dec_out = 4'b0001`
- Cuando `sel = 2'b01` → `dec_out = 4'b0010`
- Cuando `sel = 2'b10` → `dec_out = 4'b0100`
- Cuando `sel = 2'b11` → `dec_out = 4'b1000`

Recomendaciones:

- Usar `unique case (sel)` para que el decoder quede claro y el sintetizador pueda optimizarlo bien.
- Mantener la asignación por defecto `dec_out = 4'b0000;` al inicio del bloque para cubrir cualquier caso no esperado.

---

## Paso 2: implementar el mux 4→1 usando el decoder

Una vez que `dec_out` funciona correctamente, se implementa el mux 4→1 sin usar el operador condicional `?:` ni un `case` directo, sino a partir de **AND + OR**, reutilizando el decoder como lógica de selección.

Idea lógica:

- `and0 = dec_out[0] & data[0]`
- `and1 = dec_out[1] & data[1]`
- `and2 = dec_out[2] & data[2]`
- `and3 = dec_out[3] & data[3]`
- `mux_y = and0 | and1 | and2 | and3`

En SystemVerilog esto puede hacerse, por ejemplo:

- Declarando señales auxiliares (`logic and0, and1, and2, and3;`) y asignándolas en un `always_comb`.
- O escribiendo directamente la expresión de `mux_y` en una sola línea, sumando todos los productos lógicos.

Finalmente, se asigna `mux_y` a `led[4]` para poder observar en la placa qué entrada está siendo seleccionada.

---

## Paso 3: pruebas sugeridas

1. Fijar un patrón en `data[3:0]` (por ejemplo `4'b1010`) con `key[5:2]`.
2. Recorrer `sel` (`key[1:0]`) de `00` a `11` y observar:

   - Cómo `dec_out` recorre `0001`, `0010`, `0100`, `1000` en `led[3:0]`.
   - Cómo `led[4]` refleja el bit correspondiente de `data` según el valor de `sel`.

Ejemplo de comportamiento esperado si `data = 4'b1010`:

- `sel = 2'b00` → `mux_y = data[0] = 0`
- `sel = 2'b01` → `mux_y = data[1] = 1`
- `sel = 2'b10` → `mux_y = data[2] = 0`
- `sel = 2'b11` → `mux_y = data[3] = 1`

Este comportamiento permite comprobar visualmente que:

- El decoder está generando correctamente el patrón one-hot.
- El mux 4→1 está seleccionando el canal adecuado.

---

## Extensiones opcionales

Si hay tiempo o se desea experimentar más, se pueden realizar, por ejemplo, las siguientes extensiones:

- Usar `led[7:5]` para mostrar `sel` y alguna combinación de `data` (por ejemplo, `led[6:5] = sel`).
- Implementar una segunda versión del mux 4→1 usando `case (sel)` y comparar que ambas implementaciones producen exactamente la misma salida.
- Añadir al final de `hackathon_top.sv` una pequeña tabla de verdad en comentarios que documente:
  - las combinaciones de `sel`,
  - el patrón one-hot esperado en `dec_out`,
  - y el bit de `data` que debe aparecer en `mux_y`.

Con esta actividad se cierra el ciclo: **decoder 2→4 + mux 4→1** como ejemplo de composición de bloques combinacionales a partir de módulos simples.
