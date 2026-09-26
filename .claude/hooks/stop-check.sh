#!/usr/bin/env bash
# End-of-task gate: if `make check` fails, exit 2
# → Claude Code blocks the stop and receives the output on stderr so it keeps fixing.
# Anti-loop guard: Claude Code passes stop_hook_active=true when a Stop hook has already blocked.
INPUT=$(cat)
if echo "$INPUT" | grep -q '"stop_hook_active": *true'; then exit 0; fi
OUT=$(make check 2>&1)
if [ $? -ne 0 ]; then
  # Unfilled Makefile (before /architecture): nothing to enforce yet, do not block.
  if echo "$OUT" | grep -q "not configured"; then exit 0; fi
  echo "make check is RED. Fix it before stopping:" >&2
  echo "$OUT" | tail -n 60 >&2
  exit 2
fi
exit 0
