# D-0003: Login for version 1

- **Date:** 2026-10-23
- **Status:** accepted

## Context
A typical clinic has one doctor and fewer than ten nurses. Some nurses use their own phones, and the clinic also has shared devices. Fingerprint passkeys can't tell users apart on a shared device, because any fingerprint enrolled on that device unlocks every passkey stored on it.

## Decision
- On personal phones, each nurse and the doctor log in once and **stay logged in**.
- A shared device uses a **common nurse account**.
- There is no per-user PIN in version 1.

## Consequences
- The activity log can't tell which nurse acted on the shared device. Per-person accountability on shared devices is in the [pre-release checklist](../roadmap.md#pre-release-checklist).
- Sessions that stay logged in need a "log out everywhere" action for lost phones.

## Alternatives considered
- **A profile picker plus a personal PIN on shared devices:** possible later.
- **Biometric passkeys on shared devices:** can't identify the person. Passkeys make sense on each person's own phone, later.
