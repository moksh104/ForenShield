<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

$data = json_decode(file_get_contents('php://input'), true);
$index = $data['selected_verdict_index'] ?? 0;

$score = ($index == 0) ? 100 : 40;

echo json_encode(['score' => $score]);
