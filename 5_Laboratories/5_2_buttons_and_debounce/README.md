# Lab 5.2 – buttons_and_debounce

**Nivel:** Básico  
**Board:** Tang Nano 9K (configuración `tang_nano_9k_lcd_480_272_tm1638_hackathon`)  
**Archivo principal:** `hackathon_top.sv`

---

## 1. Objetivo

Controlar uno o varios LEDs a partir de botones, usando **lógica combinacional pura**:

- Asignaciones continuas (`assign`).
- Operadores lógicos sobre 1 bit: `~`, `&`.
- Mapeo directo de señales internas a salidas físicas.

Al final del lab se busca que:

- Se entienda la diferencia entre `assign` (combinacional continuo) y `always_ff`.
- Se pueda mapear rápidamente botones a LEDs con distintas relaciones lógicas.
- Se vea físicamente en la placa qué hace cada operación booleana.

---

## 2. Mapeo de señales

Sugerencia de mapeo (se puede ajustar al wrapper que se esté usando):

- **Entradas:**
  - `btn = key[0]` → botón principal.
  - `en  = key[1]` → botón de habilitación (enable).

- **Salidas:**
  - `led[0]` → sigue directamente el botón (`btn`).
  - `led[1]` → encendido cuando el botón está suelto (`~btn`).
  - `led[2]` → encendido solo cuando `btn` y `en` son 1 (`btn & en`).
  - `led[7:3]` → apagados (`0`).

---

## 3. Pasos sugeridos

### Paso 1 – Abrir la plantilla

1. Ir a la carpeta:  
   `5_Labs/5_2_comb_button_led/`
2. Ubicar en `hackathon_top.sv`:
   - La sección donde se apagan `abcdefgh`, `digit`, `red`, `green`, `blue`.
   - El mapeo de `btn` y `en` desde `key`.
   - Las líneas `assign` marcadas como `TODO`.

---

### Paso 2 – Completar las asignaciones

En la plantilla aparece algo similar a:

    assign led[7:3] = 5'b00000;

    // assign led[0] = ...;
    // assign led[1] = ...;
    // assign led[2] = ...;

El objetivo es completar estas asignaciones con las expresiones lógicas deseadas.

1. **LED 0: seguir directamente el botón**

   Se quiere que `led[0]` copie el estado de `btn`:

   - Si `btn = 1` → `led[0] = 1`
   - Si `btn = 0` → `led[0] = 0`

   Asignación:

   - `assign led[0] = btn;`

2. **LED 1: encender cuando el botón está suelto**

   Se quiere que `led[1]` sea el complemento de `btn`:

   - Si `btn = 1` (botón presionado) → `led[1] = 0`
   - Si `btn = 0` (botón suelto)     → `led[1] = 1`

   Asignación:

   - `assign led[1] = ~btn;`

3. **LED 2: `btn` con habilitación (`en`)**

   Se quiere que `led[2]` solo se encienda cuando:

   - `btn = 1` **y**
   - `en = 1`

   Esta es una AND lógica:

   - `assign led[2] = btn & en;`

El bloque completo de salidas de LEDs queda, por ejemplo:

    assign led[7:3] = 5'b00000;  // LEDs superiores apagados
    assign led[0]   = btn;       // botón directo
    assign led[1]   = ~btn;      // botón negado
    assign led[2]   = btn & en;  // botón con enable

---

## 4. Pruebas sugeridas

### 4.1 Probar `led[0]` y `led[1]`

1. Programar la FPGA con el diseño.
2. Observar:

   - Al presionar `key[0]` (`btn = 1`):
     - `led[0]` debe encender.
     - `led[1]` debe apagarse.
   - Al soltar `key[0]` (`btn = 0`):
     - `led[0]` debe apagarse.
     - `led[1]` debe encenderse.

Esto permite visualizar claramente:

- El valor directo del botón (`led[0]`).
- Su negación (`led[1]`).

### 4.2 Probar `led[2]` con habilitación

1. Poner `en = 0` (`key[1]` sin presionar):
   - Sin importar el estado de `btn`, `led[2]` debe permanecer apagado (`0`).
2. Poner `en = 1` (`key[1]` presionado):
   - `led[2]` debe encender **solo** cuando también `btn = 1`.

De manera resumida:

- `en = 0` → `led[2] = 0` siempre.
- `en = 1` y `btn = 0` → `led[2] = 0`.
- `en = 1` y `btn = 1` → `led[2] = 1`.

En términos de tabla de verdad (`btn`, `en` → `led[2]`):

- 0,0 → 0  
- 0,1 → 0  
- 1,0 → 0  
- 1,1 → 1  

---

## 5. Sobre el rebote de botones (debounce)

Este lab se centra en **lógica combinacional pura**, por lo que se conecta el botón directamente. En hardware real, los botones mecánicos producen **rebotes** (transiciones rápidas 0↔1 cuando se presionan o sueltan).

Eso implica que, en aplicaciones más complejas:

- Un solo “clic” humano puede verse como varias pulsaciones breves.
- Un contador o FSM podría avanzar más de una vez por cada pulsación.

Aunque en este lab el efecto no es crítico, es importante entender que:

- Para usos más avanzados se suele pasar el botón por un módulo de **sincronización + debounce** (como `sync_and_debounce` en este repositorio).
- Ese módulo entrega una versión “limpia” de la señal del botón, apta para lógica secuencial más sofisticada.

---

## 6. Extensiones opcionales

Cuando el comportamiento básico esté verificado, se pueden probar variaciones.

### 6.1 Usar más combinaciones lógicas

Algunas ideas:

- `led[3] = btn | en;` → LED encendido si **alguno** de los dos botones está activo.
- `led[4] = btn ^ en;` → LED encendido si **exactamente uno** está activo (XOR).
- `led[5] = ~(btn & en);` → ejemplo de Ley de De Morgan.

Esto permite visualizar más operaciones lógicas directamente en la placa.

### 6.2 Invertir el sentido de los LEDs

Si el hardware tiene LEDs activos en bajo, se pueden invertir:

- En lugar de `assign led[0] = btn;` usar `assign led[0] = ~btn;`  
  para que el LED se encienda cuando el botón está presionado pero el pin lógico esté en 0.

### 6.3 Añadir debounce (para labs posteriores)

Como preparación para labs más avanzados se pueden hacer pruebas con el módulo `sync_and_debounce` del repositorio:

1. Instanciar `sync_and_debounce_one` o `sync_and_debounce` para `btn`.
2. Sustituir `btn` por su versión “debounced” en las asignaciones a los LEDs.

Esto obliga a conectar:

- `clk` (reloj).
- `reset`.
- La entrada `btn` cruda.
- La salida debounced hacia la lógica combinacional.

No es obligatorio en este lab, pero ayuda a entender cómo se integrará el tratamiento de rebotes en diseños siguientes.

---

## 7. Resumen

En este lab se trabaja con:

- **Asignaciones combinacionales (`assign`)** en SystemVerilog.
- **Operadores lógicos básicos** (`~`, `&`, `|`, `^`) aplicados a señales de 1 bit.
- **Mapeo directo** de botones (`key`) a LEDs, para ver de forma inmediata el resultado lógico.

Este patrón de “leer entradas digitales y reflejarlas en LEDs” es una base muy útil para:

- Depurar señales internas.
- Ver estados de máquinas de estados más adelante.
- Entender intuitivamente cómo se comportan las operaciones booleanas en hardware real.
