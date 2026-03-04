# Ekinoxis n8n — Root Boot File

## What Is This?
A multi-agent automation platform built on n8n for Ekinoxis financial and legal services in Colombia.
Each Claude Code session should identify which agent it is and boot from that agent's `CLAUDE.md`.

---

## Agent Map (Org Chart)

| Agent | Name | Model | Owns | Directory |
|-------|------|-------|------|-----------|
| #1 | **ARIA** | `claude-opus-4-6` | Workflow 01 — Enterprise Credit Evaluation | `agents/agent-1-aria/` |
| #2 | **LEXI** | `claude-sonnet-4-6` | Workflows 02 + 03 — Legal Services | `agents/agent-2-lexi/` |
| #3 | **NOVA** | `claude-haiku-4-5-20251001` | Coordination, Sheets, Notifications | `agents/agent-3-nova/` |
| #4 | **ECHO** | `claude-sonnet-4-6` | n8n infra, API, workflow maintenance | `agents/agent-4-echo/` |

---

## Project Structure

```
/Users/williammartinez/Documents/ekinoxis/n8n/
├── QUICKSTART.md                    ← Zero-to-running guide (start here for humans)
├── CLAUDE.md                        ← You are here (root org chart for agents)
├── scripts/
│   └── launch-agents.sh             ← Launch all 4 agents in a tmux 2×2 grid
├── agents/
│   ├── COORDINATION.md              ← Shared task board (all agents read/write)
│   ├── agent-1-aria/                ← Financial Analyst
│   ├── agent-2-lexi/                ← Legal Advisor
│   ├── agent-3-nova/                ← Operations Manager
│   └── agent-4-echo/                ← Tech Lead
└── workflows/
    ├── 01-enterprise-credit-evaluation.json   ← Claude Opus 4.6
    ├── 02-credit-score-recovery.json          ← Claude Sonnet 4.6
    ├── 03-traffic-fines.json                  ← Claude Sonnet 4.6
    ├── .env.example
    └── README.md
```

---

## How to Boot

1. **Identify your agent** — which agent are you acting as?
2. **Navigate to your folder** → `agents/agent-N-name/`
3. **Read your `CLAUDE.md`** — boot sequence with identity + quick start
4. **Check `TASKS.md`** — what needs doing right now
5. **Check `COORDINATION.md`** — cross-agent blockers or handoffs

---

## Shared Rules (All Agents)

- **Language:** Spanish for client-facing content, English for technical config
- **Credentials:** NEVER in workflow JSONs — always use n8n credential store + env vars
- **Coordination:** Post cross-agent dependencies to `agents/COORDINATION.md`
- **Claude API:** All workflows use Anthropic (not OpenAI) — see `workflows/.env.example`
- **Colombia context:** COP, RUT/NIT, DataCrédito, Colombian legal framework

---

## Quick Links

- **New here?** → Start at `QUICKSTART.md` (zero-to-running guide)
- **Launch all agents:** `./scripts/launch-agents.sh` (requires tmux)
- Shared task board: `agents/COORDINATION.md`
- Environment setup: `workflows/.env.example`
- Workflow technical docs: `workflows/README.md`
- n8n local: `npx n8n` or `docker run -p 5678:5678 n8nio/n8n`
