# <Project>

## Commands - use ONLY these
`make dev` · `make test` · `make e2e` · `make lint` · `make fmt` · `make typecheck` · `make check` · `make build` · `make migrate`
`make check` = lint + typecheck + test. It must be green before any PR.

## Structure
- `backend/` - API (see backend/AGENTS.md)
- `frontend/` - React web UI (see frontend/AGENTS.md)
- `mobile/` - React Native/Expo app (see mobile/AGENTS.md)
- `docs/CONSTITUTION.md` - non-negotiable principles
- `docs/PRD.md`, `docs/ARCHITECTURE.md`, `docs/ROADMAP.md` - product, architecture, breakdown (from scratch or major refactor)
- `docs/specs/` - one micro-spec per feature (EARS criteria), validated by a human BEFORE the code
- `docs/adr/` - architecture decisions; read them before proposing a structural change

## Rules
- New project: /prd → /architecture → /roadmap → /spec. Feature: /spec → /build → /pr. Bug: /spec (5 lines) → /build → /pr.
- The skills chain on their own: each one runs the next as soon as its human gate is passed ("PRD validated", "architecture validated", "spec validated"). Never skip a gate.
- No feature without a validated spec in docs/specs/.
- Never work around a test or a lint rule: fix the cause.
- Small PRs, one intent per PR. Conventional commits (feat/fix/chore/refactor/test/docs).
- Review happens on the PR, not locally. Do not ask for a local review.
- When you get something wrong and I correct you: add a line under "Known pitfalls" below.

## Known pitfalls
<!-- grows with every correction -->
