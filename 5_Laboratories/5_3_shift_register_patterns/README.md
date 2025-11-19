# Lab 5.3 – Shift register patterns (running lights / KITT)

## Objetivo

Diseñar y probar patrones de movimiento de luces usando un **registro de desplazamiento de 8 bits** conectado a los LEDs de la Tang Nano 9K.

Al final del lab deberías poder:

- Generar un **tick lento** a partir del reloj de la FPGA.
- Usar un **registro de desplazamiento** para crear animaciones en `led[7:0]`.
- Cambiar entre varios patrones usando `key[1:0]`.

---

## Prerrequisitos

- Haber realizado los labs:
  - **5.1 blink_hello_world** (divisor de frecuencia).
  - **5.2 buttons_and_debounce** (uso básico de entradas).

- Conocer:
  - `always_ff @(posedge clk ...)`
  - Registros tipo `logic [7:0]`.
  - Operadores de desplazamiento `<<` y `>>`.

---

## Mapeo básico

- **Entradas**
  - `clock`: reloj principal (~27 MHz).
  - `reset`: reset global.
  - `key[1:0]`: seleccionan el modo del patrón.

- **Salidas**
  - `led[7:0]`: muestran el patrón (shift register).

---

## Modos de operación

- `mode = key[1:0]`

| Modo | key[1:0] | Comportamiento                           |
|------|----------|-------------------------------------------|
| 0    | `00`     | Rotación circular a la izquierda          |
| 1    | `01`     | Rotación circular a la derecha            |
| 2    | `10`     | Patrón tipo **KITT / ping-pong**          |
| 3    | `11`     | LEDs apagados (reservado para experimentos)|

---

## Procedimiento sugerido

1. **Revisa el divisor de frecuencia**
   - Ubica el bloque con `W_DIV`, `div_cnt` y `step_en`.
   - Cambia `W_DIV` si quieres animación más rápida o más lenta.
   - Verifica en simulación (opcional) que `step_en` se active periódicamente.

2. **Entiende el registro de desplazamiento**
   - Observa cómo `pattern_reg` se actualiza solo cuando `step_en = 1`.
   - Prueba primero con un solo modo (por ejemplo el de rotación izquierda).

3. **Prueba en hardware**
   - Programa la FPGA.
   - Cambia `key[1:0]` y observa:
     - En modo `00`: los LEDs parecen una luz que gira.
     - En modo `01`: gira en sentido contrario.
     - En modo `10`: la luz rebota de un extremo a otro (KITT).
     - En modo `11`: todos apagados.

4. **Ajusta la velocidad**
   - Modifica `W_DIV` (por ejemplo 20, 22, 24) y ve cómo cambia la velocidad.
   - Elige una velocidad cómoda para el ojo (ni demasiado rápida ni demasiado lenta).

---

## Checklist de pruebas

- [ ] Tras un `reset`, solo `led[0]` está encendido.
- [ ] En modo `00`, la luz recorre todos los LEDs en un círculo.
- [ ] En modo `01`, recorre en sentido contrario.
- [ ] En modo `10`, la luz va de `led[0]` a `led[7]` y regresa a `led[0]` sin “saltos”.
- [ ] En modo `11`, todos los LEDs permanecen apagados.
- [ ] Cambiar de modo no cuelga el patrón ni genera estados raros.

---

## Extensiones opcionales

Ideas para jugar más con este lab:

- Usar `key[2]` como **pausa**:
  - Si `key[2] = 0`, el patrón se detiene.
  - Si `key[2] = 1`, el patrón continúa.

- Crear un modo adicional donde:
  - Combines un contador binario con el shift register:  
    `led = pattern_reg ^ contador`.

- Sincronizar la dirección KITT con el valor de alguna tecla:
  - Por ejemplo, si `key[3] = 1`, invertir el sentido.

Este lab es buena base para animaciones más avanzadas (barras de nivel, juegos simples, etc.).
