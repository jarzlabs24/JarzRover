# JarzRover colored-ball model card

Status: provenance updated from the Roboflow evidence supplied on 2026-09-20. The dataset/version configuration is now recorded; the exact exported-weight license, training run, and model conversion record still need confirmation before signed binary redistribution.

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

A user-provided project handoff was reviewed on 2026-09-20. The Roboflow PDFs and screenshots supplied on 2026-09-20 add the following evidence:

- Roboflow project: **OpenBot Colored Ball Detector**, workspace slug `aarav-patel-k0rgk`, project slug `openbot-colored-ball-detector`. Browse URL: [`app.roboflow.com/aarav-patel-k0rgk/openbot-colored-ball-detector`](https://app.roboflow.com/aarav-patel-k0rgk/openbot-colored-ball-detector).
- The project was created as a public project under the default **CC BY 4.0** choice in the recorded workflow. Roboflow's project screen states that the public plan makes datasets public on Roboflow Universe; the exact Universe/license page for the exported version should still be preserved.
- The Browse capture shows original team photographs with bounding boxes and three color classes. The Create New Version capture shows **89 source images**, **3 classes**, and **0 unannotated** images.
- Version-generation evidence shows the 80%/10%/10% split applied as **71 training**, **9 validation**, and **9 testing** images.
- Preprocessing evidence shows **Auto-Orient: Applied** and **Fit (black edges) in 512×512**.
- The augmentation screen was opened and marked as a credit-using step, but the supplied capture does not show any selected augmentation values. It displays Roboflow's recommendation to set augmentations during training instead, because they run each epoch, add no images, and cost no credits. Do not infer a final augmentation recipe from this screen.
- The download dialog selected **YOLO v5 PyTorch** and showed the Roboflow Python SDK path: `project(...).version(1).download("yolov5")`. The screenshot also displayed a private API key warning; the key is intentionally not recorded. Never commit or share that snippet. Rotate the key if it was exposed beyond the authorized team.
- The linked training reference is the Roboflow YOLOv5 custom-data notebook: [train-yolov5-object-detection-on-custom-data.ipynb](https://colab.research.google.com/github/roboflow/notebooks/blob/main/notebooks/train-yolov5-object-detection-on-custom-data.ipynb). The notebook link documents the workflow, not the exact run parameters used for this artifact.
- The shipped artifact is integrated as a YOLOv5-compatible TFLite detector. The exact YOLOv5 implementation/commit, starting checkpoint, training epochs/hyperparameters, export command, quantization, metrics, and conversion tool version are still not established by the supplied evidence.

The public-project/license statements above are provenance evidence from the recorded workflow. Preserve the exact version URL/export manifest when the new version finishes generating, then verify that the exact dataset version and exported weights carry the stated license. Roboflow documents that uploaded images remain owned by the uploader; the team should retain the source-photo/annotation ownership record alongside the export evidence.

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
- the split is recorded as 71/9/9, but image-level leakage and the exact generated-version manifest have not been independently checked;
- no retained training metrics, confusion matrix, per-class precision/recall, or test predictions;
- unknown preprocessing/augmentation and exact model/export version; and
- labels whose order must be verified before behavior decisions are trusted.

This model must not be used for safety-critical perception. Sonar and explicit motion fail-safes remain independent safety layers; successful ball detection does not establish safe rover motion.

## Required completion evidence

Obtain from Roboflow or the other Mac and preserve without credentials:

1. The completed version URL/identifier and generation timestamp (the supplied screen shows the version-creation setup, not a completed export manifest).
2. Exact augmentation values, if any, and the final training configuration.
3. Training architecture, implementation/version, starting checkpoint, input dimensions, epochs, and hyperparameters.
4. Evaluation metrics and representative failure cases.
5. Exact export format, quantization, Roboflow/export-tool version, and label map supplied with the export.
6. A saved license/export record confirming CC BY 4.0 applies to the exact dataset version and distributed model weights.
7. The attribution text and link required by CC BY 4.0.

If this evidence cannot be recovered, exclude the binary from the initial public release and document a reproducible retraining path using a newly versioned dataset.
