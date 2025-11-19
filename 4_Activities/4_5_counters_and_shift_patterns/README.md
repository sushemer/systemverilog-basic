# 4.5 – Contadores y patrones de desplazamiento en LEDs

En esta actividad se combinan **contadores** y **registros de desplazamiento** para generar diferentes patrones de luces en los LEDs de la Tang Nano 9K.

La idea es que, a partir del reloj principal de la FPGA, se genere un “tick” más lento (`step_en`) y se use para avanzar uno o varios patrones:

- **Patrón 1:** contador binario que recorre todos los valores de 8 bits.
- **Patrón 2:** un bit encendido que se desplaza (running light / KITT).
- **Patrones extra (opcionales):** rebote tipo “ping-pong”, mezclas, etc.

Después, con algunas teclas (`key`), se selecciona qué patrón se muestra en los LEDs.

---

## Señales principales

Entradas relevantes:

- `clock`  → reloj principal (~27 MHz).
- `reset`  → reset síncrono global.
- `key[1:0]` → selección de modo de visualización.

Salidas:

- `led[7:0]` → patrón de 8 bits que se verá en la barra de LEDs.

El archivo `hackathon_top.sv` ya:

- Apaga el display de 7 segmentos y el LCD (no se usan en esta actividad).
- Incluye un **divisor de frecuencia** básico que produce una señal `step_en` periódica.
- Declara registros para:
  - `counter_pattern` → contador binario de 8 bits.
  - `shift_pattern`   → registro de desplazamiento de 8 bits.
- Tiene un `case (mode)` que selecciona qué patrón va a `led`.

La tarea consiste en **completar y personalizar la lógica interna**.

---

## Objetivos de la actividad

1. Practicar el uso de **contadores** como divisores de frecuencia (prescalers).
2. Implementar un **contador binario** libre y verlo en los LEDs.
3. Implementar uno o varios **registros de desplazamiento** (patrones de movimiento).
4. Seleccionar el patrón visible usando `key[1:0]`.
5. Ajustar la velocidad del patrón para que sea cómoda a la vista.

---

## Pasos sugeridos

### 1. Entender el divisor de frecuencia (`step_en`)

En el código se incluye:

- Un contador `div_cnt` de `W_DIV` bits.
- `step_en` se activa cuando `div_cnt == 0`.

Cada vez que `div_cnt` se desborda, `step_en` vale `1` durante un ciclo de reloj. Esa señal se usa para actualizar los patrones:

```sv
always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        div_cnt  <= '0;
        step_en  <= 1'b0;
    end
    else begin
        div_cnt <= div_cnt + 1'b1;

        if (div_cnt == '0) begin
            step_en <= 1'b1;   // un solo ciclo en alto
        end
        else begin
            step_en <= 1'b0;
        end
    end
end
```
La frecuencia del “paso” visual depende de W_DIV o de una constante similar. Un valor más grande produce un patrón más lento.
### 2. Implementar los patrones internos

Dentro de un bloque secuencial típico se encuentran registros como:
```sv
logic [7:0] counter_pattern;
logic [7:0] shift_pattern;
// opcional: otros patrones
```

La recomendación es actualizar estos registros solo cuando step_en sea 1.

#### 2.1. Implementar los patrones internos
Un ejemplo de actualización es:
```sv
always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        counter_pattern <= 8'd0;
    end
    else if (step_en) begin
        counter_pattern <= counter_pattern + 8'd1;
    end
end
```

#### 2.2. Patrón 2: bit en desplazamiento (running light)
Para shift_pattern se puede usar un bit “corriendo” de izquierda a derecha y reiniciando:
```sv
always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        shift_pattern <= 8'b0000_0001;  // inicia en el bit 0
    end
    else if (step_en) begin
        if (shift_pattern == 8'b1000_0000) begin
            shift_pattern <= 8'b0000_0001;  // reinicia al llegar al final
        end
        else begin
            shift_pattern <= shift_pattern << 1;
        end
    end
end
```
Como variación, se puede diseñar un patrón “ping-pong” (rebote) manteniendo una dirección (left/right) en una variable adicional.

## 3. Seleccionar el patrón con key[1:0]
En el archivo de plantilla suele aparecer algo similar a:

```sv
logic [1:0] mode;
assign mode = key[1:0];

always_comb begin
    led = 8'b0000_0000;

    unique case (mode)
        2'b00: led = counter_pattern;
        2'b01: led = shift_pattern;
        // 2'b10 y 2'b11 quedan libres para patrones extra
        default: led = 8'b0000_0000;
    endcase
end
```
La recomendación es:

- Reservar al menos un modo para el contador binario.
- Reservar un modo para el registro de desplazamiento.
- Dejar uno o dos modos libres para variantes opcionales (ping-pong, mezcla de patrones, etc.).

## 4. Pruebas sugeridas

### 4.1. Verificar el contador binario

- Seleccionar el modo `2'b00`.
- Observar cómo los LEDs cambian de patrón siguiendo una cuenta binaria.
- Ajustar `W_DIV` o la constante del divisor hasta que el cambio sea claro y cómodo a la vista (ni demasiado rápido ni demasiado lento).

### 4.2. Verificar el patrón de desplazamiento

- Seleccionar el modo `2'b01`.
- Confirmar que el bit “encendido” recorre de `LED0` a `LED7` y luego vuelve al inicio.
- Modificar la lógica para probar otras direcciones o velocidades.

### 4.3. Probar `reset`

- Activar y desactivar `reset` mientras la animación está en curso.
- Verificar que:
  - `counter_pattern` vuelve a `0`.
  - `shift_pattern` vuelve a su valor inicial (`0000_0001` u otro elegido).
- Confirmar que, al soltar `reset`, los patrones retoman la animación desde el inicio.

---

## 5. Extensiones opcionales

Algunas ideas para extender la actividad:

### 5.1. Patrón ping-pong

Añadir un registro `dir` (dirección) que indique si el bit debe moverse a la izquierda o a la derecha y cambiar su sentido en los extremos.

### 5.2. Combinar patrones

Definir un modo en el que, por ejemplo:

```sv
led = counter_pattern ^ shift_pattern;
```
u otra combinación lógica, para obtener efectos más complejos.

### 5.3. Control de velocidad dinámico

Usar bits adicionales de key para seleccionar entre varias velocidades (por ejemplo, distintos valores de comparación para el divisor).

### 5.4. Uso del TM1638 o LCD como debug

- Mostrar en el TM1638 el valor actual del contador.
- Dibujar en la LCD una barra que se mueva a la par del patrón de LEDs.
