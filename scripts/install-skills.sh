#!/usr/bin/env bash
# Skills / plugins / MCP à installer. Commandes issues des README vercel-labs/skills et vercel-labs/agent-skills (sept. 2026).
# Front = React (web) + React Native. Audite chaque SKILL.md tiers avant install : skills.sh n'est pas curé.
set -e

echo "== Skills disponibles dans vercel-labs/agent-skills (vérifie les slugs exacts) =="
npx skills add vercel-labs/agent-skills --list

# --- Design : UN SEUL des deux ---
npx skills add anthropics/skills --skill frontend-design -a claude-code -y
# npx skills add pbakaus/impeccable -a claude-code -y   # alternative : détecteur déterministe + PRODUCT.md/DESIGN.md

# --- Vercel Labs : React web ---
npx skills add vercel-labs/agent-skills --skill react-best-practices     -a claude-code -y   # 70 règles perf React/Next
npx skills add vercel-labs/agent-skills --skill composition-patterns     -a claude-code -y   # compound components, anti boolean-props
npx skills add vercel-labs/agent-skills --skill web-design-guidelines    -a claude-code -y   # audit a11y/UX/forms, 100+ règles
# npx skills add vercel-labs/agent-skills --skill react-view-transitions -a claude-code -y   # si tu utilises l'API View Transitions

# --- Vercel Labs : React Native / Expo ---
# Slug tel que listé par --list ci-dessus (react-native-skills ou vercel-react-native-skills selon la version)
npx skills add vercel-labs/agent-skills --skill vercel-react-native-skills -a claude-code -y

# --- Vercel Labs : preuve visuelle dans la PR ---
npx skills add vercel-labs/before-and-after -a claude-code -y
npm i -g @vercel/before-and-after

# --- Vercel Labs : méta ---
npx skills add vercel-labs/skills --skill find-skills -a claude-code -y   # Claude cherche lui-même un skill existant avant d'en écrire un

# --- MCP ---
claude mcp add --scope user --transport http --header "CONTEXT7_API_KEY: $CONTEXT7_API_KEY" context7 https://mcp.context7.com/mcp
claude mcp add playwright -- npx @playwright/mcp@latest

# --- Dans Claude Code (interactif) ---
echo "Dans Claude Code :"
echo "  /plugin  → plugins LSP (typescript, python…) + code-review (marketplace officiel)"
echo "  /install-github-app  → génère .github/workflows/claude.yml"

# --- Optionnel ---
# git clone https://github.com/greptileai/skills.git ~/.claude/skills/greptile   # /check-pr, /greploop
# npx skills add vercel-labs/agent-skills --skill vercel-deploy-claimable -a claude-code -y   # si déploiement Vercel
# npx skills update -y   # mettre à jour tous les skills

# --- herdr : multiplexeur d'agents terminal (Linux/macOS) — une session Claude par feature, un pane par session ---
curl -fsSL https://herdr.dev/install.sh | sh
