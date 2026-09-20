# frontend/ — React (web)
<!-- Remplace les <…> par ta stack réelle -->
- Stack : <React 19, TypeScript, Vite ou Next.js, Tailwind>
- Structure : <src/components (UI pure) · src/features/<domaine> · src/api (client généré) · src/routes>
- Un composant = fichier + test (vitest + testing-library) + story si réutilisable.

## Skills à utiliser (installés via scripts/install-skills.sh)
- `react-best-practices` (Vercel) : à chaque composant / data fetching / review perf. Priorités : waterfalls et bundle size.
- `composition-patterns` (Vercel) : dès qu'un composant accumule des props booléennes → compound components.
- `web-design-guidelines` (Vercel) : audit a11y/UX/forms **avant toute PR UI** (appelé par /design-review).
- skill design actif (`frontend-design` ou `impeccable`) : direction esthétique. Suis DESIGN.md s'il existe. Pas de couleur/police hors tokens.
- `before-and-after` (Vercel) : screenshots dans la PR (appelé par /pr).

## Règles
- Data fetching : <TanStack Query / server components>, jamais de fetch dans un composant de présentation.
- Pas de `any`. Pas de `useEffect` pour dériver de l'état.
