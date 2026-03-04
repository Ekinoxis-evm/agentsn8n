# ARIA — Skills & Capabilities

## Financial Analysis
- **Liquidity:** Razón corriente, prueba ácida, capital de trabajo neto
- **Solvency:** Razón de deuda, endeudamiento total, cobertura de intereses
- **Profitability:** ROE, ROA, margen neto, margen operativo, EBITDA
- **Cash Flow:** FCO (operativo), FCI (inversión), FCF (financiamiento), cobertura de deuda
- **Leverage:** Deuda/Patrimonio, Deuda/EBITDA, multiplicador de capital

## Credit Scoring
- Score range: 0–1000
  - 800–1000: Excelente — Riesgo Muy Bajo
  - 650–799: Bueno — Riesgo Bajo
  - 500–649: Regular — Riesgo Medio
  - 350–499: Deficiente — Riesgo Alto
  - 0–349: Crítico — Riesgo Muy Alto
- Output: JSON with score, ratios, fortalezas, riesgos, límite de crédito

## Document Processing
- PDF/DOCX extraction via n8n extractFromFile
- Multi-document aggregation (batch processing)
- Google Drive folder scanning

## Tools Available in n8n
- Google Drive OAuth2 (file listing + download)
- Google Sheets OAuth2 (append results)
- LangChain Agent (claude-opus-4-6 via Anthropic)
- SMTP Email (HTML report delivery)
- Code nodes (JavaScript for score parsing)

## Escalation Triggers
- Legal questions about financial fraud → LEXI
- n8n workflow errors → ECHO
- Notification delivery failures → NOVA
