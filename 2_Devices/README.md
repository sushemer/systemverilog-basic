# 2. Devices · Hardware base

La carpeta `2_devices` reúne toda la información relacionada con el **hardware físico** utilizado en el repositorio:

- La placa **FPGA Tang Nano 9K**.
- Los **sensores** (entradas).
- Los **actuadores** (salidas).
- Notas comunes de **protoboard y cableado**.
- Convenciones para mantener el hardware documentado y reproducible.

El objetivo es que, antes de cablear algo o modificar constraints, sea posible:

- Ver **qué dispositivos** se utilizan.
- Entender **cómo se conectan** a la Tang Nano 9K.
- Adoptar las mismas **convenciones de nombres y wiring** en ejemplos, actividades y laboratorios.

---

## 2.1 Boards · Placas

Ruta principal:

```
2_devices/
 └─ 2_1_Boards/
     └─ 2_1_1_Tang_Nano_9K/
         ├─ docs/
         │   ├─ pinout.md
         │   ├─ power_notes.md
         │   └─ programming.md
         └─ constr/
             └─ tang-nano-9k.cst
```