# 4.8 – Integración de sensores y TM1638

En esta actividad vas a **combinar sensores físicos** con el módulo **TM1638**:

- Leerás al menos **un sensor** (ultrasonido HC-SR04 y/o encoder rotatorio KY-040).
- Mostrarás el valor en el **display de 7 segmentos** (TM1638).
- Representarás el valor como una **barra** usando los **8 LEDs** del TM1638.
- Usarás **teclas** para cambiar de modo / sensor / escala.

La idea es juntar varias piezas que ya viste en los ejemplos: sensores, drivers y lógica combinacional/secuencial simple.

---

## Objetivo

Al terminar la actividad deberías poder:

- Instanciar uno o más módulos de sensor (ultrasonido, encoder).
- Seleccionar qué valor mostrar usando teclas (`key`).
- Actualizar el display de 7 segmentos con un número de 16 bits.
- Dibujar una barra de nivel en los LEDs en función del valor leído.
- Pensar en modos de operación (ej. “distancia”, “encoder”, “mix”).

---

## Hardware asumido

- **Placa:** Tang Nano 9K con configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`.
- **TM1638** conectado (8 dígitos 7seg + 8 LEDs + teclas).
- **GPIO [3:0]** usados como:
  - `gpio[0]` → TRIG del HC-SR04.
  - `gpio[1]` → ECHO del HC-SR04.
  - `gpio[3]` → A (CLK) del KY-040.
  - `gpio[2]` → B (DT) del KY-040.

Si no tienes ambos sensores, puedes hacer la actividad solo con uno y adaptar la lógica de selección.

---

## Archivos / módulos necesarios

Asegúrate de que estos módulos estén incluidos en el proyecto:

- `ultrasonic_distance_sensor.sv`  
  (módulo para HC-SR04, usado ya en el ejemplo de ultrasonido).
- `rotary_encoder.sv`
- `sync_and_debounce.sv`
- `sync_and_debounce_one.sv`
- `seven_segment_display.sv`
- `hackathon_top.sv` (este archivo de actividad).

---

## Qué hace la plantilla

El archivo `hackathon_top.sv` ya incluye:

1. **Ultrasonido HC-SR04**

   ```sv
   ultrasonic_distance_sensor i_ultrasonic ( ... );
   ```