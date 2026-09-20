---
name: build
description: Use after a spec is validated. Implements it slice by slice with parallel native builder subagents (each in an isolated worktree), then verifies, simplifies, and runs an independent review against the spec.
---
Pré-requis : une spec au statut `validée`. Sinon, appelle /spec.
1. Crée la branche `feat/<slug>` depuis main.
2. Un agent `builder` par tranche indépendante, lancés EN PARALLÈLE si les périmètres sont disjoints (chacun a `isolation: worktree` : Claude Code crée, isole et nettoie le worktree lui-même). Passe à chacun : chemin de la spec, numéro de tranche, périmètre. Suivi : Ctrl+T (liste des tâches) ou le panneau d'agents.
3. Intègre les tranches rendues sur `feat/<slug>`, lance `verifier`. Si ROUGE : corrige directement (pas de re-spawn pour des fixes). Max 3 tours.
4. Lance `simplifier`. 5. Lance `reviewer` (lecture seule, compare le diff à la spec). Si BLOQUANTS : corrige, relance `verifier` + `reviewer`. Max 2 tours.
6. Rends : tranches, critères couverts, verdict du reviewer, points ouverts. Ne crée pas la PR : c'est /pr.
