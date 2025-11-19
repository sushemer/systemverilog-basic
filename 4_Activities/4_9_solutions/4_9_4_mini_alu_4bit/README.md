# 4_9_4 – Mini ALU de 4 bits

Actividad basada en `4_04_mini_alu_4bit`, ahora incluida en la carpeta de soluciones `4_9_solutions`.

## Objetivo

Implementar una **mini ALU de 4 bits** con:

- Dos operandos: `A[3:0]` y `B[3:0]`
- Selector de operación: `op[1:0]`
- Operaciones soportadas:
  - `op = 2'b00` → `A + B`
  - `op = 2'b01` → `A - B`
  - `op = 2'b10` → `A & B`
  - `op = 2'b11` → `A ^ B`
- Banderas:
  - `carry` → acarreo/borrow en suma/resta
  - `zero`  → vale 1 cuando el resultado es 0

El resultado y las banderas se visualizan en los LEDs de la placa.

---

## Mapeo de señales

### Entradas

En esta solución se mapean las teclas `key` como si fueran switches:

- `sw = key`
- `A = sw[3:0] = key[3:0]`
- `B = sw[7:4] = key[7:4]`
- `op = key[1:0]` (selector de operación)

Nota: los bits `key[1:0]` afectan tanto parte de `A` como a `op`.  
Es una simplificación para poder usar únicamente `key` en esta actividad.

### Salidas (LEDs)

- `led[3:0] = result[3:0]`  
  Resultado de la operación de la ALU.

- `led[4] = carry`  
  Acarreo en la suma o bit extra de la resta (borrow simplificado).

- `led[5] = zero`  
  Bandera de **resultado cero** (vale 1 cuando `result == 0`).

- `led[7:6] = op[1:0]`  
  Muestran qué operación está seleccionada.

---

## Comportamiento de la ALU

### Operaciones aritméticas

Para capturar el bit de acarreo o borrow se amplía el ancho de los operandos a 5 bits:

- **Suma (`op = 2'b00`)**

  Ejemplo de implementación:

      sum_ext = {1'b0, A} + {1'b0, B};
      result  = sum_ext[3:0];
      carry   = sum_ext[4];

  Donde:

  - `sum_ext[3:0]` son los 4 bits menos significativos (resultado de la suma).
  - `sum_ext[4]` es el bit de acarreo (`carry`) de la operación.

- **Resta (`op = 2'b01`)**

  De forma análoga, se puede calcular la resta en 5 bits:

      diff_ext = {1'b0, A} - {1'b0, B};
      result   = diff_ext[3:0];
      carry    = diff_ext[4];

  En esta solución, el bit extra `diff_ext[4]` se utiliza como indicador de borrow de manera simplificada:

  - Si `A >= B`, normalmente `diff_ext[4]` será 0.
  - Si `A < B`, puede interpretarse como que se produjo un “préstamo” (borrow).

  No se entra en detalles de representación de números negativos; el foco está en observar cómo cambia `carry` al restar distintos valores.

### Operaciones lógicas

Para las operaciones lógicas no se requiere acarreo; en estas ramas se asigna `carry = 0`.

- **AND (`op = 2'b10`)**

      result = A & B;
      carry  = 1'b0;

- **XOR (`op = 2'b11`)**

      result = A ^ B;
      carry  = 1'b0;

(Una variante posible sería usar `A | B` en lugar de `A ^ B` si se desea practicar OR.)

### Bandera `zero`

Al final del bloque de la ALU se calcula la bandera `zero` como:

    zero = (result == 4'd0);

Esto hace que:

- `zero = 1` cuando el resultado es exactamente 0.
- `zero = 0` para cualquier otro valor.

---

## Estructura típica del bloque `always_comb`

Una forma ordenada de implementar la ALU es:

1. Definir señales auxiliares para suma y resta extendidas:

    sum_ext  = 5 bits  
    diff_ext = 5 bits

2. Calcular los resultados intermedios dentro del `case (op)`.

3. Inicializar `result` y `carry` con valores por defecto para evitar latches.

Ejemplo de estructura general (en pseudocódigo SystemVerilog):

    always_comb begin
        // Valores por defecto
        result = 4'd0;
        carry  = 1'b0;

        case (op)
            2'b00: begin
                // Suma
                sum_ext = {1'b0, A} + {1'b0, B};
                result  = sum_ext[3:0];
                carry   = sum_ext[4];
            end

            2'b01: begin
                // Resta
                diff_ext = {1'b0, A} - {1'b0, B};
                result   = diff_ext[3:0];
                carry    = diff_ext[4];  // interpretado como borrow simple
            end

            2'b10: begin
                // AND
                result = A & B;
                carry  = 1'b0;
            end

            2'b11: begin
                // XOR
                result = A ^ B;
                carry  = 1'b0;
            end

            default: begin
                result = 4'd0;
                carry  = 1'b0;
            end
        endcase

        // Bandera zero común a todas las operaciones
        zero = (result == 4'd0);
    end

Al final, se conectan las salidas al vector `led` según el mapeo acordado:

    led[3:0] = result;
    led[4]   = carry;
    led[5]   = zero;
    led[7:6] = op;

---

## Pruebas sugeridas

Algunas combinaciones útiles para verificar el comportamiento:

1. **Suma (`op = 2'b00`)**

   - A = 3 (0011), B = 1 (0001)  
     - `result = 4` (0100), `carry = 0`, `zero = 0`.
   - A = 15 (1111), B = 1 (0001)  
     - `sum_ext = 1_0000`  
     - `result = 0000`, `carry = 1`, `zero = 1`.

2. **Resta (`op = 2'b01`)**

   - A = 5 (0101), B = 2 (0010)  
     - `result = 3` (0011), `carry` interpretado como 0, `zero = 0`.
   - A = 2 (0010), B = 5 (0101)  
     - resultado envolvente en 4 bits, `carry` (bit extra) indica borrow, `zero` según `result`.

3. **AND (`op = 2'b10`)**

   - A = 5 (0101), B = 3 (0011)  
     - `result = 0001`, `carry = 0`, `zero = 0`.

4. **XOR (`op = 2'b11`)**

   - A = 5 (0101), B = 3 (0011)  
     - `result = 0110`, `carry = 0`, `zero = 0`.
   - A = 7 (0111), B = 7 (0111)  
     - `result = 0000`, `carry = 0`, `zero = 1`.

Si en todos estos casos los LEDs coinciden con los resultados esperados, la mini ALU está funcionando correctamente.

---

## Extensiones opcionales

Algunas ideas para ampliar la actividad:

- Añadir más operaciones:
  - OR (`A | B`)
  - NOT (`~A`)
  - Comparación (`A == B`, `A > B`, etc.)

- Introducir banderas adicionales:
  - `negative` para indicar si el resultado tiene el bit más significativo en 1.
  - `overflow` para detectar overflow aritmético en suma/resta.

- Mostrar el resultado en el TM1638:
  - En los dígitos de 7 segmentos: valor de la operación.
  - En los LEDs del TM1638: banderas (`carry`, `zero`, `negative`, etc.).

- Separar el módulo de la ALU:
  - Crear un módulo `alu_4bit` reutilizable y conectarlo desde un `hackathon_top` más grande.

Con esta solución se cierra el ciclo de la actividad `4_04_mini_alu_4bit`, mostrando una implementación completa y comentada de una mini ALU combinacional de 4 bits.
