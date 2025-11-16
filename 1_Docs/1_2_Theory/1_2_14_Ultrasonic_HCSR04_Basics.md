# Ultrasonic HC-SR04 basics

Este documento explica el funcionamiento básico del sensor ultrasónico **HC-SR04**  
y cómo se integra con la FPGA en este repositorio.

---

## ¿Qué mide el HC-SR04?

El HC-SR04 mide **distancia** hasta un objeto usando ultrasonido:

- Emite un pulso de sonido de alta frecuencia.
- Mide el tiempo que tarda en regresar el eco.
- Calcula la distancia aproximada con base en el tiempo de vuelo.

El resultado típico es una distancia en centímetros o milímetros.

---

## Pines principales

El módulo HC-SR04 suele tener 4 pines:

- `VCC` → alimentación (normalmente 5 V).
- `GND` → tierra.
- `TRIG` → entrada de disparo (desde la FPGA).
- `ECHO` → salida de respuesta (hacia la FPGA).

**Importante:**  
El pin `ECHO` puede estar a **5 V**, por lo que se debe adaptar a 3.3 V para no dañar la FPGA:

- Divisor resistivo.
- Level shifter.
- Cualquier solución segura documentada en `2_devices/`.

---

## Secuencia de medición

Flujo básico:

1. La FPGA genera un pulso corto en `TRIG`:
   - Duración típica: al menos 10 µs en nivel alto.

2. El sensor emite una ráfaga ultrasónica y luego:
   - Pone `ECHO` en alto mientras espera el eco.
   - `ECHO` permanece en alto durante un tiempo proporcional a la distancia.

3. La FPGA mide la **duración** del pulso en `ECHO`.

4. A partir de ese tiempo, se calcula la distancia:

   - Distancia ≈ (tiempo * velocidad_del_sonido) / 2

El factor 1/2 aparece porque el sonido va y regresa.

---

## Medición del tiempo con la FPGA

En la FPGA se puede medir el ancho del pulso de `ECHO` mediante:

- Un **contador** que:
  - Se pone en cero al inicio del pulso.
  - Se incrementa cada ciclo de reloj mientras `ECHO` está en 1.

- Al terminar el pulso:
  - El valor del contador representa el tiempo en “ticks de reloj”.

Luego, se puede convertir ese valor a:

- Microsegundos (si se conoce la frecuencia de reloj).
- Centímetros, usando una relación aproximada.

Ejemplo conceptual en ticks:

- Si `clk = 50 MHz`, un tick ≈ 20 ns.
- Si el pulso dura 10,000 ticks:
  - Tiempo ≈ 200 µs.
  - Distancia aproximada se calcula con la ecuación correspondiente.

En los ejemplos y labs, la fórmula exacta se ajusta según la frecuencia real del reloj y las aproximaciones elegidas.

---

## Consideraciones prácticas

- **Rango típico**: desde unos pocos centímetros hasta ~4 metros.
- **Zona muerta**: muy cerca del sensor (pocos cm), la medición es poco confiable.
- **Ambiente**:
  - Temperatura y condiciones pueden afectar ligeramente la velocidad del sonido.
  - Para fines didácticos, se suele usar un valor constante.

- **Ruido y lecturas inestables**:
  - Es común promediar varias mediciones.
  - Se pueden descartar valores fuera de rango.

---

## Uso típico en este repositorio

Ejemplos y labs:

- `ultrasonic_hcsr04_measure_demo` (example/activity):
  - Generar el pulso `TRIG`.
  - Medir el tiempo de `ECHO`.
  - Mostrar distancia aproximada en LEDs o display de 7 segmentos.

- `ultrasonic_hcsr04_cm` (lab intermedio):
  - Medición en centímetros con:
    - Promedio de varias muestras.
    - Filtro para valores atípicos.
  - Integración con otros periféricos (LCD, TM1638).

- Mini-proyecto “servo-scanned ultrasonic radar”:
  - Girar un servo mientras se mide distancia.
  - Mostrar resultados en LCD o 7 segmentos.

---

## Relación con otros archivos de teoría

- `1_2_5_Registers_and_Clock.md`  
  → uso de contadores para medir tiempos.
- `1_2_6_Timing_and_Dividers.md`  
  → relacionar ticks de reloj con unidades de tiempo.
- `1_2_7_Finite_State_Machines.md`  
  → FSM para controlar las fases: disparo, espera, medición, cálculo.

La parte de wiring y adaptación de niveles se detalla en:

- `2_devices/` → sección HC-SR04.
