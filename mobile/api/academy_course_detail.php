<?php

require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/config.php';

$courseId = $_GET['id'] ?? 'crs_1';

$courseDetail = [
    'id' => $courseId,
    'title' => 'Digital Forensics Fundamentals',
    'description' => 'Learn the basics of digital evidence, acquisition, and analysis techniques.',
    'category' => 'Digital Forensics',
    'difficulty' => 'Beginner',
    'duration_minutes' => 150,
    'instructor_name' => 'Dr. Alex Vance',
    'thumbnail_url' => '',
    'prerequisites' => ['Basic OS Concepts', 'Command Line Proficiency'],
    'learning_outcomes' => [
        'Acquire disk and memory evidence safely',
        'Identify file system artifacts',
        'Analyze browser & system logs'
    ],
    'modules' => [
        [
            'id' => 'mod_1',
            'title' => 'Module 1: Forensics Core Concepts',
            'description' => 'Essential techniques for evidence handling.',
            'lessons' => [
                [
                    'id' => 'les_101',
                    'title' => 'Digital Forensics Acquisition Techniques',
                    'duration_minutes' => 20,
                    'content_type' => 'text',
                    'content_text' => 'Memory forensics is the analysis of an acquired memory dump from a physical machine.',
                    'image_url' => 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5',
                    'code_snippet' => 'python3 vol.py -f memory.raw windows.pslist',
                    'code_language' => 'bash',
                    'checklist' => [
                        [
                            'id' => 'chk_1',
                            'label' => 'Verify raw RAM image SHA256 checksum',
                            'is_checked' => true
                        ]
                    ],
                    'is_completed' => false,
                    'order' => 1,
                    'quiz_id' => 'qz_101'
                ]
            ],
            'order' => 1
        ]
    ],
    'is_enrolled' => true,
    'completion_percentage' => 0.75,
    'total_xp' => 500
];

echo json_encode($courseDetail);
