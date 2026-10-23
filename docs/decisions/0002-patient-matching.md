# D-0002: Staff confirm patient matches; patients never see records

- **Date:** 2026-10-23
- **Status:** accepted

## Context
Returning patients should be linked to their earlier records without retyping. A public form that lets patients look themselves up by name, age and place would show anyone in the clinic that a given person is a patient there. That is health information about someone else. A daily code or a clinic-network check stops strangers at home, but not other people in the waiting room.

## Decision
- The patient fills in the form and can say whether they have visited before.
- OPDly searches for possible matches and shows them **only to staff**. A nurse confirms the right one, or marks the patient as new.
- Records are **never merged automatically**. Families often share one phone number, and names are spelled in many ways.
- Phone number is an optional input, and a clinic can make it required.
- Each patient gets an internal clinic ID, never an Aadhaar number. It is printed on prescriptions to speed up the next visit.

## Consequences
- Each returning patient takes the nurse one tap to confirm.
- How patients are finally identified (the ID card or QR, phone) can still be refined later.

## Alternatives considered
- **Patients search for and pick their own record:** leaks the fact that someone is a patient. Rejected.
- **GPS or clinic-network checks to restrict who can search:** GPS is easy to fake and imprecise indoors. Network checks break when the clinic's internet address changes or patients use mobile data. Neither solves the waiting-room problem.
