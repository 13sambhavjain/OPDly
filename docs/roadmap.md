# Roadmap

## Phases

| Phase | Goal | Status |
|---|---|---|
| 0. Design | Requirements, design decisions, tech stack | done |
| 1. Prototype | Version 1 [requirements](requirements.md) working end to end, with made-up data | next |
| 2. Clinic trial | Clinic 1 uses it day to day, and the doctor's feedback drives changes | — |
| 3. Pre-release | Every item in the checklist below done before real patient data goes in | — |
| Later | Items below, in an order chosen from feedback | — |

## Pre-release checklist

These must be done before real patient data is stored.

**Data protection (DPDP Act 2023 and Rules 2025)**
The main duties apply from about May 2027. A proposal to start them earlier had not been confirmed as of Oct 2026. ([Rules, PIB](https://static.pib.gov.in/WriteReadData/specificdocs/documents/2025/nov/doc20251117695301.pdf))
- [ ] A consent notice on the patient form, in Hindi and English
- [ ] Encryption in transit and at rest; access control by role
- [ ] An activity log kept for at least one year
- [ ] A breach-response process: report within 72 hours
- [ ] A way to handle requests to see, correct or erase a patient's data
- [ ] A published contact point for data questions
- [ ] A written agreement between the clinic (data fiduciary) and whoever hosts OPDly (data processor)
- [ ] If an external extraction service gets real data: patient notice and the provider's data terms ([D-0004](decisions/0004-automatic-assistance-scope.md))
- [ ] Per-person accountability on shared devices ([D-0003](decisions/0003-login-v1.md))

**Prescriptions**
- [ ] The doctor's registration number on prescriptions and receipts (IMC Regulations 2002, 1.4.1)
- [ ] Drugs written by generic name, legibly (IMC Regulations 2002, 1.5)
- [ ] A maintained source for the banned fixed-dose combination list (156 combinations banned in Aug 2024), if the warning is turned on

**Before offering OPDly to any other clinic**
- [ ] Recheck CDSCO guidance on medical-device software. Dose suggestions may count as clinical decision support.

## Later

- **Lab module:** a lab work list, results sent directly to the record
- **Basic offline mode** for when the internet drops
- **ABDM integration:** ABHA, Scan and Share, sharing records
- **Per-person login on shared devices** (PIN or passkeys)
- **Paid notifications** (SMS or WhatsApp), if the clinic wants them
- **Larger setups:** departments, separate nursing stations ([D-0005](decisions/0005-multi-clinic-data-model.md))
- Candidates from the [ideas backlog](ideas.md)
