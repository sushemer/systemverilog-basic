# 1.2 Theory · Teoría breve y aplicada

La carpeta `1_2_Theory` reúne archivos de teoría **cortos y enfocados**.  
Su intención es explicar los conceptos mínimos necesarios para poder:

- Entender qué hace cada ejemplo, actividad y laboratorio.
- Tomar decisiones básicas de diseño al trabajar con la Tang Nano 9K.
- Relacionar el lenguaje (Verilog/SystemVerilog) con hardware real (FPGA y periféricos).

Cada archivo se centra en un tema específico y no pretende ser teoría completa ni formal, sino un complemento directo para el trabajo práctico.

---

## Organización de la teoría

Se recomienda leer los temas en el siguiente orden:

1. **Fundamentos de contexto**
   - `1_2_1_HDL_and_FPGA_Basics.md`  
     Qué es un HDL, qué es una FPGA y en qué se diferencia de otros enfoques (por ejemplo, microcontroladores).
   - `1_2_2_Verilog_SystemVerilog_Overview.md`  
     Visión general del lenguaje, sintaxis básica y enfoque que usa este repositorio.

2. **Fundamentos de descripción de hardware**
   - `1_2_3_Modules_and_Ports.md`
   - `1_2_4_Combinational_vs_Sequential.md`
   - `1_2_5_Registers_and_Clock.md`
   - `1_2_6_Timing_and_Dividers.md`
   - `1_2_7_Finite_State_Machines.md`
   - `1_2_8_Debouncing_and_Edge_Detection.md`
   - `1_2_9_Buses_Overview.md`
   - `1_2_10_PWM_Basics.md`

3. **Periféricos básicos usados en el repositorio**
   - `1_2_11_ADC_Basics.md`
   - `1_2_12_Seven_Segment_Basics.md`
   - `1_2_13_LCD_HD44780_Basics.md`
   - `1_2_14_Ultrasonic_HCSR04_Basics.md`
   - `1_2_15_Potentiometer_ADC_Basics.md`

Cada archivo puede referenciar Examples, Activities y Labs relacionados para facilitar la transición de teoría a práctica.

---

## Cómo usar esta carpeta

- **Antes de un tema nuevo**  
  Revisar el archivo de teoría asociado (por ejemplo, PWM antes de un dimmer de LED o un servo, ADC antes de usar potenciómetro o sensores analógicos).

- **Durante un laboratorio**  
  Consultar la teoría como referencia rápida ante dudas de sintaxis o de concepto.

La idea es que la teoría se consulte **a demanda**, no como lectura lineal obligatoria.
