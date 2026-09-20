# <Projet>

## Commandes — utilise UNIQUEMENT celles-ci
`make dev` · `make test` · `make e2e` · `make lint` · `make fmt` · `make typecheck` · `make check` · `make build` · `make migrate`
`make check` = lint + typecheck + test. Il doit être vert avant toute PR.

## Structure
- `backend/` — API (voir backend/AGENTS.md)
- `frontend/` — UI web React (voir frontend/AGENTS.md)
- `mobile/` — app React Native/Expo (voir mobile/AGENTS.md)
- `docs/CONSTITUTION.md` — principes non négociables
- `docs/PRD.md`, `docs/ARCHITECTURE.md`, `docs/ROADMAP.md` — produit, archi, découpage (from scratch ou refonte)
- `docs/specs/` — une micro-spec par feature (critères EARS), validée par un humain AVANT le code
- `docs/adr/` — décisions d'architecture ; lis-les avant de proposer un changement structurel

## Règles
- Nouveau projet : /prd → /architecture → /roadmap. Feature : /spec → /build → /pr. Bug : /spec (5 lignes) → /build → /pr.
- Aucune feature sans spec validée dans docs/specs/.
- Ne contourne jamais un test ou un lint : corrige la cause.
- Petites PRs, une intention par PR. Commits conventionnels (feat/fix/chore/refactor/test/docs).
- La review se fait sur la PR, pas en local. Ne demande pas de review locale.
- Quand tu te trompes et que je te corrige : ajoute une ligne dans "Pièges connus" ci-dessous.

## Pièges connus
<!-- s'enrichit à chaque correction -->
