# Ekinoxis Agent Coordination Board

Shared task board for all 4 agents. Read and update this when tasks cross agent boundaries.

---

## Agent Status

| Agent | Status | Current Focus |
|-------|--------|---------------|
| ARIA (#1) | 🟢 Ready | WF01 — verify live credential binding + score output format |
| LEXI (#2) | 🟢 Ready | WF02+03 — test live output with claude-sonnet-4-6 |
| NOVA (#3) | 🟢 Ready | Sheets schema verification + SMTP delivery confirmation |
| ECHO (#4) | 🟢 Ready | toolsAgent compatibility verification + error workflow |

---

## Cross-Agent Tasks

| ID | Status | From | To | Task | Notes |
|----|--------|------|----|------|-------|
| COORD-002 | 🔴 BLOCKED | NOVA | ECHO | Confirm SMTP delivery after Claude API swap | Blocked on: live n8n setup (QUICKSTART Steps 1–6) |
| COORD-003 | 🔴 BLOCKED | ARIA | LEXI | Align on scoring JSON format consistency | Blocked on: WF01 live test run (ARIA P1). WF01 score 0–1000; WF02/03 use different output shape — normalize after first run |

---

## Blocked Tasks

*(none currently)*

---

## Handoff Log

| Date | From | To | Handoff | Resolution |
|------|------|----|---------|------------|
| 2026-03-04 | ECHO | ALL | Claude API migration completed for WF01/02/03 | Migrated to `lmChatAnthropic` + `toolsAgent` |
| 2026-03-04 | ECHO | ALL | Multi-agent system initialized | All agent folders created |
| 2026-03-04 | LEXI | — | WF02+03 migration verified + fixes applied | Fixed: WF03 typeVersion 1.1→1.2; WF02 added `fromEmail` to both email nodes |
| 2026-03-04 | ECHO | ALL | COORD-001 resolved | Credential names documented in QUICKSTART.md + workflows/README.md: `Google Drive`, `Google Sheets`, `Anthropic`, `Email SMTP` |
| 2026-03-04 | NOVA | ALL | COORD-004 resolved | COORDINATION.md process documented in "How to Use This Board" section — no further action needed |

---

## How to Use This Board

1. **Starting a cross-agent task:** Add a row to "Cross-Agent Tasks" with status ⚪ PENDING
2. **Picking up a task:** Change status to 🟡 IN PROGRESS, add your name to "To"
3. **Completing a task:** Move to "Handoff Log" with resolution notes
4. **Blocking an issue:** Add to "Blocked Tasks" with reason and who can unblock

---

## Escalation Matrix

| Issue Type | Primary | Backup |
|-----------|---------|--------|
| Financial analysis | ARIA | — |
| Legal content | LEXI | — |
| Sheets/email ops | NOVA | ECHO |
| n8n errors/config | ECHO | — |
| Cross-workflow | NOVA | ECHO |
