<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

$evidenceId = $_GET['id'] ?? 'ev_001';

$evidence = [
    'id' => $evidenceId,
    'title' => 'Suspicious USB Dump Log',
    'type' => 'log',
    'content_text' => '2026-04-24 14:02:11 UTC - USB Mass Storage Device Attached: SanDisk Ultra 3.0 (SN: 99482012)',
    'metadata_map' => [
        'Source' => 'Windows Event Log (System)',
        'Event ID' => '20001',
        'User' => 'SYSTEM / Administrator',
        'Computer' => 'FINANCE-PC01'
    ],
    'is_reviewed' => true,
    'timestamp' => '2026-04-24 14:02 UTC'
];

echo json_encode($evidence);
