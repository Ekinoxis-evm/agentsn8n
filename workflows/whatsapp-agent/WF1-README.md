# WF1: WhatsApp Webhook

## Purpose
Receives all WhatsApp messages from Meta, saves them to Supabase, responds 200 OK immediately, then triggers the AI agent asynchronously.

## File
`WF1-whatsapp-webhook.json`

## n8n Workflow ID
`Khcso1q69XXXaRNS`

## Status
Active

## Trigger
Two webhooks on path `/webhook/whatsapp`:
- `GET` — Meta verification handshake (responds `hub.challenge`)
- `POST` — Incoming customer messages

## Node Flow
```
Webhook GET  → Respond Challenge (200 + hub.challenge)

Webhook POST → Extract Message (Code)
                 ↓ skip=true (non-text/no message)
               Respond 200 Skip
                 ↓ skip=false
               Upsert Customer (HTTP → Supabase)
               Upsert Conversation (HTTP → Supabase)
               Save Message (HTTP → Supabase)
               Respond 200 OK
               Trigger AI Agent (executeWorkflow → WF2, async)
```

## Inputs
- Meta WhatsApp Cloud API webhook POST payload

## Outputs
- `customers` row (upserted by `wa_phone`)
- `conversations` row (upserted by `wa_phone`, status `ai_active`)
- `messages` row (inbound, direction `inbound`)
- Triggers WF2 with: `wa_phone`, `message_text`, `customer_name`, `conversation_id`, `customer_id`

## Environment Variables
| Variable | Purpose |
|----------|---------|
| `SUPABASE_URL` | Supabase project URL |
| `SUPABASE_SERVICE_KEY` | Supabase auth |
| `WA_VERIFY_TOKEN` | Meta webhook verification token |

## Known Issues / TODOs
- Only processes `text` type messages — audio/image returns `skip=true` (Claude handles this gracefully in WF2)
- Supabase upserts use HTTP Request (not native Supabase node) — keep until upsert `conflictTarget` verified in native node
