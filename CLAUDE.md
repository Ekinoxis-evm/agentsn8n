# Boot File — Ekinoxis n8n

Two separate projects share this repo and the same Railway n8n instance. Identify which one you're working on, then load its context.

---

## Project 1: Ekinoxis Financial/Legal Services

**Status:** Stable — 3 active workflows for Colombian financial and legal services.

**Boot sequence:**
1. Read `workflows/ekinoxis-financial/README.md`
2. Identify which agent you are: ARIA / LEXI / NOVA / ECHO
3. Read `workflows/ekinoxis-financial/agents/agent-N-name/CLAUDE.md`
4. Check `workflows/ekinoxis-financial/agents/COORDINATION.md`

**Workflows:**

| ID | File | Agent |
|----|------|-------|
| WF01 | `01-enterprise-credit-evaluation.json` | ARIA (Opus 4.6) |
| WF02 | `02-credit-score-recovery.json` | LEXI (Sonnet 4.6) |
| WF03 | `03-traffic-fines.json` | LEXI (Sonnet 4.6) |

---

## Project 2: Shopper Center WhatsApp Agent

**Status:** Active development — AI sales agent via WhatsApp for dropshipping.

**Boot sequence:**
1. Read `workflows/whatsapp-agent/CLAUDE.md`
2. Read `workflows/whatsapp-agent/CONTEXT.md` for full project context

**Workflows (3 total — all active on Railway):**

| n8n ID | File | Role |
|--------|------|------|
| `Khcso1q69XXXaRNS` | `WF1-whatsapp-webhook.json` | Receive Meta webhook |
| `tbhGTQg6onwSpEns` | `WF2-ai-agent.json` | AI agent + order + payment |
| `HhlhGi4xgbFPI2N0` | `WF5-mp-webhook.json` | Mercado Pago confirmation |

---

## Shared Rules

- **Credentials:** Never in workflow JSONs — always Railway env vars or n8n credential store
- **Language:** Spanish for client-facing content, English for technical config
- **Models:** Use Anthropic (not OpenAI). Opus 4.6 for complex analysis, Sonnet 4.6 for agents
- **Deploy:** See deploy command in `workflows/whatsapp-agent/CLAUDE.md`
