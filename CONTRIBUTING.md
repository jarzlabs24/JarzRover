# Contributing to JarzRover

Thank you for helping improve JarzRover. JARzLabs maintains this project as an
OpenBot-derived, youth-led robotics project.

## Before you start

1. Search the [issues](https://github.com/jarzlabs24/JarzRover/issues) for an
   existing report or proposal.
2. Open an issue before starting a large feature, hardware change, new
   dependency, or protocol change.
3. Read [`docs/PROJECT_CONTEXT.md`](docs/PROJECT_CONTEXT.md). Hardware and
   firmware changes must also follow [`docs/HARDWARE.md`](docs/HARDWARE.md),
   [`docs/WIRING.md`](docs/WIRING.md), and [`docs/TEST_LOG.md`](docs/TEST_LOG.md).

## Development workflow

Fork the public repository, then clone your fork:

```bash
git clone https://github.com/<your-account>/JarzRover.git
cd JarzRover
git remote add upstream https://github.com/jarzlabs24/JarzRover.git
git checkout jarz-development
git checkout -b <short-feature-name>
```

Keep changes focused, document user-visible or hardware-visible behavior, and
never commit signing keys, passwords, API keys, or private service
configuration. Push your branch and open a pull request against
`jarz-development` in the JARzLabs repository.

## Checks

Run checks that match the code you changed. For Android work:

```bash
cd android
./gradlew :robot:assembleStandardDebug :robot:assembleMakerFaireDebug
./gradlew :controller:assembleDebug
./gradlew :robot:testStandardDebugUnitTest :robot:testMakerFaireDebugUnitTest
```

For Flutter controller work:

```bash
cd controller/flutter
flutter pub get
flutter analyze
flutter test
```

Python code should pass `black --check` for the files or package you changed.
Record device and hardware validation that you actually performed in
[`docs/TEST_LOG.md`](docs/TEST_LOG.md); do not report planned testing as a
completed result.

## Pull-request guidelines

- Explain the outcome in plain language.
- Link the related issue and list checks performed and checks not performed.
- Preserve OpenBot attribution and third-party license notices.
- Add the source and license for models, images, fonts, and other external assets.
- Keep generated binaries out of normal source commits; publish approved builds
  as release assets.
- Use `@jarvis414-bot` and `@jarzlabs24` for project ownership or review routing.

See [`docs/DISTRIBUTION.md`](docs/DISTRIBUTION.md) before packaging an app.
