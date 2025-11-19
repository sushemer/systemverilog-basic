# Debouncing and edge detection

Este documento aborda dos temas que aparecen en casi todos los diseños con botones y señales lentas:

- **Debouncing** (eliminar rebotes).
- **Detección de flancos** (`edge detection`).

---

## Problema del rebote (bouncing)

Cuando se presiona un botón físico:

- El contacto no pasa de 0 a 1 de forma limpia.
- Durante unos milisegundos puede “rebotar”:
  0 → 1 → 0 → 1 → … antes de estabilizarse.

Si la FPGA ve estos rebotes:

- Puede interpretar varias pulsaciones en lugar de una.
- Las máquinas de estados pueden avanzar más de un paso.
- Los contadores pueden incrementar varias veces por un solo toque.

---

## ¿Qué es el debouncing?

**Debouncing** es el proceso de filtrar esos rebotes para obtener una señal más estable:

- Entrada “sucia” del botón → filtro de tiempo → señal “limpia”.
- Una transición real de 0→1 o 1→0 se reconoce solo cuando la señal permanece estable cierto tiempo.

En FPGA, el debouncing suele implementarse:

- Con contadores que verifican estabilidad.
- Con muestreo periódico de la entrada.

Ejemplo conceptual (debouncing por conteo de estabilidad):
  ```sv
    module button_debouncer (
        input  logic clk,
        input  logic rst_n,
        input  logic btn_raw,     // señal con rebotes
        output logic btn_clean    // señal filtrada
    );

        logic [15:0] counter;
        logic        btn_sync;

        // Sincronización simple a clk (recomendable cuando el botón viene del mundo exterior)
        always_ff @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                btn_sync <= 1'b0;
            else
                btn_sync <= btn_raw;
        end

        // Debouncing: contar cuánto tiempo se mantiene el valor actual
        always_ff @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                counter   <= '0;
                btn_clean <= 1'b0;
            end else begin
                if (btn_clean == btn_sync) begin
                    // Sin cambio aparente → reiniciar contador
                    counter <= '0;
                end else begin
                    // Posible cambio → contar
                    counter <= counter + 1;

                    // Si se mantiene el nuevo valor el tiempo suficiente, aceptarlo
                    if (&counter) begin
                        btn_clean <= btn_sync;
                        counter   <= '0;
                    end
                end
            end
        end

    endmodule
  ```
---

## Detección de flancos (edge detection)

Una vez que se tiene una señal limpia (`btn_clean`), muchas veces no se desea trabajar con el “nivel” (1 mientras el botón está presionado), sino con un **pulso corto** cuando se produce el cambio:

- **Flanco de subida** (rising edge): 0 → 1.
- **Flanco de bajada** (falling edge): 1 → 0.

Ejemplo típico: se quiere que un contador incremente **una sola vez** en cada pulsación, aunque el usuario mantenga el botón presionado un tiempo.

Idea básica:

- Guardar el valor anterior de la señal limpia.
- Comparar el valor actual con el anterior.

Ejemplo:
  ```sv
    module edge_detector (
        input  logic clk,
        input  logic rst_n,
        input  logic sig_in,      // señal limpia (por ejemplo, btn_clean)
        output logic rise_edge,   // pulso 1 ciclo en flanco 0→1
        output logic fall_edge    // pulso 1 ciclo en flanco 1→0
    );

        logic sig_prev;

        always_ff @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                sig_prev <= 1'b0;
            else
                sig_prev <= sig_in;
        end

        // Flanco de subida: antes 0, ahora 1
        assign rise_edge = (sig_in == 1'b1) && (sig_prev == 1'b0);

        // Flanco de bajada: antes 1, ahora 0
        assign fall_edge = (sig_in == 1'b0) && (sig_prev == 1'b1);

    endmodule
  ```
En muchos labs solo se necesita el flanco de subida (`rise_edge`), ya que se interpreta como “evento” o “click”.

---

## Relación con los módulos comunes del repositorio

En este proyecto se utilizan módulos reutilizables que combinan:

- **Sincronización** (para señales externas como botones o sensores).
- **Debounce** (para limpiarlas).
- **Detección de flancos** (para generar pulsos).

Ejemplos típicos:

- `sync_and_debounce`: trata un vector de entradas (por ejemplo, varios botones) y entrega versiones limpias y sincronizadas.
- `sync_and_debounce_one`: versión simple para una sola señal.

Estas salidas se usan luego para:

- Avanzar máquinas de estados (FSM).
- Iniciar o detener contadores.
- Cambiar modos de operación (por ejemplo, seleccionar qué sensor se muestra).

---

## Resumen

- Los botones físicos generan rebotes que pueden causar múltiples conteos no deseados.
- El **debouncing** filtra esos rebotes mediante estabilidad en el tiempo.
- La **detección de flancos** convierte cambios de nivel en pulsos de un solo ciclo.
- En este repositorio se encapsulan estos patrones en módulos como `sync_and_debounce`, que se usan en activities, labs e implementations para tener entradas confiables.
