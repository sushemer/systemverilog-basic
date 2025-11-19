# Lab 5.1 – counter_hello_world

**Nivel:** Básico  
**Board:** Tang Nano 9K (configuración `tang_nano_9k_lcd_480_272_tm1638_hackathon`)  
**Archivo principal:** `hackathon_top.sv`

---

## 1. Objetivo

Hacer parpadear un LED de la placa (~1 Hz) usando:

- Un **contador** que divide el reloj de la FPGA.
- Un **registro** actualizado en `always_ff @(posedge clk)`.
- Un **mapeo simple** desde lógica interna a un pin físico (`led[0]`).

Al final del lab, se busca que la persona que lo realiza se sienta cómoda con:

- Crear un módulo simple con entradas y salidas.
- Usar un registro como divisor de frecuencia.
- Entender cómo un bit alto del contador se ve como un parpadeo visible.

---

## 2. Requisitos previos

- Tener instalado:
  - Gowin IDE + toolchain (como en el resto del repositorio).
  - Scripts `03_synthesize_for_fpga.bash` funcionando.
- Conocer lo básico de:
  - Tipos `logic`, `always_ff`, `always_comb`.
  - Estructura de `hackathon_top` en otros ejemplos.

---

## 3. Pasos sugeridos

### Paso 1 – Explorar la plantilla

1. Abrir `5_Labs/5_1_counter_hello_world/hackathon_top.sv`.
2. Localizar:
   - Las asignaciones que apagan `abcdefgh`, `digit`, `red`, `green`, `blue`.
   - La sección del **divisor de frecuencia** (`W_DIV` y `div_cnt`).
   - El bloque `always_comb` donde se asigna `led`.

La idea es identificar dónde se encuentra el contador y dónde se conecta el LED antes de modificar nada.

---

### Paso 2 – Implementar el contador

En el archivo se encuentra algo similar a:

    logic [W_DIV-1:0] div_cnt;

    always_ff @(posedge clock or posedge reset)
    begin
        if (reset)
        begin
            div_cnt <= '0;
        end
        else
        begin
            // TODO: incrementar el contador
            // div_cnt <= ...;
        end
    end

La tarea consiste en que el contador **avance de forma continua** mientras `reset` sea 0.  
Una implementación típica es:

- Después del `else`, sumar 1 al registro:

    always_ff @(posedge clock or posedge reset)
    begin
        if (reset)
        begin
            div_cnt <= '0;
        end
        else
        begin
            div_cnt <= div_cnt + 1'b1;
        end
    end

Con esto, `div_cnt` se comporta como un contador binario de `W_DIV` bits que se incrementa en cada flanco positivo de `clock`.

---

### Paso 3 – Elegir el bit que producirá el parpadeo

Cada bit de `div_cnt` cambia a una frecuencia distinta:

- El bit 0 cambia a la misma frecuencia que el reloj (`clock`).
- El bit 1 cambia a la mitad.
- El bit 2 a la cuarta parte.
- …
- En general, el bit `k` cambia a `clock / (2^(k+1))`.

Para generar un parpadeo cercano a 1 Hz, se elige un bit “alto” del contador (dependerá del valor de `W_DIV` y de la frecuencia real de `clock` de la placa).

Ejemplo típico:

- Si `W_DIV = 25`, un buen candidato puede ser `div_cnt[24]`.

Se puede declarar una señal intermedia:

    logic blink;

    assign blink = div_cnt[W_DIV-1];  // por ejemplo, el bit más alto

O, si se prefiere, un índice concreto:

    localparam int BLINK_BIT = W_DIV-1;
    logic blink;

    assign blink = div_cnt[BLINK_BIT];

Ese bit será el que se conecte después al LED.

---

### Paso 4 – Mapear el bit de parpadeo a `led[0]`

En la plantilla suele haber un bloque combinacional para los LEDs:

    always_comb
    begin
        led = 8'b0000_0000;
        // TODO: conectar algo a led[0]
    end

La idea es:

- Mantener apagados los demás LEDs.
- Conectar `blink` a `led[0]`.

Por ejemplo:

    always_comb
    begin
        led      = 8'b0000_0000;
        led[0]   = blink;      // LED0 parpadea con el bit del contador
        // led[7:1] se quedan en 0
    end

Con esto, el pin físico asociado a `led[0]` en la placa mostrará el parpadeo.

---

### Paso 5 – Sintetizar, programar y observar

1. Ejecutar el script de síntesis/programación del repo desde la raíz (o desde la carpeta correspondiente), por ejemplo:

   - `./03_synthesize_for_fpga.bash 5_Labs/5_1_counter_hello_world`

   (El comando exacto depende de cómo estén organizados los scripts en el entorno local.)

2. Esperar a que se genere el bitstream y se programe la Tang Nano 9K.

3. Una vez cargado el diseño:

   - Verificar que `led[0]` parpadea.
   - Si parpadea **demasiado rápido** (apenas se distingue el encendido y apagado), se puede:
     - Aumentar `W_DIV` (más bits de contador).
     - Elegir un bit más alto (`div_cnt[k]` con `k` mayor).
   - Si parpadea **demasiado lento**, hacer lo contrario:
     - Reducir `W_DIV`.
     - Elegir un bit más bajo.

La meta es encontrar un parpadeo cómodo a la vista (~1–2 Hz).

---

## 4. Pruebas y extensiones

### 4.1 Verificaciones básicas

- Confirmar que al activar `reset`:
  - El contador `div_cnt` vuelve a 0.
  - El LED vuelve a un estado coherente (por ejemplo, apagado si el bit elegido parte de 0).
- Verificar que el parpadeo es **estable** y no errático.

### 4.2 Extensiones sugeridas

Cuando la versión básica funcione, se pueden realizar pequeñas mejoras:

1. **Varios LEDs con diferentes frecuencias**

   - Conectar `led[1]` a otro bit de `div_cnt` (por ejemplo `div_cnt[W_DIV-2]`).
   - Conectar `led[2]` a otro bit más bajo.
   - Se observarán distintos parpadeos y patrones.

2. **Invertir el parpadeo**

   - Usar `~blink` en lugar de `blink` para que el LED esté encendido cuando el bit es 0 y apagado cuando es 1.

3. **Control simple de velocidad con teclas**

   - Usar uno o dos bits de `key` para seleccionar entre distintos bits del contador (por ejemplo, un pequeño multiplexor que elija entre `div_cnt[20]`, `div_cnt[21]`, `div_cnt[22]`).
   - De esta forma se suaviza la transición hacia otros labs donde se usan teclas para cambiar modos.

4. **Preparar el código para labs posteriores**

   - Mantener clara la separación entre:
     - Lógica de **división de reloj**.
     - Lógica de **salida a LEDs**.
   - Esto facilita reutilizar la misma estructura en labs posteriores (contadores más complejos, registros de desplazamiento, etc.).

---

## 5. Resumen

En este lab se implementa el equivalente a un “hola mundo” para FPGAs:

- Un contador divide el reloj rápido de la placa.
- Un bit de ese contador se conecte a un LED.
- El resultado visible es un **LED parpadeando**, demostrando:

  - Que el reloj está funcionando.
  - Que el flujo de síntesis y programación está correcto.
  - Que se comprende la relación entre frecuencia de reloj, contadores y señales visibles.

Este patrón se reutilizará en muchos de los ejemplos y labs posteriores, como base para animaciones, divisores de frecuencia, temporizadores y lógica más compleja.
