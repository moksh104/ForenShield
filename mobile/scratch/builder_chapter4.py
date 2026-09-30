import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from report_utils import (
    FONT_NAME, BLACK,
    add_heading_1, add_heading_2, add_heading_3,
    add_para, add_bullet, add_caption,
    set_cell_margins, set_cell_shading, set_table_borders, format_row
)

def build_table_dictionary(doc, tbl_number, tbl_name, purpose_text, columns):
    p_t = doc.add_paragraph()
    p_t.paragraph_format.space_before = Pt(12)
    p_t.paragraph_format.space_after = Pt(3)
    p_t.paragraph_format.keep_with_next = True
    r = p_t.add_run(f"Table 4.{tbl_number}: Data Dictionary for '{tbl_name}'")
    r.font.name = FONT_NAME
    r.font.size = Pt(11)
    r.font.bold = True
    r.font.color.rgb = BLACK
    
    add_para(doc, purpose_text, bold_prefix="Table Purpose: ", space_after=4)
    
    # Table header: Field Name, Data Type, Nullable / Size, Constraint, Description
    table_data = [("Field Name", "Data Type", "Size / Nullable", "Constraint / Key", "Description")] + columns
    
    t = doc.add_table(rows=len(table_data), cols=5)
    t.alignment = WD_TABLE_ALIGNMENT.CENTER
    t.autofit = False
    
    col_w = [Inches(1.4), Inches(1.1), Inches(1.1), Inches(1.3), Inches(2.2)]
    for row in t.rows:
        for c_idx, w in enumerate(col_w):
            row.cells[c_idx].width = w
            
    set_table_borders(t, color="000000", sz="4", val="single")
    
    for r_idx, row_data in enumerate(table_data):
        row = t.rows[r_idx]
        is_hdr = (r_idx == 0)
        bg = "D9D9D9" if is_hdr else "FFFFFF"
        for c_idx, val in enumerate(row_data):
            p = row.cells[c_idx].paragraphs[0]
            p.text = val
        format_row(row, is_header=is_hdr, bg_color=bg)
        
    p_sp = doc.add_paragraph()
    p_sp.paragraph_format.space_before = Pt(4)
    p_sp.paragraph_format.space_after = Pt(4)

def build_chapter_4(doc):
    add_heading_1(doc, "CHAPTER 4 – DATA DICTIONARY")
    
    add_para(
        doc,
        "A data dictionary is a centralized repository of metadata detailing the structural definitions, data types, "
        "nullability constraints, keys, relationships, and operational semantics of all database tables within an "
        "application. ForenShield utilizes an enterprise-grade PostgreSQL relational database hosted on the Neon cloud "
        "platform. The schema comprises 27 normalized relational tables designed to ensure referential integrity, prevent "
        "redundancy, support rapid query indexing, and uphold ACID transactional guarantees."
    )
    add_para(
        doc,
        "The following sections present the exhaustive data dictionary for all database entities grouped across functional subsystems:"
    )
    
    # ----------------------------------------------------
    # 4.1 AUTHENTICATION & SESSION TABLES
    # ----------------------------------------------------
    add_heading_2(doc, "4.1 Authentication & User Session Tables")
    
    # 1. users
    build_table_dictionary(
        doc, 1, "users",
        "Stores the foundational profile, credentials, and notification registration data for each student or administrator.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique auto-incrementing integer identifier for the user account."),
            ("full_name", "VARCHAR", "100 / NOT NULL", "None", "Full legal name of the registered student."),
            ("email", "VARCHAR", "100 / NOT NULL", "UNIQUE, INDEX", "Unique email address utilized for login authentication and recovery."),
            ("phone", "VARCHAR", "20 / NULL", "None", "Optional contact phone number of the student."),
            ("password_hash", "TEXT", "Variable / NOT NULL", "None", "Bcrypt cryptographic hash (work factor 10) of the user password."),
            ("avatar_url", "TEXT", "Variable / NULL", "None", "HTTPS URL pointing to user profile image hosted on Cloudinary CDN."),
            ("fcm_token", "TEXT", "Variable / NULL", "None", "Firebase Cloud Messaging device token for push notification delivery."),
            ("created_at", "TIMESTAMPTZ", "8 Bytes / DEFAULT NOW()", "None", "Timestamp recording the account registration moment."),
            ("updated_at", "TIMESTAMPTZ", "8 Bytes / DEFAULT NOW()", "None", "Timestamp recording the most recent profile modification."),
        ]
    )
    
    # 2. otp_codes
    build_table_dictionary(
        doc, 2, "otp_codes",
        "Manages time-limited One-Time Password (OTP) verification tokens for email verification and secure password reset workflows.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the OTP issuance event."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the associated user account."),
            ("otp_code", "VARCHAR", "6 / NOT NULL", "INDEX (lookup)", "Cryptographically generated 6-digit numeric verification code."),
            ("expires_at", "TIMESTAMPTZ", "8 Bytes / NOT NULL", "None", "Expiration timestamp, strictly enforcing a 10-minute validity window."),
            ("created_at", "TIMESTAMPTZ", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when the OTP was generated and dispatched."),
        ]
    )
    
    # 3. refresh_tokens
    build_table_dictionary(
        doc, 3, "refresh_tokens",
        "Stores cryptographically generated refresh tokens used to maintain stateless, long-lived authenticated client sessions safely.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the refresh token record."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the authenticated user account."),
            ("refresh_token", "TEXT", "Variable / NOT NULL", "UNIQUE", "Cryptographically secure random 256-bit token string."),
            ("created_at", "TIMESTAMPTZ", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when the refresh token was issued by the backend."),
        ]
    )
    
    # ----------------------------------------------------
    # 4.2 CYBER ACADEMY TABLES
    # ----------------------------------------------------
    add_heading_2(doc, "4.2 Cyber Academy & Learning Management Tables")
    
    # 4. courses
    build_table_dictionary(
        doc, 4, "courses",
        "Defines cybersecurity courses available in the Cyber Academy, containing syllabus overview and metadata.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the educational course."),
            ("title", "VARCHAR", "255 / NOT NULL", "None", "Descriptive course title (e.g., 'Network Security Fundamentals')."),
            ("description", "TEXT", "Variable / NULL", "None", "Comprehensive summary of topics, objectives, and prerequisites."),
            ("difficulty", "VARCHAR", "50 / NOT NULL", "None", "Skill level classification: 'Beginner', 'Intermediate', 'Advanced'."),
            ("category", "VARCHAR", "100 / NOT NULL", "None", "Topic category: 'Network Security', 'Web Defense', 'Forensics'."),
            ("duration_minutes", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Estimated total time in minutes to complete all modules."),
            ("xp_reward", "INTEGER", "4 Bytes / DEFAULT 100", "None", "Bonus experience points awarded upon full course completion."),
            ("is_published", "BOOLEAN", "1 Byte / DEFAULT TRUE", "None", "Visibility flag indicating if course is active in catalog."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 5. course_modules
    build_table_dictionary(
        doc, 5, "course_modules",
        "Represents individual structured learning chapters or units within a parent course.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the course module."),
            ("course_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (courses.id) ON DELETE CASCADE", "Reference to the owning course entity."),
            ("title", "VARCHAR", "255 / NOT NULL", "None", "Title of the module (e.g., 'Understanding Packet Sniffing')."),
            ("description", "TEXT", "Variable / NULL", "None", "Overview of concepts addressed in this unit."),
            ("order_index", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Sequential display ordering within the course curriculum."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 6. lessons
    build_table_dictionary(
        doc, 6, "lessons",
        "Contains the actual instructional content, markdown readings, code examples, and key takeaways for a module.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the instructional lesson."),
            ("module_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (course_modules.id) ON DELETE CASCADE", "Reference to the parent module."),
            ("title", "VARCHAR", "255 / NOT NULL", "None", "Descriptive lesson title."),
            ("content", "TEXT", "Variable / NOT NULL", "None", "Rich markdown content including theoretical concepts and syntax."),
            ("duration_minutes", "INTEGER", "4 Bytes / DEFAULT 5", "None", "Estimated reading time in minutes."),
            ("order_index", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Sequential lesson order within the module."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 7. user_course_progress
    build_table_dictionary(
        doc, 7, "user_course_progress",
        "Tracks overall course enrollment, percentage completion, and certification status per student.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the course progress record."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the student."),
            ("course_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (courses.id) ON DELETE CASCADE", "Reference to the enrolled course."),
            ("status", "VARCHAR", "50 / DEFAULT 'in_progress'", "None", "State: 'enrolled', 'in_progress', 'completed'."),
            ("progress_percentage", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Calculated completion metric from 0 to 100%."),
            ("completed_at", "TIMESTAMP", "8 Bytes / NULL", "None", "Timestamp when all course requirements were satisfied."),
        ]
    )
    
    # 8. user_lesson_progress
    build_table_dictionary(
        doc, 8, "user_lesson_progress",
        "Maintains granular completion states for each individual lesson reviewed by a student.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the lesson progress entry."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the student."),
            ("lesson_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (lessons.id) ON DELETE CASCADE", "Reference to the specific lesson."),
            ("is_completed", "BOOLEAN", "1 Byte / DEFAULT FALSE", "None", "Flag denoting whether the student finished reading the lesson."),
            ("completed_at", "TIMESTAMP", "8 Bytes / NULL", "None", "Timestamp when lesson was marked complete."),
        ]
    )
    
    # 9. quizzes
    build_table_dictionary(
        doc, 9, "quizzes",
        "Defines formative knowledge evaluation tests linked to modules or entire courses.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the quiz."),
            ("course_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (courses.id) ON DELETE CASCADE", "Reference to the associated course."),
            ("title", "VARCHAR", "255 / NOT NULL", "None", "Descriptive quiz title (e.g., 'Network Protocols Mastery Quiz')."),
            ("passing_score", "INTEGER", "4 Bytes / DEFAULT 70", "None", "Minimum percentage score required to pass and earn XP."),
            ("xp_reward", "INTEGER", "4 Bytes / DEFAULT 50", "None", "Experience points awarded upon passing."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 10. quiz_questions
    build_table_dictionary(
        doc, 10, "quiz_questions",
        "Stores multiple-choice questions, option arrays, correct answers, and educational explanations.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the question."),
            ("quiz_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (quizzes.id) ON DELETE CASCADE", "Reference to the parent quiz."),
            ("question_text", "TEXT", "Variable / NOT NULL", "None", "The question prompt presented to the user."),
            ("options", "JSONB / TEXT", "Variable / NOT NULL", "None", "JSON-encoded array of 4 multiple-choice options."),
            ("correct_answer", "VARCHAR", "255 / NOT NULL", "None", "The exact correct option string or index."),
            ("explanation", "TEXT", "Variable / NULL", "None", "Educational rationale explaining why the answer is correct."),
        ]
    )
    
    # 11. user_quiz_attempts
    build_table_dictionary(
        doc, 11, "user_quiz_attempts",
        "Logs every quiz submission attempt, recorded score, pass/fail status, and timestamp.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the quiz attempt."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the student."),
            ("quiz_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (quizzes.id) ON DELETE CASCADE", "Reference to the quiz attempted."),
            ("score", "INTEGER", "4 Bytes / NOT NULL", "None", "Achieved score percentage (0–100)."),
            ("passed", "BOOLEAN", "1 Byte / NOT NULL", "None", "Boolean flag indicating if score ≥ passing_score."),
            ("attempted_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when attempt was submitted."),
        ]
    )
    
    # ----------------------------------------------------
    # 4.3 DIGITAL INVESTIGATION LAB TABLES
    # ----------------------------------------------------
    add_heading_2(doc, "4.3 Digital Investigation Lab Tables")
    
    # 12. cases
    build_table_dictionary(
        doc, 12, "cases",
        "Stores realistic digital forensic cases, containing background briefings, incident details, and difficulty ratings.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the investigation case."),
            ("title", "VARCHAR", "255 / NOT NULL", "None", "Case title (e.g., 'Operation Shadow Leak – Corporate Data Breach')."),
            ("description", "TEXT", "Variable / NOT NULL", "None", "Comprehensive narrative overview of the alleged cybercrime."),
            ("difficulty", "VARCHAR", "50 / NOT NULL", "None", "Difficulty level: 'Beginner', 'Intermediate', 'Advanced'."),
            ("category", "VARCHAR", "100 / NOT NULL", "None", "Case category: 'Ransomware', 'Insider Threat', 'Phishing', 'Data Theft'."),
            ("xp_reward", "INTEGER", "4 Bytes / DEFAULT 200", "None", "Bonus experience points granted upon successful resolution."),
            ("status", "VARCHAR", "50 / DEFAULT 'active'", "None", "Operational state: 'active', 'archived'."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 13. evidence
    build_table_dictionary(
        doc, 13, "evidence",
        "Catalogs digital evidence items linked to an investigation case (e.g., server logs, PCAP dumps, email headers, disk files).",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the evidence artifact."),
            ("case_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (cases.id) ON DELETE CASCADE", "Reference to the parent forensic case."),
            ("title", "VARCHAR", "255 / NOT NULL", "None", "Name of artifact (e.g., 'Apache Access Log - 2026-08-14')."),
            ("type", "VARCHAR", "50 / NOT NULL", "None", "Artifact classification: 'log', 'pcap', 'email', 'image', 'disk_dump'."),
            ("file_url", "TEXT", "Variable / NULL", "None", "URL to downloadable/viewable artifact file."),
            ("metadata", "JSONB / TEXT", "Variable / NULL", "None", "Extracted metadata: SHA-256 hash, file size, timestamps, IP addresses."),
            ("description", "TEXT", "Variable / NULL", "None", "Forensic context explaining the acquisition source of this item."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 14. case_timeline
    build_table_dictionary(
        doc, 14, "case_timeline",
        "Maintains chronological event logs and incident milestones that students analyze to reconstruct the attack sequence.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the timeline milestone."),
            ("case_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (cases.id) ON DELETE CASCADE", "Reference to the associated case."),
            ("event_time", "TIMESTAMP", "8 Bytes / NOT NULL", "None", "Simulated historical timestamp when the cyber incident occurred."),
            ("description", "TEXT", "Variable / NOT NULL", "None", "Detailed description of the observed event (e.g., 'Unauthorized SSH login')."),
            ("source", "VARCHAR", "100 / NULL", "None", "System source reporting the event (e.g., 'Firewall_01', 'Auth_Daemon')."),
            ("severity", "VARCHAR", "50 / DEFAULT 'info'", "None", "Event severity: 'low', 'medium', 'high', 'critical'."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 15. verdicts
    build_table_dictionary(
        doc, 15, "verdicts",
        "Defines the authoritative ground-truth findings and rubric used by the system to evaluate student case submissions.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the ground-truth verdict definition."),
            ("case_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (cases.id) ON DELETE CASCADE", "Reference to the evaluated case."),
            ("correct_suspect", "VARCHAR", "255 / NOT NULL", "None", "Authoritative identification of culprit or threat group."),
            ("correct_vector", "VARCHAR", "255 / NOT NULL", "None", "Authoritative initial access vector (e.g., 'Spear-Phishing Credential Theft')."),
            ("key_evidence_ids", "TEXT", "Variable / NOT NULL", "None", "Comma-delimited or JSON list of mandatory evidence artifact IDs."),
            ("solution_notes", "TEXT", "Variable / NOT NULL", "None", "Comprehensive forensic explanation detailing how the incident unfolded."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 16. user_case_progress
    build_table_dictionary(
        doc, 16, "user_case_progress",
        "Maintains student investigation lifecycle states, evidence collected, and verdict submission scores.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for student case progress."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the student."),
            ("case_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (cases.id) ON DELETE CASCADE", "Reference to the investigated case."),
            ("status", "VARCHAR", "50 / DEFAULT 'in_progress'", "None", "Investigation status: 'in_progress', 'submitted', 'solved', 'failed'."),
            ("score", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Graded verdict score percentage (0–100%)."),
            ("submitted_at", "TIMESTAMP", "8 Bytes / NULL", "None", "Timestamp when student submitted their formal verdict."),
        ]
    )
    
    # 17. reports
    build_table_dictionary(
        doc, 17, "reports",
        "Stores the final evaluated investigation reports containing student findings, grading feedback, and remediation advice.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the generated case report."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the student."),
            ("case_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (cases.id) ON DELETE CASCADE", "Reference to the investigated case."),
            ("report_data", "JSONB / TEXT", "Variable / NOT NULL", "None", "JSON object containing student verdict, evidence cited, and system feedback."),
            ("grade", "VARCHAR", "10 / NOT NULL", "None", "Letter grade: 'A+', 'A', 'B', 'C', 'F'."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when the report was officially issued."),
        ]
    )
    
    # ----------------------------------------------------
    # 4.4 THREAT SIMULATION & GAMIFICATION TABLES
    # ----------------------------------------------------
    add_heading_2(doc, "4.4 Threat Simulation, Gamification & System Tables")
    
    # 18. scenarios
    build_table_dictionary(
        doc, 18, "scenarios",
        "Defines interactive multi-step attack simulation environments in the Simulation Lab.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the simulation scenario."),
            ("title", "VARCHAR", "255 / NOT NULL", "None", "Scenario name (e.g., 'Phishing Defense Sandbox')."),
            ("type", "VARCHAR", "50 / NOT NULL", "None", "Attack type: 'phishing', 'sqli', 'ransomware', 'mitm', 'brute_force'."),
            ("difficulty", "VARCHAR", "50 / NOT NULL", "None", "Difficulty rating: 'Beginner', 'Intermediate', 'Advanced'."),
            ("steps_data", "JSONB / TEXT", "Variable / NOT NULL", "None", "Structured JSON containing sequential steps, choices, prompts, and hints."),
            ("countermeasures", "TEXT", "Variable / NOT NULL", "None", "Detailed technical explanation of prevention and detection controls."),
            ("xp_reward", "INTEGER", "4 Bytes / DEFAULT 150", "None", "Experience points credited upon completing all scenario steps."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    # 19. achievements
    build_table_dictionary(
        doc, 19, "achievements",
        "Catalogs collectible milestone badges, unlock conditions, and icon assets.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the achievement definition."),
            ("title", "VARCHAR", "100 / NOT NULL", "None", "Badge title (e.g., 'First Incident Solved', 'Phishing Master')."),
            ("description", "TEXT", "Variable / NOT NULL", "None", "Clear criteria describing how the badge is unlocked."),
            ("icon_url", "TEXT", "Variable / NULL", "None", "Asset path or CDN URL for badge visual icon."),
            ("xp_bonus", "INTEGER", "4 Bytes / DEFAULT 50", "None", "One-time bonus XP awarded when badge unlocks."),
            ("criteria_type", "VARCHAR", "50 / NOT NULL", "None", "Trigger type: 'case_completed', 'quiz_perfect', 'streak_7_days'."),
        ]
    )
    
    # 20. user_achievements
    build_table_dictionary(
        doc, 20, "user_achievements",
        "Tracks which achievement badges have been unlocked by each student and records the unlock moment.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the user achievement record."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the student."),
            ("achievement_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (achievements.id) ON DELETE CASCADE", "Reference to the unlocked achievement."),
            ("unlocked_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when the achievement trigger was satisfied."),
        ]
    )
    
    # 21. leaderboard
    build_table_dictionary(
        doc, 21, "leaderboard",
        "Maintains denormalized, fast-query cache of institutional rankings, total XP, and solved case counts.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the leaderboard row."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "UNIQUE, FOREIGN KEY (users.id)", "Reference to the student."),
            ("username", "VARCHAR", "100 / NULL", "None", "Display username or full name."),
            ("xp", "INTEGER", "4 Bytes / DEFAULT 0", "INDEX", "Total cumulative experience points earned."),
            ("rank", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Computed competitive rank position across the institution."),
            ("completed_courses", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Total count of finished academy courses."),
            ("completed_cases", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Total count of successfully solved forensic cases."),
            ("streak", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Current consecutive daily active streak count."),
            ("last_activity", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp of most recent platform interaction."),
        ]
    )
    
    # 22. leaderboard_stats
    build_table_dictionary(
        doc, 22, "leaderboard_stats",
        "Tracks extended user statistics, global percentiles, and dynamic tier levels.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the statistics record."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "UNIQUE, FOREIGN KEY (users.id)", "Reference to the user account."),
            ("total_xp", "INTEGER", "4 Bytes / DEFAULT 0", "None", "Cached sum of all XP from courses, quizzes, cases, and badges."),
            ("tier_level", "VARCHAR", "50 / DEFAULT 'Recruit'", "None", "Designation: 'Recruit', 'Analyst', 'Specialist', 'Investigator', 'Sentinel'."),
            ("solved_ratio", "FLOAT", "8 Bytes / DEFAULT 0.0", "None", "Case accuracy ratio calculated from verdict scores."),
            ("updated_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp of most recent stats recalculation."),
        ]
    )
    
    # 23. xp_transactions
    build_table_dictionary(
        doc, 23, "xp_transactions",
        "Maintains an immutable ledger of every XP award event for auditability and anti-cheat validation.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the XP transaction."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the student."),
            ("amount", "INTEGER", "4 Bytes / NOT NULL", "None", "XP amount awarded (positive integer)."),
            ("source_type", "VARCHAR", "50 / NOT NULL", "None", "Earning activity: 'quiz', 'simulation', 'case_verdict', 'badge'."),
            ("source_id", "INTEGER", "4 Bytes / NULL", "None", "Identifier of the specific quiz, scenario, or case."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when XP was credited to the student account."),
        ]
    )
    
    # 24. daily_activity
    build_table_dictionary(
        doc, 24, "daily_activity",
        "Tracks daily login and task completion dates used to calculate uninterrupted student learning streaks.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for daily activity log."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the student."),
            ("activity_date", "DATE", "4 Bytes / NOT NULL", "UNIQUE (user_id, activity_date)", "Calendar date of recorded student activity."),
            ("tasks_completed", "INTEGER", "4 Bytes / DEFAULT 1", "None", "Count of learning tasks completed on that calendar day."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "First interaction timestamp of the day."),
        ]
    )
    
    # 25. notifications
    build_table_dictionary(
        doc, 25, "notifications",
        "Stores user notifications, including new case alerts, achievement notices, and security advisories.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the notification message."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "INDEX, FOREIGN KEY (users.id)", "Reference to the target student recipient."),
            ("title", "VARCHAR", "255 / NOT NULL", "None", "Notification title (e.g., 'New Case Assigned!')."),
            ("message", "TEXT", "Variable / NOT NULL", "None", "Notification content payload."),
            ("type", "VARCHAR", "50 / NOT NULL", "None", "Alert type: 'case_assigned', 'badge_unlocked', 'threat_alert', 'system'."),
            ("is_read", "BOOLEAN", "1 Byte / DEFAULT FALSE", "None", "Flag denoting whether the student opened the notification."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when notification was generated."),
        ]
    )
    
    # 26. device_sessions
    build_table_dictionary(
        doc, 26, "device_sessions",
        "Tracks active client device sessions, hardware signatures, client platforms, and push notification tokens.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the session record."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the authenticated user."),
            ("device_name", "VARCHAR", "255 / NULL", "None", "Hardware device model name (e.g., 'Pixel 7', 'Samsung Galaxy S22')."),
            ("platform", "VARCHAR", "50 / NULL", "None", "Client operating system platform ('Android', 'iOS')."),
            ("app_version", "VARCHAR", "50 / NULL", "None", "Installed application build version string."),
            ("ip_address", "VARCHAR", "45 / NULL", "None", "Client IPv4 or IPv6 address captured during handshake."),
            ("login_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when session was initiated."),
            ("last_active", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp of most recent client activity."),
            ("is_current", "BOOLEAN", "1 Byte / DEFAULT FALSE", "None", "Flag denoting if session corresponds to current device."),
            ("fcm_token", "TEXT", "Variable / NULL", "None", "Firebase Cloud Messaging push token for this device."),
            ("session_token", "TEXT", "Variable / NULL", "None", "Cryptographically generated session token string."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Session creation timestamp."),
            ("updated_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Session modification timestamp."),
        ]
    )
    
    # 27. login_history
    build_table_dictionary(
        doc, 27, "login_history",
        "Maintains chronological audit trails of user authentication events, IP addresses, and login status.",
        [
            ("id", "SERIAL", "4 Bytes / NOT NULL", "PRIMARY KEY", "Unique identifier for the login event record."),
            ("user_id", "INTEGER", "4 Bytes / NOT NULL", "FOREIGN KEY (users.id) ON DELETE CASCADE", "Reference to the user account."),
            ("device_name", "VARCHAR", "255 / NULL", "None", "Device model reported during authentication."),
            ("platform", "VARCHAR", "50 / NULL", "None", "Operating system platform of the client device."),
            ("ip_address", "VARCHAR", "45 / NULL", "None", "IP address from which authentication was requested."),
            ("login_time", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Timestamp when the login attempt occurred."),
            ("logout_time", "TIMESTAMP", "8 Bytes / NULL", "None", "Timestamp when the user logged out (if explicitly terminated)."),
            ("status", "VARCHAR", "50 / DEFAULT 'success'", "None", "Authentication result status ('success', 'failed_credentials', 'locked')."),
            ("created_at", "TIMESTAMP", "8 Bytes / DEFAULT NOW()", "None", "Record creation timestamp."),
        ]
    )
    
    doc.add_page_break()
