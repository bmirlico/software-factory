# backend/
<!-- Remplace par tes conventions. Exemple Python/FastAPI : -->
- Langage / framework : <Python 3.12, FastAPI>
- Structure : <app/api (routes) · app/services · app/models · app/schemas · tests/>
- Un endpoint = schéma Pydantic + route + service + test dans tests/api/.
- Tests : <pytest, fixtures dans tests/conftest.py, pas de mock de la DB : DB de test via docker-compose>
- Typage strict : <mypy --strict>. Pas de `Any` sans commentaire.
- Migrations : <alembic>, une migration par PR max.
