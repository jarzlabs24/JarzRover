# Third-party software and asset review

Status: initial open-source audit completed 2026-09-19. This is an engineering inventory, not legal advice and not yet a complete release notice.

## Repository license baseline

JarzRover is derived from [OpenBot](https://github.com/ob-f/OpenBot). The root [`LICENSE`](../LICENSE) is the inherited MIT license and Intel ISL copyright notice. Keep that notice with redistributed source and substantial portions of the software. JarzRover documentation must identify OpenBot as the upstream project; a fork must not imply endorsement by the OpenBot maintainers.

JarzRover-specific code currently has no separate license header or exception. Unless the project owners decide otherwise, it is distributed under the repository's root MIT license. This statement does not automatically license trademarks, logos, generated media, training data, model weights, third-party packages, or hosted services.

## Assets and model weights

| Item | Location | Current evidence | Public-release status |
| --- | --- | --- | --- |
| OpenBot source, documentation, and inherited app resources | Repository-wide | Fork ancestry plus root MIT license | Retain the MIT license and upstream attribution. Review any individually marked file on modification. |
| OpenBot default TFLite models and labels | `android/robot/src/main/assets/networks`; `android/robot/download.gradle` | Files are downloaded from OpenBot's Google Cloud Storage bucket. The Android README identifies model families and COCO benchmarking, but the repository does not provide a model-by-model redistribution notice. | **Needs verification.** Record the source and applicable model/dataset notices before the public release. |
| Downloadable object-detection models | `android/robot/src/main/assets/config.json` | URLs point to OpenBot-hosted MobileNet, YOLOv4, YOLOv5, and EfficientDet files. | **Needs verification.** Model-family source-code licenses do not alone establish the license of a particular exported weight file. |
| JarzRover colored-ball model and labels | `colored_ball_yolov5.tflite`; `colored_balls.txt` | Added in commit `27aa942`. The JARzLabs team photographed and annotated the balls. The reviewed training session records a public Roboflow project named **OpenBot Colored Ball Detector**, 89 annotated images, three ball classes, and creation under default CC BY 4.0. See the [model card](models/COLORED_BALL_MODEL.md). | **Partially resolved.** Preserve the exact Roboflow project/dataset-version and export record, verify CC BY 4.0 applies to the distributed weights, and document actual split/preprocessing/augmentation, architecture/version, export settings, metrics, and attribution. If those cannot be established, omit the binary from the first public release. |
| JARzLabs logos, brand references, and JarzRover app icon | `branding/` and generated app resources | User-supplied or user-directed original project assets; not inherited OpenBot artwork. Aarambh LLC, doing business under the registered fictitious business name JARZLABS, was confirmed as copyright owner on 2026-09-20. | **Resolved for initial policy.** `BRAND_POLICY.md` reserves the marks while keeping covered software under MIT and permits limited truthful/official-release uses. Review with counsel if broader asset licensing or trademark registration is pursued. |
| Creature Lab inputs and generated creatures | Runtime only; successful results are held in a session gallery | Not intended to be checked into source control. Rights may depend on the visitor's input and the selected generation service's terms. | Document contributor/operator rules before publishing sample outputs or a hosted public service. Never commit visitor photos without explicit permission. |

COCO benchmark references describe evaluation data; they do not make every model weight or derived training dataset interchangeable. Preserve dataset and model notices separately.

## Dependency and binary inventory

The authoritative versions are in the listed manifests and lockfiles. Before the public release, generate a versioned transitive-license report for each shipped product and review any copyleft, non-commercial, source-available, or service-specific terms.

| Product/tool | Authoritative manifests | Audit note |
| --- | --- | --- |
| Android robot/controller | `android/build.gradle`, module `build.gradle` files, Gradle resolution | AndroidX, Material, TensorFlow Lite, Google Play/Firebase/ARCore, CameraX, WebRTC/RTSP, networking, image, permissions, BLE, and utility libraries are used. Their terms are not replaced by this repository's MIT license. Generate notices from the exact resolved graph. |
| Android downloaded AARs | `android/comlib/download.gradle` | `Wroup-master-release.aar`, `google-webrtc-1.0.32006.aar`, and `usbserial-6.1.0-release.aar` are fetched from an OpenBot bucket without pinned hashes or adjacent source/license metadata. Identify upstream source and license, record SHA-256, and fail on a mismatch before public release. |
| Native iOS robot | `ios/OpenBot/Podfile`, `Podfile.lock`, Xcode `Package.resolved` | Includes Firebase/Google SDKs, TensorFlow Lite Swift, GoogleWebRTC, Starscream, Socket.IO, ZIPFoundation, and others. Replace the TensorFlow Lite nightly dependency with a tested release if practical. Replace branch-based Socket.IO resolution with an immutable version or document the pinned revision. Generate acknowledgements for the resolved graph. |
| Flutter controller | `controller/flutter/openbot_controller/pubspec.yaml`, `pubspec.lock` | Generate notices from the locked pub graph and verify bundled fonts/images independently. |
| Creature Lab and web tooling | npm manifests/lockfiles under `tools/creature-lab`, `open-code`, and `policy`; Python requirements under `policy` and `tools` | Review each shipped service separately. Add or refresh lockfiles where reproducible installation is required; development-only tools need not appear in an app notice but still need license-compatible use. |
| Firmware | `firmware/` libraries and platform definitions | Confirm each Arduino/ESP32 library's source, version, and license when the supported firmware dependency set is locked. |

Google service SDKs and hosted APIs can carry product terms and configuration requirements in addition to open-source notices. A permissive SDK license does not grant access to another party's backend project.

## Required work before a public release

1. Complete the colored-ball [model card](models/COLORED_BALL_MODEL.md), verify the exact CC BY 4.0 dataset/weights record, and add required attribution—or exclude the binary and explain how contributors can supply/retrain one.
2. Verify the provenance, licenses, and hashes of downloaded AARs and OpenBot-hosted model files.
3. Produce transitive dependency reports/acknowledgements from the exact Android, iOS, Flutter, JavaScript, Python, and firmware release graphs.
4. Pin mutable/nightly dependencies or document why a reviewed immutable revision is used.
5. Add the final acknowledgements to repository documentation and, where appropriate, to the app About/legal UI.

Do not label this review complete merely because compilation succeeds. A build proves technical resolution, not redistribution rights.
