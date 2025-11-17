<!-- File: 4_Activities/4_04_mini_alu_4bit/README.md -->

# 4.4 – Mini ALU de 4 bits (suma, resta y lógica)

En esta actividad vas a construir una **mini ALU de 4 bits** capaz de hacer operaciones aritméticas y lógicas simples sobre dos operandos A y B.

La ALU tendrá:

- **Entradas:**
  - `A[3:0]` y `B[3:0]` (operandos de 4 bits).
  - `op[1:0]` (selector de operación).
- **Salidas:**
  - `result[3:0]` (resultado de la operación).
  - `carry` (acarreo / borrow).
  - `zero` (el resultado es cero).

---

## Mapeo sugerido de señales

Operandos (usando switches):

- `A = sw[3:0]`
- `B = sw[7:4]`

Selector de operación:

- `op = key[1:0]`

Interpretación de `op`:

| `op`  | Operación sugerida           |
|-------|------------------------------|
| 2'b00 | `A + B`                      |
| 2'b01 | `A - B`                      |
| 2'b10 | `A & B`                      |
| 2'b11 | `A ^ B` (o `A \| B`, tú decides) |

Salidas a LEDs:

- `led[3:0]` → `result[3:0]`
- `led[4]`   → `carry`
- `led[5]`   → `zero`
- `led[7:6]` → `op[1:0]` (para ver qué operación está seleccionada)

> Si tu wrapper no tiene `sw`, puedes adaptar A y B a `key` u otro periférico (TM1638, etc.).

---

## Objetivos

1. Implementar una ALU combinacional de 4 bits usando `case (op)`.
2. Manejar correctamente:
   - suma y resta con ancho extendido (para capturar el acarreo),
   - operaciones lógicas bit a bit (AND, XOR / OR).
3. Calcular y mostrar banderas básicas:
   - `carry` → bit extra de suma/resta (o 0 en operaciones lógicas).
   - `zero`  → 1 cuando `result == 0`.
4. Visualizar el resultado en LEDs y confirmar manualmente algunos casos.

---

## Pasos sugeridos

1. **Conectar operandos y selector**

   En `hackathon_top.sv`:

   - Revisa el mapeo de `A`, `B` y `op`.
   - Adáptalo si tu placa usa otras señales (por ejemplo, solo `key`).

2. **Implementar la ALU**

   Dentro del bloque `always_comb`:

   - Declara variables auxiliares si lo necesitas (por ejemplo, `logic [4:0] sum_ext;`).
   - Usa un `case (op)` para seleccionar la operación:

     - `op = 2'b00`:  
       - Calcula `A + B` en 5 bits.  
       - Asigna los 4 bits menos significativos a `result`.  
       - Usa el bit 4 como `carry`.

     - `op = 2'b01`:  
       - Calcula `A - B` en 5 bits (también en ancho extendido).  
       - Decide cómo usar el bit extra (puede ser “borrow” o simplemente informativo).

     - `op = 2'b10`:  
       - Asigna `result = A & B`.

     - `op = 2'b11`:  
       - Asigna `result = A ^ B` (o `A | B` si prefieres).

   - Al final del bloque, calcula:

     ```systemverilog
     zero = (result == 4'd0);
     ```

3. **Conectar LEDs**

   Usa el bloque:

   ```sv
   always_comb
   begin
       led = 8'b0;
       led[3:0] = result;
       led[4]   = carry;
       led[5]   = zero;
       led[7:6] = op;
    end
    ```