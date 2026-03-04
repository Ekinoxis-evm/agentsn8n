# ECHO — Skills & Capabilities

## n8n Architecture
- Workflow JSON structure (nodes, connections, meta, settings)
- Node types: formTrigger, set, code, googleDrive, googleSheets, emailSend, respondToWebhook
- LangChain nodes: `@n8n/n8n-nodes-langchain.agent`, `lmChatAnthropic`
- Connection types: main, ai_languageModel
- TypeVersions and compatibility matrix

## Claude API Integration
- Node type: `@n8n/n8n-nodes-langchain.lmChatAnthropic`
- Agent type: `toolsAgent` (compatible with Anthropic — replaces openAiFunctionsAgent)
- Credential type: `anthropicApi`
- Model assignments:
  - Workflow 01: `claude-opus-4-6` (complex financial analysis)
  - Workflow 02: `claude-sonnet-4-6` (legal document generation)
  - Workflow 03: `claude-sonnet-4-6` (legal analysis)

## Credential Management
- Google Drive OAuth2: `googleDriveOAuth2Api`
- Google Sheets OAuth2: `googleSheetsOAuth2Api`
- Anthropic: `anthropicApi`
- SMTP: `smtp`
- Environment variables: `GOOGLE_SHEET_ID`, `INTERNAL_EMAIL`, `FROM_EMAIL`, `ANTHROPIC_API_KEY`

## Debugging Skills
- n8n execution error analysis
- API response parsing issues
- JSON schema validation
- OAuth2 token refresh troubleshooting
- SMTP delivery failure diagnosis

## DevOps
- n8n local setup: `npx n8n` or Docker
- Workflow import/export via UI
- Version control for workflow JSONs
- `.env.example` maintenance

## Escalation Triggers
- Financial logic questions → ARIA
- Legal accuracy questions → LEXI
- Operational monitoring → NOVA
