import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from report_utils import (
    add_heading_1, add_heading_2, add_heading_3,
    add_para, add_bullet, add_caption
)

def build_chapter_6(doc):
    add_heading_1(doc, "CHAPTER 6 – LIMITATIONS & FUTURE ENHANCEMENT")
    
    add_para(
        doc,
        "Engineering an educational cybersecurity and digital investigation platform on a mobile operating system "
        "requires balancing technical realism, operating system security boundaries, and user accessibility. This chapter "
        "delineates the current architectural constraints of ForenShield and outlines a comprehensive future enhancement "
        "roadmap for subsequent academic development."
    )
    
    # ----------------------------------------------------
    # 6.1 LIMITATIONS
    # ----------------------------------------------------
    add_heading_2(doc, "6.1 Limitations")
    add_para(
        doc,
        "The current implementation of ForenShield, while highly comprehensive for diploma-level pedagogy, possesses "
        "several technical and operational boundaries:"
    )
    add_bullet(
        doc,
        "To ensure total safety and eliminate the risk of accidental malware execution on student devices, all attack "
        "scenarios are executed within controlled, pre-computed sandboxes. The platform simulates the observable symptoms and "
        "network artifacts of cyberattacks rather than running live, destructive binary exploits.",
        bold_prefix="1. Controlled Simulation Sandbox Boundaries: "
    )
    add_bullet(
        doc,
        "Standard mobile operating systems (Android and iOS) enforce strict application sandboxing that restricts "
        "user-space applications from accessing raw network sockets in promiscuous mode or executing low-level kernel "
        "memory inspection without root/jailbreak privileges. As a result, network packet captures and disk images must be "
        "pre-acquired and delivered as structured evidence artifacts rather than captured live from the mobile radio.",
        bold_prefix="2. Mobile Operating System Hardware & Kernel Constraints: "
    )
    add_bullet(
        doc,
        "The current architecture relies upon active network connectivity to authenticate JWT sessions, fetch curriculum "
        "updates, evaluate forensic verdicts, and sync leaderboard ranks with the cloud PostgreSQL backend. While static "
        "lesson text is cached locally, dynamic scenario grading requires active internet access.",
        bold_prefix="3. Cloud Backend Network Dependency: "
    )
    add_bullet(
        doc,
        "The digital investigation cases currently stored in the PostgreSQL database are curated academic scenarios "
        "spanning several megabytes of logs and PCAP extracts. The system is not currently connected to live, enterprise-scale "
        "Security Information and Event Management (SIEM) systems (such as Splunk or Elastic Security) that process gigabytes "
        "of raw telemetric data per second.",
        bold_prefix="4. Academic-Scale Dataset Scope: "
    )
    add_bullet(
        doc,
        "The current investigation workflow is tailored for individual student learning. Collaborative multi-user "
        "investigation sessions, where multiple investigators simultaneously interrogate shared evidence items in real time, "
        "are not supported in the current version.",
        bold_prefix="5. Single-Investigator Session Model: "
    )
    
    # ----------------------------------------------------
    # 6.2 FUTURE ENHANCEMENT
    # ----------------------------------------------------
    add_heading_2(doc, "6.2 Future Enhancement")
    add_para(
        doc,
        "To expand upon the foundations established during the 5th semester, several high-impact technical enhancements "
        "are planned for future iterations:"
    )
    add_bullet(
        doc,
        "Integrate large language model (LLM) APIs to dynamically generate unique, procedurally generated forensic "
        "incident cases and simulation scenarios. This will provide infinite variety, preventing students from memorizing "
        "static answer keys.",
        bold_prefix="1. AI-Powered Dynamic Threat Case Generation: "
    )
    add_bullet(
        doc,
        "Implement an on-device embedded SQLite database and a native Dart packet parsing engine, allowing students "
        "to parse Wireshark PCAPs, filter IP addresses, and inspect syslog headers entirely offline during intermittent connectivity.",
        bold_prefix="2. On-Device Offline Forensic Parsing Engine: "
    )
    add_bullet(
        doc,
        "Leverage Flutter’s multi-platform capabilities to compile ForenShield natively for Windows, macOS, and Web "
        "browsers. A desktop workstation interface will allow multi-window side-by-side evidence inspection, providing an "
        "authentic laboratory feel.",
        bold_prefix="3. Cross-Platform Desktop & Web Workstation Client: "
    )
    add_bullet(
        doc,
        "Incorporate standardized STIX/TAXII threat intelligence sharing formats and map all simulation scenarios "
        "directly to the MITRE ATT&CK Enterprise Framework, enabling students to generate industry-standard incident reports.",
        bold_prefix="4. MITRE ATT&CK & STIX/TAXII Threat Intelligence Integration: "
    )
    add_bullet(
        doc,
        "Introduce real-time collaborative investigation rooms powered by WebSockets, allowing student pairs or "
        "syndicates to divide evidence artifacts, cross-examine clues, and formulate joint verdicts during competitive hackathons.",
        bold_prefix="5. Multiplayer Collaborative Investigation War Rooms: "
    )
    add_bullet(
        doc,
        "During the upcoming 6th semester capstone phase, the platform will be expanded to include automated USB "
        "hardware forensic write-blocker integration tests, automated cyber triage scoring, and faculty grading portals.",
        bold_prefix="6. Sixth-Semester Capstone Roadmap: "
    )
    
    doc.add_page_break()

def build_chapter_7(doc):
    add_heading_1(doc, "CHAPTER 7 – CONCLUSION")
    
    add_para(
        doc,
        "The ForenShield project successfully conceptualizes, designs, and deploys an interactive, mobile-first cybersecurity "
        "training and digital investigation platform tailored specifically for computer engineering education. By directly "
        "addressing the persistent theory-to-practical pedagogy gap, the application transforms complex, intimidating "
        "cyber defense concepts into engaging, tactile, and pedagogically structured learning experiences."
    )
    
    add_heading_2(doc, "7.1 Summary of Accomplishments")
    add_para(
        doc,
        "Throughout the 5th-semester project lifecycle, several critical engineering objectives were accomplished:"
    )
    add_bullet(
        doc,
        "Delivered a cross-platform mobile application compiled natively via Flutter and Dart, ensuring smooth 60 FPS "
        "animations, clean Material 3 aesthetics, and compile-safe Riverpod state management.",
        bold_prefix="Cross-Platform Frontend Delivery: "
    )
    add_bullet(
        doc,
        "Engineered 50+ modular PHP REST endpoints (51 endpoint scripts across root and subsystem modules) backed by an ACID-compliant PostgreSQL relational database "
        "on Neon Cloud, incorporating bcrypt credential hashing and HMAC-SHA256 JWT authorization.",
        bold_prefix="Robust Cloud Backend & Database: "
    )
    add_bullet(
        doc,
        "Developed structured courses spanning core cyber disciplines, coupled with automated formative multiple-choice quizzes.",
        bold_prefix="Cyber Academy Learning Hub: "
    )
    add_bullet(
        doc,
        "Engineered sandboxed simulation environments for five prominent attack methodologies (Phishing, SQLi, Ransomware, "
        "MitM, Brute Force), demonstrating both offensive exploit anatomy and defensive remediation.",
        bold_prefix="Safe Threat Simulation Lab: "
    )
    add_bullet(
        doc,
        "Pioneered a realistic evidence inspection engine that trains students to interrogate server access logs, PCAP dumps, "
        "and email headers to construct chronological attack timelines and file graded verdicts.",
        bold_prefix="Digital Forensics Investigation Division: "
    )
    add_bullet(
        doc,
        "Implemented an engaging progression ecosystem comprising experience points, 5-tier rank advancements, milestone badges, "
        "and real-time institutional leaderboard competition.",
        bold_prefix="Motivational Gamification Engine: "
    )
    
    add_heading_2(doc, "7.2 Technical Problems Solved")
    add_para(
        doc,
        "ForenShield resolves the fundamental educational dilemma wherein students understand abstract cybersecurity definitions "
        "yet fail when confronted with actual indicators of compromise. By embedding students within safe, sandboxed attack environments "
        "and forensic crime scenes, the platform demystifies exploit mechanisms, teaches evidence preservation, and instills an "
        "analytical mindset."
    )
    
    add_heading_2(doc, "7.3 Learning Achieved")
    add_para(
        doc,
        "The end-to-end development of ForenShield provided invaluable technical mastery across diverse software engineering "
        "disciplines, including cross-platform mobile UI engineering with Flutter, reactive state architecture with Riverpod, "
        "secure REST API design with PHP PDO, enterprise relational schema normalization with PostgreSQL, stateless cryptographic "
        "JWT session handling, and structured software testing methodologies."
    )
    
    add_heading_2(doc, "7.4 Concluding Remarks")
    add_para(
        doc,
        "ForenShield establishes that mobile learning technologies can serve as an exceptionally powerful, accessible, and "
        "secure medium for advanced technical education. By bridging the divide between academic theory and industry operational "
        "reality, ForenShield equips aspiring diploma computer engineers with the vital competencies required to defend modern "
        "digital infrastructures against the evolving cyber threat landscape."
    )
    
    doc.add_page_break()

def build_references(doc):
    add_heading_1(doc, "REFERENCES")
    
    add_para(
        doc,
        "The conceptualization, architectural design, security protocols, and forensic methodologies implemented in "
        "ForenShield are informed by the following academic textbooks, standards, official documentation, and research publications:"
    )
    
    add_heading_2(doc, "Academic Textbooks & Standards")
    add_bullet(
        doc,
        "Guide to Integrating Forensic Techniques into Incident Response. NIST Special Publication 800-86, "
        "National Institute of Standards and Technology, Gaithersburg, MD, 2006.",
        bold_prefix="[1] Kent, K., Chevalier, S., Grance, T., & Dang, H. "
    )
    add_bullet(
        doc,
        "Digital Evidence and Computer Crime: Forensic Science, Computers, and the Internet. 3rd Edition, "
        "Academic Press, Elsevier, Amsterdam, 2011.",
        bold_prefix="[2] Casey, E. "
    )
    add_bullet(
        doc,
        "Computer Networks. 6th Edition, Pearson Education, Upper Saddle River, NJ, 2021.",
        bold_prefix="[3] Tanenbaum, A. S., Wetherall, D. J., & Feamster, N. "
    )
    add_bullet(
        doc,
        "Cryptography and Network Security: Principles and Practice. 8th Edition, Pearson Education, 2020.",
        bold_prefix="[4] Stallings, W. "
    )
    add_bullet(
        doc,
        "JSON Web Token (JWT). RFC 7519, Internet Engineering Task Force (IETF), May 2015.",
        bold_prefix="[5] Jones, M., Bradley, J., & Sakimura, N. "
    )
    
    add_heading_2(doc, "Official Documentation & Framework Guides")
    add_bullet(
        doc,
        "Flutter Documentation & Architectural Overview. Google Developers, https://docs.flutter.dev/, 2026.",
        bold_prefix="[6] Google LLC. "
    )
    add_bullet(
        doc,
        "Dart Programming Language Specification & Effective Dart Guidelines. https://dart.dev/, 2026.",
        bold_prefix="[7] Dart Team. "
    )
    add_bullet(
        doc,
        "Riverpod: A Reactive Caching and Data-Binding Framework. https://riverpod.dev/, 2026.",
        bold_prefix="[8] Roussel, R. "
    )
    add_bullet(
        doc,
        "PostgreSQL 16.0 Documentation. PostgreSQL Global Development Group, https://www.postgresql.org/docs/16/, 2026.",
        bold_prefix="[9] The PostgreSQL Global Development Group. "
    )
    add_bullet(
        doc,
        "PHP Manual: PDO (PHP Data Objects) Extension. The PHP Group, https://www.php.net/manual/en/book.pdo.php, 2026.",
        bold_prefix="[10] The PHP Group. "
    )
    
    add_heading_2(doc, "Cybersecurity Research & Web Resources")
    add_bullet(
        doc,
        "OWASP Top 10: The Ten Most Critical Web Application Security Risks. Open Web Application Security Project, "
        "https://owasp.org/www-project-top-ten/, 2021.",
        bold_prefix="[11] OWASP Foundation. "
    )
    add_bullet(
        doc,
        "MITRE ATT&CK: Design and Philosophy. The MITRE Corporation, https://attack.mitre.org/, 2026.",
        bold_prefix="[12] The MITRE Corporation. "
    )
    add_bullet(
        doc,
        "Known Exploited Vulnerabilities (KEV) Catalog. Cybersecurity and Infrastructure Security Agency, https://www.cisa.gov/known-exploited-vulnerabilities-catalog, 2026.",
        bold_prefix="[13] CISA. "
    )
    add_bullet(
        doc,
        "National Vulnerability Database (NVD) API Specification. National Institute of Standards and Technology, https://nvd.nist.gov/, 2026.",
        bold_prefix="[14] NIST. "
    )
