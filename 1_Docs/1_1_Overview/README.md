# 1.1 Overview · Cómo usar la documentación

Este documento ofrece una visión general de la carpeta `1_docs` y explica cómo se relaciona con el resto del repositorio (`2_devices`, `3_examples`, `4_activities`, `5_labs`, `6_implementation`).

El objetivo es responder a tres preguntas:

- ¿Por dónde empezar?
- ¿Cuándo consultar teoría?
- ¿Cómo conectar la documentación con ejemplos, actividades, labs e implementaciones?

---

## 1. Flujo sugerido de aprendizaje

Un recorrido típico usando la documentación es el siguiente:

1. **Leer este Overview (`1_1_Overview`)**  
   Para entender el propósito del repositorio, a quién va dirigido y qué resultados se esperan.

2. **Revisar la teoría que haga falta (`1_2_*`)**  
   Solo lo necesario para la práctica que vas a hacer (lógica combinacional, FSM, contadores, PWM, etc.).

3. **Seguir las guías de instalación y entorno (`1_3_install`)**  
   Para dejar listo VS Code, Git, Gowin y la clonación del repositorio.

4. **Usar los how-to cuando te atores (`1_5_howto`)**  
   - Conexiones de hardware (`1_5_1_connections`).
   - Flujo de código (`1_5_2_code_flow`).
   - Cómo correr scripts (`1_5_3_how_to_run`).
   - Errores típicos y precauciones (`1_5_4_troubleshooting_and_pitfalls`).

5. **Trabajar sobre `4_activities`, `5_labs` y `6_implementation`**  
   Usando la documentación de `1_docs` como apoyo cuando haga falta.

---

## 2. Relación con el resto del repositorio

A alto nivel:

- `1_docs/`  
  Explica conceptos, flujo de trabajo, instalación y errores comunes.  
  No contiene el código de las prácticas principales, sino el soporte teórico y práctico.

- `2_devices/`  
  Describe la Tang Nano 9K y los periféricos usados.  
  Se consulta cuando hay dudas sobre pines, voltajes o conexiones físicas.

- `3_examples/`  
  Ofrece ejemplos de referencia (gráficos, sonido, integraciones más complejas).  
  Sirve para estudiar diseños más grandes y ver cómo se estructuran.

- `4_activities/`  
  Agrupa ejercicios cortos, cada uno centrado en un concepto concreto.  
  La documentación ayuda a recordar teoría mientras se completan los `TODO`.

- `5_labs/`  
  Reúne prácticas más completas, integrando varios conceptos.  
  La documentación se usa como guía rápida para repasar temas al diseñar y depurar.

- `6_implementation/`  
  Contendrá mini–proyectos que combinan todo lo anterior.  
  La documentación sirve como referencia para justificar decisiones de diseño y estructura.

---

## 3. Cuándo leer qué

- **Antes de tocar código**:  
  - Lea `1_1_1_Purpose`, `1_1_2_Audience` y `1_1_3_Results` para tener claro el objetivo.
  - Revise rápidamente `1_1_4_Map` para ubicarse en el repositorio.

- **Cuando esté preparando su máquina**:  
  - Use `1_3_install` (Windows o Linux) para configurar VS Code, Git y Gowin.

- **Cuando un ejercicio no se entienda bien**:  
  - Vea los resúmenes teóricos en `1_2_*` y a los how-to de `1_5_*`.

- **Cuando algo no funcione**:  
  - Revise `1_5_3_how_to_run` (por si es un tema de scripts).
  - Revise `1_5_4_troubleshooting_and_pitfalls` (errores típicos y precauciones).

---

## 4. Resumen

- `1_docs` es el **manual** que acompaña a las carpetas de código y hardware.
- Esta subcarpeta `1_1_Overview` explica:
  - Para qué existe el repositorio.
  - Para quién está pensado.
  - Qué resultados se esperan.
  - Cómo se conectan documentación, ejemplos, activities, labs e implementations.

Una vez que tenga clara esta estructura, puede moverse con más seguridad por el resto del proyecto.