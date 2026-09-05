# JarzRover test log

## Historical baseline

Recorded on 2026-09-04 from the user's JarZLabs handoff. Original test dates, firmware revisions, measurements, and detailed procedures were not supplied. These are user-reported completed tests, not tests rerun during this documentation work.

| Test / observation | Reported outcome | Limits / current status |
| --- | --- | --- |
| Direct wiring without breadboard | Robot successfully operated | Exact as-built schematic not recorded |
| Left motor test | Completed successfully | Speed, load, and procedure not recorded |
| Right motor test | Completed successfully | Speed, load, and procedure not recorded |
| HC-SR04 serial readings | Eventually worked | Fix, sketch, accuracy, and range not recorded; sonar currently disabled in checked-in DIY firmware |
| Android USB OTG power to Nano | Nano powered from phone | Full robot still requires proper battery power |

## Documentation verification — 2026-09-04

Inspected `firmware/openbot/openbot.ino` at commit `5d7e4ce`: `OPENBOT DIY`, `MCU NANO`, and all pin assignments in [HARDWARE.md](HARDWARE.md) match the source. Sonar, front speed sensors, indicators, voltage-divider sensing, and OLED are disabled in the DIY block. No firmware was changed and no physical robot tests were run for this setup.

## Current development status

OpenBot object navigation / green-ball behavior is the active focus. End-to-end detection, centering, approach, stopping, and target-loss behavior have no recorded acceptance result in the supplied history. Standalone sonar success must not be treated as proof of integrated obstacle handling.

Creature Lab's computer-camera flow is under active development in `tools/creature-lab`. Code-level build results should be recorded below; camera interaction and the complete visitor flow remain unverified until they are tested in a browser with a real object.

## Creature Lab build verification — 2026-09-05

- Added local creature details: generated name, type, description, and special ability derived from the captured image's sampled colors.
- `npm run build`: pass.
- Focused `oxlint` check for `app/page.tsx` and `app/api/generate/route.ts`: pass.
- Local development route at `http://localhost:3000/`: HTTP 200.
- Full-project `npm run lint`: fail because of 19 existing findings in generated `components/ui/*` and `hooks/use-mobile.ts` files; no reported finding was in the Creature Lab page or generation route changed for this step.
- Real camera capture, retake, local transformation, result display, and timing: not run by Codex; requires user interaction in the browser.

## Creature Lab recognition refinement — 2026-09-05

- User verified that real AI image generation and AI creature abilities work.
- User observed that some photos prioritize people instead of the intended object and that the camera background appears blurred.
- Capture was changed to send only the centered square guide area rather than the entire camera frame.
- Object-analysis image detail was raised to high, and both AI prompts now explicitly exclude people and body parts as possible subjects.
- The apparent live-camera blur is not applied by Creature Lab capture code; check macOS camera Video Effects / Portrait mode during browser testing.

## Creature Lab art direction — 2026-09-05

- User reported that the initial AI artwork did not match the intended creature-collecting illustration aesthetic.
- The image prompt now specifies original retro anime creature art using hand-inked variable linework, simple rounded silhouettes, expressive geometric eyes, muted watercolor-like color, restrained cel shadows, and a warm paper-wash presentation.
- The prompt explicitly excludes photorealism, 3D rendering, copied characters, and named-artist imitation.
- Visual output from the revised prompt remains to be tested with a new user-approved camera image.

## Creature Lab morphology refinement — 2026-09-05

- User observed that generated creatures overused an upright two-arm, two-leg, ears-and-tail body plan.
- Reference examples were reviewed for high-level morphology only: limbless, quadruped, and radial/floating silhouettes. No reference character is supplied to the generation API or requested for imitation.
- Object analysis now chooses an explicit body plan and two to four source-specific defining features before image generation.
- The image prompt receives that design decision and prohibits replacing it with a generic upright mascot.
- Revised morphology output remains to be tested with new user-approved camera images.

## Creature Lab abstraction refinement — 2026-09-05

- User tested a screwdriver and observed that the result remained essentially a screwdriver with a face.
- The design rule is now "creature first, object inspiration second": reinterpret two or three source traits and invent the remaining creature anatomy.
- Prompts now reject preserving the entire object outline, recommend purposeful locomotion appendages, and tell the model to translate tool functions into distributed features such as claws, horns, arms, armor, markings, or abilities.
- Revised abstraction remains to be tested with another user-approved screwdriver generation.

## Creature Lab rendering-style refinement — 2026-09-05

- User confirmed that the object-to-creature concept now looks good but reported excessive watercolor treatment and an inaccurate rendering style.
- New references were reviewed for high-level rendering characteristics only: clean controlled outlines, flat base colors, minimal cel shading, small highlights, and white backgrounds.
- The prompt now explicitly excludes watercolor washes, paper texture, brush or pencil grain, painterly rendering, heavy gradients, photorealism, and 3D surfaces.
- Revised rendering style remains to be tested with a new user-approved generation.

Next checks should establish installed hardware and flashed firmware, then verify green-ball behavior incrementally. Record actual observations rather than marking planned checks as passed.

## Future entry template

- Date and tester:
- Goal / behavior tested:
- Firmware or app revision and feature flags:
- Hardware, wiring, and power configuration:
- Procedure and expected result:
- Actual result / measurements:
- Outcome: pass, fail, partial, or not run:
- Hardware-impacting changes and follow-up:
