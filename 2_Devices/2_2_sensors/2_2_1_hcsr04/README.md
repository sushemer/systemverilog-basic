# 2.2.1 HC-SR04 · Sensor ultrasónico de distancia

El **HC-SR04** es un sensor que mide distancia usando ultrasonido.  
Funciona enviando un pulso de sonido de alta frecuencia y midiendo el tiempo que tarda en regresar el eco.

En este repositorio se utiliza para:

- Medir distancia en centímetros.
- Mostrar el resultado en:
  - Displays de 7 segmentos.
  - Módulo TM1638.
  - LCD 16x2.
- Construir mini-proyectos como medidores de proximidad.

---

## Señales y pines lógicos

El módulo HC-SR04 tiene cuatro pines principales:

- `VCC` → alimentación (típicamente 5 V).
- `GND` → tierra común (debe conectarse a la misma GND que la Tang Nano 9K).
- `TRIG` → entrada de disparo (desde la FPGA).
- `ECHO` → salida de eco (hacia la FPGA).

En el código, se suelen usar nombres como:

- `hcsr04_trig`
- `hcsr04_echo`

La asignación a pines físicos concretos se documenta en:

- `2_1_Boards/2_1_1_Tang_Nano_9K/docs/pinout.md`
- `2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

---

## Principio de funcionamiento

1. La FPGA genera un pulso corto en `TRIG` (por ejemplo, 10 µs).
2. El sensor envía un tren de pulsos ultrasónicos.
3. Cuando el eco regresa, el sensor mantiene `ECHO` en nivel alto durante un tiempo proporcional a la distancia.
4. La FPGA mide el **ancho del pulso** en `ECHO` usando un contador basado en el reloj.
5. Con esa cuenta, se calcula la distancia aproximada en centímetros.

Fórmula típica (aproximada):

-distancia (cm) ≈ (tiempo_eco_en_segundos * velocidad_sonido) / 2
