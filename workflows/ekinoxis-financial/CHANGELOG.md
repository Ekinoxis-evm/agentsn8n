# Changelog — Ekinoxis Financial/Legal Services

## [2026-04-06] — Codebase reorganization
- **All**: Moved into `workflows/ekinoxis-financial/` subfolder for clean separation from Shopper Center project
- **All**: `agents/` and `scripts/` moved into this directory
- **All**: `QUICKSTART.md` moved here from repo root

## [2026-03-04] — Claude API migration
- **WF01/02/03**: Migrated from OpenAI GPT-4o → Anthropic Claude
- **WF01**: Model changed to `claude-opus-4-6`
- **WF02/03**: Model changed to `claude-sonnet-4-6`
- **All**: Agent type changed from `openAiFunctionsAgent` → `toolsAgent`
- **All**: Credential key changed to `anthropicApi`, name `"Anthropic"`

## [2026-03-04] — Initial setup
- **WF01**: Enterprise credit evaluation — Form → Drive → Claude Opus → Score 0-1000 → Sheets + Email
- **WF02**: Credit score recovery — Form → Sheets → Claude Sonnet → Email (3-stage, RC- case IDs)
- **WF03**: Traffic fines — Form → Sheets → Claude Sonnet → Email (free Step 1, MT- case IDs)
- Multi-agent system: ARIA, LEXI, NOVA, ECHO agents configured
