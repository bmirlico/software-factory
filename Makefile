# ============================================================
# CONTRAT UNIQUE — appelé par l'humain, Claude, les agents, la CI
# Remplis les cibles pour ta stack. Ne change pas leurs noms.
# ============================================================
.PHONY: dev test e2e lint fmt typecheck check build migrate help

help:            ## Liste les cibles
	@grep -E '^[a-z]+:.*##' $(MAKEFILE_LIST) | awk -F':.*##' '{printf "  %-10s %s\n", $$1, $$2}'

dev:             ## Lance deps + backend + frontend
	@echo "TODO: docker compose up -d && (cd backend && <run>) & (cd frontend && <run>)"

test:            ## Tests unitaires + intégration (< 2 min)
	@echo "TODO: (cd backend && pytest -q) && (cd frontend && npx vitest run)"

e2e:             ## Tests navigateur
	@echo "TODO: (cd frontend && npx playwright test)"

lint:            ## Lint + format CHECK (ne modifie rien)
	@echo "TODO: (cd backend && ruff check . && ruff format --check .) && (cd frontend && npx eslint . && npx prettier -c .)"

fmt:             ## Format + autofix
	@echo "TODO: (cd backend && ruff check --fix . && ruff format .) && (cd frontend && npx eslint --fix . && npx prettier -w .)"

typecheck:       ## Types statiques
	@echo "TODO: (cd backend && mypy .) && (cd frontend && npx tsc --noEmit)"

check: lint typecheck test   ## LE gate : ce que la CI et le hook Stop lancent

build:           ## Artefact de prod
	@echo "TODO"

migrate:         ## Migrations DB
	@echo "TODO"
