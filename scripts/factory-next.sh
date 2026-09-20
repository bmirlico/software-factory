#!/usr/bin/env bash
# Automatically launches the next N ready features: spec `validated` in docs/specs/ AND no open PR.
# One INTERACTIVE Claude session per feature (initial prompt), in its own worktree and herdr pane, chaining /build → /pr.
# If the session has a question, it stops and waits in its pane: herdr shows it as `blocked`, you answer, it resumes.
# Usage: scripts/factory-next.sh [N=1]   (with herdr running; without herdr, background fallback with no interaction possible)
set -euo pipefail
N=${1:-1}; launched=0
ROOT=$(git rev-parse --show-toplevel); cd "$ROOT"

for spec in $(grep -l "status: validated" docs/specs/*.md 2>/dev/null | sort); do
  slug=$(basename "$spec" .md)
  [ "$slug" = "TEMPLATE" ] && continue
  gh pr list --head "feat/$slug" --state all --json number -q '.[0].number' 2>/dev/null | grep -q . && continue   # already has a PR
  git worktree list | grep -qE "\[(feat/|worktree-)$slug\]" && continue                                                       # already in progress

  PROMPT="Run the build skill on $spec, then, if the reviewer returns READY FOR PR, run the pr skill. Only ask me a question for a product decision or a truly blocking ambiguity; otherwise make a reasonable assumption and record it in the report."
  CMD="cd '$ROOT' && claude --worktree '$slug' \"$PROMPT\""

  if command -v herdr >/dev/null; then
    herdr pane split --direction right >/dev/null 2>&1 || true
    PANE=$(herdr pane list 2>/dev/null | tail -n1 | awk '{print $1}')   # ⚠ adapt to the real output format of `herdr pane list`
    herdr pane run "$PANE" "$CMD"
  else
    nohup bash -c "$CMD" >/dev/null 2>&1 &
  fi
  echo "→ $slug launched (worktree $slug, branch feat/$slug once /build starts)"
  launched=$((launched+1)); [ "$launched" -ge "$N" ] && break
done
if [ "$launched" -eq 0 ]; then echo "No feature ready: write and validate a spec (/spec) first."; fi
