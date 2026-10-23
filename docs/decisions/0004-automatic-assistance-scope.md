# D-0004: Scope of automatic assistance

- **Date:** 2026-10-23
- **Status:** accepted

## Context
OPDly uses models for convenience: reading scanned documents, turning dictated or typed text into fields, and helping with setup. These features handle patient data, and a misread value (for example a dose from an old prescription) could cause harm if accepted blindly.

## Decision
- **Convenience features only.** Their output is always a suggestion, marked as such, that the doctor can edit or reject.
- Extracted fields stay **unverified** until the doctor confirms each one. The original scan stays attached.
- **Handwritten documents are not read automatically** in version 1.
- **Real patient data is never sent to free-tier external services.** Their terms allow human review or reuse of what is sent, and some forbid personal data outright. Free tiers may be used with made-up test data only. Real data goes to a local model or a paid service whose terms exclude training on it.
- Extraction sits behind **one interface with swappable providers** (a local model or an external service). That lets accuracy, cost and speed be measured for each provider.

## Consequences
- Using an external provider with real data needs patient notice and the provider's data terms. This is in the [pre-release checklist](../roadmap.md#pre-release-checklist).
- A small set of made-up test documents is needed to measure extraction accuracy.

## Alternatives considered
- **Free-tier external services for everything:** not acceptable for patient data.
- **No automatic extraction:** it is the main time-saver for digitising old records.
