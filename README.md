# 🤖 n8n Automation Portfolio — Esubalew Kunta

> **n8n Developer · Automation Architect · AI Integration Specialist**  
> 📍 Addis Ababa, Ethiopia 🇪🇹 · Building production-grade automation systems that connect the modern web

---

## Why This Portfolio?

Most automation developers build simple webhook-to-database workflows and call it a day.

I don't.

Every project in this repository solves a *real business problem* — from an autonomous multi-agent AI reasoning engine to a full event-driven CRM sync pipeline — each one demonstrating a distinct, advanced layer of n8n mastery.

> If you are looking for someone who can build *anything* in n8n, architect multi-service integrations, debug complex async flows, and ship production-ready automations — you are in the right place.

---

## 🗂️ Projects at a Glance

| # | Project | Core Skills Demonstrated |
|---|---------|--------------------------|
| 1 | [Sentinel: Autonomous Multi-Agent RAG Engine](#1--sentinel-autonomous-multi-agent-rag-engine) | AI Agents, LangChain, Vector Stores, Supervisor Routing |
| 2 | [Ethio-CRM Lifecycle Sync](#2--ethio-crm-lifecycle-sync) | GoHighLevel Webhooks, Supabase, AI Agent, Event-Driven Design |
| 3 | [n8n Catalog Automation Engine](#3--n8n-catalog-automation-engine) | Web Scraping, Puppeteer, Shopify API, ETL Pipelines |
| 4 | [n8n Content Pipeline](#4--n8n-content-pipeline) | Telegram Bot, OpenAI, Google Sheets, Multi-Workflow Orchestration |

---

## 1. 🧠 Sentinel: Autonomous Multi-Agent RAG Engine

**`/agentic-rag-system`**

> *"What if your AI assistant could question its own answers, break complex problems into sub-problems, and route each piece to the right specialist — automatically?"*

This is not a simple chatbot. **Sentinel** is a fully autonomous, multi-agent reasoning and retrieval system built entirely in n8n, combining LangChain patterns with OpenRouter LLM routing.

### What It Does
A user sends a complex question. Sentinel doesn't just look it up — it *thinks*:

1. **Decomposes** the question into focused sub-questions
2. **Routes** each sub-question to the correct specialist agent (Retriever, Thinker) via a Supervisor node using metadata and a business glossary
3. **Retrieves** relevant context from a vector knowledge base
4. **Self-verifies** — asks follow-up questions internally to check its own reasoning
5. **Synthesizes** a final, high-confidence answer from all sub-results

### Technical Depth
- **Multi-Agent Orchestration** via n8n's AI Agent nodes with chained tool calls
- **Vector Store Integration** for semantic retrieval (knowledge base Q&A)
- **Supervisor Agent Pattern** — dynamic routing of sub-queries, not hardcoded branches
- **LLM-powered reasoning** using OpenRouter (supporting multiple model backends)
- **Self-verification loop** — the workflow literally double-checks itself before responding
- **Docker deployment** with a custom `docker-compose.yml` for easy portability
- **Modern n8n node architecture** — fully migrated from deprecated `Function` nodes to the current `Code` node API

### Why This Is Impressive
Building a single-node AI assistant is easy. Building a **Supervisor-based multi-agent system** that routes, retrieves, reasons, and self-corrects — in n8n, without custom code infrastructure — is the kind of thing that puts you ahead of 95% of automation developers.

---

## 2. 🔗 Ethio-CRM Lifecycle Sync

**`/Ethio-CRM Lifecycle Sync`**

> *"Real-time event-driven automation that tracks every customer touchpoint — from first signup to final payment — and keeps your CRM in perfect sync."*

An enterprise-grade n8n workflow that listens to live events from **GoHighLevel (GHL)** and synchronizes them into **Supabase** in real time, with an AI-powered reporting layer on top.

### What It Does
Every time a client interacts with the business — signing up, booking an appointment, changing status, making a payment — this workflow:

1. **Catches the webhook** from GoHighLevel instantly
2. **Cleans and normalizes** the incoming data (handling inconsistencies, null fields, timezone normalization to **East Africa Time**)
3. **Upserts the record** into Supabase, maintaining a complete, reliable customer journey history
4. **Powers an AI Agent** that can answer natural language queries about the sales data (e.g., *"Show me all clients who booked but didn't pay this week"*)

### Technical Depth
- **Webhook-driven architecture** — zero polling, pure event-driven design
- **GoHighLevel API integration** — handling multiple event types in a single workflow
- **Supabase real-time database sync** — upsert logic to prevent duplicate records
- **AI Agent with PostgreSQL tool** — the agent can query the live database using natural language
- **East Africa Time (EAT) awareness** — timezone-correct data processing for Ethiopian and African business contexts
- **Docker + Postgres** setup for local development and testing

### Why This Is Impressive
Connecting GHL + Supabase + AI Agent in a single cohesive workflow — with proper data cleaning, timezone handling, and a natural language reporting layer — is the kind of full-stack automation thinking that agencies and SaaS companies pay top dollar for.

---

## 3. 🏭 n8n Catalog Automation Engine

**`/n8n Catalog Automation Engine`**

> *"Automating the entire supplier-to-storefront product pipeline — from headless web scraping to live Shopify product creation — with zero manual input."*

A production-ready ETL (Extract, Transform, Load) automation that bridges a supplier website (**Centrano**) directly to a **Shopify** store using n8n orchestration and a companion Node.js Puppeteer service.

### What It Does
A full end-to-end product import pipeline:

1. **Authenticates** into the supplier's website programmatically
2. **Searches and scrapes** product listings using a headless Puppeteer browser (Node.js microservice)
3. **Extracts** structured product data: title, description, price, images, variants
4. **Transforms** the data into Shopify-compatible format
5. **Creates the product** directly via the Shopify Admin API, with images and metadata

### Technical Depth
- **n8n + Puppeteer hybrid architecture** — n8n orchestrates; Node.js handles complex browser automation
- **Express.js microservice** as a scraping API, called from n8n via HTTP Request nodes
- **Shopify Admin REST API** integration — product creation, image upload, variant management
- **ETL pipeline design** — clean separation of extraction, transformation, and loading stages
- **`.env`-driven configuration** — no hardcoded credentials, fully portable and secure
- **Error handling nodes** — workflow branches gracefully on scraping failures or API errors

### Why This Is Impressive
Most n8n developers use only built-in nodes. This project shows the ability to **extend n8n** with a custom microservice, build a hybrid architecture, and orchestrate a multi-step ETL pipeline across external APIs — exactly what enterprise clients need.

---

## 4. 📱 n8n Content Pipeline

**`/n8n-content-pipeline`**

> *"A Telegram-native AI content assistant that turns a product name into a full TikTok campaign — hooks, scripts, captions, hashtags — in seconds, and logs everything automatically."*

A two-workflow n8n automation system designed for TikTok affiliates. Built around a Telegram bot interface, it eliminates the manual work of content ideation and data entry.

### What It Does

**Workflow 1 — Input Bot (Real-Time):**
1. User sends a product via Telegram (e.g., `/new traditional jebena coffee pot 500 birr`)
2. n8n parses the command and sends it to an **LLM (Groq/Llama-3)** with a localized prompt
3. The AI generates 3 viral hooks, a 15–30 second video script, a caption, and hashtags — localized for the Ethiopian/Amharic-English TikTok audience
4. Results are sent back to Telegram AND logged to **Google Sheets** automatically

**Workflow 2 — Daily Digest (Scheduled):**
- Runs on a cron schedule
- Pulls all products logged that day from Google Sheets
- Generates a consolidated daily performance summary and sends it to Telegram

### Technical Depth
- **Telegram Bot API** integration — webhook-triggered, fully conversational
- **Groq API (Llama-3)** for ultra-fast LLM inference
- **Custom system prompt engineering** — the AI is instructed to produce localized content in a mix of Amharic and English (Ethiopic script supported)
- **Google Sheets as a lightweight database** — append-on-trigger pattern
- **Multi-workflow coordination** — two independent workflows share data via Google Sheets
- **Scheduled triggers** alongside webhook triggers in the same project
- **Docker deployment** ready with a provided `docker-compose.yml`

### Why This Is Impressive
This project showcases the full breadth of n8n's real-world application: **real-time bots, AI content generation, scheduled jobs, external APIs, and persistent data storage** — all in one cohesive system. It also demonstrates product-thinking: building something a real user would actually pay for.

---

## 🛠️ Skills Demonstrated Across All Projects

| Skill Area | Specifics |
|---|---|
| **n8n Core** | Webhooks, HTTP Request, Code nodes, IF/Switch, Error Triggers, Set, Merge, Function (legacy migration) |
| **AI & LLM** | OpenAI, Groq (Llama-3), OpenRouter, AI Agent node, LangChain tool patterns, Prompt Engineering |
| **Databases** | Supabase (PostgreSQL), Google Sheets, Vector Stores |
| **External APIs** | GoHighLevel, Shopify Admin API, Telegram Bot API, Groq API |
| **DevOps** | Docker, docker-compose, Node.js microservices, Express.js, environment variable management |
| **Architecture** | Multi-agent systems, event-driven design, ETL pipelines, webhook orchestration, scheduled automation |
| **Languages** | JavaScript (n8n Code nodes), Node.js |

---

## 🚀 About Me

I am **Esubalew**, an n8n developer and automation architect based in **Addis Ababa, Ethiopia**.

I specialize in building complex, production-grade automation systems that connect AI, APIs, and databases into workflows that *actually solve problems*. From multi-agent AI reasoning engines to supplier-to-storefront ETL pipelines, I build automations that scale.

I believe great automation is invisible — it just works, handles edge cases gracefully, and makes the humans around it more effective.

**Available for:** Freelance projects · Full-time remote roles · n8n consulting

---

*Built with n8n · Powered by curiosity · Shipped from Ethiopia 🇪🇹*
