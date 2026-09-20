---
name: roadmap
description: Use after PRD and architecture are validated. Splits the product into ordered, independently shippable features and creates GitHub issues. Each issue then goes through /spec.
---
Pré-requis : PRD et ARCHITECTURE validés.
1. Extrais les features Must puis Should du PRD. Découpe toute feature > ~3 jours de travail en sous-features livrables seules.
2. Ordonne par dépendance technique (fondations d'abord : squelette, auth, modèle de données), puis par valeur.
3. Écris `docs/ROADMAP.md` : tableau (ordre, feature, périmètre en une ligne, dépend de, valeur, statut).
4. Pour chaque feature : `gh issue create --label feature --title "<feature>" --body "<périmètre + dépendances + lien PRD>"`.
5. Affiche la roadmap. La première feature de la liste est la prochaine entrée de /spec.
Ne détaille pas les specs ici : c'est /spec, une par une.
