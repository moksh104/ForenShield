<?php
require_once __DIR__ . '/config.php';
$pdo = getDb();
$sql = file_get_contents(__DIR__ . '/migrations.sql');
$pdo->exec($sql);
echo "Migration successful!\n";
