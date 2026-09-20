# Security and secret-handling review

Status: initial repository audit completed 2026-09-19. Report security concerns privately to `jarzlabs24@gmail.com` until a dedicated security address and disclosure process are established. Do not open a public issue containing a credential, private user image, or exploitable vulnerability.

## Rules for contributors

- Never commit API secrets, service-account JSON, private keys, signing keystores, certificates, provisioning profiles, passwords, access tokens, visitor photos, or production `.env` files.
- Commit example configuration with placeholders only. Keep real local configuration ignored and inject it through the local environment or an untracked file.
- Treat mobile Firebase API keys as project identifiers rather than server secrets, but restrict them to the intended apps/APIs and protect backend data with Firebase Security Rules and, where appropriate, App Check.
- A public client configuration does not authorize JarzRover to use the upstream OpenBot project's backend. Use a project controlled by JARzLabs or disable the cloud feature.
- Revoke and replace a credential immediately if it is committed. Removing it in a later commit is not sufficient because Git history retains it.

## Audit performed

The 2026-09-19 review inspected tracked filenames, current tracked text, and Git history for high-confidence private-key headers and common OpenAI, GitHub, AWS, and Google service-account secret patterns. No matching high-confidence secret file was found. Values were deliberately not copied into this document.

Limitations:

- No dedicated entropy/provider scanner such as Gitleaks, TruffleHog, or GitHub secret scanning was available in the local environment. The regex review is not an equivalent replacement.
- The review cannot prove that a low-entropy password, unknown provider token, or secret embedded in a binary is absent.
- Access controls and Firebase Security Rules were not tested.

## Findings requiring resolution

Four tracked mobile client configurations point to the upstream OpenBot Firebase project:

- `android/controller/google-services.json`
- `android/robot/google-services.json`
- `android/robot/src/main/assets/google-services.json`
- `ios/OpenBot/OpenBot/GoogleService-Info.plist`

Firebase documents that its normal mobile API keys are public by design, but these files also bind the apps to a backend JARzRover does not own. Before public release, remove the upstream binding from default builds. Cloud/account features should be disabled by default or configured through documented, ignored local files and project-owned example templates. Confirm builds and non-cloud rover behavior after the change.

`open-code/.env` exists locally and is ignored. It was not inspected for this report and must remain untracked. `tools/creature-lab/.env.example` is tracked as a placeholder template; keep real Creature Lab credentials in an ignored `.env` file.

## Public-release gate

Before changing repository visibility:

1. Remove or optionalize the upstream Firebase configuration and verify all supported builds.
2. Run a maintained secret scanner across the full Git history and review results without publishing values.
3. Enable GitHub secret scanning/push protection if available for the public repository.
4. Verify that release archives contain no local `.env`, signing, provisioning, visitor-image, or debug data.
5. Document a private vulnerability-reporting route and response owner.

This gate is independent of app-store submission and applies to a public source repository.
