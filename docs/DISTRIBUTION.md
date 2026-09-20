# JarzRover distribution guide

JarzRover source releases and installable applications are separate deliverables. Publishing source does not make an arbitrary development build safe to install, and publishing a binary does not make a private repository public.

## Official channels

- Source and release records: `https://github.com/jarzlabs24/JarzRover`
- Website and installation FAQs: `https://www.jarzlabs.com/`
- Support: `jarzlabs24@gmail.com`

Every distributed artifact must identify its source commit, version/build number, supported hardware, signing status, SHA-256 checksum, known limitations, and test evidence. Preserve the root MIT license, OpenBot attribution, third-party notices, and JARzLabs brand policy.

## Android robot and controller

Website and email distribution use release-signed APK files. Android App Bundles (`.aab`) are store-upload artifacts and are not direct-install replacements for APKs.

Before publishing an APK:

1. Build from a clean, reviewed commit with no local Firebase, `.env`, visitor images, debug data, or signing material in the source tree or packaged assets.
2. Use the long-lived JARzLabs release signing key. Never commit the keystore or passwords. Losing the key prevents seamless updates to existing installations.
3. Ensure the release is not debuggable and uses the intended package ID.
4. Install and exercise the exact APK on supported hardware.
5. Record the SHA-256 checksum and package/version information.
6. Publish installation, update, rollback, permissions, uninstall, and troubleshooting instructions.

Create the key through **Android Studio → Build → Generate Signed Bundle/APK →
Create new**, or with Java `keytool`. Copy `android/keystore.properties.example`
to the ignored `android/keystore.properties` and supply the real keystore path,
alias, and passwords. When that file is present, the Robot and native Controller
release builds use the same signing identity. Back up the `.jks` file and its
passwords in two secure locations; do not email or commit them.

Users installing from a website must allow **Install unknown apps** for the browser or file manager they use. They should disable that permission again afterward if they do not need it. Android developer/package verification requirements still apply to software distributed outside Google Play.

## iOS Flutter controller

A raw IPA cannot be installed on arbitrary iPhones merely by downloading it from email or a website. Supported routes are:

- Xcode development installation on a connected registered device;
- Ad Hoc distribution to device identifiers included in the provisioning profile; or
- TestFlight for external beta users after Apple's beta review.

Jarzlabs.com may host the FAQ and a TestFlight invitation link. Any Ad Hoc IPA must clearly state which registered devices it supports and when its signing/provisioning expires. Do not present an unsigned `.app`, unsigned IPA, or simulator build as an installable public binary.

## Release package layout

The first binary milestone should use a local untracked staging directory and publish only reviewed outputs:

```text
JarzRover-<version>/
├── android/
│   ├── JarzRover-Robot-<version>.apk
│   └── JarzRover-Controller-<version>.apk
├── ios/
│   └── JarzRover-Controller-<version>.ipa   # only when validly signed/provisioned
├── CHECKSUMS-SHA256.txt
├── INSTALL-ANDROID.md
├── INSTALL-IOS.md
├── RELEASE-NOTES.md
└── THIRD-PARTY-NOTICES.md
```

Build outputs and signing materials are not committed to Git. GitHub release assets or jarzlabs.com downloads must be derived from a recorded tag/commit.
