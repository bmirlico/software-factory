# ============================================================
# SINGLE CONTRACT - called by the human, Claude, the agents, CI
# Fill in the targets for your stack. Do not rename them.
# ============================================================
.PHONY: dev test e2e lint fmt typecheck check build migrate help

help:            ## List the targets
	@grep -E '^[a-z]+:.*##' $(MAKEFILE_LIST) | awk -F':.*##' '{printf "  %-10s %s\n", $$1, $$2}'

dev:             ## Start deps + backend + frontend
	@echo "TODO: docker compose up -d && (cd backend && <run>) & (cd frontend && <run>)"

test:            ## Unit + integration tests (< 2 min)
	@echo "TODO: (cd backend && pytest -q) && (cd frontend && npx vitest run)"

e2e:             ## Browser tests
	@echo "TODO: (cd frontend && npx playwright test)"

lint:            ## Lint + format CHECK (modifies nothing)
	@echo "TODO: (cd backend && ruff check . && ruff format --check .) && (cd frontend && npx eslint . && npx prettier -c .)"

fmt:             ## Format + autofix
	@echo "TODO: (cd backend && ruff check --fix . && ruff format .) && (cd frontend && npx eslint --fix . && npx prettier -w .)"

typecheck:       ## Static types
	@echo "TODO: (cd backend && mypy .) && (cd frontend && npx tsc --noEmit)"

check: lint typecheck test   ## THE gate: what CI and the Stop hook run

build:           ## Production artifact
	@echo "TODO"

migrate:         ## DB migrations
	@echo "TODO"
