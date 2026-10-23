# OPDly

Clinic management for small clinics:
- a patient queue that patients join by scanning a QR code
- a visit screen that loads a returning patient's history
- medicines with dose rules the doctor sets
- task lists for nurses, automatic billing, and printable prescriptions

OPDly runs in the browser and can be installed as an app.

**Status:** design is complete: requirements, design decisions and tech stack are written. The prototype is next, and there is no code yet.

**First user:** a single-doctor clinic with a few nurses. The data model also leaves room for larger setups, such as several departments or a hospital, without a rewrite.

## Documentation

| Document | What it holds |
|---|---|
| [Requirements](docs/requirements.md) | What version 1 does |
| [Architecture](docs/architecture.md) | How the parts fit together |
| [Development](docs/development.md) | Setting up the local environment |
| [Design decisions](docs/decisions/README.md) | Decisions, the reasons for them, and the alternatives considered |
| [Roadmap](docs/roadmap.md) | Phases, and the checklist that must be done before real patient data goes in |
| [Ideas](docs/ideas.md) | Features under consideration, not yet planned |
| [Changelog](CHANGELOG.md) | Notable changes |

## Tech stack

- **Web app:** React + TypeScript, installable as an app
- **Backend:** Django + Django Ninja (REST), with a separate FastAPI service for document extraction
- **Data:** PostgreSQL, Redis, Amazon DynamoDB
- **Infrastructure:** S3, SQS, Docker, GitHub Actions and Terraform on AWS

The reasons for each choice are in [D-0006](docs/decisions/0006-tech-stack.md).
