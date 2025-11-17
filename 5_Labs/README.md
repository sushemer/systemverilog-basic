# 5. Labs – Guided practices

Hands-on labs using **Tang Nano 9K + TM1638 + LCD 480×272 + sensores reales**.  
Cada lab tiene:

- Un archivo principal `hackathon_top.sv`.
- Un `README.md` propio con objetivos, conexiones y checklist.

Se recomienda hacerlos **en orden**.

---

## 5.1 – counter_blink_hello_world

**Carpeta:** `5_1_counter_blink_hello_world`  

- **Objetivo:** hacer parpadear un LED a ~1 Hz usando un divisor de reloj.
- **Conceptos clave:** módulo top, registros, `always_ff @(posedge clk)`, overflow de contador.
- **Hardware:** Tang Nano 9K, un LED de usuario.

---

## 5.2 – buttons_and_debounce

**Carpeta:** `5_2_buttons_and_debounce`  

- **Objetivo:** leer un botón, eliminar rebotes y generar pulsos limpios para cambiar el estado de un LED.
- **Conceptos clave:** sincronización a reloj, debounce simple, detección de flanco.
- **Hardware:** Tang Nano 9K, al menos 1 botón y 1 LED.

---

## 5.3 – shift_register_patterns

**Carpeta:** `5_3_shift_register_patterns`  

- **Objetivo:** generar patrones de desplazamiento en una barra de 8 LEDs (running light / “KITT”).
- **Conceptos clave:** registros de desplazamiento, rotación, patrones periódicos, enable lento.
- **Hardware:** Tang Nano 9K, 8 LEDs.

---

## 5.4 – fsm_traffic_and_lock

**Carpeta:** `5_4_fsm_traffic_and_lock`  

- **Objetivo:** implementar dos máquinas de estados:
  - Semáforo (R→G→Y→R) con tiempos configurables.
  - “Sequence lock”: una secuencia correcta de botones enciende un LED de “desbloqueo”.
- **Conceptos clave:** FSM con `case`, temporización basada en contadores, uso de entradas con debounce.
- **Hardware:** LEDs para luces del semáforo + LED de lock, botones de entrada.

---

## 5.5 – seven_segment_and_tm1638

**Carpeta:** `5_5_seven_segment_and_tm1638`  

- **Objetivo:** usar el driver de 7 segmentos + TM1638 para mostrar valores y usar los LEDs como barra/estado.
- **Conceptos clave:** `seven_segment_display`, TM1638 como periférico integrado, mapeo de nibbles a dígitos.
- **Hardware:** Módulo **TM1638** (7 segmentos, LEDs y teclas).

---

## 5.6 – sensors_and_lcd_integration

**Carpeta:** `5_6_sensors_and_lcd_integration`  

- **Objetivo:** integrar sensores reales con la pantalla LCD:
  - Leer **HC-SR04** (ultrasonido) y **encoder rotatorio KY-040**.
  - Seleccionar el origen del dato con teclas.
  - Mostrar el valor como una **barra vertical tipo “gauge”** en el LCD y como patrón en LEDs.
- **Conceptos clave:** integración de módulos (ultrasonic + rotary_encoder + debounce), uso de coordenadas `(x, y)` para gráficos simples, escalado de valores a altura de píxeles.
- **Hardware:** Tang Nano 9K, módulo LCD 480×272, HC-SR04, encoder KY-040.

---

## Recomendación de uso

1. Empieza con **5.1** y **5.2** para afianzar reloj, contadores y botones.
2. Sigue con **5.3** para practicar registros de desplazamiento y patrones.
3. En **5.4**, consolida tu manejo de FSMs con ejemplos claros.
4. En **5.5**, entra al mundo de los displays multiplexados y TM1638.
5. Cierra con **5.6**, donde unes sensores y LCD en una práctica de integración “tipo mini-proyecto”.

Cada lab está pensado para ser:

- **Corto**, pero con espacio para extensiones.
- **Reutilizable** como base para proyectos más grandes.
- Coherente con el hardware que tienes actualmente.
