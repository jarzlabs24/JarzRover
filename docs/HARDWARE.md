# JarzRover hardware baseline

## Current stack

| Component | Role / known status |
| --- | --- |
| Arduino Nano, Lafvin / ATmega328p | Low-level motor and sensor control; firmware selects NANO |
| L298N motor driver | Drives left and right motor groups |
| Four TT motors | Robot drive motors |
| HC-SR04 front ultrasonic sensor | Serial readings historically worked; integrated sonar currently disabled in source |
| Android phone over USB OTG | Higher-level OpenBot behavior and Nano USB connection; can power Nano |
| Battery power | Required for full robot operation; pack specifications and power routing not recorded |
| Optional speed sensors, indicator LEDs, bumper | Removed or disabled as appropriate; inspect robot before assuming presence |

## Verified firmware pin definitions

User-supplied mappings match the DIY block in [openbot.ino](../firmware/openbot/openbot.ino), inspected on 2026-09-04 at commit `5d7e4ce`. This verifies source definitions, not a fresh physical wiring or electrical test.

| Function | Firmware symbol | Nano pin |
| --- | --- | --- |
| Ultrasonic trigger | PIN_TRIGGER | D12 |
| Ultrasonic echo | PIN_ECHO | D11 |
| Left motor control 1 | PIN_PWM_L1 | D5 |
| Left motor control 2 | PIN_PWM_L2 | D6 |
| Right motor control 1 | PIN_PWM_R1 | D9 |
| Right motor control 2 | PIN_PWM_R2 | D10 |
| Left front speed sensor | PIN_SPEED_LF | D2 |
| Right front speed sensor | PIN_SPEED_RF | D3 |
| Battery voltage sensing | PIN_VIN | A7 |
| Left indicator | PIN_LED_LI | D4 |
| Right indicator | PIN_LED_RI | D7 |

`PIN_VIN = A7` is an analog sensing assignment, not the Nano's VIN power terminal. Voltage sensing requires an appropriate divider; the current configuration disables it.

## Checked-in configuration

`OPENBOT DIY`; `MCU NANO`.

| Feature flag | Value |
| --- | --- |
| HAS_SONAR | 0 |
| SONAR_MEDIAN | 0 |
| HAS_SPEED_SENSORS_FRONT | 0 |
| HAS_INDICATORS | 0 |
| HAS_VOLTAGE_DIVIDER | 0 |
| HAS_OLED | 0 |

The DIY block does not define a bumper pin or enable a bumper. Do not copy mappings from other OpenBot variants. Preserve these pin assignments and document any intentional configuration change together with its hardware implications and test results.
