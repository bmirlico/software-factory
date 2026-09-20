# Project constitution
<!-- Non-negotiable principles. Read by /prd, /architecture, /spec, reviewer. Inspired by the Spec Kit "constitution". -->
## Mandated stack
- Backend: <...> · Web frontend: React <...> · Mobile: React Native/Expo <...> · DB: <...> · Hosting: <...>
## Quality
- Green `make check` is mandatory. Minimum coverage: <...>. Every acceptance criterion = one test.
- No new dependency without an ADR. Small PRs.
## Security
- Secrets only through environment variables. Validate all inputs. Auth: <...>.
## Product
- Accessibility: `web-design-guidelines` on every UI. Mobile-first: <yes/no>.
## Off limits
- <what the project will never do>
