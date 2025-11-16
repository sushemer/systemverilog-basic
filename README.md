# System Verilog Basic

Repositorio académico para aprender y practicar **Verilog/SystemVerilog** utilizando la **FPGA Tang Nano 9K** y periféricos comunes (sensores y actuadores).  

Su propósito es ofrecer un camino estructurado desde los **fundamentos** hasta **mini-proyectos integradores**, con ejemplos reproducibles, actividades guiadas, laboratorios y criterios de evaluación claros.

---

## Contexto académico

Este repositorio forma parte del proyecto de investigación:

> **“Desarrollo de aplicaciones innovadoras con SystemVerilog mediante FPGA Tang Nano 9K”**

desarrollado en la **Facultad de Ciencias Químicas e Ingenierías (FCQI), UABC**.

El objetivo del proyecto es documentar y validar una ruta de aprendizaje que permita:

- Iniciar desde cero en Verilog/SystemVerilog y FPGAs.
- Llegar a aplicaciones que integren **sensores** y **actuadores**.
- Dejar una base organizada que pueda reutilizarse en cursos, talleres y futuras generaciones.

---

## Objetivo del repositorio

El repositorio existe para acelerar el aprendizaje **práctico** de Verilog/SystemVerilog con la Tang Nano 9K, ofreciendo un camino claro de **cero a integración**. Se considera que cumple su propósito si facilita que la persona usuaria pueda:

- Comprender los **fundamentos**:
  - Módulos y puertos.
  - Diferencias entre lógica **combinacional** y **secuencial**.
  - Máquinas de estados finitos (FSM).
  - Divisores de reloj y PWM.
- **Observar** los conceptos en funcionamiento mediante ejemplos mínimos.
- **Practicar** con actividades guiadas (checklist + evidencias).
- **Integrar** sensores y actuadores en laboratorios y mini-proyectos evaluables.
- Documentar cada ejercicio o proyecto con un **README** claro y reproducible.

---

## Público objetivo

El contenido está orientado principalmente a:

- Estudiantes de ingeniería o áreas afines sin experiencia previa en HDL/FPGA.
- Personas desarrolladoras de software (Python, C, Java, etc.) que migran hacia hardware digital.
- Makers y entusiastas que desean usar una FPGA en proyectos prácticos sin partir de cero.

---

## Recomendaciones previas

No se requiere experiencia profunda en electrónica, pero se recomienda:

- Conocer programación básica (estructuras de control, variables, funciones) en algún lenguaje como C, C++ o Python.
- Tener nociones elementales de **binario y lógica booleana** (AND, OR, NOT).
- Contar con habilidades básicas para:
  - Instalar software en **Windows o Linux**.
  - Utilizar la línea de comandos a nivel básico.
  - Manejar **Git** para clonar y actualizar repositorios.

Estas recomendaciones facilitan el avance, pero el material está pensado para acompañar a quienes aún se encuentran en proceso de aprender.

---

## Estructura del repositorio

La organización general es la siguiente:

- **1. Docs/**  
  Documentación conceptual y operativa:
  - Overview del proyecto y contexto.
  - Teoría breve por tema.
  - Guías de instalación (Windows/Linux).
  - Glosario de términos.
  - Referencias y enlaces externos.

- **2. Devices/**  
  Información sobre hardware:
  - Placas (Tang Nano 9K).
  - Sensores (HC-SR04, potenciómetro vía ADC, encoder, etc.).
  - Actuadores (7-segmentos, TM1638, LCD, servo, buzzer).
  - Notas de seguridad eléctrica y archivos de constraints.

- **3. Examples/**  
  Ejemplos mínimos y autocontenidos para un concepto específico  
  (compilar, programar y observar).

- **4. Activities/**  
  Actividades guiadas con:
  - Objetivo claro.
  - Pasos sugeridos.
  - Checklist y evidencias mínimas.

- **5. Labs/**  
  Prácticas estructuradas por nivel (básico, intermedio, avanzado),  
  con procedimientos más completos y rúbricas de evaluación.

- **6. Implementation/**  
  Mini-proyectos integradores (por ejemplo, reloj digital, radar ultrasonido-servo)  
  que combinan varios bloques: contadores, FSM, PWM, sensores y actuadores.

> Cada carpeta incluye un `README.md` con: objetivo, pasos, checklist, pines/constraints y entregables sugeridos.

---

## Cómo empezar

1. Revisar el contenido de `1_docs/1_1_Overview/` para entender el contexto y el flujo recomendado.
2. Seguir la guía de instalación en `1_docs/1_3_Install/` (Windows o Linux).
3. Ejecutar un ejemplo básico de `3_examples/` (por ejemplo, un contador o un “blink”).
4. Continuar con la actividad asociada en `4_activities/`.
5. Pasar al laboratorio correspondiente en `5_labs/`.
6. Finalmente, explorar los mini-proyectos en `6_implementation/`.

Este flujo permite verificar paso a paso que el entorno funciona, que la placa está bien conectada y que cada concepto se comprende antes de avanzar.

---

## Principios de diseño

- **Brevedad accionable:** teoría corta, código mínimo y enlaces directos entre Example → Activity → Lab.
- **Consistencia:** misma estructura, nomenclatura y plantilla de README en todas las carpetas.
- **Reutilización:** drivers y bloques comunes en `ip_blocks/` y constraints centralizados en `2_devices/`.
- **Evaluación clara:** criterios de aceptación, checklist y rúbricas simples.
- **Escalabilidad:** progresión de lo básico a lo avanzado, sin saltos bruscos.
- **Continuidad:** el repositorio está diseñado para que otras personas puedan extenderlo, corregirlo y adaptarlo a nuevos dispositivos o actividades.

---

## Créditos y fuentes principales

El enfoque, la estructura y varios ejemplos de este repositorio se inspiran y/o se apoyan en los siguientes proyectos:

- `https://github.com/yuri-panchul/basics-graphics-music`  
(pendiente añadir una información de cada repositorio para facilitar la busqueda)

- `https://github.com/verilog-meetup/verilog-hackathon-education-kit-manual`
- `https://github.com/ramprakashb/verilog-hackathon-education-kit-manual`
- `https://github.com/yuri-panchul/systemverilog-homework`

El objetivo no es replicar estos materiales, sino **adaptarlos, organizarlos y extenderlos** en un contexto académico específico, con una ruta de aprendizaje clara y criterios de evaluación alineados al proyecto de investigación.
