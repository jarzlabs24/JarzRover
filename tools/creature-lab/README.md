# JarzRover Creature Lab

Creature Lab is a computer-first experience that captures an object, generates an original creature concept through a separately configured local service, and displays recent discoveries in a session gallery.

The Android robot app and Flutter controller contain the capture/control experience. This directory contains the local web experience and server-side generation support. Firebase is not required.

## Local configuration

1. Copy `.env.example` to an untracked `.env` file.
2. Supply only the service settings needed by the selected local generation provider.
3. Never commit API keys, visitor photos, generated private data, or production `.env` files.
4. Keep the server on the same trusted network as the demo devices and use HTTPS for any remotely hosted generation endpoint.

The current gallery is session-only. Restarting the server clears its recent-creature list. See [project context](../../docs/PROJECT_CONTEXT.md) for the current interaction and visual-design decisions.
