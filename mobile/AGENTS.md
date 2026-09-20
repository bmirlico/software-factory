# mobile/ — React Native / Expo
<!-- Remplace les <…> par ta stack réelle -->
- Stack : <Expo SDK xx, TypeScript, expo-router, Reanimated>
- Structure : <app/ (routes) · src/components · src/features · src/api (partagé avec frontend/ si monorepo)>

## Skills à utiliser
- `vercel-react-native-skills` (Vercel) : listes (FlashList), animations Reanimated, safe areas, pressables, images, polices, monorepo. À charger pour tout composant ou écran.
- `react-best-practices` (Vercel) : les règles React génériques (re-renders, memo) s'appliquent aussi ; ignorer celles Next.js/RSC.
- `composition-patterns` (Vercel) : idem web.
- skill design actif : mêmes tokens que le web (DESIGN.md partagé).

## Règles
- Testé sur iOS ET Android avant PR (simulateur/émulateur via `make e2e-mobile` si défini).
- Aucune lib native sans ADR (impact sur le build Expo).
- Perf listes : jamais de FlatList non virtualisée sur > 50 items.
