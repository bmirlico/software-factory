---
name: techdebt
description: OPTIONAL. Weekly pass over the codebase to surface tech debt as GitHub issues. Does not modify code.
---
Lecture seule.
1. Duplication : `git log --since=7.days` + grep des blocs similaires.
2. Tests lents : durée de `make test` et `make e2e`, top 5 des plus lents.
3. Décisions non documentées : changements structurels sans ADR.
4. TODO/FIXME ajoutés cette semaine.
Pour chaque point : `gh issue create --label techdebt --title "..." --body "..."`. Rends la liste.
