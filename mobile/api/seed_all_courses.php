<?php
/**
 * ForenShield — Comprehensive Academy Courses Seeder
 * Seeds all 6 core Cyber Academy courses, modules, lessons, and quizzes into Neon PostgreSQL.
 */

require_once __DIR__ . '/config.php';

echo "=== SEEDING ALL 6 ACADEMY COURSES ===\n";

try {
    $db = getDb();

    // 1. Ensure Quiz & Progress Tables Exist
    $db->exec("
        CREATE TABLE IF NOT EXISTS quizzes (
            id VARCHAR(50) PRIMARY KEY,
            lesson_id VARCHAR(50),
            title VARCHAR(255) NOT NULL,
            passing_score_percent INTEGER DEFAULT 70,
            xp_reward INTEGER DEFAULT 50,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS quiz_questions (
            id VARCHAR(50) PRIMARY KEY,
            quiz_id VARCHAR(50) REFERENCES quizzes(id) ON DELETE CASCADE,
            question_text TEXT NOT NULL,
            options JSONB NOT NULL,
            correct_option_index INTEGER NOT NULL,
            explanation TEXT,
            question_order INTEGER DEFAULT 0
        );

        CREATE TABLE IF NOT EXISTS user_quiz_attempts (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            quiz_id VARCHAR(50) REFERENCES quizzes(id) ON DELETE CASCADE,
            score_percent INTEGER NOT NULL,
            is_passed BOOLEAN NOT NULL,
            answers_submitted JSONB,
            xp_awarded INTEGER DEFAULT 0,
            attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS user_course_progress (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            course_id VARCHAR(50) REFERENCES courses(id) ON DELETE CASCADE,
            is_enrolled BOOLEAN DEFAULT FALSE,
            completion_percentage NUMERIC(5, 2) DEFAULT 0.0,
            enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            completed_at TIMESTAMP,
            UNIQUE(user_id, course_id)
        );

        CREATE TABLE IF NOT EXISTS user_lesson_progress (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            lesson_id VARCHAR(50) REFERENCES lessons(id) ON DELETE CASCADE,
            is_completed BOOLEAN DEFAULT FALSE,
            completed_at TIMESTAMP,
            UNIQUE(user_id, lesson_id)
        );
    ");
    echo "[✓] Schema tables verified.\n";

    // 2. Define All 6 Courses
    $courses = [
        [
            'id' => 'crs_1',
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
                'Analyze browser & system logs',
            ],
            'total_xp' => 500,
        ],
        [
            'id' => 'crs_2',
            'title' => 'Malware Analysis Essentials',
            'description' => 'Understand malware behavior, static & dynamic analysis and reverse engineering.',
            'category' => 'Malware Analysis',
            'difficulty' => 'Intermediate',
            'duration_minutes' => 190,
            'instructor_name' => 'Elena Rostova',
            'thumbnail_url' => '',
            'prerequisites' => ['Assembly Basics', 'C Programming'],
            'learning_outcomes' => [
                'Static PE header analysis',
                'Dynamic sandbox behavior tracking',
                'Decompiling binaries with Ghidra',
            ],
            'total_xp' => 650,
        ],
        [
            'id' => 'crs_3',
            'title' => 'Phishing Detection & Prevention',
            'description' => 'Identify phishing attacks, analyze techniques and stay protected.',
            'category' => 'Phishing Detection',
            'difficulty' => 'Intermediate',
            'duration_minutes' => 140,
            'instructor_name' => 'Marcus Thorne',
            'thumbnail_url' => '',
            'prerequisites' => ['Email Protocols', 'SPF/DKIM/DMARC Basics'],
            'learning_outcomes' => [
                'Analyze email headers & MIME structures',
                'Extract suspicious URLs & attachments',
                'Implement defense rules',
            ],
            'total_xp' => 450,
        ],
        [
            'id' => 'crs_4',
            'title' => 'Network Security Fundamentals',
            'description' => 'Learn networking concepts, common vulnerabilities and defense strategies.',
            'category' => 'Network Security',
            'difficulty' => 'Beginner',
            'duration_minutes' => 200,
            'instructor_name' => 'Sarah Jenkins',
            'thumbnail_url' => '',
            'prerequisites' => ['TCP/IP Fundamentals'],
            'learning_outcomes' => [
                'Configure firewalls & IDS/IPS',
                'Analyze Wireshark PCAP files',
                'Detect scanning & intrusion attempts',
            ],
            'total_xp' => 550,
        ],
        [
            'id' => 'crs_5',
            'title' => 'Linux Forensics',
            'description' => 'Master Linux systems, logs, artifacts and forensic techniques.',
            'category' => 'Linux Forensics',
            'difficulty' => 'Intermediate',
            'duration_minutes' => 250,
            'instructor_name' => 'David Miller',
            'thumbnail_url' => '',
            'prerequisites' => ['Linux CLI Mastery', 'Bash Scripting'],
            'learning_outcomes' => [
                'Inspect systemd journal logs & auth.log',
                'Analyze persistence mechanisms in cron',
                'Audit user activity & bash history',
            ],
            'total_xp' => 700,
        ],
        [
            'id' => 'crs_6',
            'title' => 'Mobile Forensics',
            'description' => 'Extract, analyze and interpret data from mobile devices.',
            'category' => 'Mobile Forensics',
            'difficulty' => 'Intermediate',
            'duration_minutes' => 220,
            'instructor_name' => 'Amara Chen',
            'thumbnail_url' => '',
            'prerequisites' => ['Android/iOS Architecture Basics'],
            'learning_outcomes' => [
                'Extract SQLite databases from app data',
                'Analyze location & communication artifacts',
                'Decode backup files & keychain items',
            ],
            'total_xp' => 600,
        ],
    ];

    $stmtCourse = $db->prepare("
        INSERT INTO courses (id, title, description, category, difficulty, duration_minutes, instructor_name, thumbnail_url, prerequisites, learning_outcomes, total_xp)
        VALUES (:id, :title, :description, :category, :difficulty, :duration_minutes, :instructor_name, :thumbnail_url, :prerequisites, :learning_outcomes, :total_xp)
        ON CONFLICT (id) DO UPDATE SET
            title = EXCLUDED.title,
            description = EXCLUDED.description,
            category = EXCLUDED.category,
            difficulty = EXCLUDED.difficulty,
            duration_minutes = EXCLUDED.duration_minutes,
            instructor_name = EXCLUDED.instructor_name,
            prerequisites = EXCLUDED.prerequisites,
            learning_outcomes = EXCLUDED.learning_outcomes,
            total_xp = EXCLUDED.total_xp
    ");

    foreach ($courses as $c) {
        $stmtCourse->execute([
            'id' => $c['id'],
            'title' => $c['title'],
            'description' => $c['description'],
            'category' => $c['category'],
            'difficulty' => $c['difficulty'],
            'duration_minutes' => $c['duration_minutes'],
            'instructor_name' => $c['instructor_name'],
            'thumbnail_url' => $c['thumbnail_url'],
            'prerequisites' => json_encode($c['prerequisites']),
            'learning_outcomes' => json_encode($c['learning_outcomes']),
            'total_xp' => $c['total_xp'],
        ]);
        echo "  [+] Seeded Course: {$c['id']} — {$c['title']}\n";
    }

    // 3. Seed Modules and Lessons for Each Course
    $modules = [
        // crs_1
        ['id' => 'mod_1', 'course_id' => 'crs_1', 'title' => 'Module 1: Forensics Core Concepts', 'description' => 'Essential evidence acquisition techniques.', 'order' => 1],
        ['id' => 'mod_2', 'course_id' => 'crs_1', 'title' => 'Module 2: File System Artifacts', 'description' => 'NTFS, EXT4, and master file table inspection.', 'order' => 2],
        
        // crs_2
        ['id' => 'mod_201', 'course_id' => 'crs_2', 'title' => 'Module 1: Static Analysis', 'description' => 'Deconstructing PE headers and string extraction.', 'order' => 1],
        ['id' => 'mod_202', 'course_id' => 'crs_2', 'title' => 'Module 2: Dynamic Analysis', 'description' => 'Executing malware in isolated sandbox environments.', 'order' => 2],
        
        // crs_3
        ['id' => 'mod_301', 'course_id' => 'crs_3', 'title' => 'Module 1: Email Headers & Protocols', 'description' => 'Inspecting SMTP, SPF, DKIM, and DMARC alignments.', 'order' => 1],
        ['id' => 'mod_302', 'course_id' => 'crs_3', 'title' => 'Module 2: Malicious Payload Analysis', 'description' => 'Deobfuscating suspicious URLs and macros.', 'order' => 2],

        // crs_4
        ['id' => 'mod_401', 'course_id' => 'crs_4', 'title' => 'Module 1: TCP/IP & Packet Analysis', 'description' => 'Dissecting network traffic using Wireshark.', 'order' => 1],
        ['id' => 'mod_402', 'course_id' => 'crs_4', 'title' => 'Module 2: Intrusion Detection Rules', 'description' => 'Writing Snort and Suricata alert signatures.', 'order' => 2],

        // crs_5
        ['id' => 'mod_501', 'course_id' => 'crs_5', 'title' => 'Module 1: Linux Storage & ProcFS', 'description' => 'Investigating virtual file systems and logs.', 'order' => 1],
        ['id' => 'mod_502', 'course_id' => 'crs_5', 'title' => 'Module 2: Persistence Mechanisms', 'description' => 'Detecting cron jobs, systemd units, and bashrc traps.', 'order' => 2],

        // crs_6
        ['id' => 'mod_601', 'course_id' => 'crs_6', 'title' => 'Module 1: Mobile OS Architecture', 'description' => 'Understanding Android & iOS security models.', 'order' => 1],
        ['id' => 'mod_602', 'course_id' => 'crs_6', 'title' => 'Module 2: App Database Forensics', 'description' => 'Parsing SQLite databases, WAL files, and plist items.', 'order' => 2],
    ];

    $stmtMod = $db->prepare("
        INSERT INTO course_modules (id, course_id, title, description, module_order)
        VALUES (:id, :course_id, :title, :description, :order)
        ON CONFLICT (id) DO UPDATE SET
            title = EXCLUDED.title,
            description = EXCLUDED.description,
            module_order = EXCLUDED.module_order
    ");

    foreach ($modules as $m) {
        $stmtMod->execute([
            'id' => $m['id'],
            'course_id' => $m['course_id'],
            'title' => $m['title'],
            'description' => $m['description'],
            'order' => $m['order'],
        ]);
    }
    echo "[✓] Seeded " . count($modules) . " course modules.\n";

    // 4. Seed Lessons
    $lessons = [
        [
            'id' => 'les_101', 'module_id' => 'mod_1', 'title' => 'Digital Forensics Acquisition Techniques',
            'duration' => 20, 'type' => 'text',
            'content' => 'Memory forensics is the analysis of an acquired volatile memory dump to uncover rootkits and injected DLLs.',
            'code_snippet' => 'vol -f memory.raw windows.pslist --pid 4120',
            'code_language' => 'bash',
            'quiz_id' => 'qz_101', 'order' => 1
        ],
        [
            'id' => 'les_102', 'module_id' => 'mod_2', 'title' => 'NTFS $MFT & UsnJrnl Artifacts',
            'duration' => 25, 'type' => 'text',
            'content' => 'The Master File Table ($MFT) and Update Sequence Number Journal ($UsnJrnl) preserve timestamps and deletion traces.',
            'code_snippet' => 'MFTECmd.exe -f C:\$MFT --csv C:\out --csvf mft_parsed.csv',
            'code_language' => 'powershell',
            'quiz_id' => 'qz_102', 'order' => 1
        ],
        [
            'id' => 'les_201', 'module_id' => 'mod_201', 'title' => 'Static PE Header & Import Table Triage',
            'duration' => 25, 'type' => 'text',
            'content' => 'Examining Portable Executable (PE) headers reveals suspicious imported DLLs like VirtualAlloc and WriteProcessMemory.',
            'code_snippet' => 'objdump -p sample.exe | grep -iE "(DLL Name|VirtualAlloc|WriteProcess)"',
            'code_language' => 'bash',
            'quiz_id' => 'qz_201', 'order' => 1
        ],
        [
            'id' => 'les_202', 'module_id' => 'mod_202', 'title' => 'Behavioral Analysis in Cuckoo Sandbox',
            'duration' => 30, 'type' => 'text',
            'content' => 'Monitoring registry modifications, outbound socket connections, and process hollowing in a safe hypervisor sandbox.',
            'code_snippet' => 'cuckoo submit --package exe /samples/trojan_dropper.bin',
            'code_language' => 'bash',
            'quiz_id' => null, 'order' => 1
        ],
        [
            'id' => 'les_301', 'module_id' => 'mod_301', 'title' => 'Analyzing Phishing Email Headers',
            'duration' => 20, 'type' => 'text',
            'content' => 'Trace the Received: header hops and verify Authentication-Results for SPF, DKIM, and DMARC alignment status.',
            'code_snippet' => 'grep -iE "^(Received|Authentication-Results|DKIM-Signature):" sample.eml',
            'code_language' => 'bash',
            'quiz_id' => 'qz_301', 'order' => 1
        ],
        [
            'id' => 'les_302', 'module_id' => 'mod_302', 'title' => 'Detecting Obfuscated Malicious Links',
            'duration' => 25, 'type' => 'text',
            'content' => 'Attackers use open redirects, URL shorteners, and Punycode homograph domain spoofing to deceive email gateways.',
            'code_snippet' => 'python3 -m oledump malicious_invoice.docm -s 7 -v',
            'code_language' => 'python',
            'quiz_id' => null, 'order' => 1
        ],
        [
            'id' => 'les_401', 'module_id' => 'mod_401', 'title' => 'Wireshark PCAP Packet Triage',
            'duration' => 30, 'type' => 'text',
            'content' => 'Follow TCP streams and filter for suspicious DNS tunneling queries or unencrypted credentials across HTTP payloads.',
            'code_snippet' => 'tshark -r capture.pcap -Y "dns.flags.response == 0" -T fields -e dns.qry.name',
            'code_language' => 'bash',
            'quiz_id' => 'qz_401', 'order' => 1
        ],
        [
            'id' => 'les_402', 'module_id' => 'mod_402', 'title' => 'Writing IDS Alerts with Snort',
            'duration' => 25, 'type' => 'text',
            'content' => 'Craft alert tcp any any -> any 80 (msg:"Suspicious Web Shell"; content:"cmd.exe"; sid:100001;).',
            'code_snippet' => 'alert tcp any any -> any 80 (msg:"Suspicious Web Shell"; content:"cmd.exe"; sid:100001;)',
            'code_language' => 'bash',
            'quiz_id' => null, 'order' => 1
        ],
        [
            'id' => 'les_501', 'module_id' => 'mod_501', 'title' => 'Linux ProcFS & Volatile Inspection',
            'duration' => 25, 'type' => 'text',
            'content' => 'Analyze /proc/<pid>/exe symlinks and /proc/<pid>/fd descriptors to uncover deleted malicious binaries running in RAM.',
            'code_snippet' => 'ls -la /proc/*/exe 2>/dev/null | grep "(deleted)"',
            'code_language' => 'bash',
            'quiz_id' => 'qz_501', 'order' => 1
        ],
        [
            'id' => 'les_502', 'module_id' => 'mod_502', 'title' => 'Hunting Persistence in /etc/cron.*',
            'duration' => 25, 'type' => 'text',
            'content' => 'Inspect crontab schedules, anacron tables, and user-level ~/.bash_profile modifications.',
            'code_snippet' => 'crontab -l; cat /etc/crontab /etc/cron.*/* 2>/dev/null',
            'code_language' => 'bash',
            'quiz_id' => null, 'order' => 1
        ],
        [
            'id' => 'les_601', 'module_id' => 'mod_601', 'title' => 'Mobile File Systems & Sandboxing',
            'duration' => 25, 'type' => 'text',
            'content' => 'Android uses UID-based kernel sandboxing while iOS employs App Containers and signed provisioning profiles.',
            'code_snippet' => 'adb shell pm list packages -f -3 | cut -d= -f2',
            'code_language' => 'bash',
            'quiz_id' => 'qz_601', 'order' => 1
        ],
        [
            'id' => 'les_602', 'module_id' => 'mod_602', 'title' => 'Extracting SQLite Chat Databases',
            'duration' => 30, 'type' => 'text',
            'content' => 'Querying messages.db and wal (write-ahead log) files to recover deleted timestamped chat conversations.',
            'code_snippet' => 'sqlite3 messages.db "SELECT datetime(date/1000000000 + 978307200, \'unixepoch\'), text FROM message;"',
            'code_language' => 'sql',
            'quiz_id' => null, 'order' => 1
        ],
    ];

    $stmtLes = $db->prepare("
        INSERT INTO lessons (id, module_id, title, duration_minutes, content_type, content_text, code_snippet, code_language, lesson_order, quiz_id)
        VALUES (:id, :module_id, :title, :duration, :type, :content, :code_snippet, :code_language, :order, :quiz_id)
        ON CONFLICT (id) DO UPDATE SET
            title = EXCLUDED.title,
            duration_minutes = EXCLUDED.duration_minutes,
            content_type = EXCLUDED.content_type,
            content_text = EXCLUDED.content_text,
            code_snippet = EXCLUDED.code_snippet,
            code_language = EXCLUDED.code_language,
            lesson_order = EXCLUDED.lesson_order,
            quiz_id = EXCLUDED.quiz_id
    ");

    foreach ($lessons as $l) {
        $stmtLes->execute([
            'id' => $l['id'],
            'module_id' => $l['module_id'],
            'title' => $l['title'],
            'duration' => $l['duration'],
            'type' => $l['type'],
            'content' => $l['content'],
            'code_snippet' => $l['code_snippet'] ?? null,
            'code_language' => $l['code_language'] ?? null,
            'order' => $l['order'],
            'quiz_id' => $l['quiz_id'],
        ]);
    }
    echo "[✓] Seeded " . count($lessons) . " lessons.\n";

    // 5. Seed Quizzes and Questions
    $quizzes = [
        ['id' => 'qz_101', 'lesson_id' => 'les_101', 'title' => 'Digital Forensics Acquisition Quiz', 'passing' => 70, 'xp' => 50],
        ['id' => 'qz_102', 'lesson_id' => 'les_102', 'title' => 'File System Analysis Quiz', 'passing' => 70, 'xp' => 50],
        ['id' => 'qz_201', 'lesson_id' => 'les_201', 'title' => 'Static Malware Analysis Quiz', 'passing' => 70, 'xp' => 50],
        ['id' => 'qz_301', 'lesson_id' => 'les_301', 'title' => 'Email Authentication & Phishing Quiz', 'passing' => 70, 'xp' => 50],
        ['id' => 'qz_401', 'lesson_id' => 'les_401', 'title' => 'Network Traffic Analysis Quiz', 'passing' => 70, 'xp' => 50],
        ['id' => 'qz_501', 'lesson_id' => 'les_501', 'title' => 'Linux Forensics Quiz', 'passing' => 70, 'xp' => 50],
        ['id' => 'qz_601', 'lesson_id' => 'les_601', 'title' => 'Mobile Security & Extractions Quiz', 'passing' => 70, 'xp' => 50],
    ];

    $stmtQz = $db->prepare("
        INSERT INTO quizzes (id, lesson_id, title, passing_score_percent, xp_reward)
        VALUES (:id, :lesson_id, :title, :passing, :xp)
        ON CONFLICT (id) DO UPDATE SET
            title = EXCLUDED.title,
            passing_score_percent = EXCLUDED.passing_score_percent,
            xp_reward = EXCLUDED.xp_reward
    ");

    foreach ($quizzes as $q) {
        $stmtQz->execute([
            'id' => $q['id'],
            'lesson_id' => $q['lesson_id'],
            'title' => $q['title'],
            'passing' => $q['passing'],
            'xp' => $q['xp'],
        ]);
    }

    $questions = [
        ['id' => 'qq_1', 'quiz_id' => 'qz_101', 'q' => 'Which tool is primarily used for memory forensics on Windows systems?', 'opts' => ['Wireshark', 'Volatility 3', 'Burp Suite', 'Nmap'], 'ans' => 1, 'exp' => 'Volatility 3 is the standard memory forensics framework.'],
        ['id' => 'qq_2', 'quiz_id' => 'qz_101', 'q' => 'What does the SHA256 hash of a memory image primarily verify?', 'opts' => ['File compression', 'Evidence integrity', 'Encryption strength', 'Network speed'], 'ans' => 1, 'exp' => 'SHA256 verifies evidence integrity and chain of custody.'],
        ['id' => 'qq_3', 'quiz_id' => 'qz_101', 'q' => 'Which Volatility plugin lists active processes on Windows?', 'opts' => ['windows.netscan', 'windows.pslist', 'windows.dlllist', 'windows.malfind'], 'ans' => 1, 'exp' => 'windows.pslist enumerates active processes.'],

        ['id' => 'qq_201', 'quiz_id' => 'qz_201', 'q' => 'What is the standard format for executable binaries in Windows?', 'opts' => ['ELF', 'Mach-O', 'PE (Portable Executable)', 'APK'], 'ans' => 2, 'exp' => 'Windows uses the Portable Executable (PE) file format.'],
        ['id' => 'qq_301', 'quiz_id' => 'qz_301', 'q' => 'Which DNS record specifies mail servers authorized to send email on behalf of a domain?', 'opts' => ['SPF (Sender Policy Framework)', 'PTR', 'MX', 'CNAME'], 'ans' => 0, 'exp' => 'SPF TXT records declare authorized sending mail servers.'],
        ['id' => 'qq_401', 'quiz_id' => 'qz_401', 'q' => 'What is the default TCP handshake sequence?', 'opts' => ['ACK, SYN, SYN-ACK', 'SYN, SYN-ACK, ACK', 'FIN, ACK, RST', 'SYN, ACK, PSH'], 'ans' => 1, 'exp' => 'TCP uses SYN -> SYN-ACK -> ACK three-way handshake.'],
        ['id' => 'qq_501', 'quiz_id' => 'qz_501', 'q' => 'Where are system authorization logs typically stored on Debian/Ubuntu?', 'opts' => ['/var/log/syslog', '/var/log/auth.log', '/etc/shadow', '/proc/kmsg'], 'ans' => 1, 'exp' => '/var/log/auth.log records authentication attempts.'],
        ['id' => 'qq_601', 'quiz_id' => 'qz_601', 'q' => 'What type of mobile extraction accesses deleted records via raw bitstream image?', 'opts' => ['Logical Extraction', 'Physical Extraction', 'Cloud Backup', 'ADB Backup'], 'ans' => 1, 'exp' => 'Physical extraction captures a raw flash image including unallocated space.'],
    ];

    $stmtQq = $db->prepare("
        INSERT INTO quiz_questions (id, quiz_id, question_text, options, correct_option_index, explanation, question_order)
        VALUES (:id, :quiz_id, :q, :opts, :ans, :exp, 1)
        ON CONFLICT (id) DO UPDATE SET
            question_text = EXCLUDED.question_text,
            options = EXCLUDED.options,
            correct_option_index = EXCLUDED.correct_option_index,
            explanation = EXCLUDED.explanation
    ");

    foreach ($questions as $qq) {
        $stmtQq->execute([
            'id' => $qq['id'],
            'quiz_id' => $qq['quiz_id'],
            'q' => $qq['q'],
            'opts' => json_encode($qq['opts']),
            'ans' => $qq['ans'],
            'exp' => $qq['exp'],
        ]);
    }
    echo "[✓] Seeded " . count($quizzes) . " quizzes and " . count($questions) . " questions.\n";

    echo "\n=== ALL 6 COURSES SUCCESSFULLY RESTORED IN NEON DB ===\n";

} catch (Throwable $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString() . "\n";
}
