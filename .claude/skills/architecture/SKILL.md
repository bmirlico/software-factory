---
name: architecture
description: Use after a PRD is validated, or for a major refactor. Produces docs/ARCHITECTURE.md, one ADR per structural decision, and DESIGN.md if there is a UI. Stops for human validation.
---
Pré-requis : `docs/PRD.md` validé, `docs/CONSTITUTION.md`.
Lance `researcher` si un code existe déjà. Puis écris `docs/ARCHITECTURE.md` (niveau C4 contexte + conteneurs, pas plus) :
1. Contexte : systèmes externes, utilisateurs. 2. Conteneurs : services, apps, DB, files, et leurs responsabilités.
3. Modèle de données : entités principales et relations. 4. Contrats d'API : ressources et endpoints principaux (pas le détail).
5. Choix transverses : auth, gestion d'erreurs, logs/observabilité, config, migrations, déploiement.
6. Diagramme Mermaid des conteneurs.
Pour chaque décision difficile à annuler (DB, framework, auth, hébergement, lib native mobile) : un ADR `docs/adr/NNNN-<slug>.md` avec alternatives considérées.
Si UI : `DESIGN.md` (tokens couleurs/typo/espacements, composants de base, principes). Charge le skill design actif pour l'écrire.
Ne sur-conçois pas : uniquement ce que le PRD exige. Affiche et ARRÊTE-TOI. Attends "architecture validée".
