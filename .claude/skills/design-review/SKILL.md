---
name: design-review
description: Use after any UI change. Opens the app in a browser, screenshots key routes on desktop and mobile, audits against design guidelines, applies ONE batch of fixes, confirms once, stops.
---
Pré-requis : Playwright MCP (ou l'extension Chrome) et `web-design-guidelines` installés.
1. `make dev`. Liste les routes touchées par le diff.
2. Pour chaque route : screenshot desktop (1440) et mobile (375). Compare à DESIGN.md / la maquette Figma si présents.
3. Lance le skill `web-design-guidelines` sur les fichiers UI modifiés (a11y, focus, forms, perf).
4. Consolide UN seul lot de corrections (pas d'itérations infinies). Applique-le.
5. Re-screenshote une fois pour confirmer. Puis ARRÊTE-TOI : pas de polissage supplémentaire.
Rends : routes vérifiées, problèmes trouvés / corrigés / laissés (et pourquoi).
