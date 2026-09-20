# Optional JARzLabs Firebase setup

JarzRover does not require Firebase for rover control, the local model configuration, colored-ball detection, or Creature Lab. A fresh clone therefore builds and runs without a Firebase account and does not connect to either JARzLabs or OpenBot cloud services.

JARzLabs may still use its own Firebase project on authorized development or Maker Faire devices. The mobile configuration files identify the Firebase project and apps; they are not service-account private keys. They are nevertheless kept out of this repository so public builds do not automatically use a shared JARzLabs backend. Firebase Security Rules, restricted APIs and, where appropriate, App Check remain the actual backend protections.

Never put a service-account JSON file, private key, access token, signing key, or visitor data in this repository.

## Android robot app

1. In the JARzLabs Firebase console, register or select the Android app whose package name is `com.jarzlabs.jarzrover`.
2. Download that app's `google-services.json`.
3. Place it at `android/robot/google-services.json`.
4. Build the robot app normally. Gradle detects the local file, applies the Google Services plugin, and enables the legacy Firebase/Google sign-in implementation for that build.

The file is ignored by Git. Do not force-add it. The Android controller does not need a Firebase configuration.

The inherited OpenBot QR/Google Drive project importer additionally reads a client configuration from the app assets. That feature is hidden in the current JarzRover interface. If it is intentionally restored, copy the same local configuration to `android/robot/src/main/assets/google-services.json`; that path is ignored too. This extra copy is not needed for JarzRover's normal model, ball, rover, or Creature Lab flows.

## Native iOS robot app

The native iOS app also starts without Firebase. To test the inherited account/Google Drive code on an authorized development device:

1. Register or select the iOS app for the bundle identifier currently shown by the JarzRover Xcode target (`org.jarzlabs.openbot` at the time of this note).
2. Download `GoogleService-Info.plist` and place it at `ios/OpenBot/OpenBot/GoogleService-Info.plist`.
3. In Xcode, add that local file to the OpenBot target and its Copy Bundle Resources phase.
4. Add the plist's `REVERSED_CLIENT_ID` as the target's Google callback URL scheme.
5. Keep the resulting local project-file changes out of commits unless the project later adopts a credential-free generated configuration mechanism.

The plist itself is ignored by Git. Account/cloud screens remain transitional inherited functionality and are not part of the default JarzRover experience.

## Maker Faire devices

Install the local JARzLabs configuration only on devices that actually need an account/cloud demonstration. The normal Maker Faire rover and Creature Lab setup does not need Firebase. Do not distribute service-account credentials to visitors or contributors, and do not rely on the client configuration alone to protect stored data.
