# 3.17 Ultrasonic distance – LEDs, 7 segmentos y barra en LCD

Este ejemplo integra el **sensor ultrasónico HC-SR04** con la Tang Nano 9K para:

- Medir una **distancia relativa** mediante el módulo `ultrasonic_distance_sensor`.
- Mostrar el valor en:
  - **LEDs** (`led[7:0]`).
  - **Display de 7 segmentos** (TM1638) con `seven_segment_display`.
  - Una **barra horizontal roja** en la pantalla LCD 480×272, cuyo largo depende de la distancia.

Es una primera aproximación a la idea de “radar” o **visualización gráfica de distancia**.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender cómo conectar y usar el módulo `ultrasonic_distance_sensor` con la Tang Nano 9K.
- Visualizar la distancia medida en:
  - LEDs (como patrón binario).
  - Display de 7 segmentos (valor numérico).
  - LCD (barra horizontal proporcional).
- Practicar:
  - Escalamiento de un valor de 16 bits a coordenadas de pantalla.
  - Integración de periféricos (sensor + TM1638 + LCD) en un mismo diseño.

---

## Señales y pines

### Entradas principales

- `clock`  
  Reloj principal del sistema (~27 MHz).

- `slow_clock`  
  No se utiliza en este ejemplo (reservado para otras prácticas).

- `reset`  
  Reset asíncrono activo en alto.

- `key[7:0]`  
  Reservado para ejercicios adicionales (no se usa en la lógica principal).

### Sensor ultrasónico (vía `gpio`)

En este ejemplo se asume:

- `gpio[0]` → `TRIG` (salida hacia HC-SR04).  
- `gpio[1]` → `ECHO` (entrada desde HC-SR04).

La conexión física exacta se detalla en:

- `2_devices/` (sección HC-SR04).
- Archivo de constraints de la tarjeta hackathon (por ejemplo `board_specific.cst`).

### Salidas

- `led[7:0]`  
  Muestran el byte menos significativo de la distancia:

  assign led = distance[7:0];

- `abcdefgh[7:0]`, `digit[7:0]`  
  Salidas hacia el TM1638 mediante `seven_segment_display`:

  seven_segment_display #(
      .w_digit (8)
  ) i_7segment (
      .clk      (clock),
      .rst      (reset),
      .number   ({16'd0, distance}),
      .dots     (8'b0000_0000),
      .abcdefgh (abcdefgh),
      .digit    (digit)
  );

  `number` recibe la distancia extendida a 32 bits; el módulo se encarga de formatearla (hex/dec según su implementación interna).

- `red[4:0]`, `green[5:0]`, `blue[4:0]`  
  Color del píxel actual en la LCD:

  - Fondo: negro (`0,0,0`).
  - Barra de distancia: rojo (`31,0,0`).

- `gpio[3:0]`  
  Solo se usan `gpio[0]` y `gpio[1]`; el resto puede quedar sin uso según el `board_specific_top`.

---

## Flujo interno del diseño

### 1. Medición de distancia con `ultrasonic_distance_sensor`

Se instancia el módulo del sensor, configurando la frecuencia de reloj y el ancho del valor de distancia:

  localparam int unsigned CLK_HZ = 27_000_000;

  logic [15:0] distance;

  ultrasonic_distance_sensor #(
      .clk_frequency          (CLK_HZ),
      .relative_distance_width($bits(distance))
  ) i_sensor (
      .clk               (clock),
      .rst               (reset),
      .trig              (gpio[0]),
      .echo              (gpio[1]),
      .relative_distance (distance)
  );

- `distance` es un valor **relativo** (no necesariamente en centímetros), pero **monótono**:
  - Más grande cuando el eco tarda más.
  - Más pequeño cuando el objeto está más cerca.

### 2. Visualización numérica (LEDs y 7 segmentos)

- **LEDs** → debug directo:

  assign led = distance[7:0];

- **TM1638** → `seven_segment_display` muestra `distance` como número de 32 bits (con padding en los bits altos):

  seven_segment_display #(
      .w_digit (8)
  ) i_7segment (
      .clk      (clock),
      .rst      (reset),
      .number   ({16'd0, distance}),
      .dots     (8'b0000_0000),
      .abcdefgh (abcdefgh),
      .digit    (digit)
  );

Esto permite ver la distancia tanto en binario (LEDs) como en formato legible (7 segmentos).

### 3. Escalamiento de la distancia a coordenada X

La pantalla es de **480 píxeles de ancho**:

  localparam int unsigned SCREEN_WIDTH  = 480;
  localparam int unsigned SCREEN_HEIGHT = 272;

Se toman los bits altos de `distance` para mapearlos a una coordenada `x` válida (0..479):

  logic [8:0] distance_x; // 0..479

  always_comb begin
      if (distance[15:7] >= SCREEN_WIDTH[8:0])
          distance_x = SCREEN_WIDTH[8:0] - 1;  // saturar a 479
      else
          distance_x = distance[15:7];
  end

- `distance[15:7]` es un valor de 9 bits (0..511 aprox.).
- Si se pasa de 479, se **satura** para que no salga de pantalla.
- Este valor `distance_x` define la **longitud** de la barra roja.

### 4. Barra horizontal roja en LCD

Se dibuja una barra centrada verticalmente cuya longitud depende de `distance_x`:

  localparam int unsigned BAR_HEIGHT = 20;
  localparam int unsigned BAR_Y_MID  = SCREEN_HEIGHT / 2;

  always_comb begin
      // Fondo negro
      red   = 5'd0;
      green = 6'd0;
      blue  = 5'd0;

      // Barra roja
      if ( (x <= distance_x) &&
           (y >= (BAR_Y_MID - (BAR_HEIGHT/2))) &&
           (y <= (BAR_Y_MID + (BAR_HEIGHT/2))) ) begin
          red   = 5'd31;
          green = 6'd0;
          blue  = 5'd0;
      end
  end

- Para cada píxel (`x`, `y`), se verifica si cae dentro de la franja horizontal que va de `x = 0` a `x = distance_x`.
- Si pertenece a esa región, el píxel se pinta rojo.
- En caso contrario, permanece negro.

Resultado visual:

- Objetos más **cercanos** → `distance` pequeña → `distance_x` pequeño → barra corta.
- Objetos más **lejanos** → `distance` grande → `distance_x` más grande → barra más larga (hasta saturar).

---

## Relación con otros ejemplos

Este ejemplo se apoya en varios conceptos y archivos:

- `1_2_9_Buses_Overview.md`  
  → contexto general de buses y sensores externos.

- `1_2_11_ADC_Basics.md`  
  → ideas generales de medición y conversión (analogía con potenciómetro).

- `3_13_lcd_basic_shapes` y `3_14_lcd_moving_rectangle`  
  → cómo se usan `x`, `y` para dibujar figuras en la LCD.

- `3_15_tm1638_quickstart` y `3_11_seven_segment_basics`  
  → fundamentos de 7 segmentos y TM1638.

Este `3_17_ultrasonic_distance` combina todo lo anterior en un solo diseño:

- Sensor **ultrasónico**.
- **LEDs** y **TM1638** para salida numérica.
- **LCD** para visualización gráfica de la distancia.
