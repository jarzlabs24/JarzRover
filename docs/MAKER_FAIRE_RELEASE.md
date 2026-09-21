# JarzRover Maker Faire Android release

This is the first local binary package for Maker Faire distribution. It is not a Google Play release and does not include an iOS installable binary.

## Artifacts

Build source: `jarz-development`, version `v0.8.0`, version code `800`.

| Artifact | Package name | SHA-256 |
| --- | --- | --- |
| `controller-release.apk` | `com.jarzlabs.jarzrover.controller` | `5b3ed4ce8cea58e8de6a3ad50a17b4ebfd637635bb5a159c6cabc4ef6993e57b` |
| `robot-standard-release.apk` | `com.jarzlabs.jarzrover` | `5f7b07973c0447e870902e0a4b2bc1de86eac62b3292a3f3cf05f4b367dc3e0a` |

Both APKs are signed with the JARzLabs `jarzrover-app` release key. Keep the keystore and passwords private and use the same key for all future updates.

## Installation order

1. Install `robot-standard-release.apk` on the Android phone mounted to the rover.
2. Install `controller-release.apk` on the visitor/controller phone.
3. Allow **Install unknown apps** for the browser or file manager used to open the APK, then disable that permission again afterward if it is no longer needed.
4. Open the Robot app first and select the expected USB/control mode.
5. Open the Controller app and connect to the robot phone.
6. Test manual driving, camera/connection status, Creature Lab, colored-ball behavior, disconnect/reconnect, and restart before the event.

## Scope and limitations

- The owner physically verified the two APKs with the rover after installation.
- The Android Developer Console package registrations are complete for both package names.
- The APKs target SDK 32. Revisit Android target/toolchain requirements before Google Play submission.
- iOS distribution is not included: a valid Apple signing identity and provisioning/TestFlight or Ad Hoc route are still required.
- This bundle does not include a Roboflow API key, Firebase service credential, Android keystore, or any other private signing/service material.
