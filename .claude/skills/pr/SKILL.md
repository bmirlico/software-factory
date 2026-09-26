---
name: pr
description: Use when make check is green and the work is ready for review. Writes the PR description from the spec and diff, adds before/after screenshots for UI changes, then ships through the no-mistakes gate (or plain git push + gh when it is not installed).
---
1. `make check` green AND `reviewer` verdict = READY FOR PR. Otherwise stop.
2. Read the linked spec and `git diff main...HEAD`.
3. If files under frontend/ or mobile/ changed:
   run `make dev`, then `npx @vercel/before-and-after <main-url> <branch-url> --mobile --markdown`
   (main-url = preview of main, or the app running on main in another worktree). Collect the markdown table.
4. Write the description:
   ## Context (spec link, issue) · ## Changes · ## Acceptance criteria covered (checked boxes) ·
   ## Tests (what was run) · ## Screenshots (before/after table if UI) · ## Risks / things to watch
5. Ship:
   - If `no-mistakes` is installed (`command -v no-mistakes`): commit everything, then run the `no-mistakes` skill in validate-only mode. Intent = the spec goal + its acceptance criteria + the assumptions recorded during /build. Never `git push` or `gh pr create` yourself: the gate reviews, tests, pushes, opens the PR and watches CI. If the repo is not initialized, run `no-mistakes init` first. Once the PR exists, add the description from step 4 with `gh pr edit <number> --body-file <file>`, keeping anything no-mistakes already wrote in the body.
   - Otherwise: `git push -u origin HEAD` then `gh pr create --title "<type>: <title>" --body-file <file>`.
6. Return the PR link. Do not run any extra local review: human review happens on the PR.
