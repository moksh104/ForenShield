<?php
require_once __DIR__ . '/config.php';
$db = getDb();
$cases = $db->query("SELECT id, case_code, title, difficulty FROM cases ORDER BY id")->fetchAll(PDO::FETCH_ASSOC);
echo json_encode(['cases' => $cases, 'count' => count($cases)], JSON_PRETTY_PRINT);
