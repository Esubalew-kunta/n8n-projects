# AuraEngine — Omni-Channel Autonomous Content Factory

> **An enterprise-grade, multi-agent AI automation system** that ingests a product URL, produces platform-specific content, generates AI media assets, routes through a human-in-the-loop approval gate, and distributes across YouTube Shorts, LinkedIn, Telegram, and TikTok — all without a single manual step.

Built with **n8n** · **Groq (Llama 3)** · **Supabase** · **Pollinations.ai** · **ElevenLabs** · **Telegram Bot API**

---

## Why AuraEngine?

Most content pipelines are linear: input → AI → post. AuraEngine is different. It is an **autonomous factory** — a network of specialized AI agents, a relational database backend, a media production sub-system, and a real-time observability dashboard, all orchestrated through n8n.

| Dimension | Before (v1) | After — AuraEngine |
|---|---|---|
| AI Model | Single OpenAI call | 3 specialized Groq agents |
| Database | Google Sheets | Supabase PostgreSQL (5 tables) |
| Media | Text only | AI images + AI voiceovers |
| Approval | Auto-post | Telegram HITL inline keyboard |
| Channels | TikTok only | YouTube · LinkedIn · Telegram · TikTok |
| Nodes | ~10 | 40+ |
| Observability | None | Live Supabase monitoring dashboard |

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AuraEngine Core                          │
│                                                                 │
│  [Webhook Trigger]                                              │
│       │                                                         │
│       ▼                                                         │
│  [Discovery Layer]──── HTTP Request + HTML Extractor            │
│       │                 (Scrape product page)                   │
│       ▼                                                         │
│  ┌──────────────── Multi-Agent Orchestration ──────────────┐   │
│  │  Agent 1: Researcher   → USPs & audience insights       │   │
│  │  Agent 2: Copywriter   → Platform-specific scripts      │   │
│  │  Agent 3: Creative Dir → Image prompt generation        │   │
│  └────────────────────────────────────────────────────────┘   │
│       │                                                         │
│       ▼                                                         │
│  [Media Sub-Workflow] ── Pollinations.ai Image Gen              │
│       │                   ElevenLabs Voiceover                  │
│       ▼                                                         │
│  [Supabase Write] ──── content_pieces + media_assets tables     │
│       │                                                         │
│       ▼                                                         │
│  [HITL Gate] ────────── Telegram Inline Keyboard                │
│       │                  ✅ Approve  🔄 Regenerate  ❌ Reject   │
│       ▼ (approved)                                              │
│  [Multi-Channel Dispatcher]                                     │
│       ├── YouTube Shorts API                                    │
│       ├── LinkedIn API                                          │
│       ├── Telegram Channel Bot                                  │
│       └── Buffer/Metricool → TikTok/Instagram                  │
│                                                                 │
│  [Monitoring Workflow] ── Logs to Supabase analytics table      │
└─────────────────────────────────────────────────────────────────┘
```

---

## Workflow Files

| File | Purpose | Nodes |
|---|---|---|
| `workflow/AuraEngine_Core.json` | Main orchestration pipeline | ~45 nodes |
| `workflow/Media_Gen_Subprocess.json` | Image + voice generation sub-workflow | ~12 nodes |
| `workflow/Monitoring_Dashboard.json` | Health & error logging to Supabase | ~8 nodes |
| `workflow/input-bot.json` | Legacy Telegram input bot (v1) | ~10 nodes |
| `workflow/daily-digest.json` | Legacy daily content digest (v1) | ~8 nodes |
| `workflow/error-handling.json` | Global error handler (v1) | ~4 nodes |

---

## Database Schema (Supabase PostgreSQL)

```sql
-- Products being promoted
products (id, url, name, price, category, created_at)

-- AI-generated content pieces
content_pieces (id, product_id, platform, hooks, script, caption,
                hashtags, status, created_at)

-- AI-generated media assets
media_assets (id, content_id, type, url, provider, created_at)

-- Distribution queue with approval status
distribution_queue (id, content_id, channel, status,
                    approved_by, approved_at)

-- Execution analytics and error logs
analytics (id, workflow_run_id, status, error_message,
           api_calls_made, cost_estimate, created_at)
```

> See `supabase/schema.sql` for the full DDL and RLS policies.

---

## Security & Reliability (Enterprise Features)

- **Row Level Security (RLS)**: Implemented strict Supabase RLS policies. Only the n8n service account (via authenticated service key) can insert logs and content, while preventing unauthorized public access to internal analytics.
- **Automated UUID Generation**: All primary keys (`id`, `content_id`) use `gen_random_uuid()` at the database level. This ensures absolute data integrity and prevents ID collisions across distributed workflow runs.
- **Self-Healing Webhooks**: The HITL (Human-in-the-Loop) system utilizes n8n's dynamic `$execution.resumeUrl` with signed signatures, ensuring that only the authorized administrator can trigger the approval via the secure Telegram link.

---

## Multi-Agent AI Stack

All agents run on **Groq (Llama 3.3-70B)** — free tier, no cost.

### Agent 1 — Researcher
Receives raw product data and outputs a structured JSON object:
- Unique Selling Points (USPs)
- Target audience persona
- Pain points addressed
- Competitive differentiators

### Agent 2 — Copywriter
Receives Researcher output and produces platform-optimized content:
- **TikTok/Shorts**: 3 viral hooks + 30-sec script
- **LinkedIn**: Professional post with value framing
- **Twitter/X**: Thread structure (5 tweets)

### Agent 3 — Creative Director
Receives product context and outputs Pollinations.ai image prompts:
- Hero product shot prompt
- Lifestyle/in-use shot prompt
- Thumbnail/thumbnail-ready visual prompt

---

## Media Production (Free Tier)

| Tool | What it produces | Limit |
|---|---|---|
| **Pollinations.ai** | Product & lifestyle images | Unlimited (no key needed) |
| **ElevenLabs** | Voiceover narration (MP3) | 10,000 chars/month |

Images are generated via HTTP Request node — **no API key required**.
Voiceover files are stored as URLs in the `media_assets` table.

---

## Human-in-the-Loop (HITL) Approval Gate

Before any content is published, the system pauses and sends a Telegram message to the admin with:

- Preview of generated hooks, script, and caption
- AI-generated product image
- Inline keyboard buttons:
  - **✅ Approve** — triggers the distribution dispatcher
  - **🔄 Regenerate** — re-runs the AI agents with a different seed
  - **❌ Reject** — marks item as rejected in Supabase

This is implemented using n8n's **Wait Node** + **Telegram Webhook** pattern.

---

## Multi-Channel Distribution

| Channel | Method |
|---|---|
| YouTube Shorts | YouTube Data API v3 (upload endpoint) |
| LinkedIn | LinkedIn Marketing API (UGC Posts) |
| Telegram Channel | Bot API `sendMessage` / `sendPhoto` |
| TikTok / Instagram | Buffer API (3 channels free) |

---

## Observability Dashboard

A separate **Monitoring_Dashboard.json** workflow runs after every execution and logs:

- Workflow run ID and status (success / failed)
- Which node failed and error message
- Number of API calls made
- Estimated token cost (Groq is free, but tracked for future reference)
- Total execution time

All data is stored in the `analytics` Supabase table for real-time review.

---

## Tech Stack

| Layer | Tool | Cost |
|---|---|---|
| Orchestration | n8n (self-hosted) | Free |
| AI Brain | Groq API (Llama 3.3-70B) | Free |
| Database | Supabase (PostgreSQL) | Free tier |
| Image Gen | Pollinations.ai | Free (no key) |
| Voice Gen | ElevenLabs | Free (10k chars/mo) |
| Social Scheduling | Buffer | Free (3 channels) |
| Approval Interface | Telegram Bot API | Free |

**Total monthly cost: $0** (within free tier limits)

---

## Setup Guide

### 1. Clone & Import Workflows
```bash
git clone https://github.com/Esubalew-kunta/n8n-projects.git
```
Import `workflow/AuraEngine_Core.json` and `workflow/Media_Gen_Subprocess.json` into your n8n instance.

### 2. Set Up Supabase
1. Create a free project at [supabase.com](https://supabase.com)
2. Run `supabase/schema.sql` in the SQL editor
3. Copy your **Project URL** and **anon key**

### 3. Configure Credentials in n8n
| Credential | Where to get it |
|---|---|
| Groq API Key | [console.groq.com](https://console.groq.com) — free |
| Supabase URL + Key | Project Settings → API |
| Telegram Bot Token | @BotFather on Telegram |
| ElevenLabs API Key | [elevenlabs.io](https://elevenlabs.io) — free tier |
| Buffer API Key | [buffer.com/developers](https://buffer.com/developers) |

### 4. Trigger the Workflow
Send a POST request to the n8n Webhook URL:
```json
{
  "product_url": "https://example.com/product-page",
  "target_platforms": ["tiktok", "linkedin", "youtube_shorts"]
}
```

---

## Project Structure

```
n8n-content-pipeline/
├── workflow/
│   ├── AuraEngine_Core.json          # Main pipeline (v2)
│   ├── Media_Gen_Subprocess.json     # Image + voice sub-workflow (v2)
│   ├── Monitoring_Dashboard.json     # Observability workflow (v2)
│   ├── input-bot.json                # Legacy Telegram bot (v1)
│   ├── daily-digest.json             # Legacy digest (v1)
│   └── error-handling.json           # Legacy error handler (v1)
├── supabase/
│   └── schema.sql                    # Full database DDL
├── screenshots/                      # Workflow screenshots
└── README.md
```

---

## Key Engineering Highlights

- **Agent Chaining Pattern**: Each agent receives a structured JSON context object from the previous agent, enabling clean data handoff without prompt leakage.
- **Idempotent Supabase Writes**: Uses `upsert` on `product_url` to prevent duplicate entries on re-runs.
- **Graceful HITL with Wait Node**: Workflow execution is suspended at the approval gate — no polling or cron workarounds needed.
- **Zero-Cost Media Pipeline**: Pollinations.ai requires no API key; images are fetched via a simple parameterized HTTP GET.
- **Modular Sub-Workflow Architecture**: Media generation is isolated in its own workflow, callable from any future pipeline.

---

## Built By

**Esubalew Kunta**
AI Automation & Workflow Systems Engineer
Specializing in n8n, multi-agent pipelines, and enterprise automation architecture.

> *"The best automation is the one that disappears — leaving only results."*
