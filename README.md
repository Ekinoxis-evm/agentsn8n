# Ekinoxis n8n — Automation Platform

Two automation projects running on a shared n8n instance (Railway).

## Projects

| Project | Directory | Status | Description |
|---------|-----------|--------|-------------|
| **Ekinoxis Financial/Legal** | `workflows/ekinoxis-financial/` | Stable | Credit evaluation, credit recovery, traffic fines — Colombia |
| **Shopper Center WhatsApp Agent** | `workflows/whatsapp-agent/` | Active | AI sales agent via WhatsApp for Colombian dropshipping |

## Shared Infrastructure

- **n8n:** `https://n8n-production-8ea7.up.railway.app` (Railway, project `ekinoxis-n8n`)
- **Shared credentials:** Anthropic API, Resend SMTP
- **n8n API Key:** Railway env `N8N_API_KEY`

## Quick Start

- **Ekinoxis Financial:** `workflows/ekinoxis-financial/QUICKSTART.md`
- **Shopper Center:** `workflows/whatsapp-agent/CLAUDE.md`

## For Claude Code

Read `CLAUDE.md` to be routed to the correct project context.
