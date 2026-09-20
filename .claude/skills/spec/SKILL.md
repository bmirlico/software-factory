---
name: spec
description: Use when starting a feature or bug fix (from a roadmap issue or ad hoc). Produces a validated micro-spec in docs/specs/ with EARS acceptance criteria BEFORE any code. Stops for human validation.
---
Proportionne : un bug = spec de 5 lignes ; une feature = le template complet. Ne relance jamais /prd ou /architecture ici.
1. Lis CONSTITUTION, ARCHITECTURE (si présents), l'issue. Lance `researcher`.
2. Copie `docs/specs/TEMPLATE.md` vers `docs/specs/<slug>.md`. Critères d'acceptation en notation EARS :
   - Ubiquitous : "Le système doit toujours <…>."
   - Event-driven : "Quand <événement>, le système doit <…>."
   - State-driven : "Tant que <état>, le système doit <…>."
   - Unwanted : "Si <condition indésirable>, alors le système doit <…>."
   - Optional : "Là où <fonctionnalité>, le système doit <…>."
   Chaque critère = un test futur. Découpe en tranches indépendantes avec périmètre de fichiers.
3. Affiche la spec et ARRÊTE-TOI. Aucun code, aucune branche. Attends "spec validée", puis passe le statut à `validée`.
