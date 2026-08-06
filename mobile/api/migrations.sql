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
