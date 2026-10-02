<?php

require_once __DIR__ . '/vendor/autoload.php';

// ======================================
// JWT CONFIGURATION
// ======================================

define('JWT_SECRET', getenv('JWT_SECRET') ?: 'forenshield_super_secret_key');

// ======================================
// CLOUDINARY CONFIGURATION
// ======================================

define('CLOUDINARY_CLOUD_NAME', getenv('CLOUDINARY_CLOUD_NAME') ?: 'n82axrnr');
define('CLOUDINARY_API_KEY', getenv('CLOUDINARY_API_KEY') ?: '213326428898443');
define('CLOUDINARY_API_SECRET', getenv('CLOUDINARY_API_SECRET') ?: 'Mw3KpnWvAUJJ7lNhJ1LpZ9qSrAU');

// ======================================
// VIRUSTOTAL CONFIGURATION
// ======================================

define('VT_API_KEY', getenv('VT_API_KEY') ?: 'e9d05d77b9b241f99983982faf4d8679932e4d3eb7a8e050c67100d88a5fdf08');

// ======================================
// DATABASE CONNECTION
// ======================================

function getDb()
{
    $host = getenv('DB_HOST') ?: 'ep-rapid-silence-az1vo4jb-pooler.c-3.ap-southeast-1.aws.neon.tech';
    $port = getenv('DB_PORT') ?: '5432';
    $database = getenv('DB_NAME') ?: 'neondb';
    $username = getenv('DB_USER') ?: 'neondb_owner';
    $password = getenv('DB_PASS') ?: 'npg_mdbt5VvuLc2T';
    $endpoint = getenv('DB_ENDPOINT') ?: 'ep-rapid-silence-az1vo4jb';
    $sslmode = getenv('DB_SSL_MODE') ?: 'require';

    try {
        $options = !empty($endpoint) ? ";options=endpoint={$endpoint}" : "";
        $dsn = sprintf(
            "pgsql:host=%s;port=%s;dbname=%s;sslmode=%s%s",
            $host,
            $port,
            $database,
            $sslmode,
            $options
        );

        return new PDO(
            $dsn,
            $username,
            $password,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::ATTR_PERSISTENT => true,
                PDO::ATTR_TIMEOUT => 5,
            ]
        );
    } catch (PDOException $e) {
        error_log('[DB Connection Error] ' . $e->getMessage());
        header('Content-Type: application/json');
        http_response_code(500);
        die(json_encode(['error' => 'Database connection failed. Please try again later.']));
    }
}