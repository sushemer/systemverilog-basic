# 2.3 Actuators · Output Devices

The `2_3_Actuators` folder contains all the **output devices** used in the repository.  
These modules allow the Tang Nano 9K to **display information**, **signal states**, or **interact visually** with the user.

This includes:

- **7-segment displays**
- **TM1638** (7-segment + LEDs + keys)
- **LCD 16×2** (text display)

The purpose of this folder is to centralize:

- What each actuator does  
- How it connects to the Tang Nano 9K  
- What logical signals are used  
- Where to find wiring and constraints  
- Which examples, activities, and labs depend on each device  

---

## Structure of `2_3_Actuators`
```text
2_devices/
└─ 2_3_Actuators/
├─ 2_3_1_Seven_Segment/
│ └─ README.md
├─ 2_3_2_TM1638/
│ └─ README.md
└─ 2_3_3_LCD_16x2/
└─ README.md
```

Each actuator folder contains:

- A **README.md** explaining:
  - Purpose of the device
  - Logical signals it uses
  - Basic wiring notes
  - References to constraints (`tang-nano-9k.cst`)
  - Usage across examples, activities, and labs
- An optional `Mult/` folder for diagrams and wiring photos

---

## Actuator overview

### **2.3.1 Seven Segment**

Simple alphanumeric display used for:

- Counters  
- State indicators  
- Numeric output  

Supports 1 to 8 digits (multiplexed).

### **2.3.2 TM1638**

All-in-one interface module including:

- 8 × 7-segment digits  
- 8 LEDs  
- 8 input keys  

Communicates using `DIO`, `CLK`, and `STB` signals.

### **2.3.3 LCD 16×2**

Text display for:

- Messages  
- Measurements  
- Menus  

Usually operated in **4-bit parallel mode** (`RS`, `EN`, `D[3:0]`) or I²C (if backpack is used).

---

## Relationship with other folders

- **2_1_Boards**  
  Provides the official pinout and constraints for the Tang Nano 9K.  
  All actuators must follow:
  - `docs/pinout.md`
  - `docs/power_notes.md`
  - `constr/tang-nano-9k.cst`

- **2_2_Sensors**  
  Actuators often combine with sensors (e.g., display sensor readings).

- **2_4_Common**  
  Provides wiring guidelines for protoboard and voltage considerations.

- **3_examples**, **4_activities**, **5_labs**  
  Actuators appear in many exercises:
  - Display counters  
  - Show HC-SR04 distance  
  - Build menus with encoder or TM1638 keys  

---

## Purpose of this folder

This folder ensures that all actuators in the repository:

- Follow consistent naming conventions  
- Use the same pin assignments  
- Provide clear documentation  
- Can be reused across activities and labs without conflicts  

It also helps new users quickly learn:

- **How to wire each device**
- **Which signals they must use**
- **How the FPGA interacts with the display modules**

---
