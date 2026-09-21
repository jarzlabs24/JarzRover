<p align="center">
  <a href="https://www.jarzlabs.com/">
    <img alt="JARzLabs — Where Imagination Takes Shape" width="100%" src="branding/generated/jarzlabs-readme-banner.png" />
  </a>
</p>

<h1 align="center">JarzRover</h1>

<p align="center"><strong>Smartphone-powered robotics by JARzLabs</strong></p>

JarzRover is JARzLabs' open-source robotics project for hands-on STEM learning and experimentation. Derived from [OpenBot](https://github.com/ob-f/OpenBot), it combines a low-cost 3D-printed rover with a tested Android-to-Arduino Nano control path, colored-ball behaviors, Creature Lab, companion controllers, and an in-development iOS-to-ESP32 path.

JarzRover retains OpenBot's MIT license and attribution. OpenBot remains the upstream project and does not endorse or maintain JarzRover.

## Project status

| Path | Status | Notes |
| --- | --- | --- |
| Android robot app + Arduino Nano over USB OTG | Primary tested architecture | Uses the OpenBot DIY hardware configuration; preserve the documented pin map |
| Flutter controller on Android/iOS | Active | Remote driving, video/control connection, and Creature Lab controls |
| Creature Lab | Included | Runs without Firebase; AI generation uses a separately configured local HTTPS service |
| Colored-ball detection and behaviors | Active development | Red, green, and blue behaviors require physical regression testing |
| Native iOS robot app + ESP32 over BLE | In development | Separate from the Android/Nano architecture; exact ESP32 hardware must be verified before wiring changes |

The repository builds without Firebase and does not connect public clones to a shared backend. Authorized JARzLabs devices can opt in to the JARzLabs Firebase project using ignored local configuration described in [the Firebase setup guide](docs/FIREBASE_SETUP.md).

## Start here

- [Project context and current decisions](docs/PROJECT_CONTEXT.md)
- [JarzRover compatibility notes](body/jarzrover-diy/COMPATIBILITY.md)
- [JarzRover DIY preview](body/jarzrover-diy/README.md)
- [Recorded build and physical-test evidence](docs/TEST_LOG.md)
- [Android apps](android/README.md)
- [Controller options](controller/README.md)
- [Firmware](firmware/README.md)
- [Robot body designs](body/README.md)
- [Creature Lab](tools/creature-lab/README.md)
- [Native iOS build guide](docs/BUILD_IOS.md)
- [Public source and customer-package boundary](body/jarzrover-diy/OVERVIEW.md)

## Get the source

```bash
git clone https://github.com/jarzlabs24/JarzRover.git
cd JarzRover
```

The integration branch is `jarz-development`. Tagged releases identify reviewed source and binary milestones. Do not download JarzRover binaries from upstream OpenBot links; the products and configurations are different.

## Apps and downloads

Reviewed release artifacts are published through the [latest JarzRover release](https://github.com/jarzlabs24/JarzRover/releases/latest) and may also be linked from [jarzlabs.com](https://www.jarzlabs.com/).

- Android robot and controller apps are distributed as signed APK files. Website installation requires Android's **Install unknown apps** permission for the browser or file manager used to open the APK.
- iOS does not support unrestricted public IPA installation. Public beta distribution uses TestFlight; development or Ad Hoc builds work only on appropriately signed and registered devices.
- Release pages must include version information, SHA-256 checksums, supported hardware, installation steps, known limitations, and third-party notices.

Until the first signed release is posted, build from source and treat generated debug artifacts as development builds—not public releases.

## Safety

JarzRover is an experimental moving robot. Test new firmware and app behavior with the wheels raised or motors disconnected first. Keep a reliable STOP control available, operate away from people and fragile objects, and verify battery polarity, voltage, motor-driver wiring, and the exact flashed firmware before powered testing. Use at your own risk.

## OpenBot attribution

JarzRover is based on OpenBot, originally developed by Matthias Müller and Vladlen Koltun. The inherited OpenBot source, documentation, technical identifiers, body designs, and paper citation remain identified as OpenBot where that history or compatibility matters.

If you use the underlying OpenBot research, cite:

```bibtex
@inproceedings{mueller2021openbot,
    title     = {OpenBot: Turning Smartphones into Robots},
    author    = {M{\"u}ller, Matthias and Koltun, Vladlen},
    booktitle = {Proceedings of the International Conference on Robotics and Automation (ICRA)},
    year      = {2021}
}
```

See [third-party licenses and provenance](docs/THIRD_PARTY_LICENSES.md) for the current audit and remaining release gates.

## Contributing

Issues and pull requests are welcome after the public repository opens. Read [CONTRIBUTING.md](CONTRIBUTING.md), preserve the working hardware configuration, keep changes small and testable, and clearly distinguish results you observed from tests that remain pending.

Release/security work is owned by [@jarvis414-bot](https://github.com/jarvis414-bot). Ball, creature, and behavior development is owned by [@jarzlabs24](https://github.com/jarzlabs24). Joint hardware validation requires both maintainers.

## License, branding, and support

The software and covered documentation are provided under the repository's [MIT license](LICENSE), including the retained OpenBot/Intel ISL notice. JARzLabs and JarzRover names and artwork are governed separately by the [brand policy](BRAND_POLICY.md); the software license does not grant trademark rights.

- Website: [jarzlabs.com](https://www.jarzlabs.com/)
- Support and security contact: [jarzlabs24@gmail.com](mailto:jarzlabs24@gmail.com)
- Instagram: [@jarzlabs24](https://www.instagram.com/jarzlabs24/)
- YouTube: [@JarzLabs](https://www.youtube.com/@JarzLabs)
