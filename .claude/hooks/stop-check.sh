#!/usr/bin/env bash
# Gate de fin de tâche : si `make check` échoue, on renvoie exit 2
# → Claude Code bloque l'arrêt et reçoit la sortie sur stderr pour continuer à corriger.
# Garde-fou anti-boucle : Claude Code passe stop_hook_active=true si un Stop hook a déjà bloqué.
INPUT=$(cat)
if echo "$INPUT" | grep -q '"stop_hook_active": *true'; then exit 0; fi
OUT=$(make check 2>&1)
if [ $? -ne 0 ]; then
  echo "make check est ROUGE. Corrige avant de t'arrêter :" >&2
  echo "$OUT" | tail -n 60 >&2
  exit 2
fi
exit 0
