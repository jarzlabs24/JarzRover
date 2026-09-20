# JarzRover iOS Apps — Development

The Flutter controller is the active iOS companion app. The native iOS robot app is an in-development BLE path intended for a separately verified ESP32 rover; it cannot control the current Arduino Nano rover over the iPhone's wired connection.

<p align="center">
  <span>English</span> |
  <a href="README.zh-CN.md">简体中文</a> |
  <a href="README.de-DE.md">Deutsch</a> |
  <a href="README.fr-FR.md">Français</a> |
  <a href="README.es-ES.md">Español</a> |
  <a href="README.ko-KR.md">한국어</a>
</p>

> Translation note: linked translations are inherited OpenBot documentation and have not yet been adapted to JarzRover. Use this English page for current iOS status.

## Features

Click on the links below to read about the features of the apps.

- [Robot App](./OpenBot/README.md)
- [Controller App](../controller/flutter/README.md)
## Install the apps

Development builds can be installed from Xcode on registered devices. Public beta distribution should use TestFlight; a raw IPA cannot be installed freely on arbitrary iPhones. Ad Hoc packages work only on devices included in the provisioning profile.

## Build the apps

### Prerequisites

- [Xcode iOS 13 or Later](https://developer.apple.com/xcode/) for building and installing the apps.
- [Cocoapods](https://cocoapods.org/) installed on your system.
- Firebase is optional and is not required for robot control or Creature Lab. See the [local Firebase setup](../docs/FIREBASE_SETUP.md) only when testing inherited account/Drive features.
- Currently, we're using iOS deployment target version 15.5.
- Project is configured as "Automatically manage signing", so you can configure your own independent account for building the app -
  <img alt="iOS App" width="100%" src="../docs/images/ios_automatically_manage_signing.png" />
- To configure your own team, add your iCloud Account via XCode > Settings > Accounts or directly from the Team menu above.
- iOS device with minimum iOS 13 or Later. [List of supported devices](https://support.apple.com/en-in/guide/iphone/iphe3fa5df43/ios).
- [Developer mode](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device) activated on your iOS device.
- The added iCloud account should be [trusted by your iOS device](https://developer.apple.com/forums/thread/685271).

### Build Process

1. Open XCODE and select *open a project or file*.
2. To install the [OpenBot app](OpenBot/README.md) make sure to select the *OpenBot* configuration.
   <img alt="iOS App" width="100%" src="../docs/images/ios_openbot_configuration.png" />
3. Select your device from the list of available devices.
   <img alt="iOS App" width="100%" src="../docs/images/ios_device_selection.png" />
4. Run the app on device by clicking on the ▶️ icon on top left of Xcode screen.
