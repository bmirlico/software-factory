---
name: architecture
description: Use after a PRD is validated, or for a major refactor. Produces docs/ARCHITECTURE.md, one ADR per structural decision, and DESIGN.md if there is a UI. Stops for human validation.
---
Prerequisites: a validated `docs/PRD.md`, and `docs/CONSTITUTION.md`.
Run `researcher` if code already exists. Then write `docs/ARCHITECTURE.md` (C4 context + containers level, no deeper):
1. Context: external systems, users. 2. Containers: services, apps, DB, queues, and their responsibilities.
3. Data model: main entities and relationships. 4. API contracts: main resources and endpoints (not the detail).
5. Cross-cutting choices: auth, error handling, logs/observability, config, migrations, deployment.
6. Mermaid diagram of the containers.
For every decision that is hard to undo (DB, framework, auth, hosting, native mobile lib): one ADR `docs/adr/NNNN-<slug>.md` with the alternatives considered.
If there is a UI: `DESIGN.md` (color/type/spacing tokens, base components, principles). Load the active design skill to write it.
Do not over-design: only what the PRD requires. Display the result and STOP. Wait for "architecture validated".
Once the user says "architecture validated", wire the chosen stack into the factory contract:
1. Replace every `TODO` recipe in the `Makefile` with the real commands for the stack. Keep the target names. A target that does not apply (e.g. `migrate` without a DB) becomes an explicit no-op with a comment.
2. Fill in the `<...>` placeholders in `docs/CONSTITUTION.md` (mandated stack) and in `backend/AGENTS.md`, `frontend/AGENTS.md`, `mobile/AGENTS.md`. Delete the directories the project does not need.
3. Replace the setup `TODO`s in `.github/workflows/ci.yml`.
Do not scaffold application code here: `make check` stays red until the first roadmap feature (the skeleton) is built, and that is expected.
Then run the `roadmap` skill right away, without waiting to be asked.
