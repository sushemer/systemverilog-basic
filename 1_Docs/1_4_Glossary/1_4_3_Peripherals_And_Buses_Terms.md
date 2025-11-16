# 1.4.3 Peripherals and buses terms

Términos relacionados con periféricos (sensores, actuadores) y buses de comunicación usados en el repositorio.

---

### GPIO (General-Purpose Input/Output)

Pines de propósito general que pueden configurarse como entrada o salida digital.  
En la FPGA se usan para conectar botones, LEDs, 7 segmentos, buzzer, etc.

---

### Bus

Conjunto de líneas (señales) que transmiten información entre módulos o entre la FPGA y un periférico.  
Puede ser:
- Paralelo (varios bits en paralelo, por ejemplo `led[7:0]`).
- Serial (bits enviados uno tras otro, como en SPI o I²C).

---

### ADC (Analog-to-Digital Converter)

Convertidor analógico–digital que transforma un voltaje analógico en un número digital.  
La FPGA lo usa para leer señales analógicas, como el valor de un potenciómetro.  
En este repositorio se utilizan ADC externos (MCP3008, ADS1115, ADC0832, etc.).

---

### PWM (Pulse Width Modulation)

Técnica que usa una señal digital de periodo fijo con ciclo de trabajo (duty cycle) variable para emular niveles analógicos.  
Se usa en este repositorio para controlar brillo de LEDs y posición de servos.

---

### Seven-segment display

Display formado por 7 LEDs dispuestos en forma de “8” (más punto decimal opcional).  
Se usan combinaciones de segmentos encendidos para representar dígitos y algunas letras.  
En el repo se utiliza para mostrar contadores, resultados y estados simples.

---

### LCD (Liquid Crystal Display) HD44780

Display de caracteres (típicamente 16x2 o 20x4) basado en el controlador HD44780 o compatibles.  
Permite mostrar texto (mensajes, valores numéricos, menús).  
Puede conectarse en modo paralelo (4/8 bits) o a través de un backpack I²C (por ejemplo, PCF8574).

---

### TM1638

Controlador/módulo que integra:

- Displays de 7 segmentos.
- Varias teclas.
- LEDs individuales.

Se comunica con la FPGA mediante un protocolo serial sencillo (CLK, DIO, STB).  
En este repositorio se usa para interfaces compactas de usuario (display + teclas + LEDs).

---

### PCF8574

Expansor de entradas/salidas de 8 bits vía I²C.  
Permite aumentar la cantidad de pines digitales disponibles usando solo dos líneas (SCL, SDA).  
Se utiliza, entre otros, para controlar LCDs HD44780 mediante un backpack I²C.

---

### HC-SR04

Sensor ultrasónico de distancia.  
Usa un pulso en `TRIG` para disparar la medición y devuelve un pulso en `ECHO` cuya duración es proporcional a la distancia medida.  
En la FPGA se mide el ancho del pulso de `ECHO` con contadores.

---

### Servo (por ejemplo, SG90)

Actuador rotacional que se posiciona según el ancho de un pulso PWM de periodo fijo (~20 ms).  
En el repo se controla con módulos de PWM diseñados para generar los pulsos de 1–2 ms correspondientes a ángulos como 0°, 90°, 180°.

---

### Potentiometer

Resistencia variable con tres terminales que funciona como divisor de voltaje.  
Conectado a un ADC permite obtener un valor digital ajustable (por ejemplo, para controlar brillo, posición, umbrales, etc.).

---

### Buzzer (active / passive)

Dispositivo que produce sonido:

- **Active buzzer**: suena al aplicar un nivel lógico estable (internamente genera la frecuencia).
- **Passive buzzer**: requiere una señal PWM a cierta frecuencia para producir tono.  

En este repositorio, se enlaza con módulos de PWM o divisores de frecuencia para generar notas simples o melodías básicas.

---

### SPI (Serial Peripheral Interface)

Bus serial síncrono con líneas típicas:

- `SCK` (clock),
- `MOSI` (Master Out, Slave In),
- `MISO` (Master In, Slave Out),
- `CS` / `SS` (Chip Select).

La FPGA actúa como master y controla la comunicación con dispositivos como algunos ADCs o controladores externos.

---

### I²C (Inter-Integrated Circuit)

Bus serial de dos hilos:

- `SCL` (clock),
- `SDA` (datos bidireccionales).

Permite conectar múltiples dispositivos (con direcciones) en las mismas líneas.  
Se usa con expansores (PCF8574), algunos ADCs y módulos de LCD con backpack I²C.

---

### UART (Universal Asynchronous Receiver/Transmitter)

Interfaz serie asíncrona (TX/RX) usada para comunicación punto a punto, por ejemplo con un PC.  
Aunque no es el foco principal de este repositorio, es un periférico típico en proyectos con FPGA y puede aparecer en extensiones futuras.

---

### Debounce (debouncing)

Técnica para eliminar rebotes mecánicos de botones o switches, filtrando cambios muy rápidos.  
En el contexto de periféricos, se aplica a entradas humanas (botones del usuario).

---

### Edge detection (for inputs)

Detección de flancos (subida/bajada) en señales provenientes del exterior (botones, ECHO, etc.) para generar pulsos de un ciclo.  
Se utiliza en integración con periféricos para registrar eventos únicos a partir de señales más largas.

---

### Pull-up / pull-down resistor

Resistencias usadas para fijar el valor de una señal cuando no está siendo activamente conducida.  

- **Pull-up**: mantiene la señal en 1 lógico por defecto.
- **Pull-down**: mantiene la señal en 0 lógico por defecto.

En botones y buses (como I²C) ayudan a asegurar niveles definidos y evitar entradas flotantes.

---

### Level shifter / level shifting

Circuito para adaptar niveles de voltaje entre dispositivos que trabajan a tensiones distintas (por ejemplo, 5 V ↔ 3.3 V).  
En este repositorio es importante para conectar módulos como el HC-SR04 (salida ECHO a 5 V) a la FPGA de 3.3 V sin dañarla.
