# Modules and ports

Este documento explica qué es un **módulo** en SystemVerilog y cómo se definen sus **puertos** (entradas, salidas y, cuando aplica, `inout`).

El objetivo es entender la “unidad básica” de un diseño en este repositorio.

---

## 1. ¿Qué es un módulo?

Un **módulo** representa un bloque de hardware:

- Tiene un nombre (`module nombre ... endmodule`).
- Define **puertos** para comunicarse con otros módulos o con el mundo externo.
- Contiene señales internas y lógica que describe su comportamiento.

En un diseño más grande:

- Varios módulos se conectan entre sí en una estructura jerárquica.
- Un módulo puede **instanciar** otros módulos como sub-bloques.

---

## 2. Definición básica de un módulo

Estructura general:

```sv
module nombre_modulo (
    // Puertos
    input  logic a,
    input  logic b,
    output logic y
);

    // Señales internas
    // logic internal_signal;

    // Lógica (assign, always_comb, always_ff, etc.)

endmodule
```

Elementos clave:

- `module nombre_modulo`  
  Define el inicio del módulo.
- Lista de puertos entre paréntesis `( ... )`.
- Cuerpo del módulo: declaraciones internas y lógica.
- `endmodule` marca el final.

---

## 3. Direcciones de puertos

Los puertos definen **cómo fluye la información** entre módulos:

- `input`  
  - Señales que **entran** al módulo.
  - El módulo **lee** estas señales.
- `output`  
  - Señales que **salen** del módulo.
  - El módulo **las conduce** hacia afuera.
- `inout`  
  - Señales bidireccionales (casos especiales: buses tri-estado, ciertos periféricos).
  - En este repositorio se usan poco; aparecen sobre todo como `gpio` en el top.

Ejemplo de módulo combinacional simple (AND):

```sv
module and_gate (
    input  logic a,
    input  logic b,
    output logic y
);
    assign y = a & b;
endmodule
```

- `a` y `b` son **entradas**.
- `y` es **salida**.

---

## 4. Ancho de puertos (vectores)

Los puertos pueden ser:

- **Escalares**: un solo bit, por ejemplo `logic a;`.
- **Vectores**: varios bits, por ejemplo `logic [7:0] data;`.

Sintaxis típica:

```sv
input  logic       clk;        // 1 bit
input  logic [7:0] key;        // 8 bits
output logic [7:0] led;        // 8 bits
```

Ejemplo de sumador de 8 bits:

```sv
module adder_8bit (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] sum
);
    assign sum = a + b;
endmodule
```

- `a`, `b`, `sum` son vectores de 8 bits (`[7:0]`).

---

## 5. Señales internas vs. puertos

Dentro de un módulo se pueden declarar **señales internas**:

```sv
module example (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] in_data,
    output logic [7:0] out_data
);

    logic [7:0] reg_data;   // señal interna (registro)
    logic [7:0] next_data;  // señal interna (combinacional)

    // Lógica combinacional para next_data
    always_comb begin
        next_data = in_data + 8'd1;
    end

    // Registro sincronizado al reloj
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            reg_data <= 8'd0;
        else
            reg_data <= next_data;
    end

    // Salida
    assign out_data = reg_data;

endmodule
```

Diferencias:

- **Puertos** (`in_data`, `out_data`) conectan el módulo con el exterior.
- **Señales internas** (`reg_data`, `next_data`) solo viven dentro del módulo.

---

## 6. Instanciación de módulos

Para usar un módulo dentro de otro, se **instancia**:

```sv
module top_example (
    input  logic       a,
    input  logic       b,
    output logic       y
);

    // Señal interna para conectar la salida del AND a algo más (si hiciera falta)
    logic y_internal;

    // Instancia del módulo and_gate
    and_gate u_and (
        .a (a),          // conecta puerto a  del módulo con señal a  de top_example
        .b (b),          // conecta puerto b  con señal b
        .y (y_internal)  // conecta puerto y  con señal y_internal
    );

    // En este ejemplo, la salida final es igual a y_internal
    assign y = y_internal;

endmodule
```

Puntos importantes:

- `and_gate u_and ( ... );`  
  - `and_gate` es el **nombre del módulo** a instanciar.  
  - `u_and` es el **nombre de la instancia** (puede ser cualquier identificador válido).
- Conexiones por **nombre de puerto**: `.a (a)`  
  - A la izquierda: `a` → nombre del puerto en `and_gate`.
  - A la derecha: `a` → señal en `top_example`.

> Es buena práctica usar conexión **por nombre** (`.puerto(señal)`) en lugar de posición, para evitar errores cuando cambie el orden de los puertos.

---

## 7. Módulos top-level en este repositorio

En este proyecto aparecen dos tipos de top frecuentemente:

1. **Top de la tarjeta (board-specific)**  
   - Vive en una carpeta tipo `boards/.../board_specific_top.sv`.
   - Conecta:
     - Pines físicos: reloj, GPIO, LCD, TM1638, etc.
     - Con la lógica del proyecto (`hackathon_top`).
   - Es el **top real** que ve la herramienta de síntesis (Gowin).

2. **Top lógico de actividades/labs (`hackathon_top`)**  
   - En cada carpeta de `4_activities/` y `5_labs/` existe un `hackathon_top.sv`.
   - Define puertos “lógicos” estándar:
     - `clock`, `slow_clock`, `reset`
     - `key[7:0]`, `led[7:0]`
     - `abcdefgh`, `digit`
     - `x`, `y`, `red`, `green`, `blue`
     - `gpio[3:0]`
   - Es donde el estudiante implementa la lógica de cada ejercicio.

Ejemplo simplificado de `hackathon_top`:

```sv
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

    // Aquí se escribe la lógica de la actividad / lab.
    // Ejemplo: desactivar temporalmente lo que no se usa
    assign abcdefgh = '0;
    assign digit    = '0;
    assign red      = '0;
    assign green    = '0;
    assign blue     = '0;

    // Lógica para LEDs como ejemplo mínimo
    always_comb begin
        led = key;  // reflejar botones en LEDs
    end

endmodule
```

Ese `hackathon_top` será instanciado dentro del `board_specific_top` correspondiente a la Tang Nano 9K con TM1638 y LCD.

---

## 8. Buenas prácticas con módulos y puertos

Para mantener el código claro y reusable:

1. **Definir puertos claramente**  
   - Use `input`, `output`, `inout` con tipo explícito (`logic`).
   - Indique el ancho (`[N-1:0]`) cuando aplique.

2. **Separar combinacional y secuencial**  
   - `always_comb` para lógica combinacional.
   - `always_ff` para lógica secuencial (registros).

3. **Evitar lógica compleja en los top-level**  
   - Mantener `hackathon_top` como integrador de módulos y lógica principal.
   - Colocar bloques reutilizables (contadores, decodificadores, drivers) en archivos separados cuando sea conveniente.

4. **Usar instanciación por nombre**  
   - `.puerto(señal)` facilita leer y revisar conexiones.
   - Reduce errores cuando se cambian o agregan puertos.

5. **Comentar puertos y módulos**  
   - Añadir comentarios breves para explicar la función de cada puerto y módulo.
   - Especialmente útil en módulos que controlan periféricos (TM1638, LCD, sensores).

---

## 9. Relación con otros archivos de teoría

Este documento se relaciona con:

- `1_2_1_HDL_and_FPGA_Basics.md`  
  → contexto general de HDL y FPGA.
- `1_2_2_Verilog_SystemVerilog_Overview.md`  
  → sintaxis básica y diferencias entre Verilog y SystemVerilog.
- `1_2_4_Combinational_vs_Sequential.md`  
  → diferencia entre lógica combinacional y secuencial dentro de un módulo.
- `1_2_5_Registers_and_Clock.md`  
  → rol del reloj y los registros.
