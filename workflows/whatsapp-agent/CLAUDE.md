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

## Active Workflows (3 total)

| ID | File | Role | Active |
|----|------|------|--------|
| `Khcso1q69XXXaRNS` | `WF1-whatsapp-webhook.json` | Receive Meta webhook → save to DB → trigger AI agent | ✅ |
| `tbhGTQg6onwSpEns` | `WF2-ai-agent.json` | AI agent + order creation + MP payment link (all in one) | ✅ |
| `HhlhGi4xgbFPI2N0` | `WF5-mp-webhook.json` | Receive Mercado Pago webhook → confirm payment → notify team | ✅ |

---

## WF2 Architecture (consolidated)

```
Input
  → Load History + Load Products + Load Config (parallel)
  → Build Prompt (Code)
  → Claude API (Anthropic HTTP)
  → Parse Response (Code)
  → Has Tool? (IF)
      false → Send WA Message → Save Outbound Message
      true  → Which Tool? (Switch)
                ├── crear_pedido    → Parse Order Data → Insert Order → Is COD?
                │                       COD=true  → Notify Team COD (Resend) → Return Order
                │                       COD=false → Return Order
                │                   → Build Tool Result
                ├── generar_link_pago → Parse MP Input → Create MP Preference → Save Payment → Return Payment URL
                │                   → Build Tool Result
                ├── buscar_productos → Search Products → Build Tool Result
                ├── escalar_a_humano → Escalate Conversation → Build Tool Result
                └── consultar_pedido → Query Orders → Build Tool Result
              → Claude Final Reply → Extract Final Reply → Send WA Message → Save Outbound Message
```

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
with open('WF2-ai-agent.json') as f: wf = json.load(f)
payload = {'name': wf['name'], 'nodes': wf['nodes'], 'connections': wf['connections'], 'settings': wf.get('settings', {}), 'staticData': None}
print(json.dumps(payload))
" | curl -s -X PUT "https://n8n-production-8ea7.up.railway.app/api/v1/workflows/{WF_ID}" \
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
