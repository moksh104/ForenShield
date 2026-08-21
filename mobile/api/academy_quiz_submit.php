<?php
/**
 * ForenShield — Academy Quiz Submission (Phase 19 — Server-authoritative)
 *
 * POST /academy_quiz_submit.php
 * Body: { "quiz_id": "qz_101", "answers": { "qq_1": 1, "qq_2": 0, "qq_3": 1 } }
 *       where answers is a map of question_id => chosen_option_index (0-based).
 *
 * Flow:
 *   1. Authenticate JWT
 *   2. Load quiz + questions from DB (correct_option_index stays server-side)
 *   3. Compare submitted answers against correct answers
 *   4. Calculate score_percent = correct / total * 100
 *   5. If passed (score >= passing_score_percent) AND quiz not yet passed:
 *        awardXp(quiz.xp_reward, 'course_completed', quiz.id)
 *   6. Record attempt in user_quiz_attempts
 *   7. Return: { score, total, score_percent, is_passed, xp_awarded, feedback }
 *
 * NOTE: correct_option_index is NEVER returned to the client in this endpoint.
 */

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/xp_service.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// ── 1. JWT Authentication ──────────────────────────────────────────────────

$authorization = '';
$headers = getallheaders();
if (isset($headers['Authorization'])) {
    $authorization = $headers['Authorization'];
} elseif (isset($headers['authorization'])) {
    $authorization = $headers['authorization'];
}

if (!$authorization || !preg_match('/Bearer\s+(\S+)/', $authorization, $matches)) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

try {
    $decoded = JWT::decode($matches[1], new Key(JWT_SECRET, 'HS256'));
    $userId = (int)($decoded->sub ?? 0);
    if (!$userId) throw new Exception('Invalid token payload.');
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'POST method required.']);
    exit;
}

// ── 2. Parse Input ─────────────────────────────────────────────────────────

$input = json_decode(file_get_contents('php://input'), true);
$quizId  = trim($input['quiz_id'] ?? '');
$answers = $input['answers'] ?? null; // { "qq_1": 1, "qq_2": 0, ... }

if (empty($quizId) || !is_array($answers)) {
    http_response_code(400);
    echo json_encode(['error' => 'quiz_id and answers are required.']);
    exit;
}

$db = getDb();

try {
    // ── 3. Load Quiz ───────────────────────────────────────────────────────

    $stmtQuiz = $db->prepare("
        SELECT id, title, passing_score_percent, xp_reward
        FROM quizzes
        WHERE id = :quiz_id
    ");
    $stmtQuiz->execute(['quiz_id' => $quizId]);
    $quiz = $stmtQuiz->fetch(PDO::FETCH_ASSOC);

    if (!$quiz) {
        http_response_code(404);
        echo json_encode(['error' => 'Quiz not found.']);
        exit;
    }

    // ── 4. Load Questions (with correct answers — server-side only) ────────

    $stmtQ = $db->prepare("
        SELECT id, question_text, options, correct_option_index, explanation
        FROM quiz_questions
        WHERE quiz_id = :quiz_id
        ORDER BY question_order ASC
    ");
    $stmtQ->execute(['quiz_id' => $quizId]);
    $questions = $stmtQ->fetchAll(PDO::FETCH_ASSOC);

    if (empty($questions)) {
        http_response_code(422);
        echo json_encode(['error' => 'Quiz has no questions.']);
        exit;
    }

    // ── 5. Grade Answers ───────────────────────────────────────────────────

    $totalQuestions = count($questions);
    $correctCount   = 0;
    $feedback       = [];

    foreach ($questions as $q) {
        $qId           = $q['id'];
        $correctIdx    = (int)$q['correct_option_index'];
        $submittedIdx  = isset($answers[$qId]) ? (int)$answers[$qId] : -1;
        $isCorrect     = ($submittedIdx === $correctIdx);
        if ($isCorrect) $correctCount++;

        // Parse options JSON (stored as JSONB string in PHP)
        $options = is_string($q['options']) ? json_decode($q['options'], true) : $q['options'];

        $feedback[] = [
            'question_id'     => $qId,
            'question_text'   => $q['question_text'],
            'submitted_index' => $submittedIdx,
            'is_correct'      => $isCorrect,
            // We do NOT include correct_option_index here; we give explanation only.
            'explanation'     => $isCorrect ? $q['explanation'] : 'Incorrect. ' . $q['explanation'],
        ];
    }

    $scorePercent = (int)round(($correctCount / $totalQuestions) * 100);
    $isPassed     = $scorePercent >= (int)$quiz['passing_score_percent'];
    $xpAwarded    = 0;

    // ── 6. Award XP (only if passed and not already passed before) ─────────

    if ($isPassed) {
        // Check if user already passed this quiz (to prevent repeated XP)
        $stmtPrev = $db->prepare("
            SELECT id FROM user_quiz_attempts
            WHERE user_id = :uid AND quiz_id = :qid AND is_passed = TRUE
            LIMIT 1
        ");
        $stmtPrev->execute(['uid' => $userId, 'qid' => $quizId]);
        $alreadyPassed = $stmtPrev->fetch();

        if (!$alreadyPassed) {
            $xpReward = (int)$quiz['xp_reward'];
            if ($xpReward > 0) {
                try {
                    $xpResult  = awardXp($db, $userId, $xpReward, 'Passed Academy Quiz ' . $quizId, 'course_completed', 'Academy', 'quiz_' . $quizId);
                    $xpAwarded = $xpResult['xp_added'];
                } catch (Exception $e) {
                    // XP failure is non-fatal; score result is still returned.
                    error_log('[Quiz XP Error] ' . $e->getMessage());
                }
            }
        }
    }

    // ── 7. Record Attempt ──────────────────────────────────────────────────

    $stmtAttempt = $db->prepare("
        INSERT INTO user_quiz_attempts
            (user_id, quiz_id, score_percent, is_passed, answers_submitted, xp_awarded)
        VALUES
            (:uid, :qid, :score, :passed, :answers, :xp)
    ");
    $stmtAttempt->execute([
        'uid'     => $userId,
        'qid'     => $quizId,
        'score'   => $scorePercent,
        'passed'  => $isPassed ? 'true' : 'false',
        'answers' => json_encode($answers),
        'xp'      => $xpAwarded,
    ]);

    // ── 8. Return Result ───────────────────────────────────────────────────

    echo json_encode([
        'success'       => true,
        'score'         => $scorePercent,
        'correct'       => $correctCount,
        'total'         => $totalQuestions,
        'is_passed'     => $isPassed,
        'passing_score' => (int)$quiz['passing_score_percent'],
        'xp_awarded'    => $xpAwarded,
        'feedback'      => $feedback,
    ]);

} catch (Exception $e) {
    error_log('[academy_quiz_submit] ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'An internal server error occurred.']);
}
