# Notas de alimentación y niveles lógicos · Tang Nano 9K

Este documento resume las consideraciones básicas de **alimentación** y **niveles de señal** al usar la Tang Nano 9K con los ejemplos de este repositorio.

No es un reemplazo del datasheet, pero sí una guía rápida para evitar errores comunes.

---

## 1. Niveles lógicos principales

- La mayoría de las IO de usuario en la Tang Nano 9K trabaja a **3.3 V lógicos**.
- En el archivo de constraints `tang-nano-9k.cst` se asume:
  - `CLK`, `KEY[x]`, `LED[x]`, `GPIO[x]`, etc. como señales a 3.3 V.
- Algunos pines especiales están marcados como **1.8 V** en el `.cst` original y **no se usan** en los ejemplos básicos.

> Regla general:  
> Tratar todas las IO de usuario como señales de 3.3 V salvo que la documentación oficial indique lo contrario.

---

## 2. Alimentación de la placa

En la mayoría de usos:

- La Tang Nano 9K se alimenta a través del **conector USB**.
- Internamente regula los voltajes necesarios para la FPGA y la lógica.

Recomendaciones:

- Usar un puerto USB de PC o un cargador/Hub confiable.
- Evitar conectar y desconectar módulos externos con la placa energizada, especialmente si hay duda sobre el voltaje.

---

## 3. GND común

Al conectar sensores y actuadores externos:

- La fuente de 5 V (si se usa) y la Tang Nano 9K deben compartir **tierra (GND)**.
- Siempre conectar `GND` del módulo externo a `GND` de la placa.

Sin GND común:

- Las señales no tienen referencia en común.
- Es probable que la FPGA lea valores erróneos o se comporte de forma aleatoria.

---

## 4. Módulos de 5 V (sensores / actuadores)

Muchos módulos comerciales (HC-SR04, servos, algunos LCD, etc.) trabajan a **5 V de alimentación**, pero sus líneas de datos deben ser compatibles con la FPGA:

- **Hacia la FPGA (entrada)**:
  - Nunca conectar directamente una salida de **5 V** a un pin de IO de la Tang Nano 9K.
  - Usar **divisores resistivos** o **conversores de nivel** (ver `2_4_Common/level_shifting.md`).

- **Desde la FPGA (salida)**:
  - Una salida a 3.3 V suele ser interpretada como “alto lógico” por la mayoría de módulos de 5 V, pero se recomienda revisar el datasheet.

Ejemplos típicos:

- `HC-SR04`:
  - `VCC` a 5 V.
  - `TRIG` puede manejarse con 3.3 V desde la FPGA.
  - `ECHO` debe reducirse de 5 V a 3.3 V (divisor resistivo o level shifter).

- `Servo SG90`:
  - Alimentación a 5 V (fuente separada de suficiente corriente).
  - Señal de PWM desde la FPGA a 3.3 V (suele ser aceptada).
  - GND del servo y de la FPGA unidos.

---

## 5. Limitaciones de corriente

- Los pines de IO de la FPGA están pensados para **señales lógicas**, no para manejar cargas de potencia.
- No conectar:
  - Motores directamente a pines de IO.
  - Relés u otros actuadores que requieran corrientes altas sin usar drivers intermedios (transistores, MOSFET, etc.).

Los LEDs integrados de la placa suelen tener resistencias ya incluidas o un diseño pensado para uso directo, pero los LEDs externos deben llevar su propia resistencia limitadora.

---

## 6. Pines de 1.8 V (no usados)

En el archivo de constraints original hay pines comentados como:

```
# IO_LOC "GPIO_1_8_V_UNUSED[0]" 85;
# IO_LOC "GPIO_1_8_V_UNUSED[1]" 84;
...
```