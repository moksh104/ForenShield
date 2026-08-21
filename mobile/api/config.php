<?php

require_once __DIR__ . '/vendor/autoload.php';

// ======================================
// JWT CONFIGURATION
// ======================================

define('JWT_SECRET', getenv('JWT_SECRET') ?: throw new Exception('JWT_SECRET is missing'));

// ======================================
// CLOUDINARY CONFIGURATION
// ======================================

define('CLOUDINARY_CLOUD_NAME', getenv('CLOUDINARY_CLOUD_NAME') ?: '');
define('CLOUDINARY_API_KEY', getenv('CLOUDINARY_API_KEY') ?: '');
define('CLOUDINARY_API_SECRET', getenv('CLOUDINARY_API_SECRET') ?: '');

// ======================================
// VIRUSTOTAL CONFIGURATION
// ======================================

define('VT_API_KEY', getenv('VT_API_KEY') ?: '');

// ======================================
// DATABASE CONNECTION
// ======================================

function getDb()
{
    $host = getenv('DB_HOST') ?: '127.0.0.1';
    $port = getenv('DB_PORT') ?: '5432';
    $database = getenv('DB_NAME') ?: 'forenshield';
    $username = getenv('DB_USER') ?: 'postgres';
    $password = getenv('DB_PASS') ?: '';
    $endpoint = getenv('DB_ENDPOINT') ?: ''; // specific to Neon
    
    // For Neon Postgres
    $options = '';
    if (!empty($endpoint)) {
        $options = ";options=endpoint={$endpoint}";
    }
    
    // Check if SSL is required
    $sslmode = getenv('DB_SSL_MODE') ?: 'prefer';
    
    try {
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
            ]
        );
    } catch (PDOException $e) {
        error_log('[DB Connection Error] ' . $e->getMessage());
        header('Content-Type: application/json');
        http_response_code(500);
        die(json_encode(['error' => 'Database connection failed.']));
    }
}