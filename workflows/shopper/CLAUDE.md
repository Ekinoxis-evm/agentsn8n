# WhatsApp Sales Agent — Boot File for Claude

## Mission
Build and maintain the n8n workflows for the AI sales agent of **Shopper Center** via WhatsApp.

## Full context
Read first: `./CONTEXT.md`

---

## Stack
- **n8n:** `https://n8n-production-8ea7.up.railway.app`
- **n8n API Key:** Railway env `N8N_API_KEY`
- **Supabase:** `https://jfhxmmkwdedmlixhogae.supabase.co`
- **Railway project:** `ekinoxis-n8n`

---

## Active Workflows (2 total)

| ID | File | Role | Active |
|----|------|------|--------|
| `tbhGTQg6onwSpEns` | `WF-whatsapp-agent.json` | Single merged workflow: webhook + AI Agent (native) + tools | ⚠️ needs credentials |
| `HhlhGi4xgbFPI2N0` | `WF5-mp-webhook.json` | Receive Mercado Pago webhook → confirm payment → notify team | ✅ |

**Deprecated (deactivated):**
- `Khcso1q69XXXaRNS` — WF1-whatsapp-webhook.json — superseded by merged workflow above
- Old WF2-ai-agent.json — replaced by WF-whatsapp-agent.json

**To activate `tbhGTQg6onwSpEns`:** Create 2 credentials in n8n UI first:
1. Type `Anthropic`, name `Anthropic` — use `ANTHROPIC_API_KEY` from Railway
2. Type `Postgres`, name `Railway Postgres` — host `postgres.railway.internal`, port 5432, db `railway`, user `postgres`, password from Railway Postgres service, SSL off

---

## WF-whatsapp-agent Architecture (native AI Agent node)

21 nodes total — single workflow, single execution log.

```
Webhook GET  → Respond Challenge (Meta verification)

Webhook POST → Extract Message (Code)
             → Should Skip? (IF)
                  true  → Respond 200 Skip
                  false → Upsert Customer (HTTP/Supabase)
                        → Upsert Conversation (HTTP/Supabase)
                        → Save Inbound Message (HTTP/Supabase)
                        → Respond 200 OK  ← Meta gets response here (<5s guaranteed)
                        → Prepare Agent Input (Code)
                        → AI Agent (toolsAgent)  ← claude-sonnet-4-6
                              ├── Anthropic Chat Model (lmChatAnthropic)
                              ├── Postgres Chat Memory (sessionKey=wa_phone)
                              ├── Tool: buscar_productos  (toolCode → Supabase GET)
                              ├── Tool: crear_pedido      (toolCode → Supabase POST + Resend if COD)
                              ├── Tool: generar_link_pago (toolCode → MP API + Supabase PATCH)
                              ├── Tool: consultar_pedido  (toolCode → Supabase GET)
                              └── Tool: escalar_a_humano  (toolCode → Supabase PATCH + Resend)
                        → Send WA Reply (HTTP → Meta Graph API)
                        → Save Outbound Message (HTTP/Supabase)
```

### Tool inputs (all `toolCode` — input via `query` variable)
| Tool | Input format |
|------|-------------|
| `buscar_productos` | string: search term |
| `crear_pedido` | JSON string: customer_name, customer_phone, address, city, department, items[], is_cod, conversation_id, customer_id |
| `generar_link_pago` | JSON string: order_id, amount, description |
| `consultar_pedido` | string: phone number (digits only) |
| `escalar_a_humano` | JSON string: reason, conversation_id |

### Key nodes
- AI Agent output: `$json.output`
- Chat memory table: `n8n_chat_histories` (auto-created in Railway Postgres)
- Session key: `wa_phone` — one memory thread per WhatsApp number

---

## Webhook URLs
- WhatsApp: `https://n8n-production-8ea7.up.railway.app/webhook/whatsapp`
- Mercado Pago: `https://n8n-production-8ea7.up.railway.app/webhook/mercadopago`
- Verify Token Meta: `ekinoxis_shopper_2026`

---

## Environment Variables (Railway)

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | Claude API |
| `SUPABASE_URL` | Supabase project URL |
| `SUPABASE_SERVICE_KEY` | Supabase service role key |
| `WA_ACCESS_TOKEN` | Meta WhatsApp permanent token |
| `WA_PHONE_NUMBER_ID` | WhatsApp Business phone number ID |
| `WA_BUSINESS_ACCOUNT_ID` | Meta Business Account ID |
| `WA_API_VERSION` | Meta API version (v21.0) |
| `WA_VERIFY_TOKEN` | Webhook verification token |
| `WEBHOOK_URL` | Public n8n URL (no trailing slash) |
| `MP_ACCESS_TOKEN` | Mercado Pago access token |
| `RESEND_API_KEY` | Resend email API key |
| `INTERNAL_EMAIL` | Team email for order/payment alerts |
| `FROM_EMAIL` | Sender email (needs verified Resend domain) |
| `N8N_API_KEY` | n8n REST API key (for programmatic deploys) |

---

## Deploy a workflow (CLI)

```bash
# Read workflow ID from CLAUDE.md table above, then:
python3 -c "
import json
with open('WF-whatsapp-agent.json') as f: wf = json.load(f)
payload = {'name': wf['name'], 'nodes': wf['nodes'], 'connections': wf['connections'], 'settings': wf.get('settings', {}), 'staticData': None}
print(json.dumps(payload))
" | curl -s -X PUT "https://n8n-production-8ea7.up.railway.app/api/v1/workflows/tbhGTQg6onwSpEns" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @-
```

## Test the flow (curl)

```bash
curl -X POST "https://n8n-production-8ea7.up.railway.app/webhook/whatsapp" \
  -H "Content-Type: application/json" \
  -d '{
    "entry": [{
      "changes": [{
        "value": {
          "messages": [{"from": "573001234567", "id": "msg001", "type": "text", "text": {"body": "Hola, qué productos tienen?"}, "timestamp": "1234567890"}],
          "contacts": [{"profile": {"name": "Test Usuario"}, "wa_id": "573001234567"}]
        }
      }]
    }]
  }'
```
