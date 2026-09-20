# JarzRover brand assets

This directory keeps JARzLabs brand sources separate from generated platform exports. Do not overwrite a source file while preparing an Android, iOS, web, documentation, or social-media asset.

## Naming

- Organization and brand: **JARzLabs**
- Legal owner: **Aarambh LLC**, operating under the registered Alameda County fictitious business name **JARZLABS**
- Robotics product: **JarzRover**
- Upstream project: **OpenBot**
- Companion controller, when a distinction is needed: **JarzRover Controller**

Do not spell the brand as `JarzLabs`, `JARZLABS`, or `Jarzlabs` in user-facing product copy. Package names, source identifiers, URLs, and existing technical protocol names may use lowercase or legacy OpenBot identifiers where compatibility requires it.

## Sources

| File | Role | Status |
| --- | --- | --- |
| `source/jarzlabs-full-logo-transparent.png` | Full circular JARzLabs logo with tagline and activity labels | Official user-provided source; best for large-format material |
| `source/jarzlabs-brand-reference-front.png` | Wordmark, printer character, tagline, palette, and layout reference | Official user-provided brand reference; not an app icon |
| `source/jarzlabs-brand-reference-back.png` | Contact-card layout and service-icon reference | Official user-provided brand reference; may contain contact details that should be reviewed before publication |
| `review/jarzrover-app-icon-v1-wheel-hubs.png` | First checked-in square app-icon candidate | Superseded review version; currently still used by the Android manifest |
| `source/jarzrover-app-icon-master.png` | White-background printer/rover sketch with straight tires and no wheel-hub circles | Approved app-icon master as of 2026-09-19 |
| `review/jarzrover-app-icon-v2-straight-wheels.png` | Approved revision before promotion | Retained as review history; identical to the approved master |

The app icon intentionally omits the JARzLabs wordmark and tagline because those details are not legible at launcher sizes. The full logo remains the preferred large-format brand mark.

## Export policy

1. Choose one approved master; never export from an already-downscaled platform icon.
2. Preserve a white background for the current app-icon direction.
3. Keep the rover centered and front-facing, with straight parallel wheels.
4. Do not add text to launcher icons.
5. Generate platform sizes mechanically from the approved master with `./branding/export_app_icons.sh`.
6. Inspect at 1024, 192, 60, 40, and 20 pixels. Small sizes must retain the face and overall rover silhouette without looking like four eyes.
7. Keep Android robot, native iOS robot, and Flutter controller exports distinct. The robot apps can share the JarzRover mark; the companion controller needs an explicit decision about whether to add a controller badge.

## Attribution and ownership

The source and review images were supplied or directed by the JarzRover project owner; they are not OpenBot artwork. Copyright in the original JARzLabs/JarzRover brand assets is held by Aarambh LLC, doing business as JARZLABS. Their permitted use is defined in [`BRAND_POLICY.md`](../BRAND_POLICY.md); the repository's MIT software license does not grant trademark rights. Continue to credit OpenBot for the software ancestry in the app About screen and repository notices.

## Platform scope

The approved master is exported to the Android robot launcher resources and the native iOS robot asset catalog. The Flutter controller icon is intentionally unchanged until its shared-versus-badged identity is decided.

The exporter currently uses macOS `sips`, which is available on the supported iOS build host. If cross-platform brand generation becomes a contributor requirement, replace or complement it with a pinned image tool and verify byte and visual output before switching workflows.
