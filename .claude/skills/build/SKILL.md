---
name: build
description: Use after a spec is validated. Implements it slice by slice with parallel native builder subagents (each in an isolated worktree), then verifies, simplifies, and runs an independent review against the spec.
---
Prerequisite: a spec with status `validated`. Otherwise, call /spec.
1. Create the branch `feat/<slug>` from main.
2. One `builder` agent per independent slice, launched IN PARALLEL when scopes are disjoint (each has `isolation: worktree`: Claude Code creates, isolates and cleans up the worktree itself). Pass each one: spec path, slice number, scope. Tracking: Ctrl+T (task list) or the agents panel.
3. Integrate the returned slices into `feat/<slug>`, run `verifier`. If RED: fix directly (no re-spawn for fixes). Max 3 rounds.
4. Run `simplifier`. 5. Run `reviewer` (read-only, compares the diff to the spec). If BLOCKING items: fix, re-run `verifier` + `reviewer`. Max 2 rounds.
6. Return: slices, criteria covered, reviewer verdict, open points.
7. If the reviewer verdict is READY FOR PR: when `git diff --name-only main...HEAD` touches `frontend/` or `mobile/`, run the `design-review` skill first, then run the `pr` skill; otherwise run `pr` directly. Do not wait to be asked. If it is NOT READY after the 2 rounds, stop and report.
