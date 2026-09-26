# ============================================================
# SINGLE CONTRACT - called by the human, Claude, the agents, CI
# Fill in the targets for your stack. Do not rename them.
# Unfilled targets FAIL on purpose: a green `make check` must mean something.
# ============================================================
.PHONY: dev test e2e lint fmt typecheck check build migrate help

not_configured = @echo "make $@: not configured. Replace this recipe with your stack's command (README §3)." >&2; exit 1

help:            ## List the targets
	@grep -E '^[a-z]+:.*##' $(MAKEFILE_LIST) | awk -F':.*##' '{printf "  %-10s %s\n", $$1, $$2}'

dev:             ## Start deps + backend + frontend
	$(not_configured)
	# e.g. docker compose up -d && (cd backend && <run>) & (cd frontend && <run>)

test:            ## Unit + integration tests (< 2 min)
	$(not_configured)
	# e.g. (cd backend && pytest -q) && (cd frontend && npx vitest run)

e2e:             ## Browser tests
	$(not_configured)
	# e.g. (cd frontend && npx playwright test)

lint:            ## Lint + format CHECK (modifies nothing)
	$(not_configured)
	# e.g. (cd backend && ruff check . && ruff format --check .) && (cd frontend && npx eslint . && npx prettier -c .)

fmt:             ## Format + autofix
	$(not_configured)
	# e.g. (cd backend && ruff check --fix . && ruff format .) && (cd frontend && npx eslint --fix . && npx prettier -w .)

typecheck:       ## Static types
	$(not_configured)
	# e.g. (cd backend && mypy .) && (cd frontend && npx tsc --noEmit)

check: lint typecheck test   ## THE gate: what CI and the Stop hook run

build:           ## Production artifact
	$(not_configured)

migrate:         ## DB migrations (explicit no-op if the project has no DB)
	$(not_configured)
