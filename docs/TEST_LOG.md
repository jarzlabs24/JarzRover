# JarzRover test log

## Historical baseline

Recorded on 2026-09-04 from the user's JarZLabs handoff. Original test dates, firmware revisions, measurements, and detailed procedures were not supplied. These are user-reported completed tests, not tests rerun during this documentation work.

| Test / observation | Reported outcome | Limits / current status |
| --- | --- | --- |
| Direct wiring without breadboard | Robot successfully operated | Exact as-built schematic not recorded |
| Left motor test | Completed successfully | Speed, load, and procedure not recorded |
| Right motor test | Completed successfully | Speed, load, and procedure not recorded |
| HC-SR04 serial readings | Eventually worked | Fix, sketch, accuracy, and range not recorded; sonar currently disabled in checked-in DIY firmware |
| Android USB OTG power to Nano | Nano powered from phone | Full robot still requires proper battery power |

## Documentation verification — 2026-09-04

Inspected `firmware/openbot/openbot.ino` at commit `5d7e4ce`: `OPENBOT DIY`, `MCU NANO`, and all pin assignments in [HARDWARE.md](HARDWARE.md) match the source. Sonar, front speed sensors, indicators, voltage-divider sensing, and OLED are disabled in the DIY block. No firmware was changed and no physical robot tests were run for this setup.

## Current development status

OpenBot object navigation / green-ball behavior is the active focus. End-to-end detection, centering, approach, stopping, and target-loss behavior have no recorded acceptance result in the supplied history. Standalone sonar success must not be treated as proof of integrated obstacle handling.

Next checks should establish installed hardware and flashed firmware, then verify green-ball behavior incrementally. Record actual observations rather than marking planned checks as passed.

## Future entry template

- Date and tester:
- Goal / behavior tested:
- Firmware or app revision and feature flags:
- Hardware, wiring, and power configuration:
- Procedure and expected result:
- Actual result / measurements:
- Outcome: pass, fail, partial, or not run:
- Hardware-impacting changes and follow-up:
