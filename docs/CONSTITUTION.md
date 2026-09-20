# Constitution du projet
<!-- Principes non négociables. Lue par /prd, /architecture, /spec, reviewer. Inspiré de la "constitution" Spec Kit. -->
## Stack imposée
- Backend : <…> · Frontend web : React <…> · Mobile : React Native/Expo <…> · DB : <…> · Hébergement : <…>
## Qualité
- `make check` vert obligatoire. Couverture minimale : <…>. Tout critère d'acceptation = un test.
- Aucune dépendance nouvelle sans ADR. Petites PRs.
## Sécurité
- Secrets uniquement via variables d'environnement. Validation de toutes les entrées. Auth : <…>.
## Produit
- Accessibilité : `web-design-guidelines` sur toute UI. Mobile-first : <oui/non>.
## Hors limites
- <ce que le projet ne fera jamais>
