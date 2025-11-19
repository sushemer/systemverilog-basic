# 2.2.3 Buttons & Switches · Botones y switches
![alt text](Mult/image.png)

Esta carpeta documenta el uso de **entradas digitales simples**:

- Los botones integrados en la Tang Nano 9K (`KEY[0]`, `KEY[1]`).
- Pulsadores o micro-switches externos, si se añaden en el protoboard.

Los conceptos de esta sección también se aplican a otras teclas o botones usados en el proyecto, por ejemplo:

- Las teclas del módulo **TM1638** (aunque la lectura concreta se documenta en `2_3_2_TM1638`).

---

## Propósito

Los botones y switches se utilizan para:

- Cambiar de estado en una **FSM**.
- Iniciar o detener contadores.
- Cambiar modos de operación (por ejemplo, seleccionar qué se muestra en un display).

Son una de las formas más sencillas de interactuar con la FPGA.

---

## Señales y pines lógicos

Ejemplos típicos de señales:

- `btn_a`, `btn_b` → botones de usuario.
- `sw_mode` → switch de selección de modo.

En la Tang Nano 9K, los botones integrados suelen mapearse como:

- `KEY[0]`
- `KEY[1]`

con sus pines físicos definidos en:

- `2_1_Boards/2_1_1_Tang_Nano_9K/docs/pinout.md`
- `2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

---

## Conceptos clave

### Pull-up / Pull-down

Un botón normalmente se conecta:

- Entre la señal y **GND**, con una resistencia de **pull-up** a VCC, o
- Entre la señal y **VCC**, con una resistencia de **pull-down** a GND.

En muchos casos:

- La placa ya incluye el pull-up/pull-down.
- En botones externos, puede ser necesario añadirlos en el protoboard.

### Rebote (debouncing)

Los contactos mecánicos no cambian limpio de 0 a 1; “rebotan” durante unos milisegundos.  
Para evitar que un solo clic cuente como varios, se usa **debouncing**:

- Por hardware (RC + Schmitt trigger, cuando aplica).
- Por lógica digital (contadores, filtros por tiempo).

### Detección de flancos

Muchas veces interesa detectar “cuando se presiona” (flanco de subida) o “cuando se suelta” (flanco de bajada), no el nivel constante.  
Esto se puede hacer con:

- Registros que guarden el valor anterior.
- Comparación entre valor actual y anterior.

---

## Relación con otros dispositivos

- **Rotary Encoder**  
  El botón `ENC_SW` del encoder se trata igual que un botón normal:
  - Necesita debouncing.
  - Se puede usar para “aceptar” o “entrar” a una opción.

- **TM1638**  
  Las teclas del TM1638 también son entradas digitales, solo que su lectura se realiza:
  - Mediante el protocolo propio del chip.
  - A través de señales compartidas (`DIO`, `CLK`, `STB`).

Los conceptos de **pull-up**, **rebote** y **flancos** siguen siendo los mismos.

---

## Relación con la teoría

Este dispositivo se apoya en los siguientes temas de `1_2_Theory`:

- `1_2_4_Combinational_vs_Sequential.md`  
  Lógica secuencial para memorizar estados y flancos.

- `1_2_7_Finite_State_Machines.md`  
  Uso de botones para avanzar o resetear estados.

- `1_2_8_Debouncing_and_Edge_Detection.md`  
  Técnicas para limpiar señales mecánicas y detectar flancos correctos.

---

## Ejemplos, actividades y laboratorios relacionados

Algunas ideas típicas:

- **Examples**
  - Encender/apagar un LED con un botón.
  - Cambiar entre dos patrones de LEDs con un switch.

- **Activities**
  - Implementar un contador que solo avance en flanco de subida de un botón.
  - Crear una FSM de semáforo controlada por un botón de “peatón”.

- **Labs / Implementation**
  - Menú controlado por botones:
    - Un botón para avanzar opción.
    - Otro para seleccionar/confirmar.

Los nombres exactos de Examples/Activities/Labs pueden ajustarse cuando se definan las carpetas correspondientes.

---
