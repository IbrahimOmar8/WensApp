# Wens (ونس)

Wens is an Android app for people with Alzheimer’s disease and their caregivers. The patient gets simple medication reminders. The caregiver is notified when a dose is missed, can see the patient’s last known location, and keeps the patient’s basic medical data in one place.

Final project, CS599, Cairo University, Faculty of Graduate Studies for Statistical Research.

## Repository

| Folder | Content |
|---|---|
| `backend/` | Spring Boot REST API, MySQL schema (Flyway migrations) |
| `mobile/` | Flutter Android app (see `mobile/README.md`) |
| `Proposal_Wens_Alzheimer_App_2026.*` | Project proposal |
| `Wens_SRS_CS599.*` | Software Requirements Specification |

## Run the backend

Requirements: Java 17+, Maven, Docker (for MySQL).

```bash
docker compose up -d          # MySQL on localhost:3306
cd backend
mvn spring-boot:run
```

- Health check: http://localhost:8080/api/health
- Swagger UI: http://localhost:8080/swagger-ui.html

Run the tests with `mvn test` (they use an in-memory database, MySQL is not needed).

Database settings can be changed with the environment variables `DB_URL`, `DB_USER`, `DB_PASSWORD` and `JWT_SECRET`.

## Branches

- `main`: stable, demo-ready code
- `dev`: integration of features
- `feature/<name>`: one branch per task, merged into `dev` with a pull request

## Sprint plan

| Sprint | Weeks | Scope |
|---|---|---|
| 1 | 5-6 | Authentication, patient linking, patient profile |
| 2 | 7-8 | Medicines and schedules |
| 3 | 9-10 | Reminders, dose log, missed-dose alerts, appointments |
| 4 | 11-12 | Location, SOS, reports |
| Final | 13-14 | Testing, deployment, demo, documentation |
