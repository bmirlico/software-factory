# mobile/ - React Native / Expo
<!-- Replace the <...> with your real stack -->
- Stack: <Expo SDK xx, TypeScript, expo-router, Reanimated>
- Structure: <app/ (routes) · src/components · src/features · src/api (shared with frontend/ if monorepo)>

## Skills to use
- `vercel-react-native-skills` (Vercel): lists (FlashList), Reanimated animations, safe areas, pressables, images, fonts, monorepo. Load for any component or screen.
- `vercel-react-best-practices` (Vercel): the generic React rules (re-renders, memo) apply here too; ignore the Next.js/RSC ones.
- `vercel-composition-patterns` (Vercel): same as web.
- active design skill: same tokens as web (shared DESIGN.md).

## Rules
- Tested on iOS AND Android before a PR (simulator/emulator via `make e2e-mobile` if defined).
- No native lib without an ADR (impact on the Expo build).
- List perf: never a non-virtualized FlatList above 50 items.
