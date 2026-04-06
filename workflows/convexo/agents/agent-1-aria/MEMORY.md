# ARIA — Working Memory

## Learned Patterns

### Score Calibration
- Companies with Deuda/EBITDA > 4x consistently score below 500
- Missing cash flow statements → automatic 150-point deduction from base
- Negative working capital + negative FCO = Crítico flag regardless of other ratios

### Common Edge Cases
- **Holding companies:** Consolidated vs standalone statements differ significantly
- **Seasonal businesses:** Single-year snapshot can be misleading — flag when detected
- **Startups (<3 years):** Standard ratios unreliable; weight qualitative factors more

### Colombian Context
- DIAN filing date: April 30 (persona natural), May 31 (persona jurídica)
- Superfinanciera regulates banks; Supersociedades for regular companies
- DataCrédito score range: 150–950 (different from our 0–1000 internal scale)

### API Notes
- Claude opus-4-6 handles financial JSON output reliably with explicit format instructions
- Always include example JSON in system prompt to anchor output format
- Temperature: keep default (1.0) — financial analysis benefits from consistency

## Open Questions
- How to handle companies with fiscal year not matching calendar year?
- Should we weight recent quarters more heavily than annual averages?
