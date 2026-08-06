# ForenShield PHP REST API

This directory contains the initial PHP REST API endpoints for the mobile authentication flow.

## Endpoints

- `login.php`
- `register.php`
- `verify_otp.php`
- `refresh_token.php`
- `logout.php`
- `forgot_password.php`

## Database schema

Create the `users` table:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    password_hash TEXT,
    created_at TIMESTAMP
);
```

Create the `otp_codes` table:

```sql
CREATE TABLE otp_codes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    otp_code VARCHAR(6),
    expires_at TIMESTAMP
);
```

Create the `refresh_tokens` table:

```sql
CREATE TABLE refresh_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    refresh_token TEXT,
    created_at TIMESTAMP
);
```

## Notes

- Replace `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, and `JWT_SECRET` in `config.php` with secure values.
- Install dependencies with Composer before running the API server:

```powershell
cd mobile\api
composer install
```

- Run a local PHP server from the `mobile/api` folder:

```powershell
php -S 127.0.0.1:8000
```

- The Flutter app is configured to use `API_BASE_URL=http://127.0.0.1:8000` in `.env` when `USE_MOCK_API=false`.
- The current terminal does not have `php` or `composer` available, so local endpoint testing requires installing PHP and Composer or using a system shell where those executables are available.
- `current_user.php` was added to support `GET /current_user.php` for profile restoration.
