# 4_9_5 – Contadores y patrones de desplazamiento en LEDs

Actividad basada en `4_05_counters_and_shift_patterns`, incluida en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Practicar:

- Uso de un **divisor de frecuencia** para obtener un paso lento (`step_en`) a partir del reloj de la FPGA.
- Implementación de **patrones secuenciales** en un vector de 8 LEDs:
  - Contador binario (free-running counter).
  - Registro de desplazamiento (“running light”).
  - Patrón tipo **ping-pong** (bit que rebota entre extremos).
  - Patrón combinado que mezcla varios efectos.
- Selección de patrones mediante bits de entrada (`key`).

---

## Mapeo de señales

### Entradas

- `clock`  
  Reloj principal de la FPGA (~27 MHz en Tang Nano 9K).

- `reset`  
  Reset global (según wrapper de la placa) para inicializar los contadores.

- `key[1:0]`  
  Selección de modo/patrón de LEDs:

      mode = key[1:0]

      00 → contador binario
      01 → desplazamiento circular
      10 → ping-pong (rebote)
      11 → mezcla XOR de varios patrones

Otros bits de `key` pueden quedar libres o utilizarse para futuras extensiones (control de velocidad, inversión de dirección, etc.).

### Salidas

- `led[7:0]`  
  Vector de 8 bits que muestra el patrón seleccionado para esta actividad.

El display de 7 segmentos (`abcdefgh`, `digit`) y la LCD no forman parte de la solución y se mantienen apagados o en su configuración por defecto.

---

## Estructura interna de la solución

La solución separa claramente tres bloques:

1. **Divisor de frecuencia** → genera `step_en`.
2. **Patrones secuenciales** → registros que se actualizan solo cuando `step_en = 1`.
3. **Multiplexor de modos** → selecciona qué patrón se envía a `led[7:0]`.

### 1. Divisor de frecuencia (`step_en`)

Se declara un contador de ancho parametrizable:

- `W_DIV` → número de bits del divisor (por ejemplo, 24).
- `div_cnt[W_DIV-1:0]` → contador que se incrementa con cada flanco de `clock`.
- `step_en` → pulso de un ciclo cuando `div_cnt` se desborda.

Estructura típica:

- Al hacer `reset`:
  - `div_cnt` se inicializa a 0.
  - `step_en` se pone en 0.
- En operación normal:
  - `div_cnt` se incrementa en cada ciclo.
  - Cuando `div_cnt` vuelve a 0, se genera `step_en = 1` durante un solo ciclo.
  - En los demás ciclos, `step_en = 0`.

El efecto es que `step_en` tiene una frecuencia mucho menor que `clock`, de modo que los cambios en los LEDs se vuelven visibles.

Un valor de `W_DIV` mayor implica un paso más lento; un valor menor, un patrón más rápido.

### 2. Patrones internos

Se definen registros para guardar el estado de cada patrón:

- `counter_pattern[7:0]`  
  Contador binario que recorre de 0 a 255.

- `shift_pattern[7:0]`  
  Registro de desplazamiento circular (running light).

- `pingpong_pattern[7:0]`  
  Patrón de un bit que “rebota” entre el extremo izquierdo y el derecho.

- Opcionalmente, registros adicionales para combinaciones o variantes.

#### 2.1. Contador binario

El contador binario se actualiza únicamente cuando `step_en = 1`:

- En `reset`:
  - `counter_pattern` se inicializa a `8'd0`.
- En operación:
  - Cuando `step_en = 1`, se hace:
    
        counter_pattern <= counter_pattern + 8'd1;

De esta forma, la cuenta binaria avanza a velocidad humana.

#### 2.2. Desplazamiento circular (running light)

Para el patrón de desplazamiento circular se parte de un bit encendido:

- En `reset`:
  - `shift_pattern <= 8'b0000_0001;`  (bit menos significativo encendido).
- En cada `step_en = 1`:
  - Se rota el vector para que el bit “circule” por los 8 LEDs.

Ejemplo de comportamiento:

- `0000_0001`
- `0000_0010`
- `0000_0100`
- …
- `1000_0000`
- de vuelta a `0000_0001`

La implementación puede usar un corrimiento con reinicio manual o un corrimiento rotacional (rota el bit que sale por el otro extremo).

#### 2.3. Patrón ping-pong (rebote)

Para el patrón ping-pong se utilizan:

- `pingpong_pattern[7:0]` → posición del bit encendido.
- `dir` → dirección actual (por ejemplo, 0 = hacia la izquierda, 1 = hacia la derecha).

En `reset`:

- `pingpong_pattern <= 8'b0000_0001;`  (bit en el extremo derecho).
- `dir <= 1'b0;` (por ejemplo, “hacia la izquierda”).

En cada `step_en = 1`:

1. Se desplaza el bit en la dirección actual.
2. Si el patrón llega a uno de los extremos:
   - Si llega a `8'b1000_0000`, se invierte `dir` para ir de regreso.
   - Si llega a `8'b0000_0001`, se invierte `dir` para ir hacia el otro lado.

De esta forma, el bit recorre:

- `0000_0001`
- `0000_0010`
- …
- `1000_0000`
- y luego regresa:
- `0100_0000`
- `0010_0000`
- …
- `0000_0001`

### 3. Selección de patrón (`mode` → `led`)

Finalmente, se define un `mode` a partir de `key[1:0]`:

- `mode = key[1:0];`

En un bloque combinacional se selecciona qué patrón se envía a `led`:

- `mode = 2'b00`  
  → `led = counter_pattern;`  
  (contador binario libre).

- `mode = 2'b01`  
  → `led = shift_pattern;`  
  (running light circular).

- `mode = 2'b10`  
  → `led = pingpong_pattern;`  
  (bit que rebota entre extremos).

- `mode = 2'b11`  
  → `led = counter_pattern ^ shift_pattern;`  
  (mezcla XOR de ambos patrones para obtener un efecto más complejo).

Se incluye un valor por defecto para evitar estados indefinidos:

- Si `mode` toma un valor inesperado (por ejemplo, en simulación), `led` puede inicializarse a `8'b0000_0000`.

---

## Resumen del flujo interno

1. El divisor de frecuencia genera `step_en` lentamente a partir de `clock`.
2. Cada patrón (contador, desplazamiento, ping-pong) se actualiza **solo** cuando `step_en = 1`.
3. Según `mode = key[1:0]`, se escoge uno de los patrones (o una combinación) para mostrarlo en `led[7:0]`.

Esta organización facilita:

- Depurar cada patrón por separado.
- Añadir nuevos patrones en el futuro.
- Cambiar la velocidad de todos los patrones únicamente modificando el divisor de frecuencia.

---

## Pruebas sugeridas

1. **Modo 00 – Contador binario**

   - Ajustar el parámetro del divisor (`W_DIV` o constante equivalente) hasta que el contador cambie a una velocidad cómoda.
   - Observar cómo los LEDs recorren todas las combinaciones binarias.

2. **Modo 01 – Desplazamiento circular**

   - Verificar que el bit encendido recorre los 8 LEDs y vuelve al inicio sin “saltos”.
   - Probar distintos valores de velocidad para ver el efecto.

3. **Modo 10 – Ping-pong**

   - Confirmar que el bit va de extremo a extremo y luego regresa.
   - Comprobar que no desaparece al llegar a los límites, sino que rebota.

4. **Modo 11 – Mezcla XOR**

   - Activar tanto el contador como el patrón de desplazamiento.
   - Observar la mezcla XOR en los LEDs, que genera un patrón más “rico”.
   - Cambiar la velocidad y comprobar cómo el patrón resultante cambia de aspecto.

---

## Extensiones opcionales

Algunas ideas para ampliar la solución:

- Usar bits adicionales de `key` para:
  - Cambiar la velocidad (`step_en`) en tiempo real.
  - Invertir la dirección de los patrones.
  - Congelar o reanudar la animación.

- Añadir nuevos patrones:
  - “Lluvia” de bits (bits que caen desde el MSB al LSB).
  - Más de un bit encendido a la vez.
  - Combinaciones lógicas entre los patrones existentes (OR, AND, XOR múltiples).

- Integrar el TM1638 o la LCD:
  - Mostrar el valor del contador en 7 segmentos mientras los LEDs muestran el patrón.
  - Dibujar en la LCD una barra que se mueva al ritmo del patrón de LEDs.

Con esta solución se consolida el uso de **contadores**, **divisores de frecuencia** y **registros de desplazamiento**, bloques fundamentales en diseños digitales sobre FPGA.
