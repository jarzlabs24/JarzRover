# JarzRover operating instructions

JarzRover is the OpenBot-based robotics implementation project within JarZLabs, a youth-run STEM and 3D-printing project.

Before editing, read [docs/PROJECT_CONTEXT.md](docs/PROJECT_CONTEXT.md). For hardware or firmware work, also read [docs/HARDWARE.md](docs/HARDWARE.md), [docs/WIRING.md](docs/WIRING.md), and [docs/TEST_LOG.md](docs/TEST_LOG.md).

- Preserve the working OPENBOT DIY configuration and pin mappings. Do not change wiring assumptions incidentally to a software change.
- Prefer small, testable changes. Explain changes in plain language that youth project members can follow.
- Document hardware-impacting changes: affected pins, wiring, power, feature flags, expected behavior, and validation. Resolve discrepancies between these notes, source code, and the physical robot before changing hardware assumptions.
- Match optional feature flags to installed hardware. A declared pin does not mean its feature is enabled; sonar is currently disabled in the checked-in DIY configuration.
- Run checks appropriate to the change. Record actual results and limitations in TEST_LOG.md; never present a proposed or user-reported test as one you ran.
- Keep durable decisions and current status in PROJECT_CONTEXT.md, hardware details in HARDWARE.md, and connection changes in WIRING.md.
- Current focus: OpenBot object navigation and green-ball detection, centering, approach, and stopping. End-to-end completion is not yet established in these records.

Shared-context workflow: JarZLabs holds broader planning and discussion; this repository holds implementation context. Carry relevant decisions from ChatGPT into these documents, and share an updated context summary back with JarZLabs when needed. These files are the maintained handoff, not an automatic chat-history synchronization mechanism.
