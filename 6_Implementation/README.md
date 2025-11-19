# 6. Implementation – Propuestas de mini-proyectos

Esta carpeta reúne **propuestas de implementación** que integran varios temas del repositorio:

- Diseño secuencial (contadores, FSM, divisores de reloj).
- Manejo de displays (7 segmentos / TM1638).
- Sensores (HC-SR04).
- Periféricos externos (servo, LCD).

> Nota: son **proyectos propuestos**, no entregables obligatorios.  
> Pueden ajustarse al hardware disponible (por ejemplo, usar solo TM1638 + LCD 480×272 si no se cuenta con 16×2 ni servos).

---

## 6.1 Clock


Un reloj digital en displays de 7 segmentos (o TM1638) con:

- Reloj estable derivado del clock de la FPGA.
- Formatos de hora **12 h / 24 h**.
- Ajuste de minutos con pasos de **±1, ±5, ±10** mediante botones (o encoder rotatorio).
- Manejo correcto de “rollover”:
  - 59 → 00 en minutos.
  - 23 → 00 en horas (modo 24 h).
  - 12/11 → 1/12 según lógica de 12 h, si se implementa.
- Visualización sin parpadeos ni glitches.

---

## 6.2 Servo-scanned ultrasonic radar


Un “radar” simple que:

- Barre un arco con un **servo** (ej. SG90).
- Mide distancia con el **HC-SR04** en cada ángulo.
- Muestra en la pantalla:
  - Ángulo actual.
  - Distancia medida.
  - Destaca visualmente cuando hay un objeto por debajo de un umbral.
- Aplica promediado para lecturas estables.
- Detiene el servo al detectar un objeto cercano y reanuda el barrido:
  - por tiempo (timeout) o
  - cuando el usuario lo indique (botón/encoder).

