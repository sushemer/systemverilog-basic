# Potentiometer + ADC basics

Este documento explica el uso combinado de un **potenciómetro** con un **ADC**  
para obtener un valor digital ajustable desde la FPGA.

---

## ¿Qué es un potenciómetro?

Un **potenciómetro** es una resistencia variable con tres terminales:

- Un extremo se conecta a un voltaje de referencia (por ejemplo, VCC).
- El otro extremo se conecta a GND.
- El terminal central (wiper) entrega un voltaje intermedio que depende de la posición del control.

Si:

- Un extremo está a 0 V (GND).
- El otro está a Vref (por ejemplo, 3.3 V).
- El wiper se mueve de un extremo al otro.

Entonces el voltaje en el wiper varía de:

- ~0 V → posición mínima.
- ~Vref → posición máxima.

---

## De voltaje variable a número digital: ADC

La FPGA no mide directamente voltajes analógicos.  
Para eso se usa un **ADC** externo (ver `1_2_11_ADC_Basics.md`).

Configuración típica:

- Potenciómetro como **divisor de voltaje**:
  - Un extremo a referencia alta (Vref o 3.3 V).
  - Otro extremo a GND.
  - Wiper al canal de entrada del ADC.

- El ADC convierte el voltaje del wiper a un valor digital:
  - Por ejemplo, 0–255 (8 bits) o 0–1023 (10 bits).

De esta forma, el potenciómetro se vuelve un “control giratorio” que entrega:

- Un número más grande cuanto más se gira en una dirección.
- Un número más pequeño en la otra dirección.

---

## Flujo general con la FPGA

1. La FPGA se comunica con el ADC (por SPI o I²C, según el modelo).
2. Solicita o recibe el valor convertido.
3. El valor digital se interpreta como:

   - Nivel (0–255).
   - Porcentaje (0–100%).
   - Parámetro para PWM, umbral, posición, etc.

Ejemplo de uso:

- `pot_value` (0–255) → se asigna directamente a `duty` en un módulo PWM.
- `pot_value` → se mapea a un rango de frecuencias, posiciones o menús.

---

## Escalado y mapeo de valores

Según la aplicación, es común convertir el valor bruto del ADC a otra escala.

Ejemplos:

- **Brillo de LED (5 niveles)**  
  Dividir el rango en tramos:
  - 0–51 → nivel 0.
  - 52–102 → nivel 1.
  - …
  - O bien usar directamente el valor como `duty` de un PWM.

- **Posición de servo (0°, 90°, 180°)**  
  - Rango 0–255:
    - 0–85 → 0°
    - 86–170 → 90°
    - 171–255 → 180°

- **Menú con múltiples opciones**  
  - Mapear el rango total a un número discreto de slots (por ejemplo, 0–3, 0–7).

Este escalado se hace en lógica combinacional dentro de la FPGA.

---

## Ejemplos de diseño

En este repositorio, el conjunto potenciómetro + ADC se usa en:

- `pot_read_demo` (example/activity):
  - Leer el valor de potenciómetro.
  - Mostrarlo en LEDs (como barra o número aproximado).

- Labs y mini-proyectos:
  - Controlar el brillo de un LED con PWM.
  - Ajustar parámetros (tiempos, umbrales de distancia, etc.).
  - Navegar por menús donde el potenciómetro actúa como “perilla de selección”.

---

## Relación con otros archivos de teoría

- `1_2_11_ADC_Basics.md`  
  → fundamentos de ADC.
- `1_2_9_Buses_Overview.md`  
  → buses SPI/I²C para comunicarse con el ADC.
- `1_2_10_PWM_Basics.md`  
  → uso del valor leído para controlar PWM.
- `1_2_12_Seven_Segment_Basics.md` y `1_2_13_LCD_HD44780_Basics.md`  
  → mostrar el valor del potenciómetro en 7 segmentos o LCD.

El wiring y detalles de modelos específicos de ADC (MCP3008, ADS1115, ADC0832, etc.) se documentan en:

- `2_devices/` → sección de ADCs y potenciómetro.
