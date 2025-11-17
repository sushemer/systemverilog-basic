# 4.5 – Contadores y patrones de desplazamiento en LEDs

En esta actividad vas a combinar **contadores** y **registros de desplazamiento** para generar diferentes patrones de luces en los LEDs de la Tang Nano 9K.

La idea es que, a partir del reloj principal de la FPGA, generes un “tick” más lento (`step_en`) y lo uses para avanzar uno o varios patrones:

- **Patrón 1:** contador binario que recorre todos los valores de 8 bits.
- **Patrón 2:** un bit encendido que se desplaza (running light / KITT).
- **Patrones extra (opcionales):** rebote tipo “ping-pong”, mezclas, etc.

Luego, con algunas teclas (`key`), seleccionarás qué patrón se muestra en los LEDs.

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
  - `counter_pattern` → contador binario 8 bits.
  - `shift_pattern`   → registro de desplazamiento 8 bits.
- Tiene un `case (mode)` que selecciona qué patrón va a `led`.

Tu tarea es **completar y personalizar la lógica interna**.

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

Cada vez que `div_cnt` se desborda, `step_en` vale 1 durante un ciclo de reloj. Usa esa señal para actualizar tus patrones:

```sv
else if (step_en)
begin
    // actualizar patrones aquí
end
```

# 4.5 – Contadores y patrones de desplazamiento en LEDs

En esta actividad vas a combinar **contadores** y **registros de desplazamiento** para generar diferentes patrones de luces en los LEDs de la Tang Nano 9K.

La idea es que, a partir del reloj principal de la FPGA, generes un “tick” más lento (`step_en`) y lo uses para avanzar uno o varios patrones:

- **Patrón 1:** contador binario que recorre todos los valores de 8 bits.
- **Patrón 2:** un bit encendido que se desplaza (running light / KITT).
- **Patrones extra (opcionales):** rebote tipo “ping-pong”, mezclas, etc.

Luego, con algunas teclas (`key`), seleccionarás qué patrón se muestra en los LEDs.

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
  - `counter_pattern` → contador binario 8 bits.
  - `shift_pattern`   → registro de desplazamiento 8 bits.
- Tiene un `case (mode)` que selecciona qué patrón va a `led`.

Tu tarea es **completar y personalizar la lógica interna**.

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

Cada vez que `div_cnt` se desborda, `step_en` vale 1 durante un ciclo de reloj. Usa esa señal para actualizar tus patrones:

```sv
else if (step_en)
begin
    // actualizar patrones aquí
end
```