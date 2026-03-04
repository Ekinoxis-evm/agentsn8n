# LEXI — Task Queue

## Status Legend
- 🔴 BLOCKED — waiting on dependency
- 🟡 IN PROGRESS — actively working
- 🟢 DONE — completed
- ⚪ PENDING — queued

---

## Active Tasks

| Priority | Status | Task | Notes |
|----------|--------|------|-------|
| P1 | 🔴 BLOCKED | Run live test of WF02 — submit credit recovery form | Blocked on: QUICKSTART Steps 1–6. Verify claude-sonnet-4-6 diagnosis + RC- case email |
| P2 | 🔴 BLOCKED | Run live test of WF03 — submit with Cobro Coactivo = Sí | Blocked on: QUICKSTART Steps 1–6. Verify urgency email styling (red header) |
| P3 | 🔴 BLOCKED | Coordinate with ARIA on COORD-003 | Blocked on: ARIA P1 live test run. Agree on normalized output JSON format |
| P4 | ⚪ PENDING | Add prescription date calculator to WF03 | Auto-compute prescripción date from notification date (Ley 769/2002: 3 años) |

---

## Backlog

- [ ] Paso 2 full document drafting flow (Derecho de Petición draft)
- [ ] SIMIT (national fine registry) integration check
- [ ] Reminder system for cobro coactivo urgent cases
- [ ] Draft Paz y Salvo template for Paso 3

---

## Completed

- [2026-03-04] P1: Verified Claude API migration in WF02 + WF03 — both use `lmChatAnthropic` + `toolsAgent` + `claude-sonnet-4-6`
- [2026-03-04] P3: Legal content validated — Ley 1266/2008, Ley 769/2002, cobro coactivo urgency, prescripción dates — accurate
- [2026-03-04] Applied fixes: WF03 typeVersion 1.1→1.2; WF02 `fromEmail` added to both email nodes
