-- ============================================================
-- AuraEngine Database Schema
-- Supabase PostgreSQL DDL
-- Run this in your Supabase SQL Editor
-- ============================================================

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- Table: products
-- Stores every product URL fed into the pipeline
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  url           TEXT NOT NULL UNIQUE,
  name          TEXT,
  price         TEXT,
  category      TEXT,
  raw_html      TEXT,
  scraped_data  JSONB,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_products_url ON products(url);
CREATE INDEX idx_products_category ON products(category);

-- ============================================================
-- Table: content_pieces
-- AI-generated content for each product × platform combo
-- ============================================================
CREATE TABLE IF NOT EXISTS content_pieces (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id      UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  platform        TEXT NOT NULL CHECK (platform IN ('tiktok', 'youtube_shorts', 'linkedin', 'twitter', 'telegram')),
  hook_1          TEXT,
  hook_2          TEXT,
  hook_3          TEXT,
  script          TEXT,
  caption         TEXT,
  hashtags        TEXT[],
  cta             TEXT,
  agent_metadata  JSONB,   -- stores researcher + creative director outputs
  status          TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'pending_approval', 'approved', 'rejected', 'published')),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_content_product ON content_pieces(product_id);
CREATE INDEX idx_content_platform ON content_pieces(platform);
CREATE INDEX idx_content_status ON content_pieces(status);

-- ============================================================
-- Table: media_assets
-- AI-generated images and voiceover files
-- ============================================================
CREATE TABLE IF NOT EXISTS media_assets (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  content_id    UUID NOT NULL REFERENCES content_pieces(id) ON DELETE CASCADE,
  type          TEXT NOT NULL CHECK (type IN ('image', 'audio', 'video')),
  url           TEXT NOT NULL,
  provider      TEXT NOT NULL CHECK (provider IN ('pollinations_ai', 'elevenlabs', 'manual')),
  prompt_used   TEXT,
  file_size_kb  INTEGER,
  duration_sec  NUMERIC,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_assets_content ON media_assets(content_id);
CREATE INDEX idx_assets_type ON media_assets(type);

-- ============================================================
-- Table: distribution_queue
-- Tracks approval state and publishing status per channel
-- ============================================================
CREATE TABLE IF NOT EXISTS distribution_queue (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  content_id      UUID NOT NULL REFERENCES content_pieces(id) ON DELETE CASCADE,
  channel         TEXT NOT NULL CHECK (channel IN ('youtube_shorts', 'linkedin', 'telegram_channel', 'buffer')),
  status          TEXT NOT NULL DEFAULT 'queued' CHECK (status IN ('queued', 'approved', 'rejected', 'published', 'failed')),
  telegram_msg_id TEXT,     -- the message ID of the HITL approval request
  approved_by     TEXT,     -- Telegram user who approved
  approved_at     TIMESTAMPTZ,
  published_at    TIMESTAMPTZ,
  publish_url     TEXT,     -- URL of the published post
  error_message   TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_queue_content ON distribution_queue(content_id);
CREATE INDEX idx_queue_status ON distribution_queue(status);
CREATE INDEX idx_queue_channel ON distribution_queue(channel);

-- ============================================================
-- Table: analytics
-- Execution logs for every AuraEngine workflow run
-- ============================================================
CREATE TABLE IF NOT EXISTS analytics (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workflow_run_id   TEXT NOT NULL,
  workflow_name     TEXT NOT NULL,
  status            TEXT NOT NULL CHECK (status IN ('success', 'failed', 'partial')),
  product_id        UUID REFERENCES products(id),
  error_node        TEXT,
  error_message     TEXT,
  api_calls_made    INTEGER DEFAULT 0,
  groq_tokens_used  INTEGER DEFAULT 0,
  execution_time_ms INTEGER,
  cost_estimate_usd NUMERIC(10, 6) DEFAULT 0,
  metadata          JSONB,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_analytics_run ON analytics(workflow_run_id);
CREATE INDEX idx_analytics_status ON analytics(status);
CREATE INDEX idx_analytics_created ON analytics(created_at);

-- ============================================================
-- View: pipeline_health
-- Quick dashboard summary for monitoring
-- ============================================================
CREATE OR REPLACE VIEW pipeline_health AS
SELECT
  DATE_TRUNC('day', created_at) AS day,
  COUNT(*) FILTER (WHERE status = 'success')  AS successful_runs,
  COUNT(*) FILTER (WHERE status = 'failed')   AS failed_runs,
  COUNT(*) FILTER (WHERE status = 'partial')  AS partial_runs,
  ROUND(AVG(execution_time_ms))               AS avg_exec_time_ms,
  SUM(groq_tokens_used)                       AS total_tokens,
  SUM(cost_estimate_usd)                      AS total_cost_usd
FROM analytics
GROUP BY 1
ORDER BY 1 DESC;

-- ============================================================
-- Row Level Security (RLS) — enable for production
-- ============================================================
ALTER TABLE products          ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_pieces    ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_assets      ENABLE ROW LEVEL SECURITY;
ALTER TABLE distribution_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics         ENABLE ROW LEVEL SECURITY;

-- Allow service_role (n8n) full access
CREATE POLICY "service_role_all" ON products          FOR ALL USING (true);
CREATE POLICY "service_role_all" ON content_pieces    FOR ALL USING (true);
CREATE POLICY "service_role_all" ON media_assets      FOR ALL USING (true);
CREATE POLICY "service_role_all" ON distribution_queue FOR ALL USING (true);
CREATE POLICY "service_role_all" ON analytics         FOR ALL USING (true);
