# Backend Setup Guide

The ForenShield Backend is a standard PHP application connecting to PostgreSQL. 

## Requirements
- PHP 8.1+
- Composer
- PostgreSQL 15+ (Hosted on Neon DB is recommended)

## Installation
1. Clone the repository and navigate to `mobile/api`.
2. Run `composer install` to install dependencies (Firebase JWT, Cloudinary SDK).
3. Update `config.php` with your connection strings.
    - Set `JWT_SECRET`
    - Set `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`
    - Set `VT_API_KEY` (VirusTotal)
    - Set PostgreSQL Credentials inside `getDb()`

## Database Initialization
1. Connect to your PostgreSQL database instance using `psql` or pgAdmin.
2. Run the `migrations.sql` file located in `api/` to create tables and seed achievements.

## Running Locally
You can test the backend locally using PHP's built-in server:
`php -S localhost:8000`

Ensure your Flutter app's `ApiEndpoints.baseUrl` points to `http://localhost:8000/api` during local development.
