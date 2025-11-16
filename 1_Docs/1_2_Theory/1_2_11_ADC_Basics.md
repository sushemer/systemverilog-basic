# ADC basics

Este documento presenta los conceptos generales de un **convertidor analógico–digital (ADC)**,  
sin centrarse en un modelo específico.  

El objetivo es entender:

- Por qué se necesita un ADC.
- Qué parámetros son importantes.
- Cómo se relaciona con la FPGA en este repositorio.

---

## ¿Por qué se necesita un ADC?

La FPGA trabaja con **señales digitales**:

- Niveles lógicos 0 y 1.
- Entradas y salidas que representan bits.

Muchos sensores y elementos de entrada producen valores **analógicos**:

- Voltajes continuos (por ejemplo, de un potenciómetro).
- Señales que no pueden representarse solo con 0 o 1 fijos.

Un **ADC (Analog-to-Digital Converter)** convierte:

- Un **voltaje analógico** dentro de cierto rango.
- En un **número digital** (por ejemplo, de 0 a 255, de 0 a 1023, etc.).

Ese número digital sí puede ser manejado directamente por la FPGA.

---

## Parámetros clave de un ADC

1. **Resolución (bits)**  
   - Cuántos niveles diferentes puede representar:
     - 8 bits → 256 niveles (0–255).
     - 10 bits → 1024 niveles (0–1023).
     - 12 bits → 4096 niveles, etc.
   - A mayor resolución, más “fina” es la medición.

2. **Rango de entrada / referencia (Vref)**  
   - Voltaje mínimo y máximo que el ADC puede medir.
   - Ejemplo: 0–3.3 V, 0–5 V.
   - El valor digital 0 corresponde al mínimo del rango; el máximo valor digital corresponde al máximo del rango.

3. **Velocidad de muestreo (sample rate)**  
   - Cuántas mediciones por segundo puede realizar.
   - Para usos básicos (potenciómetro, sensores lentos) no suele ser un límite crítico.

---

## Interfaz con la FPGA: SPI e I²C

Muchos ADC externos se comunican por buses seriales:

- **SPI (Serial Peripheral Interface)**  
  - Líneas típicas:
    - `SCK` (clock).
    - `MOSI` (datos hacia el ADC).
    - `MISO` (datos desde el ADC).
    - `CS` (chip select).
  - La FPGA actúa como **master**: inicia y controla la comunicación.

- **I²C (Inter-Integrated Circuit)**  
  - Líneas:
    - `SCL` (clock).
    - `SDA` (datos bidireccionales).
  - La FPGA también actúa como master y selecciona dispositivos por dirección.

En ambos casos, el flujo general es:

1. La FPGA inicia una transacción (activando `CS` o generando un `start`).
2. Envía comandos/configuración necesarios.
3. El ADC realiza la conversión.
4. La FPGA lee los bits de resultado y reconstruye el valor digital.

Más detalles de buses en:

- `1_2_9_Buses_Overview.md`

---

## De voltaje a número digital

Esquema conceptual:

- Voltaje de entrada: `V_in`.
- Rango del ADC: `0` a `Vref`.
- Resolución: N bits → `2^N` niveles.

El valor digital ideal (sin considerar errores) es aproximadamente:

- `code ≈ (V_in / Vref) * (2^N - 1)`

Ejemplo:

- ADC de 10 bits (0–1023), Vref = 3.3 V.
- Si `V_in = 1.65 V` ≈ Vref/2:
  - `code ≈ 511` (aprox. la mitad de 1023).

Este valor digital se puede:

- Mostrar en LEDs.
- Usar como entrada a un PWM.
- Convertir a otra escala (por ejemplo, 0–100%).

---

## Uso típico en este repositorio

En el contexto de este proyecto, se utilizan ADC externos para:

- Leer el valor de un **potenciómetro** (divisor de voltaje).
- Leer sensores analógicos (si se integran en el futuro).

El valor digital obtenido se emplea para:

- Controlar el brillo de LEDs.
- Cambiar la posición de un servo.
- Ajustar parámetros de un sistema (umbrales, velocidades, etc.).

Casos relacionados:

- `1_2_15_Potentiometer_ADC_Basics.md`  
  → explica un caso concreto: potenciómetro + ADC.
- `pot_read_demo` (en Examples/Activities)  
  → ejemplo práctico de lectura y representación.

---

## Relación con otros archivos de teoría

- `1_2_9_Buses_Overview.md`  
  → contexto sobre SPI/I²C.
- `1_2_10_PWM_Basics.md`  
  → uso del valor digital para controlar un PWM.
- `1_2_15_Potentiometer_ADC_Basics.md`  
  → aplicación específica con potenciómetro.

La combinación de estos conceptos permite crear mini-proyectos como:

- Dimmer de LED controlado con potenciómetro.
- Ajuste de posición de servo según una entrada analógica.
