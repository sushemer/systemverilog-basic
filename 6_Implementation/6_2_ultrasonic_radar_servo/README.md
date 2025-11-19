# 6.2 – Servo-scanned Ultrasonic Radar

## Objetivo

Diseñar un sistema que:

1. Controle un **servo** (ej. SG90) para barrer un arco (p. ej. 0°–180°).
2. Use el **sensor ultrasónico HC-SR04** para medir distancia en cada ángulo.
3. Muestre:
   - Ángulo actual.
   - Distancia medida.
   - Indicación clara cuando se detecta un objeto por debajo de un umbral.
4. Detenga el barrido cuando detecta un objeto cercano y:
   - Espere orden del usuario para reanudar, **o**
   - Reanude automáticamente tras un tiempo.
5. Aplique técnicas de **promediado** o filtrado para lecturas estables.

---

## Hardware sugerido

- Tang Nano 9K.
- **HC-SR04**:
  - TRIG desde la FPGA.
  - ECHO adaptado a 3.3 V (divisor o level shifter).
- **Servo SG90** (u otro pequeño):
  - 5 V de alimentación separada.
  - GND común con FPGA.
  - Señal PWM desde la FPGA (pulso de 1–2 ms, periodo de ≈20 ms).
- **LCD**:
  - Usa LCD 480×272 para dibujar texto y barras.
- Botones o encoder para:
  - Cambiar modo (scan / pausa).
  - Ajustar umbral de detección.
  - Reanudar barrido.

---

## Conceptos que integra

- Generación de **PWM** específico para servo (1–2 ms cada 20 ms).
- FSM para el barrido del servo (izquierda → derecha → izquierda…).
- Medición de distancia con **HC-SR04** (pulse width).
- Promediado de N muestras para reducir ruido.
- Integración de sensores con una interfaz de usuario básica (botones / encoder + LCD).

---

## Comportamiento propuesto

### 1. Control de servo

- Generar un PWM con:
  - Periodo ≈ 20 ms.
  - Ancho de pulso:
    - ~1.0 ms → extremo mínimo (≈0°).
    - ~1.5 ms → centro (≈90°).
    - ~2.0 ms → extremo máximo (≈180°).
- Implementar una FSM de barrido:
  - Estado “barrido hacia la derecha”.
  - Estado “barrido hacia la izquierda”.
  - Cambiar suavemente el ancho de pulso para no dar saltos bruscos.

### 2. Medición con HC-SR04

- En cada posición (o cada N pasos de servo):
  - Disparar trig.
  - Medir la anchura del pulso echo (en ciclos de reloj).
  - Convertir a distancia relativa (o aproximar a cm).
- Promediar 2–4 lecturas para un mismo ángulo si se desea estabilidad.

### 3. Detección de objeto y umbral

- Definir un **umbral de distancia** (ej. 30 cm o el valor relativo correspondiente).
- Si `distancia <= umbral`:
  - Activar bandera de detección.
  - Detener el servo (mantener posición).
  - Destacar visualmente la detección:
    - Texto “OBJETO DETECTADO”.
    - Cambio de color o símbolos.
- Reanudar barrido:
  - Tras pulsar un botón.
  - O tras un timeout (ej. 3–5 segundos sin detección).

### 4. Visualización

#### LCD 480×272

- Fondo con marco simple.
- Zona gráfica:
  - Pequeño arco donde un punto indica el ángulo actual.
  - Color o grosor diferente si hay detección.

---