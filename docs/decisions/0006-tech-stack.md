# D-0006: Tech stack

- **Date:** 2026-10-23
- **Status:** accepted

## Context
- OPDly needs:
  - a web app that installs like a phone app, with a patient QR form that opens in any browser
  - a backend with many roles and permissions, and back-office lists to manage
  - live queue updates
  - slow background work, such as reading scans and turning text into fields
  - printable PDFs
- It may grow from one clinic to a hospital ([D-0005](0005-multi-clinic-data-model.md)).
- It should cost close to nothing while it is built and tried out.
- It is also a learning project, so each technology must have a clear job in the app.

## Decision

| Layer | Choice | Its job here |
|---|---|---|
| Web app (installable) | React + TypeScript (Vite), Tailwind CSS, shadcn/ui, TanStack Query, React Hook Form + Zod. Packaged as a PWA; Capacitor later for store apps | One codebase for patients (browser, via QR), nurses (phones) and the doctor (laptop or tablet) |
| Main backend | **Django + Django Ninja** (REST, with an OpenAPI schema; the TypeScript client is generated from it) | Patients, visits, queue, orders, billing, users, roles, and the admin panel for back-office lists |
| Extraction service | **FastAPI** | Reads scans and turns dictated or typed text into suggested fields. It runs apart from the main backend, either in the cloud or on a machine in the clinic with a local model, and can be swapped or scaled on its own ([D-0004](0004-automatic-assistance-scope.md)) |
| Clinical data | **PostgreSQL** (clinic-defined fields in JSON columns) | All patient and clinic data in one place. Related changes save together or not at all, and there is one place to export or erase a patient's data |
| Live state | **Redis** | Live queue updates to screens (server-sent events), rate limits on the public QR form, caching |
| Activity log | **Amazon DynamoDB** | An append-only log. The app's credentials can add entries but not change or delete them |
| Files and jobs | **Amazon S3**, **Amazon SQS** | Scans and PDFs (uploaded straight to S3); jobs from the main backend to the extraction service |
| PDFs | WeasyPrint | The same A4 prescription layout for print and download |
| Delivery | Docker, docker-compose, GitHub Actions, Terraform, **AWS Mumbai (ap-south-1)** | The same setup on a laptop, in CI and in the cloud. Infrastructure is defined as code |
| Quality | pytest, Playwright, Sentry | Unit and API tests, browser tests, error tracking |

Each piece is added when the first feature that needs it is built, not all up front:

| Piece | Arrives with |
|---|---|
| Django, PostgreSQL, React | the first screens |
| Redis | the live queue screen |
| S3, SQS, FastAPI | scan import |
| DynamoDB | the activity log |
| AWS, Terraform | the first deployment |

## Consequences
- **Two backend frameworks.** The only boundary between them is the extraction service. Everything else lives in Django.
- **Clinical data stays in PostgreSQL only.** Redis holds short-lived state, and DynamoDB holds only the activity log.
- **Local development** runs everything in Docker. LocalStack stands in for S3, SQS and DynamoDB.
- **Cost.** At one clinic's volume, S3, SQS, DynamoDB and CloudFront cost almost nothing. Compute and the database are the real costs once AWS credits run out. The hosting shape (a single server or managed services) is decided at the first deployment, together with where the data lives.
- **Live updates use server-sent events, not WebSockets.** Django serves them through async views, which is enough for a queue.

## Alternatives considered
- **FastAPI only:** we would have to assemble the database layer, migrations, login, permissions and admin panel ourselves. Django already provides them.
- **Django only:** extraction could not run separately, for example on a clinic machine with a local model.
- **Flask:** for a new API, FastAPI covers everything Flask offers and adds typing, validation and API docs.
- **MongoDB for patient data:** it would split records across two databases, lose saves that succeed or fail together, and double the work of exporting or erasing a patient's data. PostgreSQL JSON columns cover clinic-defined fields.
- **Next.js:** its server side duplicates the backend, and Capacitor needs a static build anyway.
- **Expo (React Native):** a weaker web app. It remains the option if native apps become the priority.
- **Kubernetes, microservices, GraphQL:** not justified for this size.
