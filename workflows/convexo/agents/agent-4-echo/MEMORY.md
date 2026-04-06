# ECHO — Working Memory

## Technical Patterns

### Claude API in n8n
- **Node type:** `@n8n/n8n-nodes-langchain.lmChatAnthropic`
- **Agent type:** `toolsAgent` (NOT `openAiFunctionsAgent` — that's OpenAI-specific)
- **Credential key:** `anthropicApi` with `id` + `name: "Anthropic"`
- **Connection type:** `ai_languageModel` (same as OpenAI — no change needed)
- **typeVersion:** Use `1.2` for Anthropic node (same as OpenAI node)

### Workflow JSON Structure
```json
{
  "type": "@n8n/n8n-nodes-langchain.lmChatAnthropic",
  "parameters": {
    "model": "claude-sonnet-4-6",
    "options": {}
  },
  "credentials": {
    "anthropicApi": {
      "id": "anthropic-cred-id",
      "name": "Anthropic"
    }
  }
}
```

### Agent Node Migration
- WF01: `"agent": "openAiFunctionsAgent"` → `"agent": "toolsAgent"`
- WF02/WF03: `"agentType": "openAiFunctionsAgent"` → `"agentType": "toolsAgent"`
- Note: WF01 uses `agent` key, WF02/03 use `agentType` key — different param names!

### Environment Variables
- Always use `$env.VAR_NAME` in n8n expressions
- Never hardcode credentials in workflow JSON
- Google Sheet ID format: `1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms` (example)

### n8n Node Compatibility
- `lmChatAnthropic` typeVersion 1.2 = stable
- `agent` typeVersion 1.7 = current stable
- `googleSheets` typeVersion 4.5 = current (WF01), 4.4 = old (WF03) — update to 4.5
- `formTrigger` typeVersion 2.2 = current

### Common Errors
- **"Credential not found":** Create credential in n8n Settings → Credentials first
- **"toolsAgent not responding":** Check model name spelling exactly (case-sensitive)
- **"OAuth2 token expired":** Re-authorize Google credentials in n8n
- **"extractFromFile failed":** File must be actual PDF, not a Google Doc link

## Open Questions
- Should we pin model versions or always use latest? (Current: use specific IDs)
- Add n8n webhook auth via header token for extra security?
