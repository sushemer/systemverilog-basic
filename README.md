# System Verilog Basic

Repositorio académico para aprender y practicar **Verilog/SystemVerilog** utilizando la **FPGA Tang Nano 9K** y periféricos comunes (sensores y actuadores).  

Su propósito es ofrecer un camino estructurado desde los **fundamentos** hasta **mini-proyectos integradores**, con ejemplos reproducibles, actividades guiadas, laboratorios y criterios de evaluación claros.

> Nota: gran parte de la base técnica (soporte de tarjetas, periféricos, scripts y algunos labs) se adapta del trabajo de **Yuri Panchul** y de repositorios educativos públicos. En este proyecto solo se reorganizan, documentan y contextualizan para uso académico en la UABC.

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
  - Divisores de reloj, contadores y PWM.
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

Estas recomendaciones facilitan el avance, pero el material está diseñado para acompañar también a personas que aún se encuentran en proceso de aprender estos temas.

---

## Estructura del repositorio

La organización general es la siguiente (los nombres exactos pueden variar ligeramente según la versión del repo):

- **1_Docs/**  
  Documentación conceptual y operativa:
  - Descripción general del proyecto y contexto.
  - Teoría breve por tema.
  - Guías de instalación (Windows/Linux).
  - Glosario de términos.
  - Referencias y enlaces externos.

- **2_Devices/**  
  Información sobre hardware:
  - Placas (especialmente **Tang Nano 9K**).
  - Sensores (HC-SR04, encoder rotatorio, etc.).
  - Actuadores (display de 7 segmentos, TM1638, LCD, buzzer, etc.).
  - Notas de seguridad eléctrica y archivos de constraints.

- **3_Examples/**  
  Ejemplos mínimos y autocontenidos para un concepto específico:  
  cada ejemplo se puede compilar, programar y observar de manera directa.

- **4_Activities/**  
  Actividades guiadas con:
  - Objetivo claro.
  - Pasos sugeridos.
  - Checklist y evidencias mínimas.

- **5_Labs/**  
  Prácticas estructuradas por nivel (básico, intermedio, avanzado),  
  con procedimientos más completos y, cuando aplica, rúbricas de evaluación.

- **6_Implementation/**  
  Mini-proyectos integradores (por ejemplo, reloj digital, radar ultrasonido-servo)  
  que combinan contadores, FSM, PWM, sensores y actuadores.

- **board_support/** (o nombre equivalente)  
  Archivos de soporte para distintas tarjetas FPGA.  
  Esta sección proviene originalmente del trabajo de **Yuri Panchul** en *basic-graphics-music*  
  y aquí solo se adapta y documenta para el contexto de la Tang Nano 9K.

- **labs_common/**  
  Módulos SystemVerilog reutilizables entre varios labs  
  (por ejemplo, el driver de display de 7 segmentos).  
  Su origen también está en los ejemplos genéricos del proyecto *basic-graphics-music*.

- **peripherals/**  
  Drivers y módulos de alto nivel para periféricos como:
  - TM1638 (7 segmentos + LEDs + teclas).
  - LCD 480×272.
  - Sensores básicos.  
  La mayoría de estos bloques se derivan de los ejemplos del ecosistema de  
  *basic-graphics-music* y del *verilog-hackathon-education-kit*.

- **scripts/**  
  Scripts en Bash para síntesis, generación de bitstream y programación de la FPGA.  
  El diseño de estos scripts sigue muy de cerca el esquema propuesto por **Yuri Panchul**  
  en *basic-graphics-music* (modo estricto de Bash, uso de gw_sh, etc.).

> Cada carpeta principal procura incluir un `README.md` con: objetivo, pasos sugeridos,
> checklist breve, mapeo de pines/constraints y, cuando aplica, entregables recomendados.

---

## Cómo empezar

Un flujo sugerido es el siguiente:

1. Revisar el contenido de `1_Docs/1_1_Overview/` para conocer el contexto y la ruta recomendada.
2. Seguir la guía de instalación en `1_Docs/1_3_Install/` (Windows o Linux).
3. Ejecutar un ejemplo básico de `3_Examples/` (por ejemplo, un contador o “blink”).
4. Continuar con la actividad asociada en `4_Activities/`.
5. Pasar al laboratorio correspondiente en `5_Labs/`.
6. Finalmente, explorar los mini-proyectos en `6_Implementation/`.

Este flujo permite verificar paso a paso que:

- El entorno de herramientas está correctamente instalado.
- La placa está bien conectada y configurada.
- Cada concepto se asimila antes de pasar al siguiente nivel de complejidad.

---

## Principios de diseño

El repositorio se organiza siguiendo estos principios:

- **Brevedad accionable**  
  Teoría corta, código mínimo y conexión clara Example → Activity → Lab.

- **Consistencia**  
  Estructura similar, nomenclatura homogénea y plantillas de README compatibles entre carpetas.

- **Reutilización**  
  Drivers y bloques comunes se concentran en `labs_common/`, `peripherals/` y soporte de tarjetas en `board_support/`, evitando duplicar código.

- **Evaluación clara**  
  Cuando aplica, se incluyen checklist, criterios de aceptación y rúbricas simples.

- **Escalabilidad**  
  Progresión gradual de lo básico a lo avanzado, sin saltos bruscos.

- **Continuidad**  
  El repositorio está pensado para que otras personas puedan extenderlo, corregirlo y adaptarlo a nuevas actividades, dispositivos o cursos sin depender de quienes lo iniciaron.

---

## Créditos y fuentes principales

Este repositorio no se construye desde cero: se apoya fuertemente en trabajo previo de la comunidad.  
En particular, se reconocen como fuentes clave:

- `https://github.com/yuri-panchul/basics-graphics-music`  
  Colección de ejemplos de gráficos y música para múltiples FPGAs.  
  De aquí provienen:
  - La idea general de un “kit educativo” con ejemplos, labs y scripts.
  - El soporte para varias tarjetas (incluida la Tang Nano 9K).
  - La estructura de scripts en Bash para síntesis y programación.  
  En este proyecto se reutilizan y adaptan esos elementos, agregando documentación en español y una ruta de aprendizaje alineada a la UABC.

- `https://github.com/verilog-meetup/verilog-hackathon-education-kit-manual`  
  Manual educativo asociado a un kit de aprendizaje de Verilog.  
  Aporta:
  - Enfoque pedagógico por etapas.
  - Ideas de actividades y labs.
  - Estilo de documentación orientado a hackathons y cursos cortos.

- `https://github.com/ramprakashb/verilog-hackathon-education-kit-manual`  
  Fork y variantes del manual del verilog hackathon education kit.  
  Se usa como referencia complementaria para comparar enfoques y ejemplos.

- `https://github.com/yuri-panchul/systemverilog-homework`  
  Conjunto de tareas y ejercicios de SystemVerilog.  
  Sirve como inspiración para el diseño de actividades prácticas y la forma de plantear problemas.

El objetivo de este repositorio no es replicar literalmente esos materiales, sino **adaptarlos, organizarlos y extenderlos**:

- Una ruta de aprendizaje clara.
- Documentación unificada.

Cualquier contribución futura debe respetar estas referencias y mantener el reconocimiento a las fuentes originales.
