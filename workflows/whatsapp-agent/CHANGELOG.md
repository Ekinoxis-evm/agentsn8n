# Changelog — Shopper Center WhatsApp Agent

## [2026-04-06] — Codebase reorganization
- **All**: Moved into `workflows/whatsapp-agent/` with clear separation from Ekinoxis financial project
- **All**: `SHOPPER-CENTER-CONTEXT.md` moved to `CONTEXT.md` and updated (removed stale WF3/WF4 refs)
- **All**: Stale planning docs deleted (`agentewhatsapp.md`, `guiamvpwhatsappagent.md`)
- **WF1/WF2/WF5**: Per-workflow README files created

## [2026-04-06] — WF2 consolidated (5 workflows → 3)
- **WF2**: Absorbed WF3 (create-order) and WF4 (mercado-pago) inline as Switch branches
- **WF3**: Deleted from n8n and local repo (logic lives in WF2)
- **WF4**: Deleted from n8n and local repo (logic lives in WF2)
- **Railway**: Removed `INTERNAL_WHATSAPP` variable (replaced by email notifications)

## [2026-04-05] — Internal notifications switched to email
- **WF3**: Replaced WhatsApp notification to team with Resend HTTP email
- **WF5**: Replaced WhatsApp notification to team with Resend HTTP email
- **Railway**: Added `RESEND_API_KEY`, `INTERNAL_EMAIL`, `FROM_EMAIL`

## [2026-04-05] — COD vs pre-payment flow
- **WF2**: Added `Is COD?` branching logic in system prompt
- **WF3**: Added `Is COD?` IF node — COD notifies team immediately, pre-payment waits for MP webhook
- **WF2**: Added `consultar_pedido` tool + Query Orders node

## [2026-04-05] — Initial deployment to Railway
- **All**: 5 workflows deployed to `https://n8n-production-8ea7.up.railway.app`
- **WF1**: Fixed dual webhook (GET for verification, POST for messages)
- **WF2**: Fixed model to `claude-sonnet-4-6`, fixed triple `{{{` in Search Products URL
- **WF4**: Fixed double `https://` in MP back_urls
- **WF5**: Fixed filter column (`order_id` not `mp_preference_id`)
