-- Phase 4: Cybersecurity Branching Simulation Engine Migration

-- 1. Enhance scenarios table with graph and case linkage
ALTER TABLE scenarios ADD COLUMN IF NOT EXISTS entry_node_id VARCHAR(64) DEFAULT 'node_start';
ALTER TABLE scenarios ADD COLUMN IF NOT EXISTS passing_score INTEGER DEFAULT 70;
ALTER TABLE scenarios ADD COLUMN IF NOT EXISTS investigation_case_id VARCHAR(64);
ALTER TABLE scenarios ADD COLUMN IF NOT EXISTS nodes JSONB DEFAULT '{}'::jsonb;

-- 2. Create scenario_attempts table for stateful attempt tracking
CREATE TABLE IF NOT EXISTS scenario_attempts (
    id VARCHAR(64) PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    scenario_id VARCHAR(64) NOT NULL REFERENCES scenarios(id) ON DELETE CASCADE,
    current_node_id VARCHAR(64) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'in_progress',
    score INTEGER NOT NULL DEFAULT 100,
    xp_earned INTEGER NOT NULL DEFAULT 0,
    selected_actions JSONB NOT NULL DEFAULT '[]'::jsonb,
    discovered_evidence_ids JSONB NOT NULL DEFAULT '[]'::jsonb,
    state_flags JSONB NOT NULL DEFAULT '{}'::jsonb,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE NULL
);

CREATE INDEX IF NOT EXISTS idx_scenario_attempts_user_scenario ON scenario_attempts(user_id, scenario_id);
CREATE INDEX IF NOT EXISTS idx_scenario_attempts_status ON scenario_attempts(status);

-- 3. Ensure idempotency unique index exists for xp_service
CREATE UNIQUE INDEX IF NOT EXISTS idx_xp_transactions_idempotency 
ON xp_transactions (user_id, event_type, reference_id) 
WHERE reference_id IS NOT NULL;

