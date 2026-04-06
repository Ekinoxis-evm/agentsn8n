# NOVA — Skills & Capabilities

## Google Sheets Operations
- Append rows to: `Credit_Evaluations`, `Credit_Recovery_Clients`, `Traffic_Fines_Cases`
- Batch updates for status changes
- Schema validation (column mapping)
- Environment variable: `GOOGLE_SHEET_ID`

## Email Operations
- HTML email delivery via SMTP
- Template management for client-facing emails
- Internal notification routing to `INTERNAL_EMAIL`
- Sender configuration via `FROM_EMAIL`
- Bounce monitoring and retry logic

## Coordination
- Maintain `agents/COORDINATION.md` task board
- Route blockers between agents
- Track cross-workflow dependencies
- Status updates: BLOCKED / IN PROGRESS / DONE

## Monitoring
- Workflow execution success/failure tracking
- Credential expiry alerts (Google OAuth2 tokens rotate)
- API rate limit monitoring (Anthropic, Google)
- Sheet row count health checks

## Environment Variables Managed
```
GOOGLE_SHEET_ID      - shared across all 3 workflows
INTERNAL_EMAIL       - team notification recipient
FROM_EMAIL           - SMTP sender address
ANTHROPIC_API_KEY    - Claude API (all 3 AI nodes)
```

## Escalation Triggers
- Financial analysis needed → ARIA
- Legal content needed → LEXI
- n8n node broken → ECHO
