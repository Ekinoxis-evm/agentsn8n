# Shopper Center — Project Context
> Last updated: 2026-04-06

---

## What this is

AI sales agent via WhatsApp for **Shopper Center** — Colombian dropshipping.
Customer writes on WhatsApp → Claude closes the sale → team creates order in Dropi.

**Stack:** n8n (Railway) + Supabase + WhatsApp Cloud API + Claude (Anthropic) + Mercado Pago + Dropi + Resend

---

## Infrastructure

### n8n — Automation
- **URL:** `https://n8n-production-8ea7.up.railway.app`
- **Platform:** Railway (project `ekinoxis-n8n`)
- **Internal DB:** PostgreSQL on Railway (for n8n workflow data)

### Environment Variables (Railway)

| Variable | Value/Description |
|----------|------------------|
| `SUPABASE_URL` | `https://jfhxmmkwdedmlixhogae.supabase.co` |
| `SUPABASE_SERVICE_KEY` | Supabase service role key |
| `ANTHROPIC_API_KEY` | Claude API key |
| `WA_PHONE_NUMBER_ID` | `1104608296062284` |
| `WA_BUSINESS_ACCOUNT_ID` | `1294365789425797` |
| `WA_ACCESS_TOKEN` | Permanent Meta System User token |
| `WA_VERIFY_TOKEN` | `ekinoxis_shopper_2026` |
| `WA_API_VERSION` | `v21.0` |
| `WEBHOOK_URL` | `https://n8n-production-8ea7.up.railway.app` |
| `MP_ACCESS_TOKEN` | Mercado Pago production token |
| `DROPI_API_URL` | `https://api.dropi.co` |
| `DROPI_INTEGRATION_TOKEN` | APIFY token (order creation only) |
| `RESEND_API_KEY` | Resend email API key |
| `INTERNAL_EMAIL` | `shopertiendaonline@gmail.com` |
| `FROM_EMAIL` | `onboarding@resend.dev` (update when domain verified) |
| `N8N_API_KEY` | n8n REST API key (programmatic deploys) |

---

## Active Workflows (3 total)

| ID | File | Role |
|----|------|------|
| `Khcso1q69XXXaRNS` | `WF1-whatsapp-webhook.json` | Receive Meta webhook → save DB → trigger agent |
| `tbhGTQg6onwSpEns` | `WF2-ai-agent.json` | AI agent + order creation + MP payment (all inline) |
| `HhlhGi4xgbFPI2N0` | `WF5-mp-webhook.json` | Receive MP webhook → confirm payment → notify team |

### Webhook URLs
| Service | URL |
|---------|-----|
| WhatsApp (Meta) | `https://n8n-production-8ea7.up.railway.app/webhook/whatsapp` |
| Mercado Pago | `https://n8n-production-8ea7.up.railway.app/webhook/mercadopago` |

---

## Database (Supabase)

**Project:** `shopper-center` | **Region:** São Paulo (`sa-east-1`)

| Table | Description |
|-------|-------------|
| `products` | Product catalog with Dropi variants |
| `customers` | Customers identified by WhatsApp number |
| `conversations` | Active conversations (`ai_active` / `human_active` / `closed`) |
| `messages` | Full message history (inbound + outbound) — business audit log |
| `orders` | Orders closed by the agent |
| `payments` | Mercado Pago payments |
| `dropi_orders` | Dropi orders (for future direct API) |
| `agent_config` | Dynamic agent config (tone, policies, shipping, escalation triggers) |

### Active Products

| dropi_product_id | Name | sale_price | Variants |
|-----------------|------|-----------|---------|
| `2039660` | Lattafa Give Me Gourmand Berry On Top | $120.000 COP | None |
| `2105529` | Body Selección Colombia | (to define) | Azul `2075676`, Rojo `2075677`, Amarillo `2050712`, Negro `2050713` |
| `2063578` | Camiseta Selección Colombia Bordada | $80.000 COP | 10 sizes (IDs: 1980314–1980323) |

### Camiseta Bordada variant IDs
| Dropi ID | Size | | Dropi ID | Size |
|----------|------|-|----------|------|
| 1980314 | Mujer S | | 1980319 | Hombre S |
| 1980315 | Mujer M | | 1980320 | Hombre M |
| 1980316 | Mujer L | | 1980321 | Hombre L |
| 1980317 | Mujer XL | | 1980322 | Hombre XL |
| 1980318 | Mujer 2XL | | 1980323 | Hombre 2XL |

---

## WhatsApp Cloud API (Meta)

- **Phone Number ID:** `1104608296062284`
- **WABA ID:** `1294365789425797`
- **Verify Token:** `ekinoxis_shopper_2026`
- **Business verification:** In progress (limits 250 conversations/24h until approved)

---

## Dropi

- **Token type:** APIFY (order creation only — read endpoints not available)
- **Current process:** Agent closes sale → team creates order manually in Dropi
- **Pending:** Token with full REST access to automate order creation

### Manual process for team (on COD order notification)
1. Go to `app.dropi.co` → Create Order
2. Copy customer data from notification email
3. Select product by Dropi ID + variant by Dropi ID
4. Choose carrier (Veloces is cheapest)
5. Select "Con Recaudo" (COD) or "Sin Recaudo" (prepaid) per `is_cod` field

---

## Mercado Pago

- **Token:** Production (`APP_USR-...`)
- **Currency:** COP
- **Methods:** Tarjeta, PSE, Efecty, Baloto, Daviplata, Nequi
- **Fee:** ~3.49% + IVA per transaction

---

## Pending before full launch

- [ ] Complete Meta business verification (in progress)
- [ ] Define sale price for Body Selección Colombia
- [ ] Verify Resend sending domain (currently using `onboarding@resend.dev`)
- [ ] Add more products to Supabase catalog
- [ ] Test full end-to-end flow with real WhatsApp number
