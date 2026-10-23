# Ideas

These features are under consideration but not yet planned. When one is picked up, it moves to the [roadmap](roadmap.md).

## Assistance features
All of these follow [D-0004](decisions/0004-automatic-assistance-scope.md): suggestions only, which the doctor confirms.

1. **Voice to fields:** dictation such as "fever 3 days, dry cough" fills the symptom fields. The first version is a text box filled by keyboard voice typing. Later, a built-in microphone with a local speech model, given the clinic's medicine list as hints so drug names come out right.
2. **Medicine-rule setup helper:** the doctor writes a rule in plain words, for example "15 mg/kg every 6 h, max 4 doses", and a structured rule is drafted for the doctor to check.
3. **Better patient matching:** handle Indian name spellings, names written in both Hindi and English, and shared phone numbers. Compare a trained model with plain fuzzy matching, and measure both.
4. **Wait-time estimates** for patients, learned from past visit durations. This needs a few weeks of real data, and should be measured against a simple baseline.
5. **Plain-language reports:** for example "revenue by procedure this month", answered by queries against a read-only copy of the data, with strict limits.
6. **Typed-scan extraction accuracy set:** made-up prescriptions and reports, with known correct fields, to compare extraction providers.
7. **Decision models for routing:** these models pick from a fixed set of answers instead of writing text, for example TypeSafe's Jev or the OpenAI Decisions API (both launched Sep/Oct 2026). Possible non-clinical uses:
   - deciding what a scanned document is (prescription, lab report, ID card, other) so it goes to the right extractor
   - deciding which form section each piece of free text belongs to
   - ranking possible patient matches for staff to confirm
   - choosing which report to run

   Each use goes through the swappable-provider interface and is measured against a plain language-model call and a small local classifier. They are not to be used for picking treatment.

## Rules engine
- **ZEN engine** (GoRules) for dose rules and warnings. It is an MIT-licensed rules engine with a Python package (`zen-engine`) and decision tables: conditions on fields, with exceptions, leading to an output. It could implement the rule format in [D-0001](decisions/0001-clinic-configurable-core.md) instead of a custom engine. Its open-source visual rule editor could form the basis of the doctor's rule screen, though it may need simplifying for non-technical users. This is a deterministic engine, not a model.

## Clinical reference (opt-in per clinic, always shown with its source)
- **AIIMS protocol support for hypertension and diabetes.** A rule-based tool from AIIMS New Delhi is being offered through ABDM. Terms and access are unconfirmed, and it most likely depends on ABDM integration.
- **Drug-interaction information** shown as information only, for example from DDInter. Its licence is non-commercial.
- **The SNOMED CT India Drug Extension** as a long-term drug list. It is free in India under the NRCeS licence.

## Other
- The patient's live status page could play a sound when their turn is near.
- Printing the patient ID as a QR card at the first visit.
