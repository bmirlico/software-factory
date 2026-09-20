---
name: prd
description: Use when starting a NEW project or a major initiative from an idea. Produces docs/PRD.md (problem, users, journeys, prioritized features, non-goals, metrics). Stops for human validation. Not for single features - use /spec.
---
Read docs/CONSTITUTION.md. Ask at most 5 questions if the idea is vague (users, problem, constraints, existing assets, success). Then write `docs/PRD.md`:
1. Problem and context (3-5 lines). 2. Personas (2-3). 3. Key user journeys (one per persona).
4. Features in MoSCoW (Must / Should / Could / Won't), each with: one sentence + value + dependencies.
5. Explicit non-goals. 6. Constraints (technical, legal, deadlines). 7. Success metrics.
Mark `status: draft`. Display the result and STOP. Write neither architecture nor code. Wait for "PRD validated".
Once the user says "PRD validated": set `status: validated`, then run the `architecture` skill right away, without waiting to be asked.
