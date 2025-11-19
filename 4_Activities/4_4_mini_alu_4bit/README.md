# 4.4 – Mini ALU de 4 bits (suma, resta y lógica)

En esta actividad se construye una **mini ALU de 4 bits** capaz de realizar operaciones aritméticas y lógicas simples sobre dos operandos `A` y `B`.

La ALU tendrá:

- **Entradas:**
  - `A[3:0]` y `B[3:0]` (operandos de 4 bits).
  - `op[1:0]` (selector de operación).
- **Salidas:**
  - `result[3:0]` (resultado de la operación).
  - `carry` (acarreo / borrow).
  - `zero` (indica si el resultado es cero).

---

## Mapeo sugerido de señales

Operandos (usando switches):

- `A = sw[3:0]`
- `B = sw[7:4]`

Selector de operación:

- `op = key[1:0]`

Interpretación de `op`:

| `op`  | Operación sugerida                        |
|-------|-------------------------------------------|
| 2'b00 | `A + B`                                   |
| 2'b01 | `A - B`                                   |
| 2'b10 | `A & B`                                   |
| 2'b11 | `A ^ B` (o `A \| B`, a elección)          |

Salidas a LEDs:

- `led[3:0]` → `result[3:0]`
- `led[4]`   → `carry`
- `led[5]`   → `zero`
- `led[7:6]` → `op[1:0]` (para ver qué operación está seleccionada)

> Si el wrapper de la placa no dispone de `sw`, se puede adaptar `A` y `B` a `key` u otro periférico (por ejemplo, TM1638).

---

## Objetivos

1. Implementar una **ALU combinacional de 4 bits** usando `case (op)`.
2. Manejar correctamente:
   - suma y resta con ancho extendido (para capturar el acarreo),
   - operaciones lógicas bit a bit (AND, XOR / OR).
3. Calcular y mostrar banderas básicas:
   - `carry` → bit extra de suma/resta (o `0` en operaciones lógicas).
   - `zero`  → `1` cuando `result == 0`.
4. Visualizar el resultado en LEDs y verificar manualmente algunos casos.

---

## Pasos sugeridos

### 1. Conectar operandos y selector

En `hackathon_top.sv`:

- Se mapean `A`, `B` y `op` a las entradas físicas reales (por ejemplo, `sw` y `key`).
- Si la placa no tiene `sw`, se puede usar `key` para ambos operandos, documentando el mapeo en comentarios.

Ejemplo de mapeo (ajustar según la tarjeta):

```sv
logic [3:0] A;
logic [3:0] B;
logic [1:0] op;

assign A  = sw[3:0];
assign B  = sw[7:4];
assign op = key[1:0];
```

### 2. Implementar la ALU
Dentro de un bloque always_comb se concentra la lógica de la ALU.
Es conveniente usar señales auxiliares de ancho extendido para suma y resta:
```sv
logic [3:0] result;
logic       carry;
logic       zero;

logic [4:0] alu_ext;  // ancho extendido para suma/resta

always_comb begin
    // Valores por defecto
    result = 4'd0;
    carry  = 1'b0;
    alu_ext = 5'd0;

    unique case (op)
        2'b00: begin
            // A + B
            alu_ext = {1'b0, A} + {1'b0, B};
            result  = alu_ext[3:0];
            carry   = alu_ext[4];
        end

        2'b01: begin
            // A - B
            alu_ext = {1'b0, A} - {1'b0, B};
            result  = alu_ext[3:0];
            // carry puede usarse como indicador de borrow o dejarse como bit informativo
            carry   = alu_ext[4];
        end

        2'b10: begin
            // A AND B
            result = A & B;
            carry  = 1'b0;
        end

        2'b11: begin
            // A XOR B (o A OR B si se prefiere)
            result = A ^ B;
            carry  = 1'b0;
        end

        default: begin
            result = 4'd0;
            carry  = 1'b0;
        end
    endcase

    // Bandera de cero (común a todas las operaciones)
    zero = (result == 4'd0);
end
```

### 3. Conectar LEDs
Para hacer visible el comportamiento de la ALU en la placa, se recomienda agrupar todas las asignaciones a LEDs en un solo bloque:
```sv
always_comb begin
    led      = 8'b0;
    led[3:0] = result;  // resultado de la operación
    led[4]   = carry;   // acarreo / borrow
    led[5]   = zero;    // bandera de cero
    led[7:6] = op;      // operación seleccionada
end
```

4. Pruebas sugeridas
---------------------

Se puede probar la ALU configurando distintos valores de `A`, `B` y `op` y verificando el resultado en los LEDs:

1. **Suma (`op = 2'b00`)**

   - Caso: `A = 4'd3`, `B = 4'd2`  
     - Esperado: `result = 5`, `carry = 0`, `zero = 0`.

   - Caso: `A = 4'd15`, `B = 4'd1`  
     - `15 + 1 = 16` → en 4 bits se observa `0` con `carry = 1`.  
     - Esperado: `result = 0`, `carry = 1`, `zero = 1`.

2. **Resta (`op = 2'b01`)**

   - Caso: `A = 4'd5`, `B = 4'd2`  
     - Esperado: `result = 3`, `zero = 0`.  
     - El bit extra de `alu_ext` indicará si hubo “borrow” según la convención elegida.

   - Caso: `A = B` (por ejemplo, `A = 7`, `B = 7`)  
     - Esperado: `result = 0`, `zero = 1`.

3. **AND (`op = 2'b10`)**

   - Caso: `A = 4'b1100`, `B = 4'b1010`  
     - Esperado: `result = 1000`, `carry = 0`, `zero = 0`.

4. **XOR (`op = 2'b11`)**

   - Caso: `A = 4'b1010`, `B = 4'b1010`  
     - Esperado: `result = 0000`, `zero = 1`.

   - Caso: `A = 4'b1111`, `B = 4'b0000`  
     - Esperado: `result = 1111`, `zero = 0`.

Si estos casos se observan correctamente en los LEDs, la mini ALU está funcionando según lo esperado.

---

5. Extensiones opcionales
-------------------------

Si se desea ir más allá de la actividad base, se pueden considerar, por ejemplo:

- Añadir más operaciones a `op` usando un selector de 3 bits (por ejemplo, NOT, desplazamientos, comparación, etc.).
- Definir de forma explícita la semántica de `carry` en la resta (borrow) y documentarla en el README.
- Mostrar el resultado también en el display de 7 segmentos (TM1638) usando el módulo `seven_segment_display`.
- Agregar una bandera extra `negative` si se decide interpretar `result` en complemento a dos.
- Documentar al final del archivo `hackathon_top.sv` una pequeña tabla con ejemplos de `A, B, op` y el resultado esperado, para utilizarla como guía de pruebas rápidas en laboratorio.

Con esta actividad se introduce un patrón clásico de diseño digital: una ALU pequeña, totalmente combinacional, que sirve como base conceptual para unidades aritmético-lógicas más grandes.
