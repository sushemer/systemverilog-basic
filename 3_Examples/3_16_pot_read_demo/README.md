# 3.15 Potentiometer read demo (simulado)

Este ejemplo muestra cómo **tomar un valor digital de 8 bits** (0–255) y:

- Representarlo con **LEDs** (patrón binario).
- Mostrarlo numéricamente en el **display de 7 segmentos**.
- Visualizarlo como una **barra horizontal en la pantalla LCD**, cuya longitud es proporcional al valor.

En la Tang Nano 9K no tenemos un ADC integrado en este setup, así que por ahora
**simulamos el potenciómetro** usando las entradas `key[7:0]`.  
Más adelante se podría sustituir por la salida de un ADC real conectado a la FPGA.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender la idea de **mapear un valor de sensor (potenciómetro)** a:
  - Representación binaria (LEDs).
  - Representación numérica (7 segmentos).
  - Representación gráfica (barra en LCD).
- Practicar operaciones de **escalamiento** (0–255 → 0–anchura de la pantalla).
- Ver cómo las diferentes interfaces de la placa pueden mostrar el mismo dato.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope para la configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon` que:

  - Lee `key[7:0]` como `pot_value` (0–255) para simular el potenciómetro.
  - Asigna `pot_value` directamente a los LEDs (`led[7:0]`).
  - Instancia `seven_segment_display` para mostrar `pot_value`.
  - Calcula el ancho de una barra verde en la LCD proporcional a `pot_value`.

El resto de módulos (wrapper de la placa, `seven_segment_display`, etc.)  
se asumen presentes en el repositorio, como en los ejemplos anteriores.

---

## Señales clave

### Entrada: potenciómetro simulado

En el código:

```sv
logic [7:0] pot_value;

always_comb begin
    pot_value = key; // simulación: switches/teclas como valor de pot
end
```