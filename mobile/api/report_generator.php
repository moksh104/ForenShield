<?php

require_once __DIR__ . '/config.php';

class ReportGenerator
{
    public static function generate(int $userId, string $caseId): array
    {
        $db = getDb();

        // 1. Idempotency Check: Return existing report if already generated
        $checkStmt = $db->prepare("SELECT * FROM reports WHERE user_id = :user_id AND case_id = :case_id LIMIT 1");
        $checkStmt->execute([
            'user_id' => $userId,
            'case_id' => $caseId
        ]);
        $existing = $checkStmt->fetch(PDO::FETCH_ASSOC);
        if ($existing) {
            return self::formatReportRow($existing);
        }

        // 2. Verify Case exists
        $caseStmt = $db->prepare("SELECT * FROM cases WHERE id = :case_id");
        $caseStmt->execute(['case_id' => $caseId]);
        $case = $caseStmt->fetch(PDO::FETCH_ASSOC);
        if (!$case) {
            throw new InvalidArgumentException("Investigation case '$caseId' not found.");
        }

        // 3. Verify user completed/solved the case
        $progStmt = $db->prepare("SELECT * FROM user_case_progress WHERE user_id = :user_id AND case_id = :case_id");
        $progStmt->execute([
            'user_id' => $userId,
            'case_id' => $caseId
        ]);
        $progress = $progStmt->fetch(PDO::FETCH_ASSOC);
        $isSolved = $progress && (!empty($progress['is_solved']) || ($progress['status'] ?? '') === 'solved');
        if (!$isSolved) {
            throw new RuntimeException("Case '$caseId' has not been solved yet. Complete the investigation verdict before generating a report.");
        }

        // 4. Fetch Case Timeline
        $timelineStmt = $db->prepare("SELECT id, title, description, timeline_timestamp, category, severity FROM case_timeline WHERE case_id = :case_id ORDER BY created_at ASC");
        $timelineStmt->execute(['case_id' => $caseId]);
        $timelineRows = $timelineStmt->fetchAll(PDO::FETCH_ASSOC);

        // 5. Fetch Evidence
        $evidenceStmt = $db->prepare("SELECT id, title, evidence_type, content_text, metadata_map, evidence_timestamp FROM evidence WHERE case_id = :case_id ORDER BY created_at ASC");
        $evidenceStmt->execute(['case_id' => $caseId]);
        $evidenceRows = $evidenceStmt->fetchAll(PDO::FETCH_ASSOC);

        // 6. Fetch Verdict
        $verdictStmt = $db->prepare("SELECT id, summary_text, options, correct_option_index, explanation_text, xp_reward FROM verdicts WHERE case_id = :case_id");
        $verdictStmt->execute(['case_id' => $caseId]);
        $verdict = $verdictStmt->fetch(PDO::FETCH_ASSOC);

        $verdictOptions = [];
        if ($verdict && !empty($verdict['options'])) {
            $verdictOptions = is_string($verdict['options']) ? json_decode($verdict['options'], true) : $verdict['options'];
        }
        $correctIndex = $verdict['correct_option_index'] ?? 0;
        $rootCause = $verdictOptions[$correctIndex] ?? 'Targeted Exploitation';

        // 7. Fetch Analyst User Details
        $userStmt = $db->prepare("SELECT full_name, email FROM users WHERE id = :user_id");
        $userStmt->execute(['user_id' => $userId]);
        $user = $userStmt->fetch(PDO::FETCH_ASSOC);
        $analystName = !empty($user['full_name']) ? $user['full_name'] : 'Forensic Specialist';

        // 8. Trace Linked Simulation Attempt (Milestone E: Simulation -> Investigation Join)
        $scenarioStmt = $db->prepare("SELECT id, title, category, difficulty FROM scenarios WHERE investigation_case_id = :case_id LIMIT 1");
        $scenarioStmt->execute(['case_id' => $caseId]);
        $scenario = $scenarioStmt->fetch(PDO::FETCH_ASSOC);

        $scenarioId = $scenario['id'] ?? null;
        $attemptId = null;
        $analystActions = [];
        $attemptScore = 100;
        $attemptXp = 0;

        if ($scenarioId) {
            $attemptStmt = $db->prepare("SELECT id, score, xp_earned, selected_actions, discovered_evidence_ids, status FROM scenario_attempts WHERE user_id = :user_id AND scenario_id = :scenario_id ORDER BY completed_at DESC NULLS LAST, started_at DESC LIMIT 1");
            $attemptStmt->execute([
                'user_id' => $userId,
                'scenario_id' => $scenarioId
            ]);
            $attempt = $attemptStmt->fetch(PDO::FETCH_ASSOC);
            if ($attempt) {
                $attemptId = $attempt['id'];
                $attemptScore = (int)($attempt['score'] ?? 100);
                $attemptXp = (int)($attempt['xp_earned'] ?? 0);
                if (!empty($attempt['selected_actions'])) {
                    $analystActions = is_string($attempt['selected_actions']) 
                        ? json_decode($attempt['selected_actions'], true) 
                        : $attempt['selected_actions'];
                }
            }
        }

        // Calculate combined score (investigation accuracy is 100% since solved; average with simulation if present)
        $finalScore = $attemptId ? (int)round(($attemptScore + 100) / 2) : 100;

        // Query XP earned for this case & scenario
        $xpStmt = $db->prepare("SELECT COALESCE(SUM(xp_earned), 0) FROM xp_transactions WHERE user_id = :user_id AND (reference_id = :case_id OR reference_id = :attempt_id)");
        $xpStmt->execute([
            'user_id' => $userId,
            'case_id' => $caseId,
            'attempt_id' => $attemptId ?? $caseId
        ]);
        $xpEarned = (int)$xpStmt->fetchColumn();
        if ($xpEarned === 0) {
            $xpEarned = (int)($verdict['xp_reward'] ?? 100) + $attemptXp;
        }

        // 9. Derive Deterministic Severity (Step 7)
        $rawPriority = $case['priority'] ?? '';
        if (in_array(strtolower($rawPriority), ['critical', 'high', 'medium', 'low'])) {
            $severity = ucfirst(strtolower($rawPriority));
        } else {
            // Check timeline severity
            $hasCritical = false;
            foreach ($timelineRows as $tRow) {
                if (strtolower($tRow['severity'] ?? '') === 'critical') {
                    $hasCritical = true;
                    break;
                }
            }
            if ($hasCritical) {
                $severity = 'Critical';
            } elseif (strtolower($case['difficulty'] ?? '') === 'hard') {
                $severity = 'High';
            } elseif (strtolower($case['difficulty'] ?? '') === 'medium') {
                $severity = 'Medium';
            } else {
                $severity = 'Low';
            }
        }

        // 10. Title & Category
        $reportTitle = $case['title'] . ' Incident Report';
        $category = $scenario['category'] ?? 'Incidents & Forensics';
        $caseNumber = $case['case_code'] ?: ('#FSC-' . strtoupper(substr(md5($caseId), 0, 4)));
        $reportId = 'rep_' . $caseId . '_' . $userId;

        // 11. Generate Deterministic Findings from Evidence & Verdict (Step 6, 15)
        $findings = [];
        foreach ($evidenceRows as $ev) {
            $title = $ev['title'] ?? 'Digital Artifact';
            $meta = is_string($ev['metadata_map']) ? json_decode($ev['metadata_map'], true) : ($ev['metadata_map'] ?? []);
            $extra = '';
            if (!empty($meta['ip'])) $extra .= " (IP: {$meta['ip']})";
            if (!empty($meta['hash'])) $extra .= " (Hash: " . substr($meta['hash'], 0, 16) . "...)";
            if (!empty($meta['url'])) $extra .= " (URL: {$meta['url']})";
            $findings[] = "Identified {$ev['evidence_type']}: {$title}{$extra}.";
        }
        if ($verdict && !empty($verdict['explanation_text'])) {
            $findings[] = "Forensic root-cause confirmation: " . $verdict['explanation_text'];
        }
        if (empty($findings)) {
            $findings[] = "No anomalous secondary payloads discovered during memory scan.";
        }

        // 12. Generate Deterministic Remediation Actions (Step 6)
        $remediation = self::generateRemediationActions($caseId, $category, $severity);

        // 13. Extract Forensic Artifacts list
        $artifacts = [];
        foreach ($evidenceRows as $ev) {
            $meta = is_string($ev['metadata_map']) ? json_decode($ev['metadata_map'], true) : ($ev['metadata_map'] ?? []);
            if (!empty($meta['filename'])) {
                $artifacts[] = $meta['filename'];
            } elseif (!empty($meta['artifact_name'])) {
                $artifacts[] = $meta['artifact_name'];
            } else {
                $cleanTitle = strtolower(preg_replace('/[^a-zA-Z0-9_]/', '_', $ev['title']));
                $artifacts[] = "{$cleanTitle}.bin";
            }
        }
        if (empty($artifacts)) {
            $artifacts = ['evidence_dump.raw', 'security_event_log.evtx'];
        }

        // 14. Deterministic Executive Summary (Step 15)
        $evidenceCount = count($evidenceRows);
        $summary = sprintf(
            "Forensic examination conducted by %s confirmed a %s-severity cybersecurity incident concerning '%s'. Forensic acquisition and correlation of %d digital evidence artifact%s verified that %s. Root-cause evaluation confirmed: '%s'. Incident containment and post-incident hardening measures have been formulated to prevent recurrences.",
            $analystName,
            strtolower($severity),
            $case['title'],
            $evidenceCount,
            $evidenceCount === 1 ? '' : 's',
            lcfirst(rtrim($verdict['summary_text'] ?? 'malicious activity was detected', '.')),
            $rootCause
        );

        // 15. Format snapshots
        $timelineSnapshot = [];
        foreach ($timelineRows as $t) {
            $timelineSnapshot[] = [
                'id' => $t['id'],
                'title' => $t['title'],
                'description' => $t['description'],
                'timestamp' => $t['timeline_timestamp'],
                'category' => $t['category'],
                'severity' => $t['severity'],
            ];
        }

        $evidenceSnapshot = [];
        foreach ($evidenceRows as $e) {
            $evidenceSnapshot[] = [
                'id' => $e['id'],
                'title' => $e['title'],
                'type' => $e['evidence_type'],
                'content' => $e['content_text'],
                'timestamp' => $e['evidence_timestamp'],
                'metadata' => is_string($e['metadata_map']) ? json_decode($e['metadata_map'], true) : $e['metadata_map'],
            ];
        }

        $verdictSnapshot = [
            'summary' => $verdict['summary_text'] ?? '',
            'root_cause' => $rootCause,
            'explanation' => $verdict['explanation_text'] ?? '',
            'score' => $finalScore,
            'xp_earned' => $xpEarned,
        ];

        // 16. Transactional Insert into Database
        $db->beginTransaction();
        try {
            $insertStmt = $db->prepare("
                INSERT INTO reports (
                    id, user_id, case_id, scenario_id, attempt_id,
                    case_number, title, category, severity, status,
                    analyst, summary, score, xp_earned,
                    findings, remediation_actions, artifacts,
                    timeline_snapshot, evidence_snapshot, analyst_actions, verdict_snapshot,
                    created_at, updated_at
                ) VALUES (
                    :id, :user_id, :case_id, :scenario_id, :attempt_id,
                    :case_number, :title, :category, :severity, 'FINALIZED',
                    :analyst, :summary, :score, :xp_earned,
                    :findings, :remediation_actions, :artifacts,
                    :timeline_snapshot, :evidence_snapshot, :analyst_actions, :verdict_snapshot,
                    NOW(), NOW()
                )
                ON CONFLICT (user_id, case_id) DO UPDATE SET
                    updated_at = NOW(),
                    score = EXCLUDED.score,
                    xp_earned = EXCLUDED.xp_earned,
                    summary = EXCLUDED.summary
                RETURNING *
            ");

            $insertStmt->execute([
                'id' => $reportId,
                'user_id' => $userId,
                'case_id' => $caseId,
                'scenario_id' => $scenarioId,
                'attempt_id' => $attemptId,
                'case_number' => $caseNumber,
                'title' => $reportTitle,
                'category' => $category,
                'severity' => $severity,
                'analyst' => $analystName,
                'summary' => $summary,
                'score' => $finalScore,
                'xp_earned' => $xpEarned,
                'findings' => json_encode($findings),
                'remediation_actions' => json_encode($remediation),
                'artifacts' => json_encode($artifacts),
                'timeline_snapshot' => json_encode($timelineSnapshot),
                'evidence_snapshot' => json_encode($evidenceSnapshot),
                'analyst_actions' => json_encode($analystActions),
                'verdict_snapshot' => json_encode($verdictSnapshot),
            ]);

            $savedRow = $insertStmt->fetch(PDO::FETCH_ASSOC);

            // Record notification for user
            $notifCheck = $db->prepare("SELECT COUNT(*) FROM notifications WHERE user_id = :user_id AND type = 'report' AND message LIKE :match");
            $notifCheck->execute([
                'user_id' => $userId,
                'match' => "%{$caseNumber}%"
            ]);
            if ((int)$notifCheck->fetchColumn() === 0) {
                $notifStmt = $db->prepare("INSERT INTO notifications (user_id, title, message, type, is_read, created_at) VALUES (:user_id, '📄 Incident Report Finalized', :msg, 'report', FALSE, NOW())");
                $notifStmt->execute([
                    'user_id' => $userId,
                    'msg' => "{$reportTitle} ({$caseNumber}) is now available in your intelligence vault."
                ]);
            }

            $db->commit();
            return self::formatReportRow($savedRow);
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    private static function generateRemediationActions(string $caseId, string $category, string $severity): array
    {
        switch ($caseId) {
            case 'case_101': // Account Takeover / Priv Escalation
                return [
                    'Immediately invalidate all active session tokens and enforce multi-factor authentication (MFA).',
                    'Audit privileged administrator accounts and restrict PowerShell/RDP remote execution policies.',
                    'Deploy endpoint detection and response (EDR) agent rules to flag token theft and LSASS dump attempts.',
                    'Rotate internal API keys and database credentials accessed during the breach window.'
                ];
            case 'case_102': // Phishing Incident
                return [
                    'Implement strict inbound email filtering with SPF, DKIM, and DMARC quarantine enforcement.',
                    'Block command-and-control (C2) domains and malicious sender IP addresses on perimeter firewalls.',
                    'Purge matching phishing email samples across all corporate email inboxes.',
                    'Conduct interactive spear-phishing resilience exercises for finance and human resource departments.'
                ];
            case 'case_103': // QR Payment Fraud
                return [
                    'Implement dynamic physical verification and tamper-evident QR code overlays at point-of-sale terminals.',
                    'Blacklist fraudulent merchant routing identifiers and coordinate financial reversal with payment gateway.',
                    'Enforce real-time transaction velocity anomalies and location mismatch fraud detection algorithms.',
                    'Provide prominent customer educational prompts before confirmation of high-value peer-to-peer transfers.'
                ];
            case 'case_104': // Fake Online Store
                return [
                    'File domain takedown requests with registrar and issue anti-abuse reports to hosting providers.',
                    'Submit fraudulent credential harvesting URLs to Google Safe Browsing and Microsoft SmartScreen.',
                    'Issue security advisories to impacted shoppers regarding compromised payment card credentials.',
                    'Monitor brand keywords using automated cyber threat intelligence (CTI) typosquatting monitors.'
                ];
            default:
                return [
                    'Isolate affected host assets from the internal corporate network VLAN.',
                    'Revoke compromised user credentials and enforce multi-factor authentication.',
                    'Deploy updated IOC signatures and YARA rules across all perimeter gateways.',
                    'Review audit logs to verify no unauthorized lateral persistence was established.'
                ];
        }
    }

    public static function formatReportRow(array $row): array
    {
        $findings = is_string($row['findings'] ?? null) ? json_decode($row['findings'], true) : ($row['findings'] ?? []);
        $remediation = is_string($row['remediation_actions'] ?? null) ? json_decode($row['remediation_actions'], true) : ($row['remediation_actions'] ?? []);
        $artifacts = is_string($row['artifacts'] ?? null) ? json_decode($row['artifacts'], true) : ($row['artifacts'] ?? []);
        $timeline = is_string($row['timeline_snapshot'] ?? null) ? json_decode($row['timeline_snapshot'], true) : ($row['timeline_snapshot'] ?? []);
        $evidence = is_string($row['evidence_snapshot'] ?? null) ? json_decode($row['evidence_snapshot'], true) : ($row['evidence_snapshot'] ?? []);
        $actions = is_string($row['analyst_actions'] ?? null) ? json_decode($row['analyst_actions'], true) : ($row['analyst_actions'] ?? []);
        $verdict = is_string($row['verdict_snapshot'] ?? null) ? json_decode($row['verdict_snapshot'], true) : ($row['verdict_snapshot'] ?? []);

        $createdAt = $row['created_at'] ?? '';
        $formattedDate = $createdAt;
        if (!empty($createdAt)) {
            $ts = strtotime($createdAt);
            if ($ts !== false) {
                $formattedDate = gmdate('Y-m-d H:i \U\T\C', $ts);
            }
        }

        return [
            'id' => $row['id'],
            'case_number' => $row['case_number'] ?? '',
            'case_id' => $row['case_id'] ?? null,
            'scenario_id' => $row['scenario_id'] ?? null,
            'attempt_id' => $row['attempt_id'] ?? null,
            'title' => $row['title'] ?? '',
            'category' => $row['category'] ?? 'Incidents & Forensics',
            'severity' => $row['severity'] ?? 'Medium',
            'status' => $row['status'] ?? 'FINALIZED',
            'generated_at' => $formattedDate,
            'analyst' => $row['analyst'] ?? 'Forensic Specialist',
            'summary' => $row['summary'] ?? '',
            'score' => (int)($row['score'] ?? 100),
            'xp_earned' => (int)($row['xp_earned'] ?? 0),
            'findings' => $findings ?: [],
            'remediation_actions' => $remediation ?: [],
            'artifacts' => $artifacts ?: [],
            'timeline' => $timeline ?: [],
            'evidence' => $evidence ?: [],
            'analyst_actions' => $actions ?: [],
            'verdict' => $verdict ?: (object)[],
        ];
    }
}
