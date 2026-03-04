# Ekinoxis n8n — Start Here (Zero to Running)

This guide takes you from nothing to all 3 workflows live, plus the Claude Code agent system running alongside them.
The clear path to run from scratch:
  1. Follow QUICKSTART.md Steps 1–7 (n8n → credentials → Sheets → import → test)
  2. Once live, ECHO's P1+P2 unblock everything else in cascade
---

## What You're Setting Up

| Piece | What it is |
|-------|-----------|
| **n8n** | Workflow automation platform (runs locally or self-hosted) |
| **3 Workflows** | Form → AI analysis → Google Sheets + Email, for each service |
| **Claude API** | Powers the AI analysis inside each workflow via Anthropic |
| **Claude Code Agents** | 4 specialized Claude Code sessions for maintaining the system |

The Claude API runs **inside** the n8n workflows automatically. The Claude Code agents are **developer tools** used to maintain and update the system.

---

## Prerequisites

Before starting, you need accounts/access for:

- [ ] [Anthropic Console](https://console.anthropic.com/) — for Claude API key
- [ ] [Google Cloud Console](https://console.cloud.google.com/) — for OAuth2 (Drive + Sheets)
- [ ] [Resend](https://resend.com/) — for transactional email (SMTP)
- [ ] Node.js ≥ 18 installed (for `npx n8n`)

---

## Step 1 — Run n8n

**Option A: Docker (recommended for stability)**
```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

**Option B: npx**
```bash
npx n8n
```

Open: [http://localhost:5678](http://localhost:5678)

Create your n8n account (local only, no data sent externally).

---

## Step 2 — Set Environment Variable

In n8n, go to **Settings → Environment Variables** and add:

| Variable | Value |
|----------|-------|
| `GOOGLE_SHEET_ID` | The ID from your Google Sheet URL (see Step 4) |

> Your Google Sheet URL looks like:
> `https://docs.google.com/spreadsheets/d/`**`YOUR_SHEET_ID`**`/edit`

---

## Step 3 — Create Credentials in n8n

Go to **Settings → Credentials → Add Credential** and create these four. The names must match exactly.

### 3a. Anthropic API
- **Credential name:** `Anthropic`
- **Type:** Anthropic
- **API Key:** your key from [console.anthropic.com](https://console.anthropic.com/)

### 3b. Google Drive OAuth2
- **Credential name:** `Google Drive`
- **Type:** Google Drive OAuth2 API
- In [Google Cloud Console](https://console.cloud.google.com/):
  1. Create a project → Enable **Google Drive API**
  2. OAuth consent screen → External → add your email as test user
  3. Credentials → OAuth 2.0 Client ID → Web application
  4. Add redirect URI: `http://localhost:5678/rest/oauth2-credential/callback`
  5. Copy Client ID + Client Secret → paste into n8n → click **Connect**

### 3c. Google Sheets OAuth2
- **Credential name:** `Google Sheets`
- **Type:** Google Sheets OAuth2 API
- Same Google Cloud project: Enable **Google Sheets API**
- Create another OAuth 2.0 Client ID (or reuse the same one)
- Same redirect URI, same flow

### 3d. SMTP (Resend)
- **Credential name:** `Email SMTP`
- **Type:** SMTP
- **Host:** `smtp.resend.com`
- **Port:** `465`
- **SSL:** on
- **User:** `resend`
- **Password:** your Resend API key

> **Domains in Resend:** Add and verify your sending domain(s).
> - WF01 sends from `financial@convexo.org`
> - WF02 + WF03 send from `servicios@thronium.org`
>
> Both use the same `Email SMTP` credential. If you want two separate SMTP creds
> (one per domain), you'll need to update the email node credentials in each workflow JSON.

---

## Step 4 — Set Up Google Sheets

Create a new Google Spreadsheet. Add **3 tabs** with these exact names and column headers:

### Tab 1: `Credit_Evaluations` (Workflow 01)

| Column | Notes |
|--------|-------|
| Solicitud ID | Auto-generated: `CRED-{timestamp}` |
| Fecha | Date of submission |
| Empresa | Company name |
| NIT | Colombian tax ID |
| Año Fundación | Year founded |
| Años Operación | Years in operation |
| Productos/Servicios | Description |
| Clientes | Main clients |
| Proveedores | Main suppliers |
| Distribución | Distribution channels |
| Email | Contact email |
| Teléfono | Phone number |
| Carpeta Drive | Link to auto-created Drive folder |
| Certificado Existencia | Drive file URL |
| Balance General | Drive file URL |
| Estado Resultados | Drive file URL |
| Flujo Caja | Drive file URL |
| RUT | Drive file URL |
| Estado | Status (updated automatically) |
| Score | 0–1000 (filled after AI analysis) |
| Nivel Riesgo | Risk level (filled after AI analysis) |

### Tab 2: `Credit_Recovery_Clients` (Workflow 02)

| Column | Notes |
|--------|-------|
| caseId | Auto-generated: `RC-{timestamp}` |
| timestamp | ISO timestamp |
| fecha | Date (Colombia timezone) |
| nombres | First name(s) |
| apellidos | Last name(s) |
| tipoDocumento | Cédula / Pasaporte / Cédula Extranjería |
| numeroDocumento | Document number |
| lugarExpedicion | City of document issue |
| direccion | Home address |
| departamento | Department (state) |
| ciudad | City |
| email | Contact email |
| celular | Mobile number |
| nombreCompleto | Full name (auto-combined) |
| estado | Status |
| etapa | Stage number (1, 2, or 3) |
| valorPaso1 | 70000 |
| valorPaso2 | 280000 |
| valorPaso3 | 350000 |

### Tab 3: `Traffic_Fines_Cases` (Workflow 03)

| Column | Notes |
|--------|-------|
| caseId | Auto-generated: `MT-{timestamp}` |
| timestamp | ISO timestamp |
| fecha | Date (Colombia timezone) |
| nombres | First name(s) |
| apellidos | Last name(s) |
| tipoDocumento | Document type |
| numeroDocumento | Document number |
| lugarExpedicion | City of document issue |
| direccion | Home address |
| departamento | Department |
| ciudad | City |
| email | Contact email |
| celular | Mobile number |
| placasVehiculo | Vehicle plate (optional) |
| organismoTransito | Traffic authority |
| cobroCoactivo | Sí / No / No sabe |
| nombreCompleto | Full name (auto-combined) |
| estado | Status |
| etapa | Stage (starts at 1) |
| tipoCaso | "Multas de Tránsito" |

Copy the Spreadsheet ID from the URL and set it as `GOOGLE_SHEET_ID` in Step 2.

---

## Step 5 — Import Workflows

In n8n: **Workflows → Import from file**

Import in this order:
1. `workflows/01-enterprise-credit-evaluation.json`
2. `workflows/02-credit-score-recovery.json`
3. `workflows/03-traffic-fines.json`

After importing each workflow, open it and verify the credentials are linked (you should see your credential names auto-resolved, not red/broken).

---

## Step 6 — Activate Workflows

For each workflow:
1. Open it in n8n
2. Toggle **Active** (top right)
3. Copy the **Form URL** from the trigger node — this is your client-facing link

| Workflow | Form URL will be |
|----------|-----------------|
| WF01 Enterprise Credit | `http://localhost:5678/form/...` |
| WF02 Credit Recovery | `http://localhost:5678/form/...` |
| WF03 Traffic Fines | `http://localhost:5678/form/...` |

---

## Step 7 — Test Each Workflow

### WF01 Test
Open the form URL and submit:
- Company name: `Empresa Test S.A.S`
- NIT: `900000000-1`
- Year founded: `2020`
- Upload any PDF for each file field (even a blank one)
- Use a real email you can check

Expected result: Email received with credit analysis + row added to `Credit_Evaluations` tab.

### WF02 Test
Submit the recovery form with real test data.
Expected: Confirmation email with `RC-` case ID + row in `Credit_Recovery_Clients`.

### WF03 Test
Submit the traffic fines form. Try with `¿Tiene Cobro Coactivo? = Sí` to see urgency styling.
Expected: Free diagnostic email with `MT-` case ID + row in `Traffic_Fines_Cases`.

---

## Claude Code Agent System

The 4 agents are **Claude Code sessions** used by developers to maintain this system. They are NOT n8n nodes — they're how the team works with the codebase.

| When you open Claude Code in this project | You boot as... |
|-------------------------------------------|----------------|
| Working on WF01 financial analysis logic | **ARIA** → read `agents/agent-1-aria/CLAUDE.md` |
| Working on WF02/03 legal content | **LEXI** → read `agents/agent-2-lexi/CLAUDE.md` |
| Working on Sheets/email ops | **NOVA** → read `agents/agent-3-nova/CLAUDE.md` |
| Working on n8n config, bugs, infra | **ECHO** → read `agents/agent-4-echo/CLAUDE.md` |

### Option A — Launch All Agents at Once (tmux)

```bash
# Requirements: tmux + Claude Code CLI
brew install tmux
npm install -g @anthropic-ai/claude-code

# Launch all 4 agents in a 2×2 grid
chmod +x scripts/launch-agents.sh
./scripts/launch-agents.sh
```

This opens a tmux session `ekinoxis` with all 4 agents in split panes:
```
┌──────────────────┬──────────────────┐
│  ARIA  (opus)    │  LEXI (sonnet)   │
│  WF01 financial  │  WF02+03 legal   │
├──────────────────┼──────────────────┤
│  NOVA  (haiku)   │  ECHO (sonnet)   │
│  ops + sheets    │  n8n infra       │
└──────────────────┴──────────────────┘
```

Tmux shortcuts: `Ctrl+B → arrows` navigate · `Ctrl+B Z` zoom · `Ctrl+B D` detach

### Option B — Boot a Single Agent

```
1. Open a Claude Code session in this project directory
2. Tell Claude: "Boot as ARIA" (or LEXI / NOVA / ECHO)
3. Claude reads the agent's CLAUDE.md and TASKS.md
4. Check COORDINATION.md for cross-agent blockers
5. Start working on the highest-priority task
```

### How the Claude API Connects to n8n

The Claude AI inside each workflow runs via the `lmChatAnthropic` node:
- **WF01:** `claude-opus-4-6` — deep financial document analysis
- **WF02:** `claude-sonnet-4-6` — legal diagnosis for credit recovery
- **WF03:** `claude-sonnet-4-6` — legal analysis for traffic fines

These are configured inside the workflow JSONs. The `Anthropic` credential you set up in Step 3 is what connects them to the real Claude API.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Credential shows red/broken | Name in n8n must match exactly: `Google Drive`, `Google Sheets`, `Anthropic`, `Email SMTP` |
| Sheets not updating | Check `GOOGLE_SHEET_ID` env var in n8n Settings → tab names must be exact |
| Email not sending | Verify Resend domain DNS records; check API key is used as SMTP password |
| Claude not responding | Verify Anthropic API key has credits; check model name in workflow JSON |
| File upload fails (WF01) | n8n needs enough disk space; check `~/.n8n` folder permissions |
| Form URL not found | Workflow must be **Active** for form URL to work |

---

## File Reference

```
/Users/williammartinez/Documents/ekinoxis/n8n/
├── QUICKSTART.md                      ← You are here
├── CLAUDE.md                          ← Agent org chart (Claude Code)
├── scripts/
│   └── launch-agents.sh               ← Launch all 4 agents in tmux 2×2
├── agents/
│   ├── COORDINATION.md                ← Shared agent task board
│   ├── agent-1-aria/                  ← ARIA: financial analysis
│   ├── agent-2-lexi/                  ← LEXI: legal services
│   ├── agent-3-nova/                  ← NOVA: ops + notifications
│   └── agent-4-echo/                  ← ECHO: n8n infra + tech
└── workflows/
    ├── 01-enterprise-credit-evaluation.json
    ├── 02-credit-score-recovery.json
    ├── 03-traffic-fines.json
    ├── .env.example                   ← Reference for env vars
    └── README.md                      ← Workflow technical docs
```
