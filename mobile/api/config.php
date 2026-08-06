<?php

require_once __DIR__ . '/vendor/autoload.php';

// ======================================
// JWT CONFIGURATION
// ======================================

define('JWT_SECRET', 'forenshield_super_secret_key');

// ======================================
// CLOUDINARY CONFIGURATION
// ======================================

define('CLOUDINARY_CLOUD_NAME', 'n82axrnr');
define('CLOUDINARY_API_KEY', '213326428898443');
define('CLOUDINARY_API_SECRET', 'Mw3KpnWvAUJJ7lNhJ1LpZ9qSrAU');

// ======================================
// DATABASE CONNECTION
// ======================================

function getDb()
{
    $host = 'ep-rapid-silence-az1vo4jb-pooler.c-3.ap-southeast-1.aws.neon.tech';
    $port = '5432';
    $database = 'neondb';
    $username = 'neondb_owner';
    $password = 'npg_mdbt5VvuLc2T';
    $endpoint = 'ep-rapid-silence-az1vo4jb';

    try {
        $dsn = sprintf(
            "pgsql:host=%s;port=%s;dbname=%s;sslmode=require;options=endpoint=%s",
            $host,
            $port,
            $database,
            $endpoint
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
        die('Database connection failed: ' . $e->getMessage());
    }
}