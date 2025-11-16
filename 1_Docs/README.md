# 1. Docs · Documentación y ruta de lectura

La carpeta `1_docs` contiene la **documentación central** del repositorio.  
Su función principal es:

- Explicar el contexto y la forma de trabajo.
- Presentar la teoría mínima necesaria, de forma aplicada.
- Guiar la instalación de herramientas.
- Unificar términos, siglas y referencias externas.

El objetivo no es reemplazar libros ni documentación oficial, sino ofrecer el **mínimo suficiente** para poder seguir los ejemplos, actividades, laboratorios y mini-proyectos del repositorio.

---

## Estructura de `1_docs`

La carpeta se organiza en los siguientes subdirectorios:

- `1_1_Overview/`  
  - Panorama general de la documentación.  
  - Relación entre Docs, Devices, Examples, Activities, Labs e Implementation.  
  - Flujo recomendado de uso del repositorio.

- `1_2_Theory/`  
  - Teoría breve y aplicada, dividida en archivos cortos por tema, por ejemplo:
    - `modules_and_ports.md`
    - `combinational_vs_sequential.md`
    - `registers_and_clock.md`
    - `finite_state_machines.md`
    - `timing_and_dividers.md`
    - `pwm_basics.md`
    - `debouncing_and_edge_detection.md`
    - `buses_overview.md`
    - `seven_segment_basics.md`
    - `lcd_hd44780_basics.md`
    - `ultrasonic_hcsr04_basics.md`
  - Cada archivo incluye:
    - Explicación breve.
    - Uno o pocos diagramas o ejemplos.
    - Enlaces a Examples, Activities y Labs relacionados.

- `1_3_Install/`  
  - Guías para instalar y configurar el entorno de trabajo.
  - Subcarpetas sugeridas:
    - `1_3_1_Windows/`
    - `1_3_2_Linux/`
  - Temas típicos:
    - Instalación de Gowin EDA (versión recomendada).
    - Controladores/Drivers necesarios.
    - Notas sobre simuladores opcionales (Icarus, Verilator, etc., si se utilizan).
    - Pruebas básicas de funcionamiento (smoke test).

- `1_4_Glosario/`  
  - Definiciones breves de términos usados en el repositorio:
    - HDL, FPGA, módulo, instancia, clock, reset, debounce, FSM, etc.
  - Referencias a periféricos: HC-SR04, TM1638, LCD, servo, ADC, entre otros.
  - El objetivo es servir como **punto de consulta rápido**, no como enciclopedia.

- `1_5_Reference/`  
  - Índice de materiales más extensos:
    - Apuntes o manuales en PDF (por ejemplo, materiales de cursos previos).
    - Repositorios externos relevantes.
  - Cada entrada debe incluir:
    - Nombre o título corto.
    - Una línea sobre “para qué sirve”.
    - Enlace al recurso (URL o ruta interna en el repositorio).

---

## Cómo usar esta carpeta

Se recomienda el siguiente flujo al trabajar con `1_docs`:

1. **Leer primero** `1_1_Overview/`  
   Para entender el contexto, la filosofía del repositorio y cómo se relaciona la documentación con el resto de las carpetas.

2. **Consultar teoría a demanda** en `1_2_Theory/`  
   - Antes o durante un Example, Activity o Lab.  
   - Solo lo necesario para el tema en curso (por ejemplo, FSM o PWM).

3. **Seguir las guías de instalación** en `1_3_Install/`  
   - Cuando se configura el entorno por primera vez.  
   - En caso de reinstalar o migrar de Windows a Linux (o viceversa).

4. **Usar el glosario** de `1_4_Glosario/`  
   - Cuando aparezca un término nuevo o una sigla desconocida.  
   - Como apoyo para elaborar reportes, presentaciones o documentación adicional.

5. **Revisar referencias** en `1_5_Reference/`  
   - Para profundizar en un tema específico.  
   - Para conocer el origen de ideas o ejemplos utilizados en el repositorio.

---
