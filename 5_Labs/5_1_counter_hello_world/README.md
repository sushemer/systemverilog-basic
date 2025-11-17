# Lab 5.1 – counter_hello_world

**Nivel:** Básico  
**Board:** Tang Nano 9K (configuración `tang_nano_9k_lcd_480_272_tm1638_hackathon`)  
**Archivo principal:** `hackathon_top.sv`

---

## 1. Objetivo

Hacer parpadear un LED de la placa (~1 Hz) usando:

- Un **contador** que divide el reloj de la FPGA.
- Un **registro** actualizado en `always_ff @(posedge clk)`.
- Un **mapeo simple** desde lógica interna a un pin físico (`led[0]`).

Al final del lab, deberías sentirte cómodo con:

- Crear un módulo simple con entradas/salidas.
- Usar un registro como divisor de frecuencia.
- Entender cómo un bit alto del contador se ve como un parpadeo visible.

---

## 2. Requisitos previos

- Haber instalado:
  - Gowin IDE + toolchain (como en el resto del repo).
  - Scripts `03_synthesize_for_fpga.bash` funcionando.
- Conocer lo básico de:
  - Tipos `logic`, `always_ff`, `always_comb`.
  - Estructura del `hackathon_top` en otros ejemplos.

---

## 3. Archivos

- `hackathon_top.sv`  
  Plantilla del lab con comentarios `TODO` para que completes la lógica.

- (Opcional, para revisión)  
  `../5_1_counter_hello_world_solution/hackathon_top.sv`  
  Una solución de referencia que **no deberías copiar directo** en un examen 😄.

---

## 4. Pasos sugeridos

### Paso 1 – Explorar la plantilla

1. Abre `5_Labs/5_1_counter_hello_world/hackathon_top.sv`.
2. Localiza:
   - Las asignaciones que apagan `abcdefgh`, `digit`, `red`, `green`, `blue`.
   - La sección del **divisor de frecuencia** (`W_DIV` y `div_cnt`).
   - El bloque `always_comb` donde se asigna `led`.

### Paso 2 – Implementar el contador

En el bloque:

```sv
always_ff @(posedge clock or posedge reset)
begin
    if (reset)
    begin
        div_cnt <= '0;
    end
    else
    begin
        // TODO: incrementar el contador
        // div_cnt <= ...;
    end
end
```