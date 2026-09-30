import os
import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from report_utils import (
    FONT_NAME, BLACK,
    add_heading_1, add_heading_2, add_heading_3,
    add_para, add_bullet, add_caption, add_image_centered,
    set_cell_margins, set_cell_shading, set_table_borders, format_row
)

def build_chapter_3(doc, img_dir):
    add_heading_1(doc, "CHAPTER 3 – SYSTEM DESIGN / CIRCUIT DIAGRAM")
    
    add_para(
        doc,
        "System design represents the architectural blueprint of an engineering application. It translates the "
        "functional and non-functional requirements established in Chapter 2 into concrete structural models, "
        "procedural workflows, data flow paths, and entity relationships. This chapter details the multi-tier "
        "system architecture, user operational flowchart, data flow diagrams (Levels 0, 1, and 2), formal use case "
        "specifications, activity workflows, entity-relationship models, and the hardware interface abstraction."
    )
    
    # ----------------------------------------------------
    # 3.1 SYSTEM ARCHITECTURE
    # ----------------------------------------------------
    add_heading_2(doc, "3.1 System Architecture")
    add_para(
        doc,
        "ForenShield implements a decoupled, modern multi-tier client-server architecture engineered for high "
        "scalability, robust security, and seamless platform portability. As illustrated in Figure 3.1, the "
        "system is bifurcated into two primary operational environments: the Client Mobile Environment and the "
        "Cloud Backend Infrastructure."
    )
    
    fig31_path = os.path.join(img_dir, "eecef9f121e055e441e2aa496d64dde66b10b132.jpg")
    add_image_centered(doc, fig31_path, width_in_inches=5.8, caption="Figure 3.1: ForenShield System Architecture & Layered Block Diagram")
    
    add_para(
        doc,
        "The architecture is organized into six distinct functional layers:",
        bold_prefix="Architectural Layer Breakdown: "
    )
    add_bullet(
        doc,
        "Rendered via Flutter’s Impeller graphics pipeline, this layer encompasses all user-facing screens, "
        "interactive forensic inspection widgets, simulation step handlers, and responsive Material 3 UI components.",
        bold_prefix="1. Presentation Layer (Mobile Client): "
    )
    add_bullet(
        doc,
        "Implemented using flutter_riverpod, this tier manages application lifecycle states, user authentication "
        "tokens, active course progress, simulation step variables, and cached forensic evidence without tight coupling "
        "to widget trees.",
        bold_prefix="2. State Management & ViewModel Tier: "
    )
    add_bullet(
        doc,
        "Engineered with Dio, this tier provides robust HTTP communications. It features an interceptor chain "
        "that automatically attaches Bearer JWT tokens to outgoing requests, catches 401 Unauthorized exceptions, triggers "
        "token refresh handshakes silently, and retries failed transactions gracefully.",
        bold_prefix="3. Network & Service Abstraction Layer: "
    )
    add_bullet(
        doc,
        "A collection of 50+ specialized PHP 8.2 REST endpoints (51 endpoint scripts across root and subsystem modules) "
        "executing on an Apache/Nginx web server. This layer handles request routing, input validation, bcrypt password hashing, "
        "HMAC-SHA256 JWT generation, and business logic execution.",
        bold_prefix="4. Application Processing Tier (PHP REST API): "
    )
    add_bullet(
        doc,
        "Hosted on Neon Serverless Cloud, the PostgreSQL relational database maintains 27 normalized tables. "
        "Communication occurs strictly via PHP Data Objects (PDO) with parameterized prepared statements, ensuring strict ACID compliance.",
        bold_prefix="5. Persistence Tier (PostgreSQL Database): "
    )
    add_bullet(
        doc,
        "Third-party cloud infrastructure integrated to augment core capabilities: Cloudinary CDN provides optimized "
        "storage and transformation for user avatars; Firebase Cloud Messaging (FCM) handles real-time push alerts; and external "
        "security APIs (CISA KEV, MITRE ATT&CK, VirusTotal) supply real-world threat feeds.",
        bold_prefix="6. Cloud Services & External Integration Tier: "
    )
    
    # ----------------------------------------------------
    # 3.2 FLOWCHART
    # ----------------------------------------------------
    add_heading_2(doc, "3.2 Flowchart")
    add_para(
        doc,
        "The complete operational lifecycle of a student interacting with ForenShield is mapped in Figure 3.2. "
        "The flowchart outlines the procedural decision trees governing onboarding, authentication, module exploration, "
        "interactive simulation execution, digital evidence examination, verdict evaluation, and XP distribution."
    )
    
    fig32_path = os.path.join(img_dir, "36d16e9c157fdb1467df24124516f85edf840082.jpg")
    add_image_centered(doc, fig32_path, width_in_inches=5.2, caption="Figure 3.2: ForenShield End-to-End User Operational Flowchart")
    
    add_para(
        doc,
        "The execution path follows a structured logic flow:",
        bold_prefix="Flowchart Logic Walkthrough: "
    )
    add_bullet(
        doc,
        "Upon application launch, the client checks local secure storage for an active refresh token. If valid, "
        "the session is silently refreshed; otherwise, the student is routed to the Welcome/Login screen.",
        bold_prefix="Phase A – Initialization & Auth Gate: "
    )
    add_bullet(
        doc,
        "From the Mission Control dashboard, the user selects one of three core training tracks: Cyber Academy, "
        "Simulation Lab, or Investigation Lab.",
        bold_prefix="Phase B – Track Selection: "
    )
    add_bullet(
        doc,
        "In Cyber Academy, the user reviews lessons and takes an end-of-module quiz. If score ≥ 70%, the module is "
        "marked complete, XP is awarded, and subsequent lessons unlock.",
        bold_prefix="Phase C – Learning & Knowledge Verification: "
    )
    add_bullet(
        doc,
        "In Simulation Lab, the user executes tactical attack stages. The sandbox evaluates each user choice, explains "
        "the offensive mechanism, and presents defensive countermeasures upon completion.",
        bold_prefix="Phase D – Threat Sandbox Execution: "
    )
    add_bullet(
        doc,
        "In Investigation Lab, the user reviews a case dossier, analyzes forensic artifacts, constructs an event timeline, "
        "and submits a structured verdict. The grading engine evaluates accuracy and outputs an investigation report.",
        bold_prefix="Phase E – Evidence Investigation & Verdict: "
    )
    add_bullet(
        doc,
        "The system aggregates earned XP, checks trigger conditions for achievement badges, recalculates rank tier, "
        "and updates the global leaderboard.",
        bold_prefix="Phase F – Gamification & Profile Update: "
    )
    
    # ----------------------------------------------------
    # 3.3 DFD / USE CASE / ER DIAGRAM
    # ----------------------------------------------------
    add_heading_2(doc, "3.3 DFD / Use Case / ER Diagram")
    
    add_heading_3(doc, "3.3.1 Data Flow Diagrams (Level 0, Level 1, Level 2)")
    add_para(
        doc,
        "Data Flow Diagrams (DFDs) provide a hierarchical graphical representation of how information moves through "
        "the ForenShield ecosystem, depicting external entities, transformative processes, and database data stores."
    )
    
    # DFD Level 0
    add_para(
        doc,
        "Figure 3.3 illustrates the Context Diagram (DFD Level 0). It defines the overarching boundary of the ForenShield "
        "system, modeling interactions between two primary external entities—the Student/Learner and the System Administrator—and "
        "external Cloud Services (Cloudinary, FCM, Threat Feeds).",
        bold_prefix="DFD Level 0 – Context Diagram: "
    )
    fig33_path = os.path.join(img_dir, "67230d7945383819aed772ec6dda469b8095ae2d.jpg")
    add_image_centered(doc, fig33_path, width_in_inches=5.2, caption="Figure 3.3: DFD Level 0 – ForenShield Context Diagram")
    
    # DFD Level 1
    add_para(
        doc,
        "Figure 3.4 illustrates DFD Level 1, decomposing the monolithic system into its primary operational subsystems: "
        "Process 1.0 (Authentication & Identity Management), Process 2.0 (Cyber Academy Course Delivery), Process 3.0 "
        "(Interactive Attack Simulation), Process 4.0 (Digital Forensic Case Investigation), Process 5.0 (Gamification, "
        "XP & Leaderboard Analytics), and Process 6.0 (System Notification & Profile Management), showing their interactions "
        "with dedicated database tables.",
        bold_prefix="DFD Level 1 – Subsystem Decomposition: "
    )
    fig34_path = os.path.join(img_dir, "2244632b3e28beccf331678981df8054241c8869.jpg")
    add_image_centered(doc, fig34_path, width_in_inches=5.5, caption="Figure 3.4: DFD Level 1 – Primary Subsystem Data Flow Diagram")
    
    # DFD Level 2
    add_para(
        doc,
        "Figure 3.5 provides DFD Level 2, zooming into the core innovative subsystem of ForenShield: Process 4.0 "
        "(Digital Forensic Case Investigation). It reveals internal data flows between Case Briefing Retrieval (4.1), "
        "Evidence Artifact Inspection (4.2), Timeline Event Correlation (4.3), Verdict Formulation & Grading (4.4), "
        "and Case Dossier Reporting (4.5).",
        bold_prefix="DFD Level 2 – Investigation Subsystem Decomposition: "
    )
    fig35_path = os.path.join(img_dir, "07ac035cd81d3c7a5e72aac0c9c381d7be97c4bb.jpg")
    add_image_centered(doc, fig35_path, width_in_inches=5.5, caption="Figure 3.5: DFD Level 2 – Forensic Investigation Process Data Flow")
    
    add_heading_3(doc, "3.3.2 Use Case Modeling & Specifications")
    add_para(
        doc,
        "Use case modeling formally captures the functional interactions between external actors and the ForenShield system. "
        "The primary actor is the Student / Investigator, who engages with learning modules, simulations, and investigations. "
        "The secondary actor is the System Administrator, who manages instructional content and monitors platform telemetry."
    )
    
    # Table 3.1: Use Case Summary Table
    p_tuc = doc.add_paragraph()
    p_tuc.paragraph_format.space_before = Pt(8)
    p_tuc.paragraph_format.space_after = Pt(4)
    r = p_tuc.add_run("Table 3.1: Formal Use Case Specification Summary")
    r.font.name = FONT_NAME
    r.font.size = Pt(11)
    r.font.bold = True
    r.font.color.rgb = BLACK
    
    uc_summary_data = [
        ("Use Case ID", "Use Case Title", "Primary Actor", "Pre-conditions", "Post-conditions"),
        ("UC-01", "User Authentication & JWT Session", "Student / User", "Application installed, network available", "Valid access token stored, dashboard loaded"),
        ("UC-02", "Complete Cyber Academy Module", "Student / User", "Authenticated session, course selected", "Quiz submitted, score computed, XP credited"),
        ("UC-03", "Execute Threat Simulation", "Student / User", "Authenticated session, scenario picked", "Attack steps executed, countermeasures reviewed"),
        ("UC-04", "Examine Digital Evidence", "Student / User", "Active forensic case open", "Evidence artifacts inspected, clues noted"),
        ("UC-05", "Submit Forensic Case Verdict", "Student / User", "Evidence examined, timeline mapped", "Verdict graded, score saved, report generated"),
        ("UC-06", "View Leaderboard & Analytics", "Student / User", "Authenticated session", "Global ranks displayed, personal standing highlighted"),
    ]
    
    t_uc = doc.add_table(rows=len(uc_summary_data), cols=5)
    t_uc.alignment = WD_TABLE_ALIGNMENT.CENTER
    t_uc.autofit = False
    uc_col_w = [Inches(1.0), Inches(1.8), Inches(1.3), Inches(1.5), Inches(1.6)]
    for row in t_uc.rows:
        for c_idx, w in enumerate(uc_col_w):
            row.cells[c_idx].width = w
    set_table_borders(t_uc, color="000000", sz="4", val="single")
    
    for r_idx, row_data in enumerate(uc_summary_data):
        row = t_uc.rows[r_idx]
        is_hdr = (r_idx == 0)
        bg = "D9D9D9" if is_hdr else "FFFFFF"
        for c_idx, val in enumerate(row_data):
            p = row.cells[c_idx].paragraphs[0]
            p.text = val
        format_row(row, is_header=is_hdr, bg_color=bg)
        
    add_para(
        doc,
        "Detailed formal specifications for representative core use cases:",
        bold_prefix="Detailed Use Case Walkthroughs: "
    )
    add_bullet(
        doc,
        "Actor: Student. Description: Authenticates registered credentials against server. Main Flow: (1) User inputs email & password; "
        "(2) Client validates format and sends POST to /api/login.php; (3) Server verifies bcrypt hash; (4) Issues JWT access & refresh tokens; "
        "(5) Client stores tokens in encrypted hardware keystore and navigates to Mission Control. Exceptions: Invalid credentials returned with HTTP 401.",
        bold_prefix="Use Case UC-01 (User Authentication): "
    )
    add_bullet(
        doc,
        "Actor: Student. Description: Solves an active cybercrime investigation case. Main Flow: (1) Student selects case from Investigation Lab; "
        "(2) Reviews incident brief and victim context; (3) Inspects evidence items (logs, PCAPs, emails); (4) Tags relevant timestamps on incident timeline; "
        "(5) Formulates verdict (suspect, attack vector, evidence citation, mitigation); (6) Server executes verdict grading algorithm; (7) Case report "
        "generated with performance score; (8) XP transactions recorded. Exceptions: Incomplete verdict submissions blocked with validation alerts.",
        bold_prefix="Use Case UC-05 (Submit Forensic Verdict): "
    )
    
    add_heading_3(doc, "3.3.3 Entity-Relationship (ER) Diagram")
    add_para(
        doc,
        "The relational database schema of ForenShield is modeled in Figure 3.7. It delineates the structural relationships, "
        "primary/foreign key linkages, and cardinalities spanning 26 tables grouped across Authentication, Cyber Academy, "
        "Simulation Lab, Investigation Lab, Gamification, and System Administration."
    )
    
    fig37_path = os.path.join(img_dir, "0ae52ac8493d78c1996d3d22824be7af722a099f.jpg")
    add_image_centered(doc, fig37_path, width_in_inches=5.8, caption="Figure 3.7: ForenShield Complete Entity-Relationship (ER) Diagram")
    
    add_para(
        doc,
        "Key entity groupings and structural cardinalities in the relational model:",
        bold_prefix="Entity-Relationship Architectural Analysis: "
    )
    add_bullet(
        doc,
        "The central `users` entity has 1:N relationships with `otp_codes`, `refresh_tokens`, `device_sessions`, and `login_history`.",
        bold_prefix="1. User & Session Subsystem: "
    )
    add_bullet(
        doc,
        "`courses` has a 1:N relationship with `course_modules`, which in turn has a 1:N relationship with `lessons`. "
        "User learning states are tracked via `user_course_progress` and `user_lesson_progress`. Each course associates with `quizzes` (1:N), "
        "which contain `quiz_questions` (1:N), evaluated through `user_quiz_attempts`.",
        bold_prefix="2. Academy Subsystem: "
    )
    add_bullet(
        doc,
        "`cases` possesses 1:N relationships with `evidence`, `case_timeline`, and `verdicts`. Student case performance is tracked in "
        "`user_case_progress` and summarized in `reports`.",
        bold_prefix="3. Forensic Investigation Subsystem: "
    )
    add_bullet(
        doc,
        "`users` associates 1:1 with `leaderboard` and `leaderboard_stats`, and 1:N with `user_achievements`, `xp_transactions`, and `daily_activity`.",
        bold_prefix="4. Gamification Subsystem: "
    )
    
    add_heading_3(doc, "3.3.4 Activity & Sequence Diagrams")
    add_para(
        doc,
        "Figure 3.6 presents the behavioral Activity Diagram of ForenShield, modeling the parallel decision paths and "
        "user activity states during an active learning session."
    )
    
    fig36_path = os.path.join(img_dir, "8748beba40c37eb2f5269a9501d948f9f6dfc9e0.jpg")
    add_image_centered(doc, fig36_path, width_in_inches=5.2, caption="Figure 3.6: ForenShield User Activity & State Transition Diagram")
    
    add_para(
        doc,
        "To complement the activity model, the temporal sequence of messages during the critical Forensic Case Verdict workflow "
        "is delineated as follows:",
        bold_prefix="Forensic Case Verdict Sequence: "
    )
    add_bullet(
        doc,
        "The Flutter UI gathers verdict inputs (suspect_id, attack_vector, evidence_ids, narrative) and calls CaseInvestigationNotifier.",
        bold_prefix="Step 1 (Client Request): "
    )
    add_bullet(
        doc,
        "The repository serializes data into JSON and dispatches an authenticated HTTP POST request to /api/investigation_verdict.php via Dio.",
        bold_prefix="Step 2 (Network Dispatch): "
    )
    add_bullet(
        doc,
        "The PHP API extracts the Bearer token, validates the HMAC-SHA256 signature, parses user_id, and binds parameters via PDO.",
        bold_prefix="Step 3 (Authentication & Validation): "
    )
    add_bullet(
        doc,
        "The backend queries ground truth verdict benchmarks, evaluates clue matches, calculates an objective accuracy score, "
        "inserts a record into `user_case_progress`, and generates an official report in `reports`.",
        bold_prefix="Step 4 (Verdict Evaluation): "
    )
    add_bullet(
        doc,
        "The achievement engine evaluates unlock conditions, credits XP into `xp_transactions`, and returns the evaluated report to the mobile client.",
        bold_prefix="Step 5 (Gamification & Response): "
    )
    
    # ----------------------------------------------------
    # 3.4 CIRCUIT DIAGRAM / HARDWARE ABSTRACTION
    # ----------------------------------------------------
    add_heading_2(doc, "3.4 Circuit Diagram (Hardware & Forensic Interface Abstraction)")
    add_para(
        doc,
        "As an advanced software application, ForenShield does not require dedicated embedded printed circuit board (PCB) "
        "hardware for its core mobile educational execution. However, to fulfill the institute's system design requirements and "
        "provide complete academic rigor, this section details the physical hardware abstraction layer, mobile device hardware "
        "interfaces, and hardware forensic laboratory interfaces relevant to digital forensics."
    )
    add_para(
        doc,
        "In physical digital forensics, hardware write-blockers (e.g., Tableau T8u Forensic USB Bridge) are deployed between "
        "target storage drives and forensic workstations to prevent operating systems from altering drive metadata during disk acquisition. "
        "ForenShield models this physical concept at the software abstraction layer: evidence artifacts served to the mobile client are "
        "cryptographically hashed (SHA-256) upon retrieval from the server and cached in read-only sandboxed storage to guarantee "
        "chain-of-custody integrity."
    )
    add_para(
        doc,
        "Furthermore, on the target mobile hardware architecture (ARM64), ForenShield directly interfaces with three dedicated "
        "hardware sub-modules:",
        bold_prefix="Mobile Hardware Interface Integration: "
    )
    add_bullet(
        doc,
        "The application utilizes Android Keystore and Apple Secure Enclave hardware co-processors via flutter_secure_storage "
        "to store RSA/AES-encrypted JWT tokens, ensuring credentials cannot be harvested even if the mobile device file system is extracted.",
        bold_prefix="1. Hardware Cryptographic Keystore / Secure Enclave: "
    )
    add_bullet(
        doc,
        "The mobile camera module is integrated via the ImagePicker subsystem, allowing students to capture physical crime scene "
        "markers or documentation during hybrid forensic training workshops.",
        bold_prefix="2. Camera Sensor Interface: "
    )
    add_bullet(
        doc,
        "The networking sub-system (Wi-Fi 802.11 / LTE modem) is governed by automated connectivity listeners that monitor network "
        "state changes and adjust Dio timeout thresholds dynamically.",
        bold_prefix="3. Baseband & Network Radio Interface: "
    )
    
    doc.add_page_break()
