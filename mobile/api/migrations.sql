-- ForenShield Notification System Database Migrations

-- TASK 1: Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TASK 2: Add fcm_token column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS fcm_token TEXT;

-- ======================================
-- Phase 6: Leaderboard System
-- ======================================

CREATE TABLE IF NOT EXISTS leaderboard (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    username VARCHAR(100),
    xp INTEGER DEFAULT 0,
    rank INTEGER DEFAULT 0,
    completed_courses INTEGER DEFAULT 0,
    completed_cases INTEGER DEFAULT 0,
    streak INTEGER DEFAULT 0,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================================
-- Phase 7: Settings Module (Devices & History)
-- ======================================

CREATE TABLE IF NOT EXISTS device_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    device_name VARCHAR(255),
    platform VARCHAR(50),
    app_version VARCHAR(50),
    ip_address VARCHAR(45),
    login_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT FALSE,
    fcm_token TEXT,
    session_token TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS login_history (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    device_name VARCHAR(255),
    platform VARCHAR(50),
    ip_address VARCHAR(45),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logout_time TIMESTAMP NULL,
    status VARCHAR(50) DEFAULT 'success',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================================
-- Phase B: Production Leaderboard System
-- ======================================

CREATE TABLE IF NOT EXISTS leaderboard_stats (
    user_id INTEGER PRIMARY KEY,
    total_xp INTEGER DEFAULT 0,
    current_streak INTEGER DEFAULT 0,
    investigations_completed INTEGER DEFAULT 0,
    courses_completed INTEGER DEFAULT 0,
    reports_completed INTEGER DEFAULT 0,
    threats_resolved INTEGER DEFAULT 0,
    missions_completed INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS xp_transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    action VARCHAR(255) NOT NULL,
    xp_earned INTEGER NOT NULL,
    reason TEXT,
    reference_id VARCHAR(100),
    event_type VARCHAR(100),
    source_module VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS daily_activity (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    date DATE NOT NULL,
    xp_earned INTEGER DEFAULT 0,
    courses_completed INTEGER DEFAULT 0,
    cases_completed INTEGER DEFAULT 0,
    reports_completed INTEGER DEFAULT 0,
    streak_increment INTEGER DEFAULT 0,
    UNIQUE(user_id, date)
);

-- ======================================
-- Phase C: Production Achievement Engine
-- ======================================

DROP TABLE IF EXISTS achievements CASCADE;

CREATE TABLE IF NOT EXISTS achievements (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    icon VARCHAR(255),
    category VARCHAR(50) NOT NULL,
    xp_reward INTEGER DEFAULT 0,
    rarity VARCHAR(50) DEFAULT 'common',
    target_metric VARCHAR(50) NOT NULL,
    threshold INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_achievements (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    achievement_id INTEGER NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, achievement_id)
);

-- Seed Achievements
INSERT INTO achievements (code, title, description, icon, category, xp_reward, rarity, target_metric, threshold) VALUES
-- Mission Control
('mission_1', 'First Mission', 'Complete your first mission', '🎯', 'mission', 100, 'common', 'missions_completed', 1),
('mission_10', 'Dedicated Operator', 'Complete 10 missions', '🎯', 'mission', 500, 'uncommon', 'missions_completed', 10),
('mission_50', 'Mission Commander', 'Complete 50 missions', '🎯', 'mission', 1000, 'rare', 'missions_completed', 50),
('mission_100', 'Centurion Operator', 'Complete 100 missions', '🎯', 'mission', 2500, 'epic', 'missions_completed', 100),
-- Cyber Academy
('academy_1', 'First Course', 'Complete your first Cyber Academy course', '📚', 'academy', 100, 'common', 'courses_completed', 1),
('academy_5', 'Avid Learner', 'Complete 5 courses', '📚', 'academy', 500, 'uncommon', 'courses_completed', 5),
('academy_10', 'Knowledge Seeker', 'Complete 10 courses', '📚', 'academy', 1000, 'rare', 'courses_completed', 10),
('academy_all', 'Academy Master', 'Complete all courses', '📚', 'academy', 5000, 'legendary', 'courses_completed', 100),
-- Investigation
('investigation_1', 'First Investigation', 'Complete your first investigation', '🔍', 'investigation', 150, 'common', 'investigations_completed', 1),
('investigation_10', 'Sleuth', 'Complete 10 investigations', '🔍', 'investigation', 1000, 'uncommon', 'investigations_completed', 10),
('investigation_50', 'Master Detective', 'Complete 50 investigations', '🔍', 'investigation', 5000, 'epic', 'investigations_completed', 50),
-- Reports
('report_1', 'First Report', 'Submit your first report', '📄', 'reports', 50, 'common', 'reports_completed', 1),
('report_25', 'Reporter', 'Submit 25 reports', '📄', 'reports', 500, 'uncommon', 'reports_completed', 25),
-- Streak
('streak_3', 'Getting Started', 'Maintain a 3-day streak', '🔥', 'streak', 100, 'common', 'current_streak', 3),
('streak_7', 'Weekly Warrior', 'Maintain a 7-day streak', '🔥', 'streak', 500, 'uncommon', 'current_streak', 7),
('streak_30', 'Monthly Master', 'Maintain a 30-day streak', '🔥', 'streak', 2000, 'rare', 'current_streak', 30),
('streak_100', 'Unstoppable', 'Maintain a 100-day streak', '🔥', 'streak', 10000, 'legendary', 'current_streak', 100),
-- XP
('xp_500', 'Rising Star', 'Earn 500 total XP', '⭐', 'xp', 0, 'common', 'total_xp', 500),
('xp_1000', 'Experienced', 'Earn 1000 total XP', '⭐', 'xp', 0, 'uncommon', 'total_xp', 1000),
('xp_5000', 'Veteran', 'Earn 5000 total XP', '⭐', 'xp', 0, 'rare', 'total_xp', 5000),
('xp_10000', 'Elite', 'Earn 10000 total XP', '⭐', 'xp', 0, 'epic', 'total_xp', 10000)
ON CONFLICT (code) DO NOTHING;
-- ======================================
-- Phase 12: Content Schema (Courses & Investigations)
-- ======================================

-- ── ACADEMY COURSES ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS courses (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    difficulty VARCHAR(50),
    duration_minutes INTEGER DEFAULT 0,
    instructor_name VARCHAR(255),
    thumbnail_url TEXT,
    prerequisites JSONB,
    learning_outcomes JSONB,
    total_xp INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS course_modules (
    id VARCHAR(50) PRIMARY KEY,
    course_id VARCHAR(50) REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    module_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS lessons (
    id VARCHAR(50) PRIMARY KEY,
    module_id VARCHAR(50) REFERENCES course_modules(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    duration_minutes INTEGER DEFAULT 0,
    content_type VARCHAR(50),
    content_text TEXT,
    image_url TEXT,
    code_snippet TEXT,
    code_language VARCHAR(50),
    checklist JSONB,
    lesson_order INTEGER DEFAULT 0,
    quiz_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_course_progress (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    course_id VARCHAR(50) REFERENCES courses(id) ON DELETE CASCADE,
    is_enrolled BOOLEAN DEFAULT TRUE,
    completion_percentage NUMERIC(5,2) DEFAULT 0.0,
    completed_at TIMESTAMP,
    PRIMARY KEY(user_id, course_id)
);

CREATE TABLE IF NOT EXISTS user_lesson_progress (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    lesson_id VARCHAR(50) REFERENCES lessons(id) ON DELETE CASCADE,
    is_completed BOOLEAN DEFAULT TRUE,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, lesson_id)
);

-- ── INVESTIGATIONS (CASES) ───────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS cases (
    id VARCHAR(50) PRIMARY KEY,
    case_code VARCHAR(50),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority VARCHAR(50),
    difficulty VARCHAR(50),
    status VARCHAR(50),
    assigned_date DATE,
    notes TEXT,
    objectives JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS evidence (
    id VARCHAR(50) PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(id) ON DELETE CASCADE,
    title VARCHAR(255),
    evidence_type VARCHAR(50),
    content_text TEXT,
    metadata_map JSONB,
    evidence_timestamp VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS case_timeline (
    id VARCHAR(50) PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(id) ON DELETE CASCADE,
    title VARCHAR(255),
    description TEXT,
    timeline_timestamp VARCHAR(100),
    category VARCHAR(100),
    severity VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS verdicts (
    id VARCHAR(50) PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(id) ON DELETE CASCADE UNIQUE,
    summary_text TEXT,
    options JSONB,
    correct_option_index INTEGER,
    explanation_text TEXT,
    xp_reward INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS user_case_progress (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    case_id VARCHAR(50) REFERENCES cases(id) ON DELETE CASCADE,
    progress NUMERIC(5,2) DEFAULT 0.0,
    status VARCHAR(50),
    is_solved BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    PRIMARY KEY(user_id, case_id)
);

-- ── SIMULATIONS ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS scenarios (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    difficulty VARCHAR(50),
    duration_minutes INTEGER,
    objectives JSONB,
    initial_state JSONB,
    xp_reward INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── SEED DATA (DEVELOPMENT ONLY) ─────────────────────────────────────────────

INSERT INTO courses (id, title, description, category, difficulty, duration_minutes, instructor_name, total_xp)
VALUES ('crs_1', 'Digital Forensics Fundamentals', 'Learn the basics of digital evidence.', 'Digital Forensics', 'Beginner', 150, 'Dr. Alex Vance', 500)
ON CONFLICT (id) DO NOTHING;

INSERT INTO course_modules (id, course_id, title, description, module_order)
VALUES ('mod_1', 'crs_1', 'Module 1: Forensics Core Concepts', 'Essential techniques', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO lessons (id, module_id, title, duration_minutes, content_type, content_text, lesson_order)
VALUES ('les_101', 'mod_1', 'Digital Forensics Acquisition Techniques', 20, 'text', 'Memory forensics is the analysis of an acquired memory dump.', 1)
ON CONFLICT (id) DO NOTHING;
ON CONFLICT (code) DO NOTHING;
-- ======================================
-- Phase 12: Content Schema (Courses & Investigations)
-- ======================================

-- ── ACADEMY COURSES ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS courses (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    difficulty VARCHAR(50),
    duration_minutes INTEGER DEFAULT 0,
    instructor_name VARCHAR(255),
    thumbnail_url TEXT,
    prerequisites JSONB,
    learning_outcomes JSONB,
    total_xp INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS course_modules (
    id VARCHAR(50) PRIMARY KEY,
    course_id VARCHAR(50) REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    module_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS lessons (
    id VARCHAR(50) PRIMARY KEY,
    module_id VARCHAR(50) REFERENCES course_modules(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    duration_minutes INTEGER DEFAULT 0,
    content_type VARCHAR(50),
    content_text TEXT,
    image_url TEXT,
    code_snippet TEXT,
    code_language VARCHAR(50),
    checklist JSONB,
    lesson_order INTEGER DEFAULT 0,
    quiz_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_course_progress (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    course_id VARCHAR(50) REFERENCES courses(id) ON DELETE CASCADE,
    is_enrolled BOOLEAN DEFAULT TRUE,
    completion_percentage NUMERIC(5,2) DEFAULT 0.0,
    completed_at TIMESTAMP,
    PRIMARY KEY(user_id, course_id)
);

CREATE TABLE IF NOT EXISTS user_lesson_progress (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    lesson_id VARCHAR(50) REFERENCES lessons(id) ON DELETE CASCADE,
    is_completed BOOLEAN DEFAULT TRUE,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, lesson_id)
);

-- ── INVESTIGATIONS (CASES) ───────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS cases (
    id VARCHAR(50) PRIMARY KEY,
    case_code VARCHAR(50),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority VARCHAR(50),
    difficulty VARCHAR(50),
    status VARCHAR(50),
    assigned_date DATE,
    notes TEXT,
    objectives JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS evidence (
    id VARCHAR(50) PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(id) ON DELETE CASCADE,
    title VARCHAR(255),
    evidence_type VARCHAR(50),
    content_text TEXT,
    metadata_map JSONB,
    evidence_timestamp VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS case_timeline (
    id VARCHAR(50) PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(id) ON DELETE CASCADE,
    title VARCHAR(255),
    description TEXT,
    timeline_timestamp VARCHAR(100),
    category VARCHAR(100),
    severity VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS verdicts (
    id VARCHAR(50) PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(id) ON DELETE CASCADE UNIQUE,
    summary_text TEXT,
    options JSONB,
    correct_option_index INTEGER,
    explanation_text TEXT,
    xp_reward INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS user_case_progress (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    case_id VARCHAR(50) REFERENCES cases(id) ON DELETE CASCADE,
    progress NUMERIC(5,2) DEFAULT 0.0,
    status VARCHAR(50),
    is_solved BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    PRIMARY KEY(user_id, case_id)
);

-- ── SIMULATIONS ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS scenarios (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    difficulty VARCHAR(50),
    duration_minutes INTEGER,
    objectives JSONB,
    initial_state JSONB,
    xp_reward INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── SEED DATA (DEVELOPMENT ONLY) ─────────────────────────────────────────────

INSERT INTO courses (id, title, description, category, difficulty, duration_minutes, instructor_name, total_xp)
VALUES ('crs_1', 'Digital Forensics Fundamentals', 'Learn the basics of digital evidence.', 'Digital Forensics', 'Beginner', 150, 'Dr. Alex Vance', 500)
ON CONFLICT (id) DO NOTHING;

INSERT INTO course_modules (id, course_id, title, description, module_order)
VALUES ('mod_1', 'crs_1', 'Module 1: Forensics Core Concepts', 'Essential techniques', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO lessons (id, module_id, title, duration_minutes, content_type, content_text, lesson_order)
VALUES ('les_101', 'mod_1', 'Digital Forensics Acquisition Techniques', 20, 'text', 'Memory forensics is the analysis of an acquired memory dump.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO cases (id, case_code, title, description, priority, difficulty, status, assigned_date)
VALUES ('case_101', 'Case #01', 'USB Forensics Investigation', 'A suspicious USB drive was found.', 'Medium', 'Beginner', 'In Progress', '2026-04-24')
ON CONFLICT (id) DO NOTHING;

INSERT INTO evidence (id, case_id, title, evidence_type, content_text, evidence_timestamp)
VALUES ('ev_001', 'case_101', 'Suspicious USB Dump Log', 'log', 'USB Mass Storage Device Attached', '2026-04-24 14:02 UTC')
ON CONFLICT (id) DO NOTHING;

-- ======================================
-- Phase 19: Quiz Schema (Server-authoritative Academy)
-- ======================================

-- Quizzes: one per lesson (referenced by lessons.quiz_id)
CREATE TABLE IF NOT EXISTS quizzes (
    id VARCHAR(50) PRIMARY KEY,
    lesson_id VARCHAR(50) REFERENCES lessons(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    passing_score_percent INTEGER DEFAULT 70,
    xp_reward INTEGER DEFAULT 50,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Questions: multiple-choice questions belonging to a quiz
CREATE TABLE IF NOT EXISTS quiz_questions (
    id VARCHAR(50) PRIMARY KEY,
    quiz_id VARCHAR(50) REFERENCES quizzes(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    options JSONB NOT NULL,            -- e.g. ["Option A","Option B","Option C","Option D"]
    correct_option_index INTEGER NOT NULL,  -- 0-based index into options array
    explanation TEXT,
    question_order INTEGER DEFAULT 0
);

-- User quiz attempts: one row per user per quiz attempt (allows retakes)
CREATE TABLE IF NOT EXISTS user_quiz_attempts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    quiz_id VARCHAR(50) REFERENCES quizzes(id) ON DELETE CASCADE,
    score_percent INTEGER NOT NULL,
    is_passed BOOLEAN NOT NULL,
    answers_submitted JSONB,          -- {question_id: chosen_index, ...}
    xp_awarded INTEGER DEFAULT 0,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================================
-- Phase 19: XP Concurrency Protection
--
-- Unique constraint on xp_transactions for idempotent events:
-- prevents duplicate XP for the same (user, event_type, reference_id).
-- reference_id IS NOT NULL is required; events without a refId are not
-- subject to this constraint.
-- ======================================

CREATE UNIQUE INDEX IF NOT EXISTS idx_xp_transactions_idempotency
    ON xp_transactions (user_id, event_type, reference_id)
    WHERE reference_id IS NOT NULL;

-- ======================================
-- Phase 19: Seed Quiz Data (Development Only)
-- ======================================

INSERT INTO quizzes (id, lesson_id, title, passing_score_percent, xp_reward)
VALUES ('qz_101', 'les_101', 'Digital Forensics Acquisition Quiz', 70, 50)
ON CONFLICT (id) DO NOTHING;

INSERT INTO quiz_questions (id, quiz_id, question_text, options, correct_option_index, explanation, question_order)
VALUES
    ('qq_1', 'qz_101', 'Which tool is primarily used for memory forensics on Windows systems?',
     '["Wireshark","Volatility 3","Burp Suite","Nmap"]', 1,
     'Volatility 3 is the standard open-source memory forensics framework for Windows, Linux and macOS.', 1),
    ('qq_2', 'qz_101', 'What does the SHA256 hash of a memory image primarily verify?',
     '["File compression","Evidence integrity","Encryption strength","Network speed"]', 1,
     'A SHA256 hash verifies the integrity of the evidence, proving it was not tampered with after acquisition.', 2),
    ('qq_3', 'qz_101', 'Which Volatility 3 plugin lists active processes on a Windows system?',
     '["windows.netscan","windows.pslist","windows.dlllist","windows.malfind"]', 1,
     'windows.pslist outputs the active process list from the memory dump.', 3)
ON CONFLICT (id) DO NOTHING;
