# 1.2.4 Combinational vs sequential logic

Este documento explica la diferencia entre **lógica combinacional** y **lógica secuencial**,  uno de los conceptos más importantes al diseñar con SystemVerilog y FPGA.

---

## 1. Lógica combinacional

La **lógica combinacional** es aquella en la que:

- La salida depende **solo** de las entradas **en ese instante**.
- No hay memoria explícita dentro del bloque.
- Si las entradas cambian, las salidas cambian “de inmediato” (a nivel lógico, ignorando retardos físicos).

Ejemplos típicos:

- Compuertas lógicas (AND, OR, NOT, XOR).
- Comparadores.
- Multiplexores (`mux`).
- Decodificadores.

En SystemVerilog, la lógica combinacional suele describirse con:

### 1.1 Asignaciones continuas

```sv
assign y = a & b;
assign z = (sel) ? d1 : d0;
```

- `assign` crea una relación continua entre las señales.
- Cada vez que cambia alguna de las señales del lado derecho, la herramienta actualiza el resultado.

### 1.2 Bloques `always_comb`

```sv
module mux2to1 (
    input  logic       sel,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] y
);
    always_comb begin
        if (sel)
            y = a;
        else
            y = b;
    end
endmodule
```

Características de `always_comb`:

- Se usa para describir lógica **sin memoria**.
- La herramienta infiere automáticamente la sensibilidad (no es necesario escribir `@(*)`).
- Si falta asignar alguna rama, la herramienta puede advertir que se está infiriendo un latch (lo cual suele indicar un problema).

---

## 2. Lógica secuencial

La **lógica secuencial** incluye **memoria**:

- La salida depende de:
  - Las **entradas actuales**, y
  - El **estado almacenado** en registros (flip-flops).
- Se actualiza normalmente en el **flanco de un reloj** (`clk`).

Ejemplos típicos:

- Contadores.
- Registros de desplazamiento (shift registers).
- Máquinas de estados (FSM).
- Acumuladores y filtros digitales.

En SystemVerilog, la lógica secuencial suele describirse con:

### 2.1 Bloques `always_ff` con reloj

```sv
module counter_8bit (
    input  logic       clk,
    input  logic       rst_n,
    output logic [7:0] count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 8'd0;           // Reset asíncrono: contador a cero
        else
            count <= count + 8'd1;   // En cada flanco de reloj, incrementa
    end
endmodule
```

Características de `always_ff`:

- Se usa para describir **registros** (flip-flops).
- La sensibilidad suele incluir:
  - El flanco de reloj (`posedge clk` o `negedge clk`).
  - Opcionalmente una señal de reset (`rst`, `rst_n`).
- Se utiliza asignación **no bloqueante** (`<=`) para evitar problemas de orden de evaluación.

---

## 3. Combinar lógica combinacional y secuencial

En la mayoría de los diseños reales, ambas se **combinan**:

- La lógica secuencial almacena el **estado**.
- La lógica combinacional calcula:
  - El **siguiente estado**.
  - Las **salidas** en función del estado y las entradas.

Ejemplo simplificado de contador con lógica combinacional de “siguiente valor”:

```sv
module counter_with_next (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enable,
    output logic [7:0] count
);
    logic [7:0] next_count;

    // Lógica combinacional: cálculo del siguiente valor
    always_comb begin
        if (enable)
            next_count = count + 8'd1;
        else
            next_count = count;
    end

    // Lógica secuencial: registro que almacena count
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 8'd0;
        else
            count <= next_count;
    end

endmodule
```

Separar “cálculo” (combinacional) y “memoria” (secuencial) ayuda a:

- Leer y depurar el código.
- Evitar errores de inflexión de tipo (latches no deseados).
- Visualizar mejor el flujo de datos.

---

## 4. ¿Cómo distinguirlas al leer código?

Al revisar un módulo, se puede usar el siguiente criterio:

- **¿Hay un reloj (`clk`) en la sensibilidad?**
  - Sí → se trata de lógica **secuencial** (registros).
  - No, y se usa `always_comb` o `assign` → lógica **combinacional**.

Ejemplos:

- `assign`, `always_comb` → combinacional.
- `always_ff @(posedge clk ...)` → secuencial.
- `always_ff @(posedge clk or posedge rst)` → secuencial con reset.

En este repositorio se recomienda:

- Usar **solo** `always_comb` para lógica combinacional.
- Usar **solo** `always_ff` para lógica secuencial.
- Evitar `always @(*)` o `always @(posedge clk)` “genéricos” sin la palabra clave adecuada, para mantener el estilo consistente.

---

## 5. Errores típicos al mezclar combinacional y secuencial

Algunos problemas comunes:

1. **Usar lógica combinacional donde se necesitaba memoria**  
   - Ejemplo: implementar un contador con `always_comb` en lugar de `always_ff`.  
   - Resultado: la herramienta puede inferir lógica inestable o generar errores de síntesis.

2. **Olvidar asignar todas las ramas en `always_comb`**  
   - Si en un `case` o `if` no se cubren todas las posibilidades, la herramienta puede inferir un **latch**, que es un tipo de memoria no deseado en muchos diseños sincronizados.

   Ejemplo problemático:

   ```sv
   always_comb begin
       if (enable)
           y = a;
       // Falta el else → y mantiene el valor anterior → se infiere un latch
   end
   ```

   Versión corregida:

   ```sv
   always_comb begin
       if (enable)
           y = a;
       else
           y = '0; // o algún valor por defecto
   end
   ```

3. **Usar asignaciones bloqueantes (`=`) en lógica secuencial**  
   - En `always_ff` se recomienda usar siempre `<=` para describir registros.
   - El uso incorrecto de `=` puede producir comportamientos inesperados al simular.

---

## 6. Relación con otros documentos de teoría

Este tema se conecta directamente con:

- `1_2_3_Modules_and_Ports.md`  
  → define cómo se estructuran los módulos y puertos donde vive esta lógica.
- `1_2_5_Registers_and_Clock.md`  
  → profundiza en el rol del reloj y los registros.
- `1_2_6_Timing_and_Dividers.md`  
  → muestra cómo el tiempo y los divisores de frecuencia afectan a la lógica secuencial.
- `1_2_7_Finite_State_Machines.md`  
  → ejemplo claro de combinación entre lógica combinacional (siguiente estado) y secuencial (estado actual).

Comprender bien la diferencia entre lógica combinacional y secuencial es esencial para:

- Interpretar correctamente los ejemplos de `3_examples/`.
- Completar las actividades de `4_activities/` sin inferir latches no deseados.
- Diseñar labs e implementaciones (`5_labs/`, `6_implementation/`) que sean estables y fáciles de depurar.
