#!/usr/bin/env bash
# Skills / plugins / MCP servers to install. Commands taken from the vercel-labs/skills and vercel-labs/agent-skills READMEs (Sept. 2026).
# Front = React (web) + React Native. Audit every third-party SKILL.md before installing: skills.sh is not curated.
set -e

echo "== Skills available in vercel-labs/agent-skills (check the exact slugs) =="
npx skills add vercel-labs/agent-skills --list

# --- Design: ONLY ONE of the two ---
npx skills add anthropics/skills --skill frontend-design -a claude-code -y
# npx skills add pbakaus/impeccable -a claude-code -y   # alternative: deterministic detector + PRODUCT.md/DESIGN.md

# --- Vercel Labs: React web ---
npx skills add vercel-labs/agent-skills --skill react-best-practices     -a claude-code -y   # 70 React/Next perf rules
npx skills add vercel-labs/agent-skills --skill composition-patterns     -a claude-code -y   # compound components, anti boolean-props
npx skills add vercel-labs/agent-skills --skill web-design-guidelines    -a claude-code -y   # a11y/UX/forms audit, 100+ rules
# npx skills add vercel-labs/agent-skills --skill react-view-transitions -a claude-code -y   # if you use the View Transitions API

# --- Vercel Labs: React Native / Expo ---
# Slug as listed by --list above (react-native-skills or vercel-react-native-skills depending on the version)
npx skills add vercel-labs/agent-skills --skill vercel-react-native-skills -a claude-code -y

# --- Vercel Labs: visual proof in the PR ---
npx skills add vercel-labs/before-and-after -a claude-code -y
npm i -g @vercel/before-and-after

# --- Vercel Labs: meta ---
npx skills add vercel-labs/skills --skill find-skills -a claude-code -y   # Claude looks for an existing skill itself before writing one

# --- MCP ---
claude mcp add --scope user --transport http --header "CONTEXT7_API_KEY: $CONTEXT7_API_KEY" context7 https://mcp.context7.com/mcp
claude mcp add playwright -- npx @playwright/mcp@latest

# --- In Claude Code (interactive) ---
echo "In Claude Code:"
echo "  /plugin  → LSP plugins (typescript, python...) + code-review (official marketplace)"
echo "  /install-github-app  → generates .github/workflows/claude.yml"

# --- Ship gate: no-mistakes (review, tests, lint, push, PR, CI watch) - used by /pr when present ---
if command -v no-mistakes >/dev/null; then
  echo "no-mistakes found: run 'no-mistakes init' once in this repo, then 'no-mistakes doctor'"
else
  echo "no-mistakes not installed: /pr falls back to git push + gh pr create. Install it if you want the gate."
fi

# --- Optional ---
# git clone https://github.com/greptileai/skills.git ~/.claude/skills/greptile   # /check-pr, /greploop
# npx skills add vercel-labs/agent-skills --skill vercel-deploy-claimable -a claude-code -y   # if deploying to Vercel
# npx skills update -y   # update all skills

# --- herdr: terminal agent multiplexer (Linux/macOS) - one Claude session per feature, one pane per session ---
# Skipped when herdr is already installed. Read https://herdr.dev/install.sh before running it on a new machine.
if command -v herdr >/dev/null; then
  echo "herdr already installed, skipping"
else
  curl -fsSL https://herdr.dev/install.sh | sh
fi
