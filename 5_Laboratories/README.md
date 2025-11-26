# 5. Laboratories – Guided Practices

Hands-on labs using **Tang Nano 9K + TM1638 + LCD 480×272 + real sensors**.  
Each lab contains:

- A main file `hackathon_top.sv`.
- Its own `README.md` with objectives, wiring, and checklist.

It is recommended to complete them **in order**.

---

## 5.1 – counter_blink_hello_world

**Folder:** `5_1_counter_blink_hello_world`  

- **Objective:** make an LED blink at ~1 Hz using a clock divider.
- **Key concepts:** top module, registers, `always_ff @(posedge clk)`, counter overflow.
- **Hardware:** Tang Nano 9K, one user LED.

---

## 5.2 – buttons_and_debounce

**Folder:** `5_2_buttons_and_debounce`  

- **Objective:** read a button, remove bounce, and generate clean pulses to toggle an LED.
- **Key concepts:** clock-domain synchronization, simple debounce, edge detection.
- **Hardware:** Tang Nano 9K, at least 1 button and 1 LED.

---

## 5.3 – shift_register_patterns

**Folder:** `5_3_shift_register_patterns`  

- **Objective:** generate shifting light patterns on an 8-LED bar (running light / “KITT”).
- **Key concepts:** shift registers, rotation, periodic patterns, slow enable.
- **Hardware:** Tang Nano 9K, 8 LEDs.

---

## 5.4 – fsm_traffic_and_lock

**Folder:** `5_4_fsm_traffic_and_lock`  

- **Objective:** implement two state machines:
  - Traffic light (R→G→Y→R) with configurable timing.
  - “Sequence lock”: correct A-B-A-B button sequence lights a “unlock” LED.
- **Key concepts:** FSM with `case`, timing based on counters, debounced inputs.
- **Hardware:** LEDs for the traffic lights + lock LED, input buttons.

---

## 5.5 – seven_segment_and_tm1638

**Folder:** `5_5_seven_segment_and_tm1638`  

- **Objective:** use the seven-segment driver + TM1638 to show values and use LEDs as bar/state indicators.
- **Key concepts:** `seven_segment_display`, TM1638 peripheral integration, mapping nibbles to digits.
- **Hardware:** **TM1638 module** (seven-segment, LEDs, and keys).

---

## 5.6 – sensors_and_lcd_integration

**Folder:** `5_6_sensors_and_lcd_integration`  

- **Objective:** integrate real sensors with the LCD panel:
  - Read **HC-SR04** ultrasonic sensor and **KY-040 rotary encoder**.
  - Select data source using keys.
  - Show the value as a **vertical gauge bar** on the LCD and as a pattern on LEDs.
- **Key concepts:** sensor module integration (ultrasonic + rotary_encoder + debounce), using `(x, y)` for simple graphics, scaling values to pixel heights.
- **Hardware:** Tang Nano 9K, 480×272 LCD, HC-SR04, KY-040 encoder.

---

## Usage recommendation

1. Start with **5.1** and **5.2** to strengthen your understanding of clocking, counters, and buttons.
2. Continue with **5.3** to practice shift registers and visual patterns.
3. In **5.4**, consolidate your FSM knowledge with clear examples.
4. In **5.5**, dive into multiplexed displays and TM1638.
5. Finish with **5.6**, where you combine sensors + LCD in a “mini-project” style practice.

Each lab is designed to be:

- **Short**, but with room for extensions.  
- **Reusable** as a foundation for larger projects.  
- Compatible with your current hardware setup.  
