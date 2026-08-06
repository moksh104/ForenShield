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
-- Phase 6: Achievement Engine
-- ======================================

CREATE TABLE IF NOT EXISTS achievements (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    badge VARCHAR(255),
    xp INTEGER DEFAULT 0,
    unlocked BOOLEAN DEFAULT FALSE,
    unlocked_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
