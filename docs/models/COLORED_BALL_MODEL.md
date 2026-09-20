# JarzRover colored-ball model card

Status: provenance partially reconstructed on 2026-09-20. Complete the unknown fields before the first public repository release.

## Model artifact

| Field | Value |
| --- | --- |
| File | `android/robot/src/main/assets/networks/colored_ball_yolov5.tflite` |
| SHA-256 | `b1064086c9f9fc0fd2cd7f8698daaa04fe29c98a61cf50c64d8bbde9bf111a39` |
| Runtime integration | Android `DetectorYoloV5` colored-ball detector |
| Packaged labels | `colored_balls.txt`: `blue`, `green`, `red` |
| Git introduction | Commit `27aa942` on 2026-09-03 |

The binary contains generic TensorFlow Lite conversion metadata but no embedded author, Roboflow project, dataset version, YOLO implementation/version, or license string.

## Dataset and training evidence

The project owner confirmed that the JARzLabs team took the training photographs itself. The source images show red, green, and blue balls, including mixed-ball images. They were uploaded to Roboflow and manually annotated by the team.

A user-provided shared ChatGPT session was reviewed on 2026-09-20. It records:

- Roboflow project/model name: **OpenBot Colored Ball Detector**.
- The workspace allowed public models only and asked to create the project publicly under the default **CC BY 4.0** license; the recorded project-creation result says it was created under that license.
- The initial estimate was roughly 25 images for each color plus mixed-ball images.
- After annotation, Roboflow displayed **89 images** with bounding boxes.
- Roboflow class names were `red-ball`, `green-ball`, and `blue-ball`.
- A 80%/10%/10% train/validation/test split was recommended after the initial screen showed all 89 images in training and none in validation/test. The session does not establish the final applied counts.
- Auto-orientation was retained in the recommendation. Fit/letterbox/pad to 512×512 was recommended instead of stretch, but the final preprocessing setting is not established.
- Modest rotation, exposure/brightness, or blur were considered; hue/saturation changes were explicitly discouraged because color is the classification signal. The final augmentation settings are not established.
- Roboflow initially mentioned SAM-assisted annotation and a possible RF-DETR path. The shipped artifact is integrated as a YOLOv5-compatible TFLite detector, but the exact training architecture, implementation version, checkpoint, and export workflow are not established by the session or binary metadata.

The public-project/license statements above are provenance evidence from the recorded workflow. Before redistribution, preserve a Roboflow project/version URL or export manifest in the repository and verify that the exact dataset version and exported weights carry the stated license.

## Known label transformation

The Roboflow project used hyphenated class names, while the Android package uses short labels in a different order:

| Roboflow class | Android label |
| --- | --- |
| `red-ball` | `red` |
| `green-ball` | `green` |
| `blue-ball` | `blue` |

The local label order is blue, green, red. The export/conversion step that established this order is not recorded. Confirm it against the model output tensor or original export package; an incorrect order would assign the wrong rover behavior to a detected color.

## Intended behavior and limitations

The model detects red, green, and blue balls for JarzRover behaviors. Existing project records report physical colored-ball detection, but they do not constitute a formal evaluation of this exact artifact across lighting, backgrounds, cameras, distances, ball materials, or demographic contexts.

Known risks include:

- color shifts caused by lighting and phone-camera processing;
- a small, project-specific dataset and potentially correlated backgrounds;
- unknown final train/validation/test split and therefore possible leakage;
- no retained training metrics, confusion matrix, per-class precision/recall, or test predictions;
- unknown preprocessing/augmentation and exact model/export version; and
- labels whose order must be verified before behavior decisions are trusted.

This model must not be used for safety-critical perception. Sonar and explicit motion fail-safes remain independent safety layers; successful ball detection does not establish safe rover motion.

## Required completion evidence

Obtain from Roboflow or the other Mac and preserve without credentials:

1. Public project and exact dataset-version URL/identifier.
2. Dataset version generation date and final train/validation/test counts.
3. Exact preprocessing and augmentation configuration.
4. Training architecture, implementation/version, starting checkpoint, input dimensions, and training parameters.
5. Evaluation metrics and representative failure cases.
6. Exact export format, quantization, Roboflow/export-tool version, and label map supplied with the export.
7. A saved license/export record confirming CC BY 4.0 applies to the exact dataset version and distributed model weights.
8. The attribution text and link required by CC BY 4.0.

If this evidence cannot be recovered, exclude the binary from the initial public release and document a reproducible retraining path using a newly versioned dataset.
