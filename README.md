# Software Factory — récap de la structure

Template de repo pour une "software factory" pilotée par Claude Code : spec → build parallèle → vérification → PR → review sur la PR → merge humain.
Stack-agnostique : la stack ne vit que dans les cibles du `Makefile`.

Légende : **[V]** mécanique vérifiée dans les docs Claude Code / README des projets · **[D]** choix de design (à adapter) · **[O]** optionnel.

---

## 1. Principes

| # | Principe | Statut |
|---|---|---|
| 1 | Une interface unique (`Makefile`) appelée par toi, Claude, les agents et la CI. La stack ne vit que là | [D] |
| 2 | Vérification partout : Claude doit pouvoir lancer `make check` et voir le résultat (conseil n°1 d'Anthropic) | [V] |
| 3 | Deux points humains seulement : valider la spec, merger la PR | [D] |
| 4 | La review se fait sur la PR, jamais en local | [D] |
| 5 | Chaque erreur de Claude → une ligne dans `AGENTS.md` ("Pièges connus") | [V] |

---

## 2. Arborescence

```
repo/
├─ Makefile                      # couche 0 : contrat (dev, test, e2e, lint, fmt, typecheck, check, build, migrate)
├─ AGENTS.md                     # couche 1 : contexte racine (standard cross-outils ; Claude Code ≥ 2.1.277 le lit si aucun CLAUDE.md n'existe)
├─ backend/AGENTS.md             # conventions du langage backend
├─ frontend/AGENTS.md            # React web : conventions + skills Vercel à utiliser
├─ mobile/AGENTS.md              # React Native/Expo : conventions + skills Vercel à utiliser
├─ docs/CONSTITUTION.md          # principes non négociables (Spec Kit "constitution")
├─ docs/PRD.md · ARCHITECTURE.md · ROADMAP.md   # produits par /prd, /architecture, /roadmap (from scratch)
├─ docs/specs/                   # 1 micro-spec par feature (EARS), validée avant le code
├─ docs/adr/                     # décisions d'architecture
├─ .pre-commit-config.yaml       # couche 2 : lint avant commit
├─ .github/workflows/ci.yml      # couche 5 : make check + make e2e
├─ .github/workflows/claude.yml  # couche 5 : @claude sur issues/PR
├─ scripts/install-skills.sh     # skills/plugins/MCP à installer
└─ .claude/
   ├─ settings.json              # couche 3 : permissions + hooks
   ├─ hooks/stop-check.sh        # gate `make check` quand Claude pense avoir fini
   ├─ agents/                    # researcher, builder, verifier, simplifier, reviewer
   └─ skills/                    # prd, architecture, roadmap, spec, build, pr, design-review, techdebt [O]
```

---

### Note AGENTS.md
Depuis Claude Code 2.1.277 (18 sept. 2026), si un dossier n'a pas de CLAUDE.md, Claude lit AGENTS.md (activable/désactivable dans `/config`). Règle : **ne crée jamais de CLAUDE.md dans ce repo**, sinon il prend le dessus et AGENTS.md est ignoré à ce niveau. Même fichier lu par Codex, Cursor, Amp… [V]

## 3. Couche 0 — Contrat `Makefile`

| Cible | Rôle | Exemples par stack |
|---|---|---|
| `dev` | lance tout (deps via docker-compose + back + front) | uvicorn + vite / next dev / go run |
| `test` | tests unitaires + intégration, < 2 min | pytest / vitest / go test / cargo test |
| `e2e` | tests navigateur | playwright |
| `lint` | lint + format **check** (ne modifie rien) | ruff / eslint+prettier ou biome / golangci-lint / clippy |
| `fmt` | format + autofix | ruff format / prettier -w / gofmt / rustfmt |
| `typecheck` | types | mypy ou pyright / tsc / compilateur |
| `check` | `lint` + `typecheck` + `test` — le gate | ce que la CI et le hook Stop lancent |
| `build` | artefact prod | |
| `migrate` | migrations DB | alembic / prisma / … |

Transverse à toute stack : `gitleaks` (secrets), audit de dépendances (`pip-audit` / `npm audit` / `cargo audit`), `pre-commit`.
`make` n'est pas un standard formel mais une convention universelle ; `just` est une alternative équivalente. Choisis-en un et ne change plus.

---

## 4. Couche 3 — Configuration Claude Code

### 4.1 `settings.json` [V pour le format]

| Élément | Contenu |
|---|---|
| `permissions.allow` | `make *`, `git status/diff/log`, `gh pr *` |
| `permissions.deny` | édition de `.env*`, `git push --force`, `rm -rf` |
| Hook `PostToolUse` (Write\|Edit) | `make fmt` — format automatique après chaque édition |
| Hook `Stop` | `hooks/stop-check.sh` → `make check` ; si rouge, Claude continue |
| Hook `PostCompact` | réinjecte `AGENTS.md` après compaction du contexte |

### 4.2 Agents (`.claude/agents/`) — 4, stack-agnostiques

| Agent | Outils | Modifie le code ? | Rôle |
|---|---|---|---|
| `researcher` | Read, Grep, Glob | non | cartographie fichiers / dépendances / risques avant une spec |
| `builder` | Read, Edit, Bash | oui, **en worktree isolé** | implémente UNE tranche de spec dans un périmètre donné ; termine par `make check` vert. Lancé N fois en parallèle (backend/, frontend/…) |
| `verifier` | Read, Bash | non | lance `make check` + `make e2e`, rapporte les échecs fichier:ligne |
| `simplifier` | Read, Edit, Bash | oui | duplication, abstractions inutiles, code mort, `make check` doit rester vert |
| `reviewer` | Read, Grep, Glob, Bash | non | review indépendante du diff **contre la spec** (couverture EARS, hors périmètre, archi/ADR, robustesse). Verdict PRÊT / PAS PRÊT avant /pr |

Le `reviewer` est un gate automatique avant la PR ; la review humaine reste sur la PR (§6).

### 4.3 Skills à écrire (`.claude/skills/`)

| Skill | Déclencheur | Ce qu'il fait | Statut |
|---|---|---|---|
| `/prd` | nouveau projet / initiative majeure | ≤5 questions → `docs/PRD.md` (problème, personas, parcours, MoSCoW, non-objectifs, métriques) → **stop** | [D] |
| `/architecture` | PRD validé / refonte | `researcher` → `docs/ARCHITECTURE.md` (C4 contexte+conteneurs, données, API, transverses, Mermaid) + ADR par décision + `DESIGN.md` si UI → **stop** | [D] |
| `/roadmap` | archi validée | features ordonnées par dépendance puis valeur → `docs/ROADMAP.md` + issues GitHub | [D] |
| `/spec` | issue de roadmap ou ad hoc | `researcher` → micro-spec `docs/specs/<slug>.md` avec critères **EARS** → **s'arrête**, attend validation humaine | [D] |
| `/build` | spec validée | un sous-agent `builder` par tranche, en parallèle, chacun en worktree isolé → `verifier` → `simplifier` → `reviewer` vs spec | [D] |
| `/pr` | `make check` vert | description depuis spec + diff ; si UI modifiée → `before-and-after --markdown` ; push ; `gh pr create` | [D] |
| `/design-review` | tout changement UI | Playwright desktop+mobile, screenshots, `web-design-guidelines`, un seul lot de corrections, une confirmation, stop | [D] |
| `/techdebt` | fin de semaine | duplication, tests lents, ADR manquants → issues | [O] |

### 4.4 À installer (pas à écrire) — `scripts/install-skills.sh`

Front = React (web) + React Native → on s'appuie sur la collection officielle **vercel-labs/agent-skills** (installée via `npx skills add`, le CLI de Vercel Labs).

| Quoi | Source | Rôle | Statut |
|---|---|---|---|
| `react-best-practices` | vercel-labs/agent-skills | 70 règles perf React/Next.js, priorisées (waterfalls, bundle en critique). ~185K installs | [V] |
| `composition-patterns` | vercel-labs/agent-skills | patterns React qui scalent : compound components, lifting state, anti-prolifération de props booléennes | [V] |
| `web-design-guidelines` | vercel-labs/agent-skills | audit UI 100+ règles : a11y, focus, forms, perf, UX. Va chercher les règles à jour à chaque appel | [V] |
| `vercel-react-native-skills` | vercel-labs/agent-skills | 16 règles RN/Expo sur 7 sections : listes, Reanimated, safe areas, images, polices, monorepo | [V] |
| `react-view-transitions` | vercel-labs/agent-skills | API View Transitions en React | [V][O] |
| `before-and-after` | vercel-labs/before-and-after | screenshots avant/après dans la PR (`--markdown`, `--mobile`). Upload public 0x0.st par défaut → `--upload` custom si sensible | [V] |
| `find-skills` | vercel-labs/skills | Claude cherche un skill existant sur skills.sh avant d'en écrire un | [V] |
| `frontend-design` **ou** `impeccable` (un seul) | anthropics/skills · pbakaus/impeccable | direction esthétique | [V] |
| Plugins LSP (TS, Python) | marketplace officiel Anthropic | diagnostics après chaque édition | [V] |
| Context7 MCP · Playwright MCP | Upstash · Microsoft | docs à jour · navigateur | [V] |
| `code-review` plugin | marketplace officiel | review inline sur PR | [V] |
| Greptile MCP + `check-pr` / `greploop` | greptileai/skills | boucle jusqu'à confidence 5/5 (max 5 itérations) | [V][O] |
| `vercel-deploy-claimable`, `vercel-optimize` | vercel-labs/agent-skills | seulement si déploiement Vercel | [V][O] |
| Figma MCP | Figma | seulement si maquettes | [V][O] |

Non retenus de la collection Vercel : `writing-guidelines` (review de prose/docs, pas de code).
Mise à jour : `npx skills update -y`.

---|---|---|---|
| Plugins LSP (TS, Python, …) | marketplace officiel Anthropic | diagnostics après chaque édition | [V] |
| Context7 MCP | Upstash | docs de libs à jour | [V] |
| Playwright MCP | Microsoft | navigateur pour Claude | [V] |
| `frontend-design` **ou** `impeccable` (un seul) | anthropics/skills · pbakaus/impeccable | direction esthétique | [V] |
| `web-design-guidelines` | vercel-labs/agent-skills | audit a11y / UX / forms, 100+ règles | [V] |
| `react-best-practices` | vercel-labs/agent-skills | 70 règles perf React/Next (moitié Next-spécifique) | [V] |
| `before-and-after` | vercel-labs/before-and-after | screenshots avant/après dans la PR (upload public 0x0.st par défaut → `--upload` custom si sensible) | [V] |
| `code-review` plugin | marketplace officiel | review inline sur PR | [V] |
| Greptile MCP + `check-pr` / `greploop` | greptileai/skills | boucle jusqu'à confidence 5/5 (max 5 itérations) | [V][O] |
| Figma MCP | Figma | seulement si maquettes existent | [V][O] |

---

### 4.5 Deux niveaux de parallélisme

| Niveau | En parallèle | Outil | Visibilité |
|---|---|---|---|
| **Intra-feature** | les tranches d'une même spec | sous-agents natifs `builder` avec `isolation: worktree` (worktree créé, isolé, nettoyé par Claude Code ; rapport remonté au parent automatiquement) [V] | Ctrl+T (liste des tâches), panneau d'agents, transcription dépliable [V] |
| **Inter-features** | 2-3 features de la roadmap | une session `claude --worktree <feature>` par pane **herdr**, chacune lance son propre `/spec` → `/build` → `/pr` [V] | sidebar herdr : working / blocked / done par feature [V] |

Pourquoi pas des sessions séparées par tranche : Claude Code n'a aucun canal natif de remontée entre sessions ; il faudrait réécrire la plomberie de firstmate (spawn, attente, rapport, merge, teardown) en bash. Les sous-agents font tout ça nativement. herdr reste pertinent au niveau au-dessus, où il n'y a rien à remonter : chaque session se termine par sa PR.

Lancement automatique (`scripts/factory-next.sh N`) : le gate humain de la spec est déplacé **avant** le lancement.
```
pane principal (main) :  /roadmap  →  /spec f1 👤  /spec f2 👤   →  scripts/factory-next.sh 2
                          ↳ 2 panes herdr : claude --worktree f1 "/build → /pr"   (idem f2)
toi : sidebar herdr + PRs GitHub → merge → factory-next.sh 1 → feature suivante
```
Le script prend les specs `validée` sans PR ni worktree en cours et lance des sessions **interactives avec prompt initial** (pas `-p`) : si une session a besoin de toi, elle s'arrête sur sa question et attend dans son pane → `blocked` dans la sidebar herdr → tu réponds, elle repart. Les builders sont instruits de faire une hypothèse (notée dans le rapport) plutôt que de demander, sauf décision produit. Point fragile non vérifié : le format de `herdr pane list` pour récupérer l'id du pane.

## 5. Couche 4 — Boucle de production

```
FROM SCRATCH (pane principal, main) : idée → /prd → 👤 → /architecture → 👤 → /roadmap (issues)
SPECS PAR LOT (pane principal, main) : /spec f1 → 👤 · /spec f2 → 👤 · …
LANCEMENT AUTO                        : scripts/factory-next.sh N → N panes herdr, claude --worktree <f> "/build → /pr"
PAR FEATURE (session autonome)        : /build (builders ∥ → verifier → simplifier → reviewer vs spec) → /pr
                                        [question bloquante → pane `blocked` → 👤 répond]
GITHUB                                : CI → bots de review → 👤 merge → factory-next.sh 1 → suivante
```

Proportion : `/prd` et `/architecture` seulement au démarrage ou sur refonte ; une feature sur repo existant entre directement en `/spec` ; un bug = spec de 5 lignes. Un ADR seulement pour une décision difficile à annuler. (Inspiré de Spec Kit constitution→specify→plan→tasks, Kiro requirements EARS→design→tasks, BMAD brief→PRD→architecture→stories, sans leur cérémonie.)

Note sur Greptile 5/5 : bon gate automatique, pas un critère de merge — une IA qui satisfait une autre IA optimise l'approbation, pas la justesse. Les critères d'acceptation de la spec (transformés en tests) valident ; toi tu merges.

---

## 6. Couche 5 — CI/CD

| Fichier | Rôle |
|---|---|
| `ci.yml` | sur chaque PR : `make check` puis `make e2e` |
| `claude.yml` | `anthropics/claude-code-action` : `@claude` dans issues/PR (à générer idéalement via `/install-github-app`) |
| bot de review | `code-review` officiel et/ou Greptile |
| déploiement | preview par PR, prod sur tag — jamais depuis la machine de Claude |

---

## 7. Couche 6 — Amélioration continue

- Chaque correction → `AGENTS.md` "Pièges connus" (composition).
- `/loop 30m /babysit` sur les PRs ouvertes (rebase, adresser les reviews). [V]
- Sentry / logs en MCP pour partir du stack trace réel. [O]

---

## 8. Ordre de mise en place

| Quand | Quoi |
|---|---|
| Jour 1 | `Makefile` + `AGENTS.md` + `CONSTITUTION.md` + `settings.json` (3 hooks). 80 % de la valeur |
| Semaine 1 | 5 agents, `/spec`, `/build`, `/pr`, puis `/prd` `/architecture` `/roadmap` si nouveau projet, `ci.yml`, LSP, Playwright, `web-design-guidelines` |
| Mois 1 | `/build` parallèle, herdr pour plusieurs features, `/design-review`, `before-and-after`, `claude.yml`, bots de PR, `/babysit` |
| Jamais sans besoin prouvé | agent teams, orchestrateur externe (firstmate…), second skill design |

---

## 9. Démarrage

```bash
git init && git add . && git commit -m "chore: software factory scaffold"
# 1. remplir les cibles du Makefile pour ta stack
# 2. remplir backend/AGENTS.md et frontend/AGENTS.md
# 3. bash scripts/install-skills.sh
# 4. claude  →  /spec "ma première feature"
```
