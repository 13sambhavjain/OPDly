# Requirements: version 1

This document is the source of truth for what version 1 does. The reasons behind each choice are in [design decisions](decisions/README.md).

## Principles

1. **The clinic decides.** Each clinic chooses its fields, lists, rules and which features are on. OPDly ships with sensible defaults that the doctor edits in the app's settings. See [D-0001](decisions/0001-clinic-configurable-core.md).
2. **Manual always works.** Every section has a free-text note. Every automatic feature can be switched off. A clinic can use OPDly purely to store what it writes today.
3. **Suggestions, never decisions.** Anything filled in automatically (doses, extracted fields, prescription sets) stays editable and needs the doctor to confirm.
4. **Warnings can be loud but never block.** The doctor can always proceed.
5. **One clinic now, more later.** Every record belongs to a clinic, and version 1 runs a single one (clinic 1). See [D-0005](decisions/0005-multi-clinic-data-model.md).

## Roles

- Three roles: **patient < nurse < doctor**. A higher role can do everything a lower role can, but not the other way round.
- Login in version 1 is described in [D-0003](decisions/0003-login-v1.md).

## 1. Queue

- Patients join by scanning a QR code at the clinic. Nurses add walk-ins themselves. Both go into **one queue**.
- Tokens are unique and sequential. The queue resets daily or at times the clinic sets.
- Tokens that were skipped or missed are handled explicitly.
- Tokens expire, so the same person can't join twice.
- Joining is only open during OPD hours.
- The QR code is shown on a screen in the clinic and changes daily, with the day's code built in. A patient can also type the code by hand.
- The doctor sees the queue with basic details and chooses who goes next. The doctor can optionally notify the patient, through a live status page on the patient's phone or a notification, or simply call the name.
- Every queue rule above is a clinic setting.

## 2. Patient details and matching

- **Form fields:** name, date of birth (with an "approximate" option), gender, place, phone, "visited before?", and the patient ID if known.
- Phone is optional by default, and a clinic can make it required.
- The form is available in **Hindi and English**.
- **Matching:** OPDly finds possible earlier records and shows them **only to staff**. A nurse confirms the match. Records are never merged automatically. See [D-0002](decisions/0002-patient-matching.md).
- **Patient ID:** each patient gets an internal clinic ID, never an Aadhaar number. It is printed on prescriptions (also as a QR code) so the next visit is quick.

## 3. Visit screen

- **Header:** name, age (calculated from date of birth), gender and ID.
- **Special conditions** are picked from the clinic's list. For example, pregnancy records the last-period date and shows weeks and due date.
- For returning patients, **past records load automatically**.
- The screen then has these sections:
  - symptoms
  - analysis and notes
  - medicines
  - precautions
  - procedures
  - tests
- **Prescription sets:** the doctor's own sets, starting from a ready-made list the doctor can edit. Sets are suggested by symptom tags the doctor assigns. There is also "repeat last prescription".

## 4. Medicines and dose rules

- The doctor maintains the list of drugs and combinations, with timing, duration and precautions.
- **Dose rules** can use any field or combination of fields (for example age or weight), with exceptions.
- When a medicine is added, the dose fills in automatically and stays editable.
- Each rule can be tried on sample patients before it goes live.
- Optional starter lists are available. The clinic decides its actual list.
- Optionally, OPDly warns about **banned fixed-dose combinations**. The warning is loud and never blocks.

## 5. Tests

- Tests are added from the clinic's test list, and their prices feed into the bill.
- In version 1, results are attached as scans or typed in by the doctor. A lab module comes later (see [roadmap](roadmap.md)).

## 6. Hand-off

- When the visit is done, the doctor sends it either to the nurses or straight to the patient, choosing each time.
- **Nurse task list:** medicines to give, procedures to do and precautions to explain, each marked done as it's completed.

## 7. Billing

- The cost is calculated automatically from medicines, procedures and tests.
- The doctor can change the total and **lock** it. Nurses can't edit a locked cost.
- Whether nurses see the cost at all is a clinic setting.
- The doctor marks the cash as collected before handing off to the nurses.

## 8. Prescription output

- The doctor chooses whether the patient gets a copy, optionally including older records.
- Output is **A4 print**, or a **PDF download** when no printer is connected.
- Some fields will be hidden from the patient's copy. Which ones is still to be decided.
- The doctor's registration number goes on prescriptions and receipts. This is a legal requirement and is tracked in the [pre-release checklist](roadmap.md#pre-release-checklist).

## 9. Importing old records

- Scans are saved with the patient's record and marked **external / scanned**.
- Automatic reading of a scan produces **suggestions marked unverified** until the doctor confirms each field. See [D-0004](decisions/0004-automatic-assistance-scope.md).
- Handwritten documents are not read automatically in version 1.

## 10. Voice and text entry

- Voice typing from the device's keyboard works in every field.
- A "fill from text" box takes dictated or typed text and turns it into suggested fields, such as symptoms and durations.

## Assumptions for version 1

- The clinic has internet. A basic offline mode is planned for later.
- Only A4 printing is supported.
- There is one clinic.

## Glossary

| Term | Meaning |
|---|---|
| Visit | One patient's consultation on one day, from queue to hand-off |
| Token | A patient's place in a day's queue |
| Order | A medicine, procedure, test or precaution the doctor adds to a visit |
| Task | One thing a nurse must do for an order |
| Clinic settings | Everything the clinic decides: fields, lists, rules and switches |
| LMP | Last menstrual period date, used to calculate pregnancy weeks and due date |
