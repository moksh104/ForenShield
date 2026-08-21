<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

header('Content-Type: application/json');

// Validate JWT Header
$authorization = '';
$headers = getallheaders();
if (isset($headers['Authorization'])) {
    $authorization = $headers['Authorization'];
} elseif (isset($headers['authorization'])) {
    $authorization = $headers['authorization'];
}

if (!$authorization || !preg_match('/Bearer\s+(\S+)/', $authorization, $matches)) {
    http_response_code(401);
    echo json_encode(['error' => 'Missing or invalid Authorization header.']);
    exit;
}

$token = $matches[1];

try {
    $decoded = JWT::decode($token, new Key(JWT_SECRET, 'HS256'));
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

$authUserId = (int)($decoded->sub ?? 0);
if (!$authUserId) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid token payload.']);
    exit;
}

$db = getDb();
$method = $_SERVER['REQUEST_METHOD'];

// Handle Mark as Read (PUT or POST with action=mark_read or notification_id)
if ($method === 'PUT' || ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'mark_read')) {
    $input = json_decode(file_get_contents('php://input'), true);
    $notificationId = (int)($input['notification_id'] ?? $_GET['id'] ?? 0);
    $markAll = !empty($input['mark_all']);

    try {
        if ($markAll) {
            $stmt = $db->prepare('UPDATE notifications SET is_read = TRUE WHERE user_id = :user_id');
            $stmt->execute(['user_id' => $authUserId]);
        } elseif ($notificationId > 0) {
            $stmt = $db->prepare('UPDATE notifications SET is_read = TRUE WHERE id = :id AND user_id = :user_id');
            $stmt->execute(['id' => $notificationId, 'user_id' => $authUserId]);
        }

        echo json_encode([
            'success' => true,
            'message' => 'Notification(s) marked as read.',
        ]);
        exit;
    } catch (Exception $e) {
        http_response_code(500);
        error_log('[API Error] ' . $e->getMessage());
        echo json_encode(['error' => 'An internal server error occurred.']);
        exit;
    }
}

// GET or default POST fetch: Fetch Notifications
$page = max(1, (int)($_GET['page'] ?? 1));
$limit = min(100, max(1, (int)($_GET['limit'] ?? 20)));
$offset = ($page - 1) * $limit;
$unreadOnly = isset($_GET['unread_only']) && ($_GET['unread_only'] === 'true' || $_GET['unread_only'] === '1');

try {
    // Unread count
    $stmtUnread = $db->prepare('SELECT COUNT(*) FROM notifications WHERE user_id = :user_id AND is_read = FALSE');
    $stmtUnread->execute(['user_id' => $authUserId]);
    $unreadCount = (int)$stmtUnread->fetchColumn();

    // Query notifications
    $sql = 'SELECT id, user_id, title, message, type, is_read, created_at FROM notifications WHERE user_id = :user_id';
    if ($unreadOnly) {
        $sql .= ' AND is_read = FALSE';
    }
    $sql .= ' ORDER BY created_at DESC LIMIT :limit OFFSET :offset';

    $stmt = $db->prepare($sql);
    $stmt->bindValue(':user_id', $authUserId, PDO::PARAM_INT);
    $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
    $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
    $stmt->execute();

    $notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Format boolean and numeric types
    foreach ($notifications as &$n) {
        $n['id'] = (int)$n['id'];
        $n['user_id'] = (int)$n['user_id'];
        $n['is_read'] = (bool)$n['is_read'];
    }

    echo json_encode([
        'success' => true,
        'page' => $page,
        'limit' => $limit,
        'unread_count' => $unreadCount,
        'notifications' => $notifications,
    ]);
} catch (Exception $e) {
    http_response_code(500);
    error_log('[API Error] ' . $e->getMessage());
    echo json_encode(['error' => 'An internal server error occurred.']);
}
