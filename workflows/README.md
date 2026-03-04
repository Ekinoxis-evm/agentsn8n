# n8n Workflows — Ekinoxis Automations

## Overview

Three automated workflows built on n8n for financial and legal services (Colombia).

| # | Workflow | AI Model | Brand | Case ID |
|---|----------|----------|-------|---------|
| 01 | Enterprise Credit Evaluation | `claude-opus-4-6` | Convexo | `CRED-` |
| 02 | Credit Score Recovery | `claude-sonnet-4-6` | Thronium | `RC-` |
| 03 | Traffic Fines Resolution | `claude-sonnet-4-6` | Thronium | `MT-` |

---

## Workflow 01 — Enterprise Credit Evaluation

**File:** `01-enterprise-credit-evaluation.json`
**Purpose:** Evaluate business creditworthiness via AI-powered financial document analysis (Big Four level).
**From email:** `financial@convexo.org`

### Form Fields

| Field | Type | Required |
|-------|------|----------|
| Nombre de la Empresa | Text | ✅ |
| NIT | Text | ✅ |
| Año de Fundación | Number | ✅ |
| Productos y Servicios | Textarea | ✅ |
| Principales Clientes | Textarea | ✅ |
| Principales Proveedores | Textarea | ✅ |
| Canales de Distribución | Textarea | ✅ |
| Correo Electrónico de Contacto | Email | ✅ |
| Teléfono de Contacto | Text | ✅ |
| Certificado de Existencia y Representación Legal | File (PDF) | ✅ |
| Balance General | File (PDF) | ✅ |
| Estado de Resultados | File (PDF) | ✅ |
| Flujo de Caja | File (PDF) | ✅ |
| RUT | File (PDF) | ✅ |

### Node Flow

```
Formulario Empresa (Form Trigger)
  → Normalizar Datos (Code)          — generates CRED-{timestamp} ID, folds data
  → Crear Carpeta Empresa (Drive)     — creates Drive folder named CRED-{id}_{empresa}
  → Guardar ID Carpeta (Set)
  → Subir [5 files] (Drive) ─┐       — uploads each PDF to the Drive folder
  → Esperar Uploads (Merge)  ┘
  → Consolidar Datos (Code)
  → Guardar en Sheets                 — appends row with file URLs (Score empty)
  → Descargar + Extraer [3 docs]      — downloads Balance, Estado Resultados, Flujo Caja
  → Combinar Extractos (Merge)
  → Combinar Textos (Code)
  → Agente Financiero IA              — claude-opus-4-6 via LangChain
  → Calcular Score (Code)             — parses JSON, 0–1000 score
  → Actualizar Sheets                 — fills Score + Nivel Riesgo columns
  → Enviar Reporte Email              — HTML report to client
  → Respuesta Final (Form)
```

### AI Agent Behavior
- Role: Big Four financial analyst (Deloitte / KPMG / PwC / EY level)
- Analyzes: liquidity, solvency, profitability, cash flow, leverage
- Output: JSON with `score` (0–1000), `nivelRiesgo`, `categoria`, `resumenEjecutivo`, `indicadores`, `fortalezas`, `riesgos`, `recomendacion`, `limiteCredito`

### Score Scale
| Score | Category | Risk |
|-------|----------|------|
| 800–1000 | Excelente | Muy Bajo |
| 650–799 | Bueno | Bajo |
| 500–649 | Regular | Medio |
| 350–499 | Deficiente | Alto |
| 0–349 | Crítico | Muy Alto |

### Credentials Required
| Credential Name | Type |
|----------------|------|
| `Google Drive` | Google Drive OAuth2 |
| `Google Sheets` | Google Sheets OAuth2 |
| `Anthropic` | Anthropic API |
| `Email SMTP` | SMTP |

### Google Sheets Tab: `Credit_Evaluations`
Columns (exact header names, in order):
```
Solicitud ID | Fecha | Empresa | NIT | Año Fundación | Años Operación |
Productos/Servicios | Clientes | Proveedores | Distribución | Email | Teléfono |
Carpeta Drive | Certificado Existencia | Balance General | Estado Resultados |
Flujo Caja | RUT | Estado | Score | Nivel Riesgo
```

---

## Workflow 02 — Credit Score Recovery

**File:** `02-credit-score-recovery.json`
**Purpose:** Collect client data for Recuperación Crediticia (Derecho de Petición). Generates case ID, stores data, sends confirmation, provides AI diagnostic.
**From email:** `servicios@thronium.org`

### Form Fields

| Field | Required |
|-------|----------|
| Nombres Completos | ✅ |
| Apellidos Completos | ✅ |
| Tipo de Documento (Cédula / Pasaporte / Cédula Extranjería) | ✅ |
| Número de Documento | ✅ |
| Lugar de Expedición | ✅ |
| Dirección de Domicilio | ✅ |
| Departamento | ✅ |
| Ciudad | ✅ |
| Correo Electrónico | ✅ |
| Número de Celular | ✅ |

### Node Flow

```
Formulario Recuperación (Form Trigger)
  → Validar y Formatear (Code)    — generates RC-{timestamp} case ID
  → Guardar en Sheets              — appends all client data (autoMapInputData)
  → Agente Diagnóstico IA          — claude-sonnet-4-6 generates diagnosis JSON
  → Formatear Diagnóstico (Code)   — builds HTML email from AI output
  → Email Cliente Confirmación     — sends case ID + Paso 1 details to client
  → Notificación Interna           — alerts internal team
  → Respuesta Formulario (Form)    — thank-you page with case ID
```

### Process Stages
| Stage | Cost | Deliverable |
|-------|------|-------------|
| Paso 1 — Diagnóstico | $70,000 COP | Score, negative reports, debt capacity |
| Paso 2 — Proceso Formal | $280,000 COP | Documents, tracking, positive history |
| Paso 3 — Éxito | $350,000 COP | Score improvement, final debt capacity |

### Credentials Required
| Credential Name | Type |
|----------------|------|
| `Google Sheets` | Google Sheets OAuth2 |
| `Anthropic` | Anthropic API |
| `Email SMTP` | SMTP |

### Google Sheets Tab: `Credit_Recovery_Clients`
Columns (auto-mapped from code node output):
```
caseId | timestamp | fecha | nombres | apellidos | tipoDocumento | numeroDocumento |
lugarExpedicion | direccion | departamento | ciudad | email | celular |
nombreCompleto | estado | etapa | valorPaso1 | valorPaso2 | valorPaso3
```

---

## Workflow 03 — Traffic Fines Resolution

**File:** `03-traffic-fines.json`
**Purpose:** Collect data for traffic fine resolution (Derecho de Petición). Step 1 diagnostic is free.
**From email:** `servicios@thronium.org`

### Form Fields

| Field | Required |
|-------|----------|
| Nombres Completos | ✅ |
| Apellidos Completos | ✅ |
| Tipo de Documento | ✅ |
| Número de Documento | ✅ |
| Lugar de Expedición | ✅ |
| Dirección de Domicilio | ✅ |
| Departamento | ✅ |
| Ciudad | ✅ |
| Correo Electrónico | ✅ |
| Número de Celular | ✅ |
| Placas del Vehículo | ❌ |
| Organismo de Tránsito | ✅ |
| ¿Tiene Cobro Coactivo? (Sí / No / No sabe) | ✅ |

### Node Flow

```
Formulario Multas (Form Trigger)
  → Validar y Formatear (Code)    — generates MT-{timestamp} case ID
  → Guardar en Sheets              — appends all case data (autoMapInputData)
  → Agente Diagnóstico IA          — claude-sonnet-4-6 generates legal diagnosis JSON
  → Formatear Diagnóstico (Code)   — builds HTML email (red header if Cobro Coactivo = Sí)
  → Email Diagnóstico Gratuito     — sends free Step 1 diagnosis to client
  → Notificación Interna           — alerts internal team
  → Respuesta Formulario (Form)    — thank-you page with case ID
```

### Process Stages
| Stage | Cost | Deliverable |
|-------|------|-------------|
| Paso 1 — Diagnóstico | **Gratis** | Fine value + interest, coercive status, dates |
| Paso 2 — Proceso | 50% del ahorro | Draft Derecho de Petición |
| Paso 3 — Cierre | 50% del ahorro | Paz y Salvo document |

> Urgency styling: email header turns red when `¿Tiene Cobro Coactivo? = Sí`

### Credentials Required
| Credential Name | Type |
|----------------|------|
| `Google Sheets` | Google Sheets OAuth2 |
| `Anthropic` | Anthropic API |
| `Email SMTP` | SMTP |

### Google Sheets Tab: `Traffic_Fines_Cases`
Columns (auto-mapped from code node output):
```
caseId | timestamp | fecha | nombres | apellidos | tipoDocumento | numeroDocumento |
lugarExpedicion | direccion | departamento | ciudad | email | celular |
placasVehiculo | organismoTransito | cobroCoactivo | nombreCompleto |
estado | etapa | tipoCaso
```

---

## Setup Instructions

> For a full zero-to-running guide, see [`QUICKSTART.md`](../QUICKSTART.md) at the root.

### 1. Credential Names (must match exactly)

| n8n Credential Name | Type | Used In |
|--------------------|------|---------|
| `Anthropic` | Anthropic API | All 3 workflows |
| `Google Drive` | Google Drive OAuth2 | WF01 only |
| `Google Sheets` | Google Sheets OAuth2 | All 3 workflows |
| `Email SMTP` | SMTP | All 3 workflows |

### 2. Environment Variable

Set in n8n **Settings → Environment Variables**:

```
GOOGLE_SHEET_ID = <your spreadsheet ID>
```

### 3. SMTP via Resend

```
Host: smtp.resend.com
Port: 465 (SSL)
User: resend
Password: <your Resend API key>
```

Add and verify your domains in Resend dashboard. Configure DNS in your registrar (Porkbun / Thronium).

### 4. Google OAuth2 Setup

In Google Cloud Console:
1. Enable **Google Drive API** and **Google Sheets API**
2. Create OAuth 2.0 credentials (Web application type)
3. Add redirect URI: `http://localhost:5678/rest/oauth2-credential/callback`
4. Use Client ID + Secret in both n8n credentials

### 5. Import & Activate

1. n8n → **Workflows → Import from file** → import each `.json`
2. Open each workflow → verify credentials resolve (no red indicators)
3. Toggle **Active** → copy the Form URL
4. Test with a submission before going live

---

## Local Development

```bash
# Docker (recommended)
docker run -it --rm --name n8n -p 5678:5678 -v ~/.n8n:/home/node/.n8n n8nio/n8n

# npx
npx n8n

# Then open: http://localhost:5678
```

---

## Notes
- All forms are in Spanish (Colombia)
- Currency: COP (Colombian pesos)
- RUT = Registro Único Tributario (business tax ID), NIT = Número de Identificación Tributaria
- DataCrédito = Colombian credit bureau (score range 150–950, different from internal 0–1000 scale)
- Legal framework: Ley 1266/2008 (data), Ley 769/2002 (traffic)
