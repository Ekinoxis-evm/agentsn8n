# WF5: Mercado Pago Payment Confirmation

## Purpose
Receives Mercado Pago webhooks, verifies payment approval, updates the database, confirms to the customer via WhatsApp, and notifies the team by email to create the order in Dropi.

## File
`WF5-mp-webhook.json`

## n8n Workflow ID
`HhlhGi4xgbFPI2N0`

## Status
Active

## Trigger
Webhook POST on path `/webhook/mercadopago` — called by Mercado Pago on payment events

## Node Flow
```
MP Webhook (POST)
  → Is Payment? (IF — checks body.type === 'payment')
      false → (end, no action)
      true  → Get Payment Details (HTTP GET → api.mercadopago.com/v1/payments/{id})
              → Is Approved? (IF — checks status === 'approved')
                  false → (end, no action)
                  true  → Update Payment (HTTP PATCH → Supabase payments, filter: order_id)
                          → Update Order Paid (HTTP PATCH → Supabase orders, status: 'paid')
                          → Confirm to Customer (HTTP POST → Meta WhatsApp API)
                          → Notify Team Payment (HTTP POST → Resend email)
```

## Inputs
- Mercado Pago webhook payload (`body.type`, `body.data.id`)
- MP payment details fetched from MP API

## Outputs
- `payments` row updated: `status=approved`, `mp_payment_id`, `mp_status`, `mp_payment_type`, `paid_at`, `raw_webhook`
- `orders` row updated: `status=paid`
- WhatsApp message to customer confirming payment + order number
- Resend email to internal team: "Pago confirmado — crear en Dropi sin recaudo"

## Environment Variables
| Variable | Purpose |
|----------|---------|
| `MP_ACCESS_TOKEN` | Mercado Pago API auth |
| `SUPABASE_URL` + `SUPABASE_SERVICE_KEY` | Database updates |
| `WA_ACCESS_TOKEN` + `WA_PHONE_NUMBER_ID` + `WA_API_VERSION` | WhatsApp confirmation |
| `RESEND_API_KEY` + `FROM_EMAIL` + `INTERNAL_EMAIL` | Team email notification |

## Known Issues / TODOs
- Customer phone for WhatsApp confirmation read from `payer.phone.number` in MP payload — may be empty if payer didn't fill it
- No retry logic if WhatsApp send fails after payment confirmed
- `responseMode: lastNode` — n8n responds to MP webhook only after full chain completes
