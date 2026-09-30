<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/report_generator.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

header('Content-Type: application/json');

// 1. Authenticate via JWT (Step 11 & 12)
$authorization = '';
$headers = getallheaders();
if (isset($headers['Authorization'])) {
    $authorization = $headers['Authorization'];
} elseif (isset($headers['authorization'])) {
    $authorization = $headers['authorization'];
}

if (!$authorization || !preg_match('/Bearer\s+(\S+)/', $authorization, $matches)) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized. Bearer token required.']);
    exit;
}

try {
    $decoded = JWT::decode($matches[1], new Key(JWT_SECRET, 'HS256'));
    $userId = (int)($decoded->sub ?? 0);
    if ($userId <= 0) {
        http_response_code(401);
        echo json_encode(['error' => 'Invalid JWT subject claim.']);
        exit;
    }
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Token validation failed: ' . $e->getMessage()]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed. Use POST.']);
    exit;
}

$rawInput = file_get_contents('php://input');
$data = json_decode($rawInput, true) ?? [];
$caseId = $data['case_id'] ?? ($_POST['case_id'] ?? null);

if (empty($caseId)) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing required parameter: case_id']);
    exit;
}

try {
    $report = ReportGenerator::generate($userId, $caseId);
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'message' => 'Incident report generated successfully.',
        'report' => $report
    ]);
} catch (InvalidArgumentException $e) {
    http_response_code(404);
    echo json_encode(['error' => $e->getMessage()]);
} catch (RuntimeException $e) {
    http_response_code(400);
    echo json_encode(['error' => $e->getMessage()]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to generate incident report: ' . $e->getMessage()]);
}
