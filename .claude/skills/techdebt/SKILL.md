---
name: techdebt
description: OPTIONAL. Weekly pass over the codebase to surface tech debt as GitHub issues. Does not modify code.
---
Read-only.
1. Duplication: `git log --since=7.days` + grep for similar blocks.
2. Slow tests: duration of `make test` and `make e2e`, top 5 slowest.
3. Undocumented decisions: structural changes without an ADR.
4. TODO/FIXME added this week.
Make sure the label exists: `gh label create techdebt --color FBCA04 --description "Tech debt" --force`. For each item: `gh issue create --label techdebt --title "..." --body "..."`. Return the list.
