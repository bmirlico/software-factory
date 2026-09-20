# frontend/ - React (web)
<!-- Replace the <...> with your real stack -->
- Stack: <React 19, TypeScript, Vite or Next.js, Tailwind>
- Structure: <src/components (pure UI) · src/features/<domain> · src/api (generated client) · src/routes>
- One component = file + test (vitest + testing-library) + story if reusable.

## Skills to use (installed via scripts/install-skills.sh)
- `react-best-practices` (Vercel): for every component / data fetching / perf review. Priorities: waterfalls and bundle size.
- `composition-patterns` (Vercel): as soon as a component accumulates boolean props → compound components.
- `web-design-guidelines` (Vercel): a11y/UX/forms audit **before any UI PR** (called by /design-review).
- active design skill (`frontend-design` or `impeccable`): aesthetic direction. Follow DESIGN.md if it exists. No color/font outside the tokens.
- `before-and-after` (Vercel): screenshots in the PR (called by /pr).

## Rules
- Data fetching: <TanStack Query / server components>, never fetch inside a presentational component.
- No `any`. No `useEffect` to derive state.
