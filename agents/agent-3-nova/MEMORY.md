# NOVA — Working Memory

## Operational Patterns

### Google Sheets
- **Schema drift:** autoMapInputData is used in WF02/WF03 — if columns change, schema updates automatically
- **WF01 uses defineBelow:** explicit column mapping — any new fields need manual addition
- **OAuth2 refresh:** Google tokens expire after 1 hour of inactivity — n8n auto-refreshes but monitor
- **Rate limits:** Google Sheets API: 100 requests/100 seconds per user

### SMTP Delivery
- **WF01:** Uses `noreply@ekinoxis.com` hardcoded — consider moving to `FROM_EMAIL` env var
- **WF02/WF03:** Use `$env.FROM_EMAIL` correctly
- **HTML emails:** Complex HTML in JSON — escape issues can silently break templates
- **SMTP timeouts:** Common failure mode — ECHO should add retry logic

### Coordination Patterns
- **ARIA → NOVA:** "Sheets append failed for case CRED-XYZ"
- **LEXI → NOVA:** "Email not delivered to client RC-XYZ"
- **NOVA → ECHO:** "Node X throwing error Y, needs fix"
- **Update COORDINATION.md** whenever a task crosses agent boundaries

### Environment Setup Checklist
```
[ ] GOOGLE_SHEET_ID set in n8n
[ ] INTERNAL_EMAIL set in n8n
[ ] FROM_EMAIL set in n8n
[ ] ANTHROPIC_API_KEY set in n8n
[ ] Google Drive OAuth2 connected
[ ] Google Sheets OAuth2 connected
[ ] Anthropic credential created
[ ] SMTP credential configured
```

## Open Questions
- Should we add a dead letter queue for failed emails?
- Can we use n8n's built-in error workflow for automatic NOVA alerts?
