# 1.5.2 Codeflow – Cómo fluye el código en este repositorio

Este documento explica **cómo se conectan los módulos** en el proyecto, desde la tarjeta Tang Nano 9K hasta tu `hackathon_top.sv`, pasando por los periféricos (TM1638, LCD, sensores, etc.).

La idea es que, cuando abras cualquier actividad, lab o implementación, sepas responder:

- ¿Quién es el **top real** que ve el FPGA?
- ¿Dónde debo escribir mi lógica?
- ¿De dónde salen señales como `clock`, `x`, `y`, `abcdefgh`, `digit`, `gpio`?
- ¿Cómo sigo el “camino” del dato desde un botón o sensor hasta un LED o display?


---

## 1. Vista general de módulos

En casi todos los ejercicios, el flujo de módulos sigue esta forma:

### 1) Top físico de la tarjeta

Archivo típico:  
`boards/tang_nano_9k_lcd_480_272_tm1638_hackathon/board_specific_top.sv`

- Es el **top real** que ve el sintetizador (Gowin).
- Aquí se conectan los pines físicos:
  - Reloj físico del FPGA.
  - Pines de la pantalla LCD.
  - Pines del módulo TM1638.
  - Pines `gpio[3:0]` (sensores, encoder, etc.).
- Este módulo instancia a tu `hackathon_top`.


### 2) Top lógico de la actividad o lab

Archivos típicos (dentro de `4_Activities` o `5_Labs`):

- `4_Activities/4_01_logic_gates_and_demorgan/hackathon_top.sv`  
- `5_Labs/5_1_counter_hello_world/hackathon_top.sv`

Características:

- Aquí es donde **tú escribes el código** de la actividad o lab.
- Recibe señales ya preparadas desde `board_specific_top`:
  - `clock`, `slow_clock`, `reset`
  - `key[7:0]`, `led[7:0]`
  - `abcdefgh`, `digit`
  - `x`, `y`, `red`, `green`, `blue`
  - `gpio[3:0]`
- Instancia módulos de `peripherals/` o `labs/common/` cuando se necesitan (TM1638, ultrasonido, 7 segmentos, etc.).


### 3) Periféricos y bloques reutilizables

Ejemplos:

- `peripherals/tm1638_board.sv`  
- `peripherals/ultrasonic_distance_sensor.sv`  
- `labs/common/seven_segment_display.sv`  
- `labs/common/counter_with_enable.sv`

Estos módulos encapsulan lógica más compleja:

- Drivers de hardware (TM1638, LCD, audio, etc.).
- Contadores reutilizables.
- Filtros de rebote (debounce).
- Encoders, sensores, etc.

Normalmente tú solo los **instancias** y conectas sus puertos desde tu `hackathon_top`.


---

## 2. Estructura típica de `hackathon_top.sv`

La mayoría de las actividades siguen un patrón muy similar.  
Ejemplo simplificado:

```sv
// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
module hackathon_top (
    input  logic       clock,
    input  logic       slow_clock,
    input  logic       reset,
    input  logic [7:0] key,
    output logic [7:0] led,
    output logic [7:0] abcdefgh,
    output logic [7:0] digit,
    input  logic [8:0] x,
    input  logic [8:0] y,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,
    inout  logic [3:0] gpio
);
    // 1) Desactivar lo que no se usa en esta actividad
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;

    // 2) Señales internas
    logic [7:0] algo;
    logic       flag;

    // 3) Instancias de submódulos (si aplica)
    //  e.g. seven_segment_display, ultrasonic_distance_sensor, etc.

    // 4) Lógica combinacional / secuencial principal
    always_comb begin
        led = algo;
    end

endmodule
```

Patrón mental:

- **Puertos** → qué entra y qué sale.
- **Asignaciones rápidas** → apagar o forzar lo que no se usa en la práctica.
- **Señales internas** → `logic` / `wire` para tu diseño.
- **Submódulos** → instancias de drivers o bloques comunes.
- `always_comb` / `always_ff` → comportamiento principal.


---

## 3. ¿De dónde salen `clock`, `slow_clock`, `x`, `y`, etc.?

Estas señales **no se crean** en tu actividad; vienen del top de la tarjeta (`board_specific_top.sv`).

En `board_specific_top.sv` (vista conceptual):

- El reloj físico del FPGA pasa por un PLL o divisor y se convierte en:
  - `clock` (≈ 27 MHz)
  - `slow_clock` (1 Hz o similar, para efectos lentos)

- El controlador de LCD genera:
  - `x`, `y` como coordenadas del píxel actual

- El driver de 7 segmentos genera:
  - la multiplexación sobre `abcdefgh` y `digit`

Luego, ese módulo instancia tu `hackathon_top`:

```sv
hackathon_top i_hackathon_top (
    .clock      ( clock_27mhz ),
    .slow_clock ( slow_1hz    ),
    .reset      ( reset_sync  ),
    .key        ( key         ),
    .led        ( led         ),
    .abcdefgh   ( abcdefgh    ),
    .digit      ( digit       ),
    .x          ( x           ),
    .y          ( y           ),
    .red        ( red         ),
    .green      ( green       ),
    .blue       ( blue        ),
    .gpio       ( gpio        )
);
```

Tu trabajo está centrado en `hackathon_top`:

- No tienes que preocuparte por **cómo** se generan exactamente esos relojes y coordenadas.
- Solo necesitas saber **cómo usarlos** dentro de la actividad o lab.


---

## 4. Codeflow según la carpeta (Activities, Labs, Implementation)

Aunque el patrón de conexión es parecido, la intención cambia según la carpeta.


### 4.1 Carpeta `4_Activities`

- Se enfocan en un **concepto principal**:
  - compuertas,
  - mux/decoder,
  - priority encoder,
  - mini ALU,
  - contadores, etc.
- `hackathon_top.sv` suele ser relativamente corto.
- Muchas partes están marcadas como `// TODO` para que el estudiante las complete.

**Codeflow típico:**

`board_specific_top`  
→ `hackathon_top`  
→ lógica simple (a veces sin submódulos extra)  
→ LEDs, TM1638 o LCD (según la actividad).


### 4.2 Carpeta `5_Labs`

- Son prácticas más **integradoras**, cercanas a un mini-proyecto:
  - debounce,
  - FSMs,
  - drivers de display,
  - sensores, etc.
- `hackathon_top.sv` integra módulos de `labs/common` y `peripherals`.

**Codeflow típico:**

`board_specific_top`  
→ `hackathon_top`  
→ módulos de `labs/common` (contador, `seven_segment_display`, etc.)  
→ módulos de `peripherals` (`tm1638_board`, `ultrasonic_distance_sensor`, LCD, encoder, etc.)  
→ LEDs, display de 7 segmentos o LCD.


### 4.3 Carpeta `6_Implementation`

- Proyectos más grandes:
  - reloj digital,
  - radar ultrasónico con servo,
  - u otras integraciones completas.
- Reutilizan lo aprendido en `4_Activities` y `5_Labs`.

En `hackathon_top.sv` puedes ver:

- Varios estados globales (FSM grandes).
- Menús y pantallas en LCD.
- Integración simultánea de varios sensores y displays.

La estructura sigue siendo la misma, pero el **flujo de código** es más largo y con más capas.


---

## 5. Cómo seguir el flujo tú mismo (paso a paso)

Cuando abras una práctica nueva y quieras entender el flujo:

### 1) Ubica el top de la tarjeta

- Ve a: `boards/.../board_specific_top.sv`
- Revisa **qué** `hackathon_top` está instanciando (ruta del archivo).


### 2) Abre el `hackathon_top.sv` correspondiente

Estará en alguna de estas rutas:

- `4_Activities/4_xx_.../hackathon_top.sv`
- `5_Labs/5_xx_.../hackathon_top.sv`
- `6_Implementation/.../hackathon_top.sv`

Ahí verás:

- Entradas: `clock`, `key`, `gpio`, etc.
- Salidas: `led`, `abcdefgh`, `digit`, `red`, `green`, `blue`.
- La lógica de la práctica (combinacional y/o secuencial).


### 3) Localiza submódulos

Busca instancias con nombres como `i_algo`, por ejemplo:

- `seven_segment_display`
- `tm1638_board`
- `ultrasonic_distance_sensor`
- `rotary_encoder`

Ábrelos en:

- `peripherals/`
- `labs/common/`

para entender:

- qué hacen,
- qué puertos exponen,
- cómo debes conectarlos.


### 4) Sigue el “camino del dato”

Ejemplo típico:

1. Un botón en la tarjeta entra por `key[0]`.
2. En tu `hackathon_top`, `key[0]` se asigna a una señal interna (`A`, `btn`, etc.).
3. Esa señal entra a:
   - una FSM,
   - un módulo de debounce,
   - un comparador, etc.
4. El resultado de esa lógica se usa para:
   - encender/apagar bits de `led`,
   - escribir un valor en un display de 7 segmentos,
   - cambiar el color de un área del LCD, etc.

En general, traza:

`pin físico`  
→ `board_specific_top`  
→ `hackathon_top`  
→ señales internas  
→ submódulos  
→ salidas (LED, 7 segmentos, LCD, TM1638, etc.).


### 5) Conecta esto con otros howto

- Para saber cómo correr simulación, síntesis y programación, usarás `1_5_3_run` (cuando esté listo).
- Para revisar errores típicos y precauciones, usarás `1_5_4_pitfalls`.

Este documento (`1_5_2_code_flow`) responde solo:  
**“cómo se relacionan las piezas de código dentro del repositorio”.**


---

## 6. Resumen rápido

- El **top físico real** es `board_specific_top.sv` (en `boards/`).
- Su trabajo principal está en `hackathon_top.sv` (en `4_Activities`, `5_Labs` o `6_Implementation`).
- Los drivers y bloques reutilizables viven en `peripherals/` y `labs/common/`.
- Casi todo se entiende siguiendo esta cadena:

`top de placa`  
→ `hackathon_top`  
→ `submódulos`  
→ `periféricos`  
→ LEDs, display, LCD, sensores.

Con este mapa mental debería poder orientarse en cualquier carpeta del repositorio **sin perderte**.
