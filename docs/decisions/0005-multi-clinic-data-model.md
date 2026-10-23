# D-0005: A multi-clinic data model, ready for larger setups

- **Date:** 2026-10-23
- **Status:** accepted

## Context
Version 1 serves one small clinic, where the doctor and nurses share a room. A larger setup, such as a hospital, has departments, separate nursing stations and a lab, and staff who are not in the same room. Building hospital features now would sink the project. A few data-model choices, though, cost almost nothing now and would be expensive to retrofit.

## Decision
- **Every record carries a clinic ID.** Version 1 runs clinic 1.
- **Places** form a hierarchy: organisation → facility → department → location (a room, a nursing station, a lab). A small clinic has one of each.
- **A queue belongs to a location plus a service**, so a larger setup simply has many queues.
- **Nurse tasks are sent to a location's work list**, not to "the nurse in the room". Each task has a status (pending, acknowledged, done). There is room for a "question for the doctor" channel.
- **Visits and prescriptions are shaped to map onto ABDM's FHIR records** (OPConsultRecord, PrescriptionRecord). Drug codes are stored, and there is an optional ABHA field. Connecting to ABDM itself comes later.

## Consequences
- Version 1 screens assume one clinic and one location, but the data model doesn't need to change for more.
- Permissions can later be set per role and per department.

## Alternatives considered
- **Single-clinic tables without a clinic ID:** cheaper today, but painful to change later.
- **Building hospital features now:** out of scope until a hospital actually wants it.
