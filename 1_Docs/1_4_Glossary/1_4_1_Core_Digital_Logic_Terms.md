# 1.4.1 Core digital logic terms

Términos básicos de lógica digital y HDL que aparecen con frecuencia en la teoría, ejemplos y labs.

---

### HDL (Hardware Description Language)

Lenguaje para describir hardware digital (módulos, registros, FSM, etc.) en lugar de escribir instrucciones secuenciales como en un programa de software.  
En este repositorio se usa principalmente Verilog/SystemVerilog.

---

### RTL (Register Transfer Level)

Nivel de descripción donde el diseño se expresa en términos de registros, operaciones sobre datos y transferencias entre registros controladas por reloj.  
La mayoría de los ejemplos y labs de este repositorio están en estilo RTL.

---

### Module

Unidad básica de diseño en Verilog/SystemVerilog.  
Define entradas, salidas y la lógica interna que conecta señales y submódulos.  
En este repositorio, cada ejemplo o bloque suele estar encapsulado en uno o varios `module`.

---

### Port

Conexión externa de un módulo: `input`, `output` o `inout`.  
Permite que un módulo reciba señales de otros módulos o del mundo físico (botones, LEDs, etc.).  
La organización clara de puertos facilita la reutilización e integración de bloques.

---

### Signal / net

Nombre genérico para una conexión interna o externa en el diseño (en este repositorio se usan típicamente tipos `logic`).  
Puede representar un solo bit o un vector de múltiples bits (por ejemplo, `led[7:0]`).

---

### Combinational logic

Lógica en la que las salidas dependen solo de las **entradas actuales**, sin memoria interna explícita.  
Se describe con `assign` o `always_comb`.  
Ejemplos: compuertas, comparadores, decodificadores, multiplexores.

---

### Sequential logic

Lógica en la que las salidas dependen de las entradas actuales **y del estado previo**, almacenado en registros.  
Se describe con `always_ff @(posedge clk ...)`.  
Ejemplos: contadores, registros de desplazamiento, FSM.

---

### Register

Elemento de memoria que almacena un valor digital entre flancos de reloj.  
En SystemVerilog se modela con señales actualizadas en bloques `always_ff`.  
Se usa para guardar estados, contadores, datos intermedios, etc.

---

### Flip-flop (FF)

Bloque básico de memoria secuencial que almacena un bit y se actualiza típicamente en el flanco de reloj.  
Un registro de N bits se puede considerar como un conjunto de N flip-flops.

---

### Clock (clk)

Señal periódica que marca el ritmo del sistema digital.  
En cada flanco activo del reloj se actualizan registros, contadores y FSM.  
En la Tang Nano 9K se conecta a un pin dedicado y se distribuye internamente.

---

### Reset (rst / rst_n)

Señal usada para llevar el diseño a un estado inicial conocido.  
Puede ser:
- Activo alto (`rst = 1` → reset).
- Activo bajo (`rst_n = 0` → reset, muy usado en este repo).  

Se maneja dentro de bloques secuenciales (`always_ff`) para inicializar registros y FSM.

---

### Edge (rising / falling edge)

Cambio puntual en una señal:

- **Rising edge**: transición de 0 → 1.
- **Falling edge**: transición de 1 → 0.

Los bloques secuenciales suelen dispararse en el flanco ascendente del reloj (`posedge clk`).  
En entrada de usuario (botones, ECHO de HC-SR04) se pueden detectar flancos para generar pulsos de un ciclo.

---

### Counter

Circuito secuencial que incrementa (o decrementa) su valor en cada flanco de reloj, según cierta lógica.  
Se usa para dividir frecuencias, medir tiempos, recorrer estados, etc.  
Aparece en ejemplos como `binary_counter` y labs de parpadeo de LED o temporización.

---

### Divider (clock divider)

Uso de un contador para derivar una señal más lenta a partir de un reloj rápido.  
Ejemplo: a partir de 27 MHz generar una señal de unos pocos Hz para parpadear un LED o multiplexar displays.  
Se explica en detalle en `1_2_6_Timing_and_Dividers.md`.

---

### Duty cycle

Porcentaje de tiempo que una señal PWM permanece en nivel alto durante un periodo.  
Se usa para controlar brillo de LEDs o posición de servos.  
Aparece en los ejemplos y labs relacionados con `pwm_led_dimmer` y `servo_pwm_positions`.

---

### FSM (Finite State Machine)

Máquina de estados finitos.  
Modelo donde el sistema se encuentra en un estado actual y pasa a otros estados según entradas y lógica definida.  
Se usa para secuencias (semáforos, menús, protocolos básicos, etc.).  
Se describe usando `typedef enum` y bloques `always_ff` + `always_comb`.

---

### State

Uno de los posibles “modos” o “situaciones” en las que puede estar una FSM (por ejemplo, `IDLE`, `MEASURE`, `DISPLAY`).  
Se representa con un valor de un tipo enumerado (`enum`) y se guarda en un registro.

---

### Debounce (debouncing)

Técnica para filtrar los rebotes eléctricos de un botón o interruptor, evitando múltiples pulsos falsos.  
En la FPGA se suele implementar con contadores y comparaciones para exigir estabilidad durante cierto tiempo.

---

### Edge detection

Lógica que transforma una transición (por ejemplo, 0→1) en un pulso de un ciclo de reloj.  
Se usa para detectar “pulsaciones” o eventos únicos a partir de señales más largas, normalmente ya debounced.

---

### Sample / sampling

Proceso de tomar el valor de una señal en un instante específico (por ejemplo, cada flanco de reloj).  
En este repositorio aparece al leer botones, señales de ECHO o datos provenientes de buses seriales.

---

### Latency

Tiempo que transcurre entre una entrada y la respuesta observable a la salida, medido en ciclos de reloj o unidades de tiempo.  
En diseños sencillos se suele ignorar, pero es útil entender que algunas operaciones toman varios ciclos (por ejemplo, FSM con varios estados).
