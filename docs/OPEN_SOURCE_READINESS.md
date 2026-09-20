# JarzRover open-source readiness

Status: active from 2026-09-19. Read with [PROJECT_CONTEXT](PROJECT_CONTEXT.md), [HARDWARE](HARDWARE.md), [WIRING](WIRING.md), and [TEST_LOG](TEST_LOG.md).

## Objective

Prepare JarzRover as a maintainable JARzLabs open-source robotics project derived from OpenBot. Keep the working Android-phone-to-Arduino-Nano rover intact, make JarzRover branding consistent, include the current ball and Creature Lab work, and add a safe native iOS robot path through an ESP32. Preserve app-store work so it can be resumed without making it a current release gate.

## Decisions

- Product: **JarzRover** by **JARzLabs**.
- Android application ID: `com.jarzlabs.jarzrover`.
- Upstream: OpenBot remains the source project to follow and credit. JarzRover-specific work stays isolated enough to make upstream updates reviewable.
- Android rover baseline: Android phone to Arduino Nano over USB OTG. Existing pins, firmware behavior, and wiring are preserved.
- iOS rover architecture: native iOS app to ESP32 over BLE. This is an additional path, not a replacement for Android/Nano.
- Creature Lab: included in both the normal open-source build and the Maker Faire build.
- Accounts, Google Play, App Store Connect, signing, D-U-N-S, privacy forms, and submissions: deferred. Existing research remains in the app-store documents.
- Secrets: API keys, signing keys, provisioning material, and private service credentials must never be committed.

## Configuration model

The Android robot app has two distributions:

| Distribution | Purpose | Creature Lab | Event-specific behavior |
| --- | --- | --- | --- |
| `standard` | Normal development and open-source use | Enabled | Disabled |
| `makerFaire` | Demonstration/event setup | Enabled | Enabled |

Features inherited from OpenBot that are currently hidden while account/cloud code is being separated must be documented as transitional. Open-source readiness should prefer optional, understandable feature flags over permanently deleting reusable upstream functionality.

## Milestones

| ID | Milestone | Exit evidence |
| --- | --- | --- |
| OSS-001 | Integrate current work and normalize configurations | Latest `jarz-development` feature work and reviewed branding coexist; `standard` and `makerFaire` build and test |
| OSS-002 | Complete reusable branding assets | Source artwork, launcher/icon exports, screenshots, naming rules, and OpenBot attribution are documented and reproducible |
| OSS-003 | Audit licenses, provenance, and secrets | Dependency/model/asset provenance and notices are recorded; secret scan findings are resolved without exposing values |
| OSS-004 | Create contributor-ready project documentation | Root onboarding explains products, supported hardware, build paths, safety, contribution flow, and upstream relationship |
| OSS-005 | Establish CI and open-source releases | CI covers supported builds/tests; release artifacts, tags, changelog, limitations, and support policy are documented |
| AND-001 | Lock the Android/Nano reference configuration | Exact app, firmware, wiring, phone, and physical regression evidence are recorded without changing known-good pins |
| ESP-001 | Identify the ESP32 hardware and wiring | Board model, voltage levels, driver connections, power, pins, and photos/diagram are verified before firmware assumptions |
| ESP-002 | Define protocol and fail-safe ESP32 firmware | Versioned BLE service/commands, heartbeat, watchdog, STOP-on-loss behavior, telemetry, and bench evidence exist under `firmware/jarzrover-esp32` |
| IOS-001 | Add native iOS BLE manual control | Scan, connect, drive, stop, disconnect, background, reconnect, and stale-command behavior pass on a real iPhone and rover |
| IOS-002 | Add iOS camera and behavior features | Camera/inference, colored-ball behavior, and Creature Lab integration are added in tested increments after manual control is safe |
| QA-001 | Complete cross-platform physical validation | Android/Nano and iOS/ESP32 matrices identify exact revisions, observed passes, failures, and unrun checks |
| OSS-006 | Publish the open-source baseline | Public-facing repository, documentation, attribution, release notes, known limitations, and reproducible artifacts are reviewed |

## Execution order

1. Finish OSS-001: integrate current feature and branding work, replace the Play-only configuration, build both Android distributions, and record results.
2. Complete OSS-002 through OSS-004: finalize reusable brand assets, audit ownership/licenses/secrets, and make onboarding understandable to a new contributor.
3. Complete AND-001 while preserving the working Nano configuration.
4. Before ESP32 code, collect the exact board model and verify its motor-driver, sensor-voltage, pin, and power requirements in ESP-001.
5. Implement a small shared rover protocol and ESP32 BLE firmware with a hardware-independent STOP/watchdog test before motor testing.
6. Implement iOS manual driving and fail-safe lifecycle behavior. Add camera, ball, and Creature Lab functions only after the transport is reliable.
7. Run the physical regression matrix, establish CI/releases, and publish the reviewed open-source baseline.

## Current milestone: OSS-001

Acceptance criteria:

- The working branch contains the latest reviewed `origin/jarz-development` Creature Lab and rover-control changes plus the Android branding checkpoint.
- Android exposes `standard` and `makerFaire` distributions; both include Creature Lab.
- Both distributions assemble and their unit tests pass in the documented local SDK/JDK environment.
- App-store execution documents are marked deferred and link back to this plan.
- Actual results and limitations are added to TEST_LOG; no physical test is inferred from a software build.

## Current branding gate: OSS-002

Official source images and review candidates are inventoried in [`branding/README.md`](../branding/README.md). The approved app-icon master removes the eye-like wheel hubs while preserving straight tires and the white background. Reproducible exports target the Android robot, native Android controller, native iOS robot, and Flutter controller. For the first public milestone, the controller shares the JarzRover mark; a controller-badged variation can be considered later.

## Current publication gate: OSS-003

The license, provenance, and secret review is recorded in [THIRD_PARTY_LICENSES](THIRD_PARTY_LICENSES.md) and [SECURITY](SECURITY.md). The root OpenBot MIT license and attribution remain intact. A full 1,040-commit Gitleaks scan passes with a checked-in allowlist limited to inherited OpenBot Firebase client configurations that already exist in upstream/public history and CocoaPods checksum false positives. No JARzLabs private signing or service credential is allowlisted.

OSS-003 remains open. The public source repository may clearly identify these limitations, but signed public app binaries remain blocked until the project resolves:

- the remaining exact Roboflow dataset-version/export record, validation evidence, and CC BY 4.0 attribution for `colored_ball_yolov5.tflite`, as detailed in its [model card](models/COLORED_BALL_MODEL.md), or removal of that binary;
- source revisions and complete license notices for downloaded AARs and OpenBot-hosted model files (the three AAR hashes are now enforced by Gradle); and
- transitive acknowledgements plus mutable/nightly dependency review for each shipped app or service.

These are publication gates, not reasons to alter the known-working Nano wiring or rover behavior. Resolve them in small changes with builds/tests after configuration changes.

The upstream Firebase binding has been removed from the default source configuration. Firebase is now optional: public builds start without it, while authorized JARzLabs development devices can opt in with ignored local configuration as documented in [FIREBASE_SETUP](FIREBASE_SETUP.md). Build verification for that change is recorded in [TEST_LOG](TEST_LOG.md); backend Security Rules and an enabled-cloud-device test remain separate operational checks.

Brand ownership is resolved: Aarambh LLC, doing business under the registered Alameda County fictitious business name JARZLABS, owns the original JARzLabs/JarzRover brand assets. [`BRAND_POLICY.md`](../BRAND_POLICY.md) keeps covered software under MIT while reserving the names and artwork and allowing limited truthful/official-release uses.

## Returning to app stores later

Reactivate [APP_STORE_READINESS](APP_STORE_READINESS.md) and [RELEASE_BACKLOG](RELEASE_BACKLOG.md) only after an explicit product decision. Revalidate policies and SDK requirements at that time. Preserve the existing package/identity research, organization-account and D-U-N-S notes, privacy audit tasks, signing requirements, and store asset work, but treat all time-sensitive policy conclusions as needing a fresh check.
