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

$db = getDb();
$method = $_SERVER['REQUEST_METHOD'];

// Handle GET: List or Single Detail
if ($method === 'GET') {
    $reportId = $_GET['id'] ?? null;

    if (!empty($reportId)) {
        // Single Report Detail (Step 9, 11, 12)
        $stmt = $db->prepare("SELECT * FROM reports WHERE id = :id");
        $stmt->execute(['id' => $reportId]);
        $report = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$report) {
            http_response_code(404);
            echo json_encode(['error' => 'Incident report not found.']);
            exit;
        }

        // Enforce Server-Side Ownership: User can only access their own reports (Step 12)
        if ((int)$report['user_id'] !== $userId) {
            http_response_code(403);
            echo json_encode(['error' => 'Forbidden. You do not have permission to view this report.']);
            exit;
        }

        echo json_encode(ReportGenerator::formatReportRow($report));
        exit;
    }

    // List Authenticated User's Reports (Step 8, 11)
    $category = $_GET['category'] ?? null;
    $search = $_GET['search'] ?? null;

    $query = "SELECT * FROM reports WHERE user_id = :user_id";
    $params = ['user_id' => $userId];

    if (!empty($category) && $category !== 'All') {
        $query .= " AND category = :category";
        $params['category'] = $category;
    }

    if (!empty($search)) {
        $query .= " AND (title ILIKE :search OR case_number ILIKE :search OR summary ILIKE :search)";
        $params['search'] = "%{$search}%";
    }

    $query .= " ORDER BY created_at DESC";

    $stmt = $db->prepare($query);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $formatted = array_map(function ($row) {
        return ReportGenerator::formatReportRow($row);
    }, $rows);

    echo json_encode($formatted);
    exit;
}

// Handle POST: Generate Report for Completed Investigation (Step 5, 11, 13)
if ($method === 'POST') {
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
        exit;
    } catch (InvalidArgumentException $e) {
        http_response_code(404);
        echo json_encode(['error' => $e->getMessage()]);
        exit;
    } catch (RuntimeException $e) {
        http_response_code(400);
        echo json_encode(['error' => $e->getMessage()]);
        exit;
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to generate incident report: ' . $e->getMessage()]);
        exit;
    }
}

http_response_code(405);
echo json_encode(['error' => 'Method not allowed.']);
