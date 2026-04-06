# Boot File — Ekinoxis n8n

Three separate businesses share this repo. Each has its own n8n instance (Shopper is live; Convexo and Tronium instances are future). Identify the project you're working on.

---

## Project 1: Convexo (Enterprise Credit Evaluation)

**Status:** Stable | **n8n:** own instance (future) | **Directory:** `workflows/convexo/`

**Boot:** Read `workflows/convexo/QUICKSTART.md` → boot agent ARIA from `workflows/convexo/agents/agent-1-aria/CLAUDE.md`

| File | Description |
|------|-------------|
| `01-enterprise-credit-evaluation.json` | Form → Drive PDFs → Claude Opus → Score 0-1000 → Sheets + Email |

---

## Project 2: Tronium (Credit Recovery + Traffic Fines)

**Status:** Stable | **n8n:** own instance (future) | **Directory:** `workflows/tronium/`

**Boot:** Boot agent LEXI from `workflows/convexo/agents/agent-2-lexi/CLAUDE.md`

| File | Description |
|------|-------------|
| `02-credit-score-recovery.json` | Legal intake → Claude Sonnet → 3-stage recovery (RC- IDs) |
| `03-traffic-fines.json` | Legal intake → Claude Sonnet → free diagnosis (MT- IDs) |

---

## Project 3: Shopper Center (WhatsApp Ecommerce Agent)

**Status:** Active development | **n8n:** `https://n8n-production-8ea7.up.railway.app` | **Directory:** `workflows/shopper/`

**Boot:** Read `workflows/shopper/CLAUDE.md` → Read `workflows/shopper/CONTEXT.md`

| n8n ID | File | Role |
|--------|------|------|
| `Khcso1q69XXXaRNS` | `WF1-whatsapp-webhook.json` | Receive Meta webhook |
| `tbhGTQg6onwSpEns` | `WF2-ai-agent.json` | AI agent + order + payment |
| `HhlhGi4xgbFPI2N0` | `WF5-mp-webhook.json` | Mercado Pago confirmation |

---

## Shared Rules

- **Credentials:** Never in workflow JSONs — always env vars or n8n credential store
- **Language:** Spanish for client-facing, English for technical config
- **Models:** Anthropic only — Opus 4.6 for deep analysis, Sonnet 4.6 for agents
