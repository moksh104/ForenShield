<?php
require_once __DIR__ . '/config.php';

try {
    $db = getDb();
    
    $sql = file_get_contents(__DIR__ . '/../database/migration_phase4_simulation.sql');
    if (!$sql) {
        $sql = file_get_contents('c:/Projects/ForenShield/mobile/database/migration_phase4_simulation.sql');
    }
    
    $db->exec($sql);
    
    echo json_encode([
        'success' => true,
        'message' => 'Phase 4 simulation migration executed successfully.'
    ], JSON_PRETTY_PRINT);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ], JSON_PRETTY_PRINT);
}
