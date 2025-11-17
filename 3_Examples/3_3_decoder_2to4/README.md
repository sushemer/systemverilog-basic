# 3.3 Decoder 2→4 (decodificador binario 2 a 4 líneas)

Este ejemplo muestra un **decoder 2→4** (decodificador binario de 2 bits a 4 salidas)
implementado de varias formas en SystemVerilog y permite ver en la Tang Nano 9K
cómo una entrada de 2 bits selecciona **exactamente una** de las 4 salidas (one-hot).

La idea es:

- Usar una entrada binaria de 2 bits `in[1:0]` formada por `A` y `B`.
- Generar 4 salidas `Y[3:0]` donde solo una está en `1` según el valor de `in`:
  - `in = 00` → `Y = 0001`
  - `in = 01` → `Y = 0010`
  - `in = 10` → `Y = 0100`
  - `in = 11` → `Y = 1000`
- Implementar el mismo decoder 2→4 de **cuatro maneras** distintas:
  - Con AND/NOT (ecuaciones lógicas “tediosas”).
  - Con `case`.
  - Con desplazamiento (`shift`).
  - Con indexado de bits.

---

## Objetivo

Al finalizar el ejemplo, la persona usuaria podrá:

- Relacionar entradas físicas (`key[1:0]`) con una palabra binaria `in[1:0]`.
- Entender el comportamiento de un **decoder 2→4** (salida one-hot).
- Implementar un decoder combinacional de diferentes maneras en SystemVerilog.
- Observar en la placa cómo se activa exactamente una salida para cada valor de entrada.

---

## Archivos del ejemplo

En esta carpeta se utilizan, al menos:

- `hackathon_top.sv`  
  Módulo tope sintetizable para la Tang Nano 9K (configuración  
  `tang_nano_9k_lcd_480_272_tm1638_hackathon`).  
  Contiene:
  - Declaración de puertos estándar (clock, reset, `key[7:0]`, `led[7:0]`, etc.).
  - Cuatro implementaciones internas de un decoder 2→4:
    - Con AND/NOT.
    - Con `case`.
    - Con desplazamiento (`<<`).
    - Con indexado (`dec3[in] = 1`).
  - Conexión de la versión “canónica” (`dec3`) a los LEDs.

- `README.md`  
  Este archivo, con la descripción del ejemplo.

Opcionalmente (si los usas en el repo):

- Scripts de automatización:
  - `01_clean.bash`
  - `02_simulate_rtl.bash`
  - `03_synthesize_for_fpga.bash`
  - `04_configure_fpga.bash`

---

## Señales y pines

En el código SystemVerilog se usan:

- `key[7:0]` como entradas digitales desde la tarjeta.
- `led[7:0]` como salidas hacia los LEDs.

Para este ejemplo, el mapeo lógico es:

- **Entrada del decoder:**

  - `in[1:0]` = `{ key[1], key[0] }`

- **Salidas visibles en LEDs:**

  - `LED[0]` → bit 0 de `in` (LSB)
  - `LED[1]` → bit 1 de `in` (MSB)

  Así, `LED[1:0]` muestran el valor binario actual de `in`.

  - `LED[5:2]` → bits `dec3[3:0]`  
    (salida one-hot del decoder implementado por indexado)
  - `LED[7:6]` → no se usan (se quedan en 0)

De este modo, puedes ver:

- En `LED[1:0]` el valor binario de la entrada.
- En `LED[5:2]` qué línea del decoder está activa (one-hot).

---

## Flujo sugerido de uso

1. **Revisar teoría asociada**

   Antes de este ejemplo, se recomienda repasar en la parte teórica:

   - Módulos y puertos (cómo declarar entradas/salidas).
   - Diferencia entre lógica combinacional y secuencial.
   - Concepto de **decoder** o **demultiplexor** (one-hot outputs).