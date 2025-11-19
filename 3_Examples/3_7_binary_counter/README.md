# 3.7 Binary counter (contador binario)

Este ejemplo implementa un **contador binario** usando el reloj de la Tang Nano 9K
y muestra sus bits más significativos en los LEDs. Es una forma clásica de:

- Verificar que el reloj y el reset están funcionando.
- Observar cómo los bits de un contador binario cambian a diferentes frecuencias.
- Practicar con lógica **secuencial** (flip‐flops, `always_ff`, reset asíncrono).

Además, se deja una **variante opcional** donde el contador sólo avanza
cuando se presiona (y suelta) alguna tecla.

---

## Objetivo

Al finalizar este ejemplo, la persona usuaria podrá:

- Entender la diferencia entre **lógica combinacional** y **secuencial**.
- Implementar un contador binario sencillo en SystemVerilog.
- Relacionar la frecuencia de reloj con la velocidad de parpadeo de los LEDs.
- Extender el diseño a variantes controladas por teclas.

---

## Señales principales y mapeo

### Entradas

- `clock`  
  Reloj principal de la placa (≈ 27 MHz en esta configuración).

- `reset`  
  Señal de reset asíncrono (activa en alto).  
  Su origen físico depende del `board_specific_top.sv` y del archivo `.cst` de la placa
  (normalmente un botón de reset).

- `key[7:0]`  
  Entradas de teclas/botones.  
  **En el ejemplo básico de contador libre no se usan.**  
  Se utilizan sólo en la variante opcional (counter controlado por teclas).

### Salidas

- `led[7:0]`  
  Muestran los bits más significativos del contador:

  ```sv
  assign led = cnt[W_CNT-1 -: 8];
  ```