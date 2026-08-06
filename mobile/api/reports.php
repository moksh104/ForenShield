<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

// Extract & Validate JWT if header present
$authorization = '';
$headers = getallheaders();
if (isset($headers['Authorization'])) {
    $authorization = $headers['Authorization'];
} elseif (isset($headers['authorization'])) {
    $authorization = $headers['authorization'];
}

if ($authorization && preg_match('/Bearer\s+(\S+)/', $authorization, $matches)) {
    try {
        $decoded = JWT::decode($matches[1], new Key(JWT_SECRET, 'HS256'));
        $userId = $decoded->sub ?? null;
        if ($userId) {
            $db = getDb();
            $check = $db->prepare("SELECT COUNT(*) FROM notifications WHERE user_id = :user_id AND type = 'report'");
            $check->execute(['user_id' => $userId]);
            if ((int)$check->fetchColumn() === 0) {
                $stmt = $db->prepare("INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (:user_id, '📄 Weekly Report Generated', 'NovaCorp Ransomware Intrusion Incident Report #FSC-0091 is finalized.', 'report', FALSE)");
                $stmt->execute(['user_id' => $userId]);
            }
        }
    } catch (Exception $e) {
        // Ignore JWT exception on optional check
    }
}

$reports = [
    [
        'id' => 'rep_001',
        'case_number' => '#FSC-0091',
        'title' => 'NovaCorp Ransomware Intrusion Incident Report',
        'category' => 'Incidents & Forensics',
        'severity' => 'Critical',
        'status' => 'FINALIZED',
        'generated_at' => '2026-04-24 16:45 UTC',
        'analyst' => 'Lead Forensic Specialist',
        'summary' => 'Forensic examination of host FS-HOST-09 confirmed a LockBit 3.0 ransomware beacon initial entry via compromised RDP credentials.',
        'findings' => [
            'Initial access vector identified as brute-forced RDP (Port 3389).',
            'Malicious DLL side-loading observed via legitimate binary.',
            'C2 communication established to IP 192.0.2.45.'
        ],
        'remediation_actions' => [
            'Isolate host FS-HOST-09 from internal network VLAN.',
            'Revoke compromised RDP user credentials and enforce 2FA.',
            'Deploy YARA rules across all domain controllers.'
        ],
        'artifacts' => [
            'memory_dump_fshost09.raw',
            'security_event_log.evtx',
            'c2_beacon_trace.pcap'
        ]
    ],
    [
        'id' => 'rep_002',
        'case_number' => '#FSC-0084',
        'title' => 'Finance Sector Spear Phishing Campaign',
        'category' => 'Threat Intelligence',
        'severity' => 'High',
        'status' => 'IN REVIEW',
        'generated_at' => '2026-04-22 11:20 UTC',
        'analyst' => 'Senior SOC Analyst',
        'summary' => 'Targeted spear-phishing emails containing malicious PDF attachments impersonating tax invoices.',
        'findings' => [
            'Emails originated from spoofed domain fin-support-update.com.',
            'Payload attempts credential harvesting via embedded link.'
        ],
        'remediation_actions' => [
            'Block domain fin-support-update.com on perimeter gateway.',
            'Purge matching email messages from exchange mailboxes.'
        ],
        'artifacts' => [
            'phishing_sample_tax.eml',
            'credential_harvest_url.txt'
        ]
    ]
];

echo json_encode($reports);
