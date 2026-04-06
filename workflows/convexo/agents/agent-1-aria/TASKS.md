# ARIA — Task Queue

## Status Legend
- 🔴 BLOCKED — waiting on dependency
- 🟡 IN PROGRESS — actively working
- 🟢 DONE — completed
- ⚪ PENDING — queued

---

## Active Tasks

| Priority | Status | Task | Notes |
|----------|--------|------|-------|
| P1 | 🔴 BLOCKED | Run live test of WF01 — submit form with real PDFs | Blocked on: QUICKSTART Steps 1–6 (n8n setup + credentials + import). Verify claude-opus-4-6 returns valid score JSON |
| P2 | 🔴 BLOCKED | Validate score output JSON shape | Blocked on: P1. Keys: score, nivelRiesgo, categoria, resumenEjecutivo, indicadores, fortalezas, riesgos, recomendacion, limiteCredito |
| P3 | 🔴 BLOCKED | Document edge cases in MEMORY.md | Blocked on: P1. Missing docs, startup companies, holding companies |
| P4 | 🔴 BLOCKED | Coordinate with LEXI on COORD-003 | Blocked on: P1 live test run. Normalize output JSON format across WF01/02/03 |

---

## Backlog

- [ ] Add sectoral benchmarks (manufacturing vs services vs retail)
- [ ] Score trend tracking (compare across periods)
- [ ] DataCrédito bureau cross-reference step
- [ ] Automated red-flag detection for fraudulent documents
- [ ] Handle fiscal year ≠ calendar year edge case

---

## Completed

- [2026-03-04] Claude API migration verified — WF01 uses `lmChatAnthropic` + `toolsAgent` + `claude-opus-4-6`
