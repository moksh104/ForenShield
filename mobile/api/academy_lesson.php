<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

$lessonId = $_GET['id'] ?? 'les_101';

$lesson = [
    'id' => $lessonId,
    'title' => 'Digital Forensics Acquisition Techniques',
    'duration_minutes' => 20,
    'content_type' => 'text',
    'content_text' => 'Memory forensics is the analysis of an acquired memory dump from a physical machine. When investigating an active C2 infection, RAM artifacts contain unencrypted network sockets, injected DLLs, and plaintext credentials.',
    'image_url' => 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5',
    'code_snippet' => "python3 vol.py -f memory.raw windows.pslist\npython3 vol.py -f memory.raw windows.netscan",
    'code_language' => 'bash',
    'checklist' => [
        [
            'id' => 'chk_1',
            'label' => 'Verify raw RAM image SHA256 checksum',
            'is_checked' => true
        ],
        [
            'id' => 'chk_2',
            'label' => 'Identify suspicious PID from netscan output',
            'is_checked' => false
        ]
    ],
    'is_completed' => false,
    'order' => 1,
    'quiz_id' => 'qz_101'
];

echo json_encode($lesson);
