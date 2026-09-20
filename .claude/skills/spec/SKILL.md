---
name: spec
description: Use when starting a feature or bug fix (from a roadmap issue or ad hoc). Produces a validated micro-spec in docs/specs/ with EARS acceptance criteria BEFORE any code. Stops for human validation.
---
Keep it proportionate: a bug = a 5-line spec; a feature = the full template. Never re-run /prd or /architecture here.
1. Read CONSTITUTION, ARCHITECTURE (if present), and the issue. Run `researcher`.
2. Copy `docs/specs/TEMPLATE.md` to `docs/specs/<slug>.md`. Acceptance criteria in EARS notation:
   - Ubiquitous: "The system shall always <...>."
   - Event-driven: "When <event>, the system shall <...>."
   - State-driven: "While <state>, the system shall <...>."
   - Unwanted: "If <unwanted condition>, then the system shall <...>."
   - Optional: "Where <feature>, the system shall <...>."
   Each criterion = one future test. Split into independent slices, each with a file scope.
3. Display the spec and STOP. No code, no branch. Wait for "spec validated", then set the status to `validated`.
4. Then run the `build` skill right away on this spec, without waiting to be asked.
   Exception: if the user says "spec validated, hold", only set the status and stop. That is batch mode: several specs are validated first, then launched in parallel by `scripts/factory-next.sh`.
