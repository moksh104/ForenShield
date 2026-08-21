# ForenShield Database Schema

ForenShield uses PostgreSQL (hosted on Neon). The database enforces strong referential integrity, uses timestamps, and JSON fields where applicable for flexible module data.

## Tables

### `users`
Core user accounts and authentication.
- `id` (UUID, PK)
- `full_name` (VARCHAR)
- `email` (VARCHAR, UNIQUE)
- `password_hash` (VARCHAR)
- `role` (VARCHAR)
- `created_at` (TIMESTAMP)

### `device_sessions`
Tracks active logins across devices to support remote revocation.
- `id` (UUID, PK)
- `user_id` (UUID, FK -> users(id))
- `device_name` (VARCHAR)
- `platform` (VARCHAR)
- `session_token` (VARCHAR)
- `is_current` (BOOLEAN)
- `created_at` (TIMESTAMP)

### `login_history`
Audit log of all login attempts for security visibility.
- `id` (UUID, PK)
- `user_id` (UUID, FK -> users(id))
- `device_name` (VARCHAR)
- `ip_address` (VARCHAR)
- `status` (VARCHAR: 'success' | 'failed')
- `created_at` (TIMESTAMP)

### `leaderboard_stats`
Aggregated statistics for player rankings. Rank is dynamically computed.
- `user_id` (UUID, PK, FK -> users(id))
- `total_xp` (INTEGER)
- `current_streak` (INTEGER)
- `investigations_completed` (INTEGER)
- `courses_completed` (INTEGER)
- `threats_resolved` (INTEGER)

### `xp_transactions`
Ledger of all XP awarded to a user.
- `id` (UUID, PK)
- `user_id` (UUID, FK -> users(id))
- `amount` (INTEGER)
- `source` (VARCHAR)
- `event_type` (VARCHAR)
- `created_at` (TIMESTAMP)

### `achievements`
Static reference table of available badges.
- `id` (UUID, PK)
- `code` (VARCHAR, UNIQUE)
- `title` (VARCHAR)
- `description` (TEXT)
- `icon` (VARCHAR)
- `category` (VARCHAR)
- `xp_reward` (INTEGER)
- `metric_type` (VARCHAR)
- `metric_threshold` (INTEGER)

### `user_achievements`
Junction table tracking which users have unlocked which achievements.
- `id` (UUID, PK)
- `user_id` (UUID, FK -> users(id))
- `achievement_id` (UUID, FK -> achievements(id))
- `unlocked_at` (TIMESTAMP)

### `notifications`
In-app messaging and alerts system.
- `id` (UUID, PK)
- `user_id` (UUID, FK -> users(id))
- `title` (VARCHAR)
- `message` (TEXT)
- `type` (VARCHAR)
- `is_read` (BOOLEAN)
- `created_at` (TIMESTAMP)

### `user_courses` & `user_lessons`
Tracks progression through the Cyber Academy module.

### `simulations` & `user_simulations`
Tracks progression through the active Threat Simulation Labs.
