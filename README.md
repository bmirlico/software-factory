# Software Factory - structure overview

Repo template for a "software factory" driven by Claude Code: spec → parallel build → verification → PR → review on the PR → human merge.
Stack-agnostic: the stack lives only in the `Makefile` targets.

Legend: **[V]** mechanic verified in the Claude Code docs / project READMEs · **[D]** design choice (adapt it) · **[O]** optional.

---

## 1. Principles

| # | Principle | Status |
|---|---|---|
| 1 | A single interface (`Makefile`) called by you, Claude, the agents and CI. The stack lives only there | [D] |
| 2 | Verification everywhere: Claude must be able to run `make check` and see the result (Anthropic's #1 tip) | [V] |
| 3 | Only two human touchpoints: validating the spec, merging the PR | [D] |
| 4 | Review happens on the PR, never locally | [D] |
| 5 | Every Claude mistake → one line in `AGENTS.md` ("Known pitfalls") | [V] |

---

## 2. Tree

```
repo/
├─ Makefile                      # layer 0: contract (dev, test, e2e, lint, fmt, typecheck, check, build, migrate)
├─ AGENTS.md                     # layer 1: root context (cross-tool standard; Claude Code ≥ 2.1.277 reads it when no CLAUDE.md exists)
├─ backend/AGENTS.md             # backend language conventions
├─ frontend/AGENTS.md            # React web: conventions + Vercel skills to use
├─ mobile/AGENTS.md              # React Native/Expo: conventions + Vercel skills to use
├─ docs/CONSTITUTION.md          # non-negotiable principles (Spec Kit "constitution")
├─ docs/PRD.md · ARCHITECTURE.md · ROADMAP.md   # produced by /prd, /architecture, /roadmap (from scratch)
├─ docs/specs/                   # 1 micro-spec per feature (EARS), validated before the code
├─ docs/adr/                     # architecture decisions
├─ .pre-commit-config.yaml       # layer 2: lint before commit
├─ .github/workflows/ci.yml      # layer 5: make check + make e2e
├─ .github/workflows/claude.yml  # layer 5: @claude on issues/PRs
├─ scripts/install-skills.sh     # skills/plugins/MCP servers to install
├─ scripts/factory-next.sh       # launches the next N validated specs, one Claude session each
└─ .claude/
   ├─ settings.json              # layer 3: permissions + hooks
   ├─ hooks/stop-check.sh        # `make check` gate when Claude thinks it is done
   ├─ agents/                    # researcher, builder, verifier, simplifier, reviewer
   └─ skills/                    # prd, architecture, roadmap, spec, build, pr, design-review, techdebt [O]
```

---

### Note on AGENTS.md

Since Claude Code 2.1.277 (Sept. 18, 2026), when a directory has no CLAUDE.md, Claude reads AGENTS.md (can be toggled in `/config`).
Rule: **never create a CLAUDE.md in this repo**, otherwise it takes over and AGENTS.md is ignored at that level.
The same file is read by Codex, Cursor, Amp... [V]

## 3. Layer 0 - `Makefile` contract

| Target | Role | Examples per stack |
|---|---|---|
| `dev` | starts everything (deps via docker-compose + back + front) | uvicorn + vite / next dev / go run |
| `test` | unit + integration tests, < 2 min | pytest / vitest / go test / cargo test |
| `e2e` | browser tests | playwright |
| `lint` | lint + format **check** (modifies nothing) | ruff / eslint+prettier or biome / golangci-lint / clippy |
| `fmt` | format + autofix | ruff format / prettier -w / gofmt / rustfmt |
| `typecheck` | types | mypy or pyright / tsc / compiler |
| `check` | `lint` + `typecheck` + `test` - the gate | what CI and the Stop hook run |
| `build` | production artifact | |
| `migrate` | DB migrations | alembic / prisma / ... |

Cross-cutting for any stack: `gitleaks` (secrets), dependency audit (`pip-audit` / `npm audit` / `cargo audit`), `pre-commit`.
Unfilled targets fail on purpose (`not configured`), so `make check` is red until `/architecture` fills them in; the Stop hook and CI know to ignore that state.
`make` is not a formal standard but a universal convention; `just` is an equivalent alternative.
Pick one and never change.

---

## 4. Layer 3 - Claude Code configuration

### 4.1 `settings.json` [V for the format]

| Item | Content |
|---|---|
| `permissions.allow` | `make *`, `git status/diff/log/add/commit`, `git push`, `gh pr *`, `before-and-after *` |
| `permissions.deny` | reading or editing `.env*`, `git push --force`, `rm -rf` |
| `PostToolUse` hook (Write\|Edit) | `make fmt` - automatic formatting after every edit |
| `Stop` hook | `hooks/stop-check.sh` → `make check`; if red, Claude keeps going |
| `SessionStart` hook (matcher `compact`) | re-injects `AGENTS.md` after context compaction (a `PostCompact` hook cannot: its output is not added to the context) |

### 4.2 Agents (`.claude/agents/`) - 5, stack-agnostic

| Agent | Tools | Modifies code? | Role |
|---|---|---|---|
| `researcher` | Read, Grep, Glob | no | maps files / dependencies / risks before a spec |
| `builder` | Read, Edit, Write, Bash, Grep, Glob | yes, **in an isolated worktree** | implements ONE spec slice within a given scope; ends with a green `make check`. Launched N times in parallel (backend/, frontend/...) |
| `verifier` | Read, Bash, Grep, Glob | no | runs `make check` + `make e2e`, reports failures as file:line |
| `simplifier` | Read, Edit, Bash, Grep, Glob | yes | duplication, needless abstractions, dead code; `make check` must stay green |
| `reviewer` | Read, Grep, Glob, Bash | no | independent review of the diff **against the spec** (EARS coverage, out of scope, architecture/ADR, robustness). Verdict READY / NOT READY before /pr |

The `reviewer` is an automatic gate before the PR; human review stays on the PR (§6).

### 4.3 Skills to write (`.claude/skills/`)

| Skill | Trigger | What it does | Status |
|---|---|---|---|
| `/prd` | new project / major initiative | ≤5 questions → `docs/PRD.md` (problem, personas, journeys, MoSCoW, non-goals, metrics) → **stop** | [D] |
| `/architecture` | validated PRD / major refactor | `researcher` → `docs/ARCHITECTURE.md` (C4 context+containers, data, API, cross-cutting, Mermaid) + one ADR per decision + `DESIGN.md` if UI → **stop** → once validated, fills the `Makefile` targets, the `<...>` placeholders (CONSTITUTION, per-directory AGENTS.md) and the `ci.yml` setup for the chosen stack | [D] |
| `/roadmap` | validated architecture | features ordered by dependency then value → `docs/ROADMAP.md` + GitHub issues | [D] |
| `/spec` | roadmap issue or ad hoc | `researcher` → micro-spec `docs/specs/<slug>.md` with **EARS** criteria → **stops**, waits for human validation | [D] |
| `/build` | validated spec | one `builder` subagent per slice, in parallel, each in an isolated worktree → `verifier` → `simplifier` → `reviewer` vs spec | [D] |
| `/pr` | green `make check` | description from spec + diff; if UI changed → `before-and-after --markdown`; then ships through the `no-mistakes` gate (review, tests, push, PR, CI watch) with the spec as intent; falls back to `git push` + `gh pr create` when it is not installed | [D] |
| `/design-review` | any UI change | Playwright desktop+mobile, screenshots, `web-design-guidelines`, one single batch of fixes, one confirmation, stop | [D] |
| `/techdebt` | end of week | duplication, slow tests, missing ADRs → issues | [O] |

The skills chain on their own: `/prd` is the single entry point of a new project.
Each skill stops at its human gate, and as soon as you pass it ("PRD validated", "architecture validated", "spec validated") it runs the next one: `/prd` → `/architecture` → `/roadmap` → `/spec` (first feature) → `/build` → `/pr`.
Say "spec validated, hold" to validate a spec without building it, which is what batch mode (`scripts/factory-next.sh`) needs.

### 4.4 To install (not to write) - `scripts/install-skills.sh`

Front = React (web) + React Native → we rely on the official **vercel-labs/agent-skills** collection (installed via `npx skills add`, the Vercel Labs CLI).

| What | Source | Role | Status |
|---|---|---|---|
| `react-best-practices` | vercel-labs/agent-skills | 70 prioritized React/Next.js perf rules (waterfalls and bundle as critical). ~185K installs | [V] |
| `composition-patterns` | vercel-labs/agent-skills | React patterns that scale: compound components, lifting state, no boolean-prop sprawl | [V] |
| `web-design-guidelines` | vercel-labs/agent-skills | UI audit with 100+ rules: a11y, focus, forms, perf, UX. Fetches the up-to-date rules on every call | [V] |
| `vercel-react-native-skills` | vercel-labs/agent-skills | 16 RN/Expo rules across 7 sections: lists, Reanimated, safe areas, images, fonts, monorepo | [V] |
| `react-view-transitions` | vercel-labs/agent-skills | View Transitions API in React | [V][O] |
| `before-and-after` | vercel-labs/before-and-after | before/after screenshots in the PR (`--markdown`, `--mobile`). Public upload to 0x0.st by default → custom `--upload` if sensitive | [V] |
| `find-skills` | vercel-labs/skills | Claude looks for an existing skill on skills.sh before writing one | [V] |
| `frontend-design` **or** `impeccable` (only one) | anthropics/skills · pbakaus/impeccable | aesthetic direction | [V] |
| LSP plugins (TS, Python, ...) | official Anthropic marketplace | diagnostics after every edit | [V] |
| Context7 MCP · Playwright MCP | Upstash · Microsoft | up-to-date library docs · browser for Claude | [V] |
| `code-review` plugin | official marketplace | inline review on the PR | [V] |
| Greptile MCP + `check-pr` / `greploop` | greptileai/skills | loops until confidence 5/5 (max 5 iterations) | [V][O] |
| `vercel-deploy-claimable`, `vercel-optimize` | vercel-labs/agent-skills | only if deploying to Vercel | [V][O] |
| Figma MCP | Figma | only if mockups exist | [V][O] |

Not retained from the Vercel collection: `writing-guidelines` (prose/docs review, not code).
Update: `npx skills update -y`.

---

### 4.5 Two levels of parallelism

| Level | In parallel | Tool | Visibility |
|---|---|---|---|
| **Intra-feature** | the slices of a single spec | native `builder` subagents with `isolation: worktree` (worktree created, isolated and cleaned up by Claude Code; report returned to the parent automatically) [V] | Ctrl+T (task list), agents panel, expandable transcript [V] |
| **Inter-feature** | 2-3 roadmap features | one `claude --worktree <feature>` session per **herdr** pane, each running its own `/spec` → `/build` → `/pr` [V] | herdr sidebar: working / blocked / done per feature [V] |

Why not separate sessions per slice: Claude Code has no native channel for reporting back between sessions; you would have to rewrite firstmate's plumbing (spawn, wait, report, merge, teardown) in bash.
Subagents do all of that natively.
herdr remains relevant one level up, where there is nothing to report back: every session ends with its PR.

Automatic launch (`scripts/factory-next.sh N`): the human spec gate is moved **before** the launch.
```
main pane (main):  /roadmap  →  /spec f1 👤 "hold"  /spec f2 👤 "hold"   →  scripts/factory-next.sh 2
                    ↳ 2 herdr panes: claude --worktree f1 "/build → /pr"   (same for f2)
you: herdr sidebar + GitHub PRs → merge → factory-next.sh 1 → next feature
```
The script picks the `validated` specs that have no PR and no worktree in progress, and launches **interactive sessions with an initial prompt** (not `-p`): if a session needs you, it stops on its question and waits in its pane → `blocked` in the herdr sidebar → you answer, it resumes.
Builders are instructed to make an assumption (recorded in the report) rather than ask, except for product decisions.
Unverified weak point: the output format of `herdr pane list` used to get the pane id.

## 5. Layer 4 - Production loop

```
FROM SCRATCH (main pane, main)    : idea → /prd → 👤 → /architecture → 👤 → Makefile filled → /roadmap (issues) → /spec f1 → 👤 → /build → /pr
SPECS IN BATCH (main pane, main)  : /spec f2 → 👤 "hold" · /spec f3 → 👤 "hold" · ...
AUTO LAUNCH                       : scripts/factory-next.sh N → N herdr panes, claude --worktree <f> "/build → /pr"
PER FEATURE (autonomous session)  : /build (builders ∥ → verifier → simplifier → reviewer vs spec) → /pr
                                    [blocking question → pane `blocked` → 👤 answers]
GITHUB                            : CI → review bots → 👤 merge → factory-next.sh 1 → next
```

Proportion: `/prd` and `/architecture` only at kickoff or on a major refactor; a feature on an existing repo goes straight into `/spec`; a bug = a 5-line spec.
An ADR only for a decision that is hard to undo.
(Inspired by Spec Kit constitution→specify→plan→tasks, Kiro requirements EARS→design→tasks, BMAD brief→PRD→architecture→stories, without their ceremony.)

Note on Greptile 5/5: a good automatic gate, not a merge criterion - an AI satisfying another AI optimizes for approval, not correctness.
The spec's acceptance criteria (turned into tests) validate; you merge.

---

## 6. Layer 5 - CI/CD

| File | Role |
|---|---|
| `ci.yml` | on every PR: `make check` then `make e2e` |
| `claude.yml` | `anthropics/claude-code-action`: `@claude` in issues/PRs (ideally generated via `/install-github-app`) |
| review bot | official `code-review` and/or Greptile |
| deployment | preview per PR, prod on tag - never from Claude's machine |

---

## 7. Layer 6 - Continuous improvement

- Every correction → `AGENTS.md` "Known pitfalls" (it compounds).
- Open PRs are kept healthy by `no-mistakes`: its CI monitor rebases and resolves conflicts on its own after checks pass. Without it, write your own babysit skill and run it with `/loop 30m`. [D]
- Sentry / logs as MCP to start from the real stack trace. [O]

---

## 8. Rollout order

| When | What |
|---|---|
| Day 1 | `Makefile` + `AGENTS.md` + `CONSTITUTION.md` + `settings.json` (3 hooks). 80% of the value |
| Week 1 | 5 agents, `/spec`, `/build`, `/pr`, then `/prd` `/architecture` `/roadmap` for a new project, `ci.yml`, LSP, Playwright, `web-design-guidelines` |
| Month 1 | parallel `/build`, herdr for several features, `/design-review`, `before-and-after`, `claude.yml`, PR bots, `no-mistakes` gate |
| Never without a proven need | agent teams, external orchestrator (firstmate...), second design skill |

---

## 9. Getting started

```bash
git init && git add . && git commit -m "chore: software factory scaffold"
# 1. bash scripts/install-skills.sh
# 2. new project:   claude  →  /prd "my idea"   (the rest chains; /architecture fills the Makefile and the AGENTS.md files)
#    existing repo: fill in the Makefile targets and the AGENTS.md files yourself, then  claude  →  /spec "my first feature"
```
