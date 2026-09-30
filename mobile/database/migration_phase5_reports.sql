-- ForenShield Phase 5 — Reports Database Migration
-- Creates the persistent 'reports' table for authoritative incident intelligence reports

CREATE TABLE IF NOT EXISTS reports (
    id VARCHAR(64) PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    case_id VARCHAR(64) NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
    scenario_id VARCHAR(64) REFERENCES scenarios(id) ON DELETE SET NULL,
    attempt_id VARCHAR(64) REFERENCES scenario_attempts(id) ON DELETE SET NULL,
    case_number VARCHAR(64) NOT NULL,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL DEFAULT 'Incident Response',
    severity VARCHAR(32) NOT NULL DEFAULT 'Medium',
    status VARCHAR(32) NOT NULL DEFAULT 'FINALIZED',
    analyst VARCHAR(120) NOT NULL,
    summary TEXT NOT NULL,
    score INTEGER NOT NULL DEFAULT 100,
    xp_earned INTEGER NOT NULL DEFAULT 0,
    findings JSONB NOT NULL DEFAULT '[]'::jsonb,
    remediation_actions JSONB NOT NULL DEFAULT '[]'::jsonb,
    artifacts JSONB NOT NULL DEFAULT '[]'::jsonb,
    timeline_snapshot JSONB NOT NULL DEFAULT '[]'::jsonb,
    evidence_snapshot JSONB NOT NULL DEFAULT '[]'::jsonb,
    analyst_actions JSONB NOT NULL DEFAULT '[]'::jsonb,
    verdict_snapshot JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_user_case_report UNIQUE (user_id, case_id)
);

CREATE INDEX IF NOT EXISTS idx_reports_user_id ON reports(user_id);
CREATE INDEX IF NOT EXISTS idx_reports_case_id ON reports(case_id);
CREATE INDEX IF NOT EXISTS idx_reports_created_at ON reports(created_at DESC);
