#!/usr/bin/env bash
# ============================================================
#  Ekinoxis Multi-Agent Launcher
#  Opens all 4 AI agents in a 2×2 tmux split view
#
#  Usage:
#    chmod +x scripts/launch-agents.sh
#    ./scripts/launch-agents.sh
#
#  Requirements: tmux, claude (Claude Code CLI)
#  Install:  brew install tmux
#            npm install -g @anthropic-ai/claude-code
# ============================================================

set -e

SESSION="ekinoxis"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# ── Colors ────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

# ── Banner ────────────────────────────────────────────────
clear
echo ""
echo -e "${BOLD}${CYAN}  ███████╗██╗  ██╗██╗███╗   ██╗ ██████╗ ██╗  ██╗██╗███████╗${NC}"
echo -e "${BOLD}${CYAN}  ██╔════╝██║ ██╔╝██║████╗  ██║██╔═══██╗╚██╗██╔╝██║██╔════╝${NC}"
echo -e "${BOLD}${CYAN}  █████╗  █████╔╝ ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ██║███████╗${NC}"
echo -e "${BOLD}${CYAN}  ██╔══╝  ██╔═██╗ ██║██║╚██╗██║██║   ██║ ██╔██╗ ██║╚════██║${NC}"
echo -e "${BOLD}${CYAN}  ███████╗██║  ██╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗██║███████║${NC}"
echo -e "${BOLD}${CYAN}  ╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝${NC}"
echo ""
echo -e "${DIM}  Multi-Agent System — n8n Automation Platform${NC}"
echo -e "${DIM}  Colombia · Financial & Legal Services${NC}"
echo ""
echo -e "  ${BOLD}Agents booting:${NC}"
echo -e "  ${CYAN}●${NC} ARIA  — Financial Analyst    ${DIM}(claude-opus-4-6)${NC}"
echo -e "  ${CYAN}●${NC} LEXI  — Legal Advisor         ${DIM}(claude-sonnet-4-6)${NC}"
echo -e "  ${CYAN}●${NC} NOVA  — Operations Manager    ${DIM}(claude-haiku-4-5-20251001)${NC}"
echo -e "  ${CYAN}●${NC} ECHO  — Tech Lead              ${DIM}(claude-sonnet-4-6)${NC}"
echo ""

# ── Dependency checks ─────────────────────────────────────
check_dep() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo -e "${RED}✗ '$1' not found.${NC} Install: $2"
    exit 1
  fi
}

check_dep tmux   "brew install tmux"
check_dep claude "npm install -g @anthropic-ai/claude-code"

echo -e "${GREEN}✓ tmux found${NC}"
echo -e "${GREEN}✓ claude CLI found${NC}"
echo ""

# ── Kill existing session ──────────────────────────────────
if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo -e "${YELLOW}⚠ Session '$SESSION' already running — killing it...${NC}"
  tmux kill-session -t "$SESSION"
fi

# ── Build 2×2 layout ──────────────────────────────────────
#
#  ┌──────────────────┬──────────────────┐
#  │                  │                  │
#  │   ARIA  (#1)     │   LEXI  (#2)     │
#  │   opus           │   sonnet         │
#  │                  │                  │
#  ├──────────────────┼──────────────────┤
#  │                  │                  │
#  │   NOVA  (#3)     │   ECHO  (#4)     │
#  │   haiku          │   sonnet         │
#  │                  │                  │
#  └──────────────────┴──────────────────┘

ARIA_DIR="$BASE_DIR/agents/agent-1-aria"
LEXI_DIR="$BASE_DIR/agents/agent-2-lexi"
NOVA_DIR="$BASE_DIR/agents/agent-3-nova"
ECHO_DIR="$BASE_DIR/agents/agent-4-echo"

# Create session (pane 0 = ARIA)
tmux new-session -d -s "$SESSION" -c "$ARIA_DIR" -x 240 -y 60

# Add 3 more panes
tmux split-window -t "$SESSION" -c "$LEXI_DIR"
tmux split-window -t "$SESSION" -c "$NOVA_DIR"
tmux split-window -t "$SESSION" -c "$ECHO_DIR"

# Apply tiled 2×2 layout
tmux select-layout -t "$SESSION" tiled

# ── tmux status bar ───────────────────────────────────────
tmux set -t "$SESSION" status on
tmux set -t "$SESSION" status-style "bg=#1a2e4a,fg=#7eb3d4"
tmux set -t "$SESSION" status-left "#[bold,fg=cyan] EKINOXIS AGENTS #[default] "
tmux set -t "$SESSION" status-right "#[fg=#7eb3d4] Ctrl+B → arrows: move | Z: zoom | D: detach "
tmux set -t "$SESSION" status-left-length 30

# ── Boot each agent ───────────────────────────────────────
boot_agent() {
  local pane="$1"
  local label="$2"
  local model="$3"
  local color="$4"

  tmux send-keys -t "$SESSION:0.$pane" \
    "clear && printf '\\n${color}  ══════════════════════════════════════\\n  %-36s\\n  %-36s\\n  ══════════════════════════════════════${NC}\\n\\n' \
    '  $label' '  $model' && claude" Enter
}

boot_agent 0 "ARIA  ·  Financial Analyst"   "claude-opus-4-6"          "\\033[1;35m"
boot_agent 1 "LEXI  ·  Legal Advisor"       "claude-sonnet-4-6"        "\\033[1;34m"
boot_agent 2 "NOVA  ·  Operations Manager"  "claude-haiku-4-5-20251001" "\\033[1;32m"
boot_agent 3 "ECHO  ·  Tech Lead"           "claude-sonnet-4-6"        "\\033[1;33m"

# ── Attach ────────────────────────────────────────────────
echo -e "${GREEN}✅ All 4 agents launched!${NC}"
echo ""
echo -e "${BOLD}Tmux shortcuts:${NC}"
echo -e "  ${CYAN}Ctrl+B → arrow keys${NC}  Navigate between agents"
echo -e "  ${CYAN}Ctrl+B → Z${NC}           Zoom in/out on active pane"
echo -e "  ${CYAN}Ctrl+B → D${NC}           Detach (agents keep running in background)"
echo -e "  ${CYAN}tmux attach -t ekinoxis${NC}  Re-attach later"
echo ""
sleep 1
tmux attach-session -t "$SESSION"
