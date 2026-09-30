<?php
require_once __DIR__ . '/config.php';

try {
    $db = getDb();
    
    $sqlFile = __DIR__ . '/../database/migration_phase5_reports.sql';
    if (!file_exists($sqlFile)) {
        $sqlFile = 'c:/Projects/ForenShield/mobile/database/migration_phase5_reports.sql';
    }
    
    $sql = file_get_contents($sqlFile);
    if (!$sql) {
        throw new Exception("Migration file could not be read: $sqlFile");
    }
    
    $db->exec($sql);
    
    // Verify table creation
    $check = $db->query("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'reports' ORDER BY ordinal_position")->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'success' => true,
        'message' => 'Phase 5 reports migration executed successfully.',
        'columns' => $check
    ], JSON_PRETTY_PRINT);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ], JSON_PRETTY_PRINT);
}
