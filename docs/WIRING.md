# JarzRover wiring

## Working architecture

The user reports successful robot operation with direct wiring and no breadboard. Preserve that arrangement and use direct connections, suitable connectors, or terminal blocks where practical.

```text
Android phone -- USB OTG --> Arduino Nano
Arduino Nano -- left/right control signals --> L298N --> four TT motors
HC-SR04 -- trigger D12 / echo D11 --> Arduino Nano
Robot battery -- motor power --> L298N
```

This is a functional overview, not a complete terminal-by-terminal schematic. The exact battery routing, L298N input terminal correspondence, enable/regulator jumper positions, and motor lead polarity have not been recorded. Trace the working assembly before reconnecting it.

## Preserve these connections

- Left motor control: D5 and D6; right motor control: D9 and D10. Preserve the working pairing and direction established by the completed left/right tests.
- HC-SR04: trigger D12, echo D11. Integrated sonar is enabled in the current DIY source and reported working on the rover.
- Front speed sensors: D2 and D3. They are enabled in the current DIY source and reported working; indicators remain disabled. Keep feature flags consistent with installed components.
- A7 is the voltage-sense input, not a battery power connection. Divider sensing is currently disabled.

See [HARDWARE.md](HARDWARE.md) for the complete firmware mapping.

## Power and direct-wiring practice

The phone has powered the Nano over USB OTG, but this does not supply the full robot's motor-power needs. Use proper battery power for the motor system. Battery voltage, capacity, regulator arrangement, and simultaneous USB/battery behavior need confirmation from the actual assembly before changing the power connections.

Maintain a common signal ground between the Nano, driver, and sensor. Preserve appropriate logic and motor supply connections; do not assume the L298N module's 5 V terminal direction or jumper configuration without inspecting it. Route motor current through appropriate wiring and driver terminals rather than the Nano or a solderless breadboard.

Prefer secure connectors, insulated joints, strain relief, and labeled left/right and power leads. Avoid adding a breadboard where practical; any temporary diagnostic wiring should be recorded. Document wiring changes and the resulting checks in [TEST_LOG.md](TEST_LOG.md).
