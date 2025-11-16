# 1.1 Overview · Cómo usar la documentación

Este documento ofrece una visión general de la carpeta `1_docs` y de cómo la documentación se relaciona con el resto del repositorio (`2_devices`, `3_examples`, `4_activities`, `5_labs`, `6_implementation`).

El objetivo es responder a tres preguntas:
- ¿Por dónde empezar?
- ¿Cuándo consultar teoría?
- ¿Cómo conectar la documentación con ejemplos, actividades y laboratorios?

---

## Flujo sugerido de aprendizaje

Un recorrido típico usando la documentación es el siguiente:

1. **Leer este Overview**  
   Para entender cómo se conectan Docs, Devices, Examples, Activities, Labs e Implementation.

2. **Revisar el README principal del repositorio (`/README.md`)**  
   Para conocer:
   - El contexto académico.
   - El objetivo general del proyecto.
   - La estructura global de carpetas.

3. **Configurar el entorno de trabajo**  
   Siguiendo las guías de `1_3_Install/`:
   - Elegir el sistema operativo (Windows o Linux).
   - Instalar las herramientas indicadas.
   - Ejecutar la prueba básica (“smoke test”).

4. **Consultar teoría a medida que avanza**  
   En `1_2_Theory/`, solo para los temas necesarios en cada momento:
   - Por ejemplo, antes de un contador: `registers_and_clock.md` y `timing_and_dividers.md`.
   - Antes de una FSM: `finite_state_machines.md`.
   - Antes de usar un periférico específico: archivo correspondiente (7 segmentos, LCD, HC-SR04, etc.).

5. **Pasar a Examples / Activities / Labs**  
   - Cada archivo de teoría indica, cuando aplica, ejemplos y actividades relacionadas.
   - El objetivo es alternar entre:
     - Leer lo justo de teoría.
     - Ver un ejemplo funcionando.
     - Practicar en una actividad o laboratorio.

6. **Integrar en Implementation**  
   Una vez dominados varios bloques (contadores, FSM, PWM, sensores, actuadores),  
   la documentación sirve como referencia rápida al trabajar en los mini-proyectos de `6_implementation`.

---

## Cómo se conecta con otras carpetas

- `2_devices/`  
  Usa la teoría de relojes, entradas/salidas y periféricos descrita en `1_2_Theory/` para documentar pines, wiring y constraints.

- `3_examples/`  
  Implementa en código los conceptos explicados de forma breve en `1_2_Theory/`.  
  La documentación sirve como apoyo para entender **qué** se quiere demostrar.

- `4_activities/`  
  Toma los ejemplos y los convierte en ejercicios guiados.  
  La teoría de `1_docs` ayuda a resolver dudas mientras se completan los pasos y checklists.

- `5_labs/`  
  Reúne varios conceptos en prácticas más completas.  
  La documentación apoya en el repaso rápido de temas (FSM, PWM, timers, periféricos).

- `6_implementation/`  
  Utiliza todo lo anterior para construir mini-proyectos.  
  La documentación sirve como referencia para ajustar detalles de diseño y justificación técnica.

---


