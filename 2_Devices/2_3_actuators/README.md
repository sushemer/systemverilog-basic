# 2. Devices · Hardware del proyecto

La carpeta `2_devices` reúne toda la información relacionada con el **hardware** utilizado en el repositorio:

- La placa principal (**Tang Nano 9K**).
- Los **sensores** (entradas).
- Los **actuadores** (salidas).
- Notas comunes de **protoboard y cableado**.
- **Convenciones** para mantener la documentación y los constraints consistentes.

El objetivo es que cualquier persona pueda:

- Saber **qué dispositivos** se usan.
- Entender **cómo se conectan** a la Tang Nano 9K.
- Encontrar rápidamente el **pinout**, los **constraints** y las **notas de wiring** necesarias para Examples, Activities, Labs e Implementation.

---

## Estructura de `2_devices`

```
2_devices/
 ├─ 2_1_Boards/
 │   └─ 2_1_1_Tang_Nano_9K/
 │       ├─ docs/
 │       │   ├─ README.md
 │       │   ├─ pinout.md
 │       │   ├─ power_notes.md
 │       │   └─ programming.md
 │       └─ constr/
 │           └─ tang-nano-9k.cst
 ├─ 2_2_Sensors/
 │   ├─ 2_2_1_HC_SR04/
 │   ├─ 2_2_2_Rotary_Encoder/
 │   └─ 2_2_3_Buttons_Switches/
 ├─ 2_3_Actuators/
 │   ├─ 2_3_1_Seven_Segment/
 │   ├─ 2_3_2_TM1638/
 │   └─ 2_3_3_LCD_16x2/
 ├─ 2_4_Common/
 │   └─ (protoboard, wiring y notas generales)
 └─ 2_5_Conventions/
     └─ (convenciones para dispositivos y constraints)
```