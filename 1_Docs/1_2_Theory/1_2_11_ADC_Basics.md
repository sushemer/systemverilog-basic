# ADC basics

This document presents the general concepts of an **Analog-to-Digital Converter (ADC)** without focusing on a specific model.

The goal is to understand:

- Why an ADC is needed  
- What parameters matter  
- How it relates to the FPGA in this repository  

---

## Why do we need an ADC?

The FPGA works with **digital signals**:

- Logic levels 0 and 1  
- Inputs/outputs that represent bits  

Many sensors and input elements produce **analog** values:

- Continuous voltages (e.g., potentiometer output)  
- Signals that cannot be represented by fixed 0/1  

An **ADC** converts:

- An **analog voltage** within a certain range  
- Into a **digital number** (e.g., 0–255, 0–1023, etc.)  

This digital value can be handled directly by the FPGA.

---

## Key ADC parameters

1. **Resolution (bits)**  
   - Number of distinct levels:
     - 8 bits → 256 levels  
     - 10 bits → 1024 levels  
     - 12 bits → 4096 levels  
   - Higher resolution → finer measurement.

2. **Input range / reference voltage (Vref)**  
   - Minimum and maximum measurable voltage.  
   - Digital 0 corresponds to the minimum; max code corresponds to Vref.

3. **Sample rate**  
   - How many conversions per second.  
   - Not critical for slow sensors (potentiometer, basic analog inputs).

---

## Interface with the FPGA: SPI and I²C

Many external ADCs communicate via serial buses:

### SPI
- Lines: `SCK`, `MOSI`, `MISO`, `CS`  
- FPGA acts as **master**

### I²C
- Lines: `SCL`, `SDA`  
- FPGA is master and selects devices via addresses

General flow:

1. FPGA starts a transaction  
2. Sends configuration/commands  
3. ADC performs the conversion  
4. FPGA reads result bits and reconstructs number  

See also: `1_2_9_Buses_Overview.md`

---

## From voltage to digital number

Concept:

- Input voltage: `V_in`  
- Range: 0 to `Vref`  
- Resolution: N bits → `2^N` levels  

Ideal code:

`code ≈ (V_in / Vref) * (2^N - 1)`

Example:

- ADC: 10-bit (0–1023), Vref = 3.3 V  
- `V_in = 1.65 V` → code ≈ 511  

The resulting value can be used for:

- LED display  
- PWM control  
- Percentage scaling  

---

## Typical usage in this repository

External ADCs are used for:

- Reading **potentiometer** values  
- Reading analog sensors  

Digital value can be used to:

- Control LED brightness (PWM)  
- Move servos  
- Adjust thresholds or parameters  

Related:

- `1_2_15_Potentiometer_ADC_Basics.md`  
- `pot_read_demo` examples  

---

## Related theory files

- `1_2_9_Buses_Overview.md`  
- `1_2_10_PWM_Basics.md`  
- `1_2_15_Potentiometer_ADC_Basics.md`  

These enable mini-projects such as:

- Pot-controlled LED dimmer  
- Servo control via analog knob  
