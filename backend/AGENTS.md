# backend/
<!-- Replace with your conventions. Python/FastAPI example: -->
- Language / framework: <Python 3.12, FastAPI>
- Structure: <app/api (routes) · app/services · app/models · app/schemas · tests/>
- One endpoint = Pydantic schema + route + service + test in tests/api/.
- Tests: <pytest, fixtures in tests/conftest.py, no DB mocking: test DB via docker-compose>
- Strict typing: <mypy --strict>. No `Any` without a comment.
- Migrations: <alembic>, one migration per PR at most.
