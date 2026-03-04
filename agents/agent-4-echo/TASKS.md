# ECHO — Task Queue

## Status Legend
- 🔴 BLOCKED — waiting on dependency
- 🟡 IN PROGRESS — actively working
- 🟢 DONE — completed
- ⚪ PENDING — queued

---

## Active Tasks

| Priority | Status | Task | Notes |
|----------|--------|------|-------|
| P1 | ⚪ PENDING | Create credentials in n8n (live environment) | Names must be exactly: `Anthropic`, `Google Drive`, `Google Sheets`, `Email SMTP` — see QUICKSTART Step 3 |
| P2 | ⚪ PENDING | Set GOOGLE_SHEET_ID env var in n8n | n8n Settings → Environment Variables → GOOGLE_SHEET_ID |
| P3 | 🔴 BLOCKED | Verify toolsAgent works with Claude in all 3 workflows | Blocked on: P1 + P2. Run test executions, check execution logs |
| P4 | 🔴 BLOCKED | Add error workflow for automatic failure alerts | Blocked on: P1. n8n Settings → Error Workflow → alert NOVA via email |
| P5 | 🔴 BLOCKED | Resolve COORD-002 with NOVA | Blocked on: P3. Confirm SMTP delivery after test runs |

---

## Backlog

- [ ] Webhook security (signature verification)
- [ ] Workflow versioning strategy
- [ ] Staging environment for workflow testing
- [ ] Rate limiting on form endpoints
- [ ] Credential rotation procedure doc

---

## Completed

- [2026-03-04] Initial workflow creation (WF01, WF02, WF03)
- [2026-03-04] Claude API migration — OpenAI → Anthropic in all 3 workflows
- [2026-03-04] `.env.example` updated with `ANTHROPIC_API_KEY` + Resend SMTP config
- [2026-03-04] Multi-agent system folder structure created
- [2026-03-04] QUICKSTART.md + workflows/README.md updated — credential names, Sheets schemas, full setup flow documented
