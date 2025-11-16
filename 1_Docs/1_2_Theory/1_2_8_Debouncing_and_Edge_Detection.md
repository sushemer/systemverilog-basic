
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

```systemverilog
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