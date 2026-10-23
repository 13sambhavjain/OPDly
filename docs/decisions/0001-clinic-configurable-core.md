# D-0001: A clinic-configurable layer on a fixed core

- **Date:** 2026-10-23
- **Status:** accepted

## Context
Each clinic wants to decide its own fields, data types, lists and rules. If everything were configurable, though, OPDly would turn into a general form builder and rules engine before it became a clinic app. It would also be hard to test.

## Decision
- **Fixed core.** The code relies on these, so their structure is fixed: patient identity, visit, queue token, orders (medicine, procedure, test, precaution), nurse tasks, billing, users and roles.
- **Clinic-defined layer.** Each clinic defines these on top of the core:
  - **Lists:** conditions, symptoms, medicines and combinations, procedures, tests, prices, prescription sets.
  - **Extra fields:** the doctor chooses each field's type, unit, options and whether it's required. Values are stored alongside the core record.
  - **Feature switches:** each optional feature can be turned on or off.
- **Rules** use one small, fixed format: conditions on fields, with exceptions, lead to a suggested dose or a warning. They are never free-form code. Each rule can be tried on sample patients before it goes live.
- **Defaults.** OPDly ships with sensible defaults (for example weight, and last-period date with pregnancy weeks and due date). The doctor edits them in the app's settings, with no code change.

## Consequences
- New *kinds* of fields or rule conditions need a code change. New *values* (a new field, a new drug, a new rule) don't.
- A wrong rule silently suggests a wrong dose. That is why rules need the preview step, and why every suggested dose stays editable.

## Alternatives considered
- **Fully configurable (a form builder plus a scripting engine):** too large and too hard to test for version 1.
- **Fully fixed fields:** every clinic would need code changes for its own fields.
