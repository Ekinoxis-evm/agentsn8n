# WF2: AI Agent (Consolidated)

## Purpose
The core AI agent. Loads context, calls Claude with tool definitions, routes tool calls inline, sends WhatsApp reply, and saves the outbound message. Contains order creation and payment link generation inline (no sub-workflow calls).

## File
`WF2-ai-agent.json`

## n8n Workflow ID
`tbhGTQg6onwSpEns`

## Status
Active

## Trigger
Called by WF1 via `executeWorkflow` (async, `waitForSubWorkflow: false`)

## Node Flow
```
Input
  → Load History + Load Products + Load Config (parallel, HTTP → Supabase)
  → Build Prompt (Code — merges system prompt + catalog + config + history)
  → Claude API (HTTP → api.anthropic.com/v1/messages, model: claude-sonnet-4-6)
  → Parse Response (Code)
  → Has Tool? (IF)
      false → Send WA Message → Save Outbound Message
      true  → Which Tool? (Switch)
                ├── crear_pedido    → Parse Order Data → Insert Order → Is COD?
                │                       true  → Notify Team COD (Resend email) → Return Order
                │                       false → Return Order
                │                   → Build Tool Result
                ├── generar_link_pago → Parse MP Input → Create MP Preference (HTTP → MP API)
                │                       → Save Payment (HTTP → Supabase) → Return Payment URL
                │                   → Build Tool Result
                ├── buscar_productos → Search Products (HTTP → Supabase) → Build Tool Result
                ├── escalar_a_humano → Escalate Conversation (HTTP PATCH → Supabase) → Build Tool Result
                └── consultar_pedido → Query Orders (HTTP → Supabase) → Build Tool Result
              → Claude Final Reply (HTTP → Anthropic)
              → Extract Final Reply (Code)
              → Send WA Message → Save Outbound Message
```

## Inputs (from WF1)
| Field | Description |
|-------|-------------|
| `wa_phone` | Customer WhatsApp number |
| `message_text` | Customer's message |
| `customer_name` | Name from Meta profile |
| `conversation_id` | Supabase conversation UUID |
| `customer_id` | Supabase customer UUID |

## Outputs
- WhatsApp reply sent to customer (HTTP → Meta Graph API)
- `messages` row saved (outbound, direction `outbound`)
- `orders` row created (on `crear_pedido`)
- `payments` row created (on `generar_link_pago`)
- Resend email to team (on COD order)
- `conversations.status` updated to `human_active` (on `escalar_a_humano`)

## Tools available to Claude
| Tool | What it does |
|------|-------------|
| `buscar_productos` | Search Supabase products by name/keyword |
| `crear_pedido` | Create order in Supabase + notify team if COD |
| `generar_link_pago` | Create Mercado Pago preference + save payment record |
| `consultar_pedido` | Query orders by phone number |
| `escalar_a_humano` | Flag conversation for human takeover |

## Environment Variables
| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | Claude API |
| `SUPABASE_URL` + `SUPABASE_SERVICE_KEY` | Database |
| `WA_ACCESS_TOKEN` + `WA_PHONE_NUMBER_ID` + `WA_API_VERSION` | WhatsApp send |
| `MP_ACCESS_TOKEN` + `WEBHOOK_URL` | Mercado Pago |
| `RESEND_API_KEY` + `FROM_EMAIL` + `INTERNAL_EMAIL` | COD email notifications |

## Known Issues / TODOs
- Single tool call per message (no loop) — Claude must complete in one turn
- System prompt built dynamically from `agent_config` table — update config there, not in code
- `FROM_EMAIL` currently `onboarding@resend.dev` — update when Resend domain verified
