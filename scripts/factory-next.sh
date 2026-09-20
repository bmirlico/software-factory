#!/usr/bin/env bash
# Lance automatiquement les N prochaines features prêtes : spec `validée` dans docs/specs/ ET pas de PR ouverte.
# Une session Claude INTERACTIVE par feature (prompt initial), dans son worktree et son pane herdr, qui enchaîne /build → /pr.
# Si la session a une question, elle s'arrête et attend dans son pane : herdr la montre `blocked`, tu réponds, elle repart.
# Usage : scripts/factory-next.sh [N=1]   (avec herdr lancé ; sans herdr, fallback en arrière-plan sans interaction possible)
set -euo pipefail
N=${1:-1}; launched=0
ROOT=$(git rev-parse --show-toplevel); cd "$ROOT"

for spec in $(grep -l "statut : validée" docs/specs/*.md 2>/dev/null | sort); do
  slug=$(basename "$spec" .md)
  [ "$slug" = "TEMPLATE" ] && continue
  gh pr list --head "feat/$slug" --state all --json number -q '.[0].number' 2>/dev/null | grep -q . && continue   # déjà une PR
  git worktree list | grep -q "\[feat/$slug\]" && continue                                                       # déjà en cours

  PROMPT="Lance le skill build sur $spec, puis, si le reviewer rend PRÊT POUR PR, lance le skill pr. Ne me pose une question que pour une décision produit ou une ambiguïté réellement bloquante ; sinon fais une hypothèse raisonnable et note-la dans le rapport."
  CMD="cd '$ROOT' && claude --worktree '$slug' \"$PROMPT\""

  if command -v herdr >/dev/null; then
    herdr pane split --direction right >/dev/null 2>&1 || true
    PANE=$(herdr pane list 2>/dev/null | tail -n1 | awk '{print $1}')   # ⚠ à adapter au format réel de `herdr pane list`
    herdr pane run "$PANE" "$CMD"
  else
    nohup bash -c "$CMD" >/dev/null 2>&1 &
  fi
  echo "→ $slug lancé (worktree feat/$slug)"
  launched=$((launched+1)); [ "$launched" -ge "$N" ] && break
done
[ "$launched" -eq 0 ] && echo "Aucune feature prête : écris et valide une spec (/spec) d'abord."
