---
name: design-review
description: Use after any UI change. Opens the app in a browser, screenshots key routes on desktop and mobile, audits against design guidelines, applies ONE batch of fixes, confirms once, stops.
---
Prerequisites: Playwright MCP (or the Chrome extension) and `web-design-guidelines` installed.
1. `make dev`. List the routes touched by the diff.
2. For each route: desktop (1440) and mobile (375) screenshot. Compare against DESIGN.md / the Figma mockup if present.
3. Run the `web-design-guidelines` skill on the modified UI files (a11y, focus, forms, perf).
4. Consolidate ONE single batch of fixes (no endless iterations). Apply it.
5. Re-screenshot once to confirm. Then STOP: no further polishing.
Return: routes checked, issues found / fixed / left (and why).
