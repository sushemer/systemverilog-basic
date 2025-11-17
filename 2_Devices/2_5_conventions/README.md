# 2.5 Conventions · Convenciones de uso de dispositivos

Esta carpeta reúne las **convenciones** que se siguen en `2_devices` para:

- Mantener la asignación de pines consistente.
- Unificar nombres de señales.
- Estandarizar la documentación de cada dispositivo.
- Mejorar la seguridad y la reproducibilidad de los montajes.

La intención es que quienes colaboren en el proyecto puedan extenderlo sin romper la organización existente.

---

## 1. Archivo de constraints centralizado

- La asignación de pines de la Tang Nano 9K se define en un único archivo:

  2_1_Boards/2_1_1_Tang_Nano_9K/constr/tang-nano-9k.cst

- Cada Example, Activity, Lab o Implementation debe:
  - Reutilizar este `.cst` o una variante documentada.
  - Evitar crear múltiples versiones contradictorias para la misma placa.

Regla práctica:

> Si se cambia el pin de un dispositivo, primero se actualiza el `.cst` y el `pinout.md`, y después se ajustan los READMEs y el código.

---

## 2. Nombres de señales coherentes

Se recomienda usar nombres coherentes entre:

- Código Verilog/SystemVerilog.
- Archivo `.cst`.
- Documentación (`README.md` de cada dispositivo).

Ejemplos de convenciones:

- Señales generales:
  - `clk`, `rst_n`, `btn`, `led[5:0]`
- HC-SR04:
  - `hcsr04_trig`, `hcsr04_echo`
- Rotary encoder:
  - `enc_a`, `enc_b`, `enc_sw`
- Botones/switches:
  - `btn_a`, `btn_b`, `sw_mode`
- 7 segmentos:
  - `seg[6:0]`, `seg_dp`, `digit_en[3:0]`
- TM1638:
  - `tm_dio`, `tm_clk`, `tm_stb`
- LCD 16x2:
  - `lcd_rs`, `lcd_en`, `lcd_d[3:0]`

La meta es que, al ver el nombre de una señal en el código o en el `.cst`, sea fácil localizarla en el README del dispositivo correspondiente.

---

## 3. Estructura mínima de cada README de dispositivo

Cada carpeta de dispositivo en `2_2_Sensors` y `2_3_Actuators` debe incluir un `README.md` con, al menos:

1. **Propósito**  
   - Qué hace el dispositivo.  
   - Para qué se usa dentro del repositorio.

2. **Señales/pines lógicos**  
   - Lista de señales (por ejemplo, `hcsr04_trig`, `hcsr04_echo`).  
   - Referencia a `pinout.md` y al archivo `.cst` para los pines físicos.

3. **Notas de conexión (wiring)**  
   - Descripción básica de cómo se conecta a la Tang Nano 9K y al protoboard.  
   - Enlace a `2_4_Common` cuando aplique.

4. **Notas eléctricas básicas**  
   - Indicación explícita cuando el dispositivo utiliza 5 V.  
   - Advertencias sobre niveles de señal y necesidad de adaptación (por ejemplo, `ECHO` del HC-SR04).

5. **Relación con la teoría**  
   - Archivos de `1_2_Theory` recomendados para entender el funcionamiento del dispositivo.

6. **Relación con Examples / Activities / Labs**  
   - Lista de prácticas donde se utiliza (cuando ya estén definidas).  
   - Tipo de uso (ejemplo mínimo, actividad guiada, lab integrador).

---

## 4. Seguridad y reproducibilidad

- Marcar claramente cualquier caso en el que haya diferencia de voltaje:
  - 3.3 V (FPGA) ↔ 5 V (algunos módulos).

- Reglas mínimas:
  - No conectar salidas de 5 V directamente a entradas de la FPGA sin revisar previamente.
  - Mantener **GND común** en todos los montajes.
  - Documentar cualquier excepción o requisito especial en el README del dispositivo.

- Evitar montajes “implícitos”:
  - Siempre indicar en la documentación:
    - Qué pin de la FPGA va a qué pin del módulo.
    - Qué riel del protoboard se usa para VCC y GND.

---

## 5. Uso de `2_4_Common`

- `2_4_Common` se utiliza para centralizar:
  - Buenas prácticas de protoboard y cableado.
  - Esquemas genéricos reutilizables.
  - Notas sobre organización de rieles y GND común.

- Cuando un README de dispositivo mencione:
  - Organización del protoboard.
  - Recomendaciones de longitud de cables.
  - Criterios de distribución de VCC/GND.

  se puede referir a `2_4_Common/README.md` como referencia principal.

---

## 6. Extensión del repositorio

Cuando se agregue un nuevo dispositivo:

1. Crear su carpeta dentro de `2_2_Sensors` o `2_3_Actuators`.
2. Añadir:
   - `README.md` siguiendo la estructura propuesta.
   - `assets/` si se requieren diagramas o fotos.
3. Actualizar:
   - `pinout.md` y `tang-nano-9k.cst` si se usan pines nuevos.
   - Este archivo de convenciones si el nuevo dispositivo requiere reglas adicionales.

Estas convenciones buscan que el repositorio se mantenga:

- **Legible** para nuevas personas.
- **Reproducible** en laboratorio.
- **Extensible** para futuras generaciones y proyectos relacionados.
