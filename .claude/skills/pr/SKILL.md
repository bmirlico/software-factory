---
name: pr
description: Use when make check is green and the work is ready for review. Writes the PR description from the spec and diff, adds before/after screenshots for UI changes, pushes and opens the PR with gh.
---
1. `make check` vert ET verdict `reviewer` = PRÊT POUR PR. Sinon arrête-toi.
2. Lis la spec liée et `git diff main...HEAD`.
3. Si des fichiers sous frontend/ ou mobile/ ont changé ET que `before-and-after` est installé :
   lance `make dev`, puis `before-and-after <url-main> <url-branche> --mobile --markdown`
   (url-main = preview de main, ou app lancée sur main dans un autre worktree). Récupère le tableau markdown.
4. Rédige la description :
   ## Contexte (lien spec, issue) · ## Changements · ## Critères d'acceptation couverts (cases cochées) ·
   ## Tests (ce qui a été lancé) · ## Screenshots (tableau before/after si UI) · ## Risques / à surveiller
5. `git push -u origin HEAD` puis `gh pr create --title "<type>: <titre>" --body-file <fichier>`.
6. Rends le lien de la PR. Ne fais aucune review locale : elle se fait sur la PR.
