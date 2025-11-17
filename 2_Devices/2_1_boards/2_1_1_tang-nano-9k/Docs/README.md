# Documentación específica · Tang Nano 9K

La carpeta `docs` reúne la documentación específica de la **Tang Nano 9K** utilizada en este repositorio.

Su propósito es complementar al archivo de constraints y ofrecer información clara sobre:

- Qué pines se usan y para qué.
- Qué consideraciones de alimentación y niveles de voltaje hay que respetar.
- Cómo es el flujo básico para programar la placa con Gowin.

---

## Contenido

Archivos principales:

- `pinout.md`  
  - Resumen de pines utilizados en el curso/taller.
  - Tablas del tipo:
    - Señal lógica → pin físico → uso (LED, botón, GPIO, etc.).
  - Enfoque en los pines que se usan en Examples, Activities y Labs.

- `power_notes.md`  
  - Notas sobre alimentación y niveles de voltaje:
    - IO de usuario a 3.3 V.
    - Consideraciones al usar módulos de 5 V.
    - Importancia del GND común.
  - Advertencias para evitar daños a la placa o a los periféricos.

- `programming.md`  
  - Guía breve para programar la Tang Nano 9K con Gowin IDE:
    - Selección del dispositivo.
    - Asociación del archivo de constraints `tang-nano-9k.cst`.
    - Flujo básico: síntesis → implementación → bitstream → programación.
  - Puede incluir notas rápidas de solución de problemas frecuentes.

Según se avance en el proyecto, se pueden añadir otros archivos de apoyo (por ejemplo, notas sobre reloj, bancos de IO, o ejemplos de wiring recomendados).

---

## Cómo usar esta carpeta

- Antes de conectar sensores o actuadores a la Tang Nano 9K:
  - Revisar `pinout.md` para saber qué pines usar.
  - Revisar `power_notes.md` para confirmar compatibilidad de voltajes.

- Antes de programar la placa por primera vez:
  - Consultar `programming.md` para seguir el flujo resumido de Gowin IDE.

- Al crear nuevos Examples, Activities o Labs:
  - Verificar que los pines elegidos coinciden con lo documentado aquí y con el archivo `constr/tang-nano-9k.cst`.
  - Si se introduce un nuevo conjunto de pines de forma “oficial”, actualizar `pinout.md`.

---

## Relación con otras carpetas

- `../constr/`  
  - Depende del archivo `tang-nano-9k.cst`.  
  - `pinout.md` y `power_notes.md` se basan en las asignaciones definidas ahí.

- `3_examples/`, `4_activities/`, `5_labs/`, `6_implementation/`  
  - Deben ser consistentes con los pines y notas documentadas en esta carpeta, para que el uso de la Tang Nano 9K sea coherente en todo el repositorio.

---

## Actualización y mantenimiento

Si en algún momento:

- Se decide cambiar el estándar de pines (por ejemplo, usar otros GPIO para un periférico).
- Se agrega un nuevo periférico conectado a la Tang Nano 9K.

entonces:

1. Actualizar el archivo de constraints si es necesario.
2. Documentar el cambio en `pinout.md` y/o `power_notes.md`.
3. Añadir una breve nota en `programming.md` si el flujo cambia (por ejemplo, uso de otra herramienta de programación).

La idea es que cualquier estudiante o persona nueva pueda entender cómo usar la placa leyendo solo estos archivos.
