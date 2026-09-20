# JarzRover Android Apps

JarzRover provides a robot app for the phone mounted on the rover and a separate controller app. These apps are derived from OpenBot, but JarzRover releases, package identities, branding, and supported configurations are maintained by JARzLabs.

<p align="center">
  <span>English</span> |
  <a href="README.zh-CN.md">简体中文</a> |
  <a href="README.de-DE.md">Deutsch</a> |
  <a href="README.fr-FR.md">Français</a> |
  <a href="README.es-ES.md">Español</a> |
  <a href="README.ko-KR.md">한국어</a>
</p>

> Translation note: linked translations are inherited OpenBot documentation and have not yet been adapted to JarzRover. Use this English page for current JarzRover release instructions.

## Features

Click on the links below to read about the features of the apps.

- [Robot App](robot/README.md)
- [Controller App](controller/README.md)

## Install the apps

Download reviewed JarzRover APKs only from the [JarzRover releases](https://github.com/jarzlabs24/JarzRover/releases) page or an official link on [jarzlabs.com](https://www.jarzlabs.com/). Do not use the inherited OpenBot QR codes or release links; those install upstream OpenBot builds rather than JarzRover.

Website installation requires Android's **Install unknown apps** permission for the browser or file manager opening the APK. Verify the release version and published SHA-256 checksum before installation. Debug APKs generated during development are not public release artifacts.

## Build the apps

### Prerequisites

- [Android Studio Electric Eel | 2022.1.1 or later](https://developer.android.com/studio/index.html) for building and installing the apks.
- Android device and Android development environment with minimum API 21.
- Currently, we use API 33 as compile SDK and API 32 as target SDK. It should get installed automatically, but if not you can install the SDK manually. Go to Android Studio -> Preferences -> Appearance & Behaviour -> System Settings -> Android SDK. Make sure API 33 is checked and click apply.

![Android SDK](../docs/images/android_studio_sdk.jpg)

### Build process

1. Open Android Studio and select *Open an existing Android Studio project*.
2. Select the OpenBot/android directory and click OK.
3. If you want to install the [OpenBot app](robot/README.md) make sure to select the *app* configuration. If you want to install the [Controller app](controller/README.md), select the *controller* configuration. Confirm Gradle Sync if neccessary. To perform a Gradle Sync manually, click on the gradle icon.
  ![Gradle Sync](../docs/images/android_studio_bar_gradle.jpg)
4. Connect your Android device and make sure USB Debugging in the [developer options](https://developer.android.com/studio/debug/dev-options) is enabled. Depending on your development environment [further steps](https://developer.android.com/studio/run/device) might be necessary. You should see your device in the navigation bar at the top now.
  ![Phone](../docs/images/android_studio_bar_phone.jpg)
5. Click the Run button (the green arrow) or select Run > Run 'android' from the top menu. You may need to rebuild the project using Build > Rebuild Project.
  ![Run](../docs/images/android_studio_bar_run.jpg)
6. If it asks you to use Instant Run, click *Proceed Without Instant Run*.

### Troubleshooting

#### Versions

If you get a message like `The project is using an incompatible version (AGP 7.4.0) of the Android Gradle plugin. Latest supported version is AGP 7.3.0` you need to upgrade Android Studio or downgrade your gradle plugin. You can read more about the version compatablility between Android Studio and the gradle plugin [here](https://developer.android.com/studio/releases/gradle-plugin#android_gradle_plugin_and_android_studio_compatibility).
