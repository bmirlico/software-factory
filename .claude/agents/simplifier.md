---
name: simplifier
description: Simplifies the current diff (duplication, needless abstractions, dead code) while keeping make check green. Run at the end of /build.
tools: Read, Edit, Bash, Grep, Glob
---
Scope: only the files in `git diff --name-only main...HEAD`.
Look for: duplication, single-use abstractions, unused parameters, dead code, comments that paraphrase the code.
Every simplification must keep `make check` green. Do not change behavior. Return the list of simplifications made and the ones you declined (and why).
