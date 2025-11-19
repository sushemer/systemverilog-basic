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

    2_devices/
     └─ 2_1_Boards/
         └─ 2_1_1_Tang_Nano_9K/
             ├─ docs/
             │   ├─ pinout.md
             │   ├─ power_notes.md
             │   └─ programming.md
             └─ constr/
                 └─ tang-nano-9k.cst

### 2.1.1 Tang Nano 9K

Placa FPGA principal utilizada en todo el repositorio.

- **Propósito**  
  Plataforma base para todas las activities, labs e implementations.  
  Todos los ejemplos de SystemVerilog están pensados para esta placa y este archivo de constraints.

- **Archivos clave**
  - `docs/pinout.md`  
    Resumen de pines relevantes (reloj, GPIO, LCD, TM1638, pines de expansión, etc.).
  - `docs/power_notes.md`  
    Notas de alimentación, niveles de voltaje y consideraciones de seguridad.
  - `docs/programming.md`  
    Cómo programar la Tang Nano 9K (Gowin Programmer, scripts, modo de conexión).
  - `constr/tang-nano-9k.cst`  
    Archivo de constraints de Gowin.  
    Es la **fuente única de verdad** para el mapeo:
    - Señales lógicas (`clock`, `gpio`, `tm1638_*`, `lcd_*`, etc.).
    - A pines físicos de la FPGA.

> Recomendación: antes de cambiar wiring en protoboard o asignaciones de pines, revisar siempre este `.cst`.

---

## 2.2 Sensors · Entradas

Los sensores se organizan en subcarpetas dentro de:

    2_devices/
     └─ 2_2_Sensors/
         ├─ 2_2_X_Sensor_A/
         ├─ 2_2_Y_Sensor_B/
         └─ ...

Cada sensor debería contar, idealmente, con:

- Un archivo `README.md` o similar describiendo:
  - Propósito del sensor.
  - Pines relevantes (VCC, GND, señales de datos).
  - Tipo de interfaz (digital simple, PWM, SPI, I²C, trigger/echo, etc.).
- Referencias a su **datasheet** o a documentación externa.
- Esquemas simples o fotos del wiring (cuando sea relevante).

Sensores previstos en este repositorio (ejemplos):

- **HC-SR04 (ultrasonic distance)**  
  - Señales principales: `TRIG`, `ECHO`, `VCC`, `GND`.  
  - Consideraciones de nivel: `ECHO` suele ser 5 V y requiere adaptación a 3.3 V.
- **Encoder rotatorio (KY-040 o similar)**  
  - Señales típicas: `CLK`, `DT`, `SW`, `VCC`, `GND`.  
  - Usado para navegación por menús o ajuste de valores.
- **Potenciómetro + ADC externo**  
  - Potenciómetro como divisor de voltaje hacia un ADC.  
  - ADC comunicándose por SPI o I²C con la FPGA.

Si se considera necesario, se pueden añadir imágenes de wiring en una subcarpeta `Mult/` dentro de cada sensor (por ejemplo, `2_2_1_HC_SR04/Mult/`).

---

## 2.3 Actuators · Salidas

Los actuadores se organizan en:

    2_devices/
     └─ 2_3_Actuators/
         ├─ 2_3_X_TM1638/
         ├─ 2_3_Y_LCD_480x272/
         └─ ...

Ejemplos típicos:

- **TM1638** (módulo con 7 segmentos, LEDs y teclas)
  - Señales principales: `VCC`, `GND`, `STB`, `CLK`, `DIO`.
  - Se utiliza como salida (7 segmentos, LEDs) y como entrada (teclas).
- **LCD 480×272** (4.3")  
  - Conexiones de datos, sincronía y backlight.
  - Utilizada como salida gráfica principal en algunos labs/implementations.
- **Buzzer / altavoz sencillo** (si aplica en ejemplos de sonido).
- **Servos o motores** (si se añaden ejercicios de PWM más adelante).

Cada subcarpeta de actuador debería documentar:

- Tensiones de trabajo.
- Conectores y numeración de pines.
- Cualquier nota especial de protección (resistencias, transistores, etc.).

Al igual que con los sensores, se recomienda una subcarpeta `Mult/` para fotos de conexión cuando sean útiles.

---

## 2.4 Protoboard y cableado

Algunos dispositivos se conectan mediante protoboard.  
Por ello, esta sección (o subcarpeta asociada) puede recoger:

- Recomendaciones de uso de protoboard:
  - Distribución de rieles de alimentación.
  - Buenas prácticas para separar señales de potencia y de datos.
- Esquemas o fotos de ejemplos típicos:
  - Tang Nano 9K en una base + protoboard con potenciómetro y HC-SR04.
  - Distribución de 3.3 V / 5 V, según el caso.

Siempre que se añadan imágenes, se sugiere usar un patrón similar a:

    2_devices/
     └─ 2_4_Breadboard/
         └─ Mult/
             ├─ base_wiring_top.jpg
             └─ base_wiring_side.jpg

---



