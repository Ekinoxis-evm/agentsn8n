# NOVA — Task Queue

## Status Legend
- 🔴 BLOCKED — waiting on dependency
- 🟡 IN PROGRESS — actively working
- 🟢 DONE — completed
- ⚪ PENDING — queued

---

## Active Tasks

| Priority | Status | Task | Notes |
|----------|--------|------|-------|
| P1 | ⚪ PENDING | Create Google Sheets with exact tab + column schema | Follow QUICKSTART.md → Step 4 column definitions |
| P2 | 🔴 BLOCKED | Verify SMTP delivery on all 3 workflows (COORD-002) | Blocked on: P1 + QUICKSTART Steps 1–6. Confirm client + internal emails arrive |
| P3 | 🔴 BLOCKED | Confirm Sheets rows appear after test submissions | Blocked on: P1 + QUICKSTART Steps 1–6. Each workflow tab should get a new row |
| P4 | 🟢 DONE | Set up COORDINATION.md update process | COORDINATION.md already has "How to Use This Board" section — complete |

---

## Backlog

- [ ] Sheets health check workflow (periodic ping)
- [ ] Email delivery monitoring
- [ ] Retry logic for failed SMTP sends
- [ ] Slack/WhatsApp internal notifications option
- [ ] Weekly summary report across all 3 workflows

---

## Completed

*(none yet)*
