# Seven-segment display basics

Este documento explica los conceptos básicos de los **displays de 7 segmentos**  
y cómo se usan en los ejemplos y labs de este repositorio.

---

## Estructura de un display de 7 segmentos

Un dígito de 7 segmentos está compuesto por:

- 7 LEDs organizados en forma de número “8”.
- Opcionalmente un **punto decimal** (`dp`).

Cada segmento se suele nombrar:

- `a, b, c, d, e, f, g`  
  (y el punto decimal `dp`).

Encendiendo y apagando combinaciones de estos segmentos se pueden formar:

- Dígitos del 0 al 9.
- Algunas letras (A, b, C, d, E, F, etc.).

---

## Common anode vs common cathode

Hay dos tipos principales:

- **Common anode**:
  - Todos los ánodos de los LEDs se conectan a un punto común.
  - Para encender un segmento:
    - Se conecta el **común** a VCC.
    - Se lleva la línea del segmento a nivel **bajo** (0).

- **Common cathode**:
  - Todos los cátodos se conectan a un punto común (generalmente GND).
  - Para encender un segmento:
    - Se lleva el común a GND.
    - Se lleva la línea del segmento a nivel **alto** (1).

Es importante saber qué tipo de display se está usando, porque:

- Afecta la **lógica de encendido** (inversión o no).
- Afecta el wiring y las resistencias.

En este repositorio, la lógica concreta (0/1 para encender) se documenta en:

- `2_devices/` → sección de 7 segmentos.
- Ejemplo `seven_segment_basics` / `seven_segment_letter`, etc.

---

## Mapeo de segmentos

Para mostrar un número o letra, se define un **mapa de segmentos**:

- Por ejemplo, para el número “0” en common cathode:
  - `a, b, c, d, e, f` = encendidos.
  - `g` = apagado.

En SystemVerilog se puede representar con un bus:

- `seg[6:0]` → `{a, b, c, d, e, f, g}`  
  (el orden exacto se documenta en el repositorio).

Ejemplo de decodificador simple (idealizado):

```systemverilog
module seven_seg_decoder (
    input  logic [3:0] hex,    // valor 0–15
    output logic [6:0] seg     // segmentos a-g
);
    always_comb begin
        unique case (hex)
            4'h0: seg = 7'b1111110;
            4'h1: seg = 7'b0110000;
            4'h2: seg = 7'b1101101;
            4'h3: seg = 7'b1111001;
            4'h4: seg = 7'b0110011;
            4'h5: seg = 7'b1011011;
            4'h6: seg = 7'b1011111;
            4'h7: seg = 7'b1110000;
            4'h8: seg = 7'b1111111;
            4'h9: seg = 7'b1111011;
            default: seg = 7'b0000000;
        endcase
    end
endmodule
```