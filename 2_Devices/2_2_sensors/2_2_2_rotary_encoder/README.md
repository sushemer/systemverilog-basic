
# 2.2.2 Rotary Encoder · Perilla digital

El **rotary encoder** es una “perilla digital” que genera dos señales en cuadratura (`A` y `B`) al girar, y en muchos módulos también incluye un botón (`SW`).

En este proyecto cumple el papel de **control giratorio principal**, es decir, se utiliza donde en otros contextos se usaría un potenciómetro para ajustar valores o navegar opciones.

Se usa para:

- Incrementar o decrementar un valor (por ejemplo, un contador).
- Ajustar parámetros (velocidad, brillo, umbrales).
- Moverse entre opciones de un menú simple.

---

## Señales y pines lógicos

Un módulo típico de rotary encoder expone:

- `ENC_A` → señal A (cuadratura).
- `ENC_B` → señal B (cuadratura).
- `ENC_SW` → botón integrado (opcional, pulsando la perilla).
- `VCC`, `GND` → alimentación (habitualmente 3.3 V o 5 V, según el módulo).

En el código se pueden usar nombres como:

- `enc_a`
- `enc_b`
- `enc_sw` (si se usa el botón integrado)

La asignación a pines físicos concretos se documenta en:

- `2_1_Boards/2_1_1_Tang_Nano_9K/docs/pinout.md`
- `2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst`

---

## Principio de funcionamiento

- Cuando se gira el encoder, `ENC_A` y `ENC_B` cambian de estado de forma desfasada (**cuadratura**).
- Observando el orden de los cambios de `A` y `B`, se puede determinar:
  - Si el giro fue **horario** (incrementar).
  - O **antihorario** (decrementar).
- El botón `ENC_SW` se comporta como un pulsador normal (requiere debouncing).

Una implementación típica:

- FSM o lógica secuencial que:
  - Detecta cambios en `A/B`.
  - Actualiza un contador interno.
  - Limita el valor a un rango (por ejemplo 0–9, 0–99, etc.).

---

## Notas de conexión y seguridad

- Verificar el nivel de voltaje del módulo del encoder:
  - Si la salida es 3.3 V, se puede conectar directo a la FPGA.
  - Si es 5 V, se recomienda adaptar nivel o usar un módulo compatible con 3.3 V.
- Conectar siempre **GND común** entre:
  - Tang Nano 9K.
  - Rotary encoder.

---

## Relación con la teoría

Este dispositivo se apoya en los siguientes temas de `1_2_Theory`:

- `1_2_4_Combinational_vs_Sequential.md`  
  Diferencias entre lógica combinacional y secuencial (el conteo es secuencial).

- `1_2_5_Registers_and_Clock.md`  
  Uso de registros para almacenar el valor actual del contador.

- `1_2_7_Finite_State_Machines.md`  
  FSM sencilla para interpretar la cuadratura de `A/B`.

- `1_2_8_Debouncing_and_Edge_Detection.md`  
  Para limpiar la señal del botón `ENC_SW` y detectar flancos.

---

## Ejemplos, actividades y laboratorios relacionados

Algunas ideas típicas para este dispositivo:

- **Examples**
  - Contador controlado por encoder (sube/baja un número).
  - Cambiar el valor de un divisor de tiempo girando el encoder.

- **Activities**
  - Usar el encoder para seleccionar un modo en TM1638 o LCD.
  - Ajustar el umbral de “cerca/lejos” para el HC-SR04.

- **Labs / Implementation**
  - Menú sencillo donde:
    - Se navega con el encoder.
    - Se seleccionan opciones con el botón `ENC_SW`.

Los nombres exactos de Examples/Activities/Labs pueden ajustarse cuando se definan las carpetas correspondientes.

---

## Checklist de uso rápido

Antes de usar el rotary encoder en un proyecto:

- [ ] Confirmar el nivel de voltaje del módulo y su compatibilidad con 3.3 V.
- [ ] Conectar `ENC_A`, `ENC_B` (y `ENC_SW` si se usa) a pines de entrada en la FPGA.
- [ ] Mapear esos pines en el archivo `.cst`.
