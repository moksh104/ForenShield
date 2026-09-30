-- ==========================================================================
-- ForenShield — Investigation Lab Seed Data (Phase 3)
-- 4 Fictional Educational Cases
-- Run this against the Neon PostgreSQL database.
-- All names, domains, IPs, and records are FICTIONAL.
-- ==========================================================================

-- ── CASE 1: Suspicious Account Takeover ─────────────────────────────────────

INSERT INTO cases (id, case_code, title, description, priority, difficulty, status, assigned_date, notes, objectives)
VALUES (
    'case_101',
    'FSC-101',
    'Suspicious Account Login',
    'A corporate helpdesk received an alert that the employee account of "Jamie Doren" at Novex Corp was logged into from an unfamiliar location in the middle of the night. Investigate the login event logs and determine whether this was a credential-based attack.',
    'Medium',
    'Beginner',
    'Open',
    '2026-09-20',
    'Focus on authentication logs and IP geolocation anomalies.',
    '["Analyze authentication event logs", "Identify the suspicious login source IP", "Determine if multi-factor authentication was bypassed", "Formulate the most likely attack vector"]'
) ON CONFLICT (id) DO UPDATE SET
    case_code    = EXCLUDED.case_code,
    title        = EXCLUDED.title,
    description  = EXCLUDED.description,
    priority     = EXCLUDED.priority,
    difficulty   = EXCLUDED.difficulty,
    status       = EXCLUDED.status,
    assigned_date = EXCLUDED.assigned_date,
    notes        = EXCLUDED.notes,
    objectives   = EXCLUDED.objectives;

INSERT INTO evidence (id, case_id, title, evidence_type, content_text, metadata_map, evidence_timestamp) VALUES
(
    'ev_101_1',
    'case_101',
    'Authentication Log Extract',
    'log',
    '2026-09-19 02:47:13 UTC [AUTH] LOGIN_SUCCESS user=j.doren@novexcorp.internal src_ip=185.220.101.47 device=Unknown-Linux user_agent="Mozilla/5.0 (X11; Linux x86_64)" mfa_used=false session_token=eyJhbGci...truncated
2026-09-19 02:47:51 UTC [AUTH] PASSWORD_CHANGE user=j.doren@novexcorp.internal initiated_from=185.220.101.47
2026-09-19 02:49:02 UTC [AUTH] EMAIL_CHANGED user=j.doren@novexcorp.internal old=j.doren@novexcorp.internal new=j.doren.recovr@protonmail.com',
    '{"Source": "Novex SIEM Platform", "Log Type": "Authentication Events", "Time Range": "2026-09-19 02:45 to 02:55 UTC", "SHA-256": "a3f8d1b2c9e74f6180a21c4e5b9d7f3a", "Analyst Note": "IP 185.220.101.47 is a known Tor exit node"}',
    '2026-09-19 02:47:13 UTC'
),
(
    'ev_101_2',
    'case_101',
    'Phishing Email Headers',
    'network',
    'From: "Novex IT Security" <security-alert@n0vex-corp.com>
To: j.doren@novexcorp.internal
Subject: [URGENT] Your account requires immediate verification
Date: 2026-09-18 23:31:05 UTC

Received: from mail.n0vex-corp.com (185.220.101.47) by mxin.novexcorp.internal
X-Originating-IP: 185.220.101.47
Content-Type: text/html

Body contains link: http://novex-verify.suspicious-domain.net/login?token=AbC123XyZ',
    '{"Domain": "n0vex-corp.com (TYPOSQUATTED)", "Sender IP": "185.220.101.47", "SPF Check": "FAIL", "DKIM": "NOT PRESENT", "DMARC": "FAIL", "SHA-256": "b8c221a9d04e7b3f91a55e8d2c106473"}',
    '2026-09-18 23:31:05 UTC'
),
(
    'ev_101_3',
    'case_101',
    'Employee Credential Database Entry',
    'file',
    'User Record:
  Username:    j.doren
  Full Name:   Jamie Doren
  Department:  Finance — Accounts Payable
  MFA Status:  DISABLED (opt-out requested 2026-07-14)
  Last Normal Login: 2026-09-18 09:12 UTC from 10.2.4.88 (Corporate VPN)
  Last Password Reset: 2026-09-19 02:47 UTC FROM UNKNOWN EXTERNAL IP',
    '{"Source": "Novex HR Identity Platform", "Record Type": "User Profile", "Access Level": "Finance Internal", "SHA-256": "c7d33e4a12b891f0234a6b7c8d9e1f02"}',
    '2026-09-18 09:12:00 UTC'
)
ON CONFLICT (id) DO UPDATE SET
    title              = EXCLUDED.title,
    evidence_type      = EXCLUDED.evidence_type,
    content_text       = EXCLUDED.content_text,
    metadata_map       = EXCLUDED.metadata_map,
    evidence_timestamp = EXCLUDED.evidence_timestamp;

INSERT INTO case_timeline (id, case_id, title, description, timeline_timestamp, category, severity) VALUES
('tl_101_1', 'case_101', 'Phishing Email Delivered', 'Typosquatted domain email delivered to j.doren@novexcorp.internal bypassing spam filter.', '2026-09-18 23:31 UTC', 'Email Attack', 'High'),
('tl_101_2', 'case_101', 'Employee Clicked Link', 'Analyst estimate: user clicked phishing link within 15 minutes of email receipt.', '2026-09-18 23:46 UTC', 'User Action', 'Critical'),
('tl_101_3', 'case_101', 'Credentials Harvested', 'Phishing page captured username and password via fake Novex login form.', '2026-09-18 23:47 UTC', 'Credential Theft', 'Critical'),
('tl_101_4', 'case_101', 'Attacker Login from Tor Exit Node', 'Successful login at 02:47 UTC from IP 185.220.101.47 (Tor exit node, Latvia). MFA was disabled.', '2026-09-19 02:47 UTC', 'Unauthorized Access', 'Critical'),
('tl_101_5', 'case_101', 'Password Changed', 'Attacker changed account password 38 seconds after login.', '2026-09-19 02:47 UTC', 'Account Manipulation', 'Critical'),
('tl_101_6', 'case_101', 'Recovery Email Hijacked', 'Recovery email redirected to attacker-controlled ProtonMail address.', '2026-09-19 02:49 UTC', 'Account Manipulation', 'Critical')
ON CONFLICT (id) DO UPDATE SET
    title              = EXCLUDED.title,
    description        = EXCLUDED.description,
    timeline_timestamp = EXCLUDED.timeline_timestamp,
    category           = EXCLUDED.category,
    severity           = EXCLUDED.severity;

INSERT INTO verdicts (id, case_id, summary_text, options, correct_option_index, explanation_text, xp_reward)
VALUES (
    'vd_101',
    'case_101',
    'Based on authentication logs, phishing email headers, and MFA status, identify the primary attack vector that led to the account compromise of Jamie Doren at Novex Corp.',
    '["Credential phishing via typosquatted domain with MFA disabled", "Brute-force password attack from multiple IPs", "Insider threat — employee voluntarily shared credentials", "SIM-swap attack bypassing SMS 2FA"]',
    0,
    'The attacker sent a phishing email from n0vex-corp.com (a typosquatted look-alike of novexcorp.internal). Because the target had disabled MFA, once credentials were captured via the fake login page, the attacker was able to log in from a Tor exit node without any second-factor challenge.',
    400
) ON CONFLICT (id) DO UPDATE SET
    summary_text        = EXCLUDED.summary_text,
    options             = EXCLUDED.options,
    correct_option_index = EXCLUDED.correct_option_index,
    explanation_text    = EXCLUDED.explanation_text,
    xp_reward           = EXCLUDED.xp_reward;


-- ── CASE 2: Phishing Email Investigation ────────────────────────────────────

INSERT INTO cases (id, case_code, title, description, priority, difficulty, status, assigned_date, notes, objectives)
VALUES (
    'case_102',
    'FSC-102',
    'Phishing Email Investigation',
    'A threat alert was triggered when the Valio Bank security gateway flagged an inbound email campaign targeting 847 employees. Three employees clicked embedded links before the alert. Analyze the email artifacts and identify the campaign type and threat actor objective.',
    'High',
    'Intermediate',
    'Open',
    '2026-09-22',
    'Focus on email headers, payload URL, and domain registration intelligence.',
    '["Extract and analyze full SMTP headers", "Identify the malicious payload delivery URL", "Determine threat actor objective (credential theft vs malware delivery)", "Classify the phishing campaign type"]'
) ON CONFLICT (id) DO UPDATE SET
    case_code    = EXCLUDED.case_code,
    title        = EXCLUDED.title,
    description  = EXCLUDED.description,
    priority     = EXCLUDED.priority,
    difficulty   = EXCLUDED.difficulty,
    status       = EXCLUDED.status,
    assigned_date = EXCLUDED.assigned_date,
    notes        = EXCLUDED.notes,
    objectives   = EXCLUDED.objectives;

INSERT INTO evidence (id, case_id, title, evidence_type, content_text, metadata_map, evidence_timestamp) VALUES
(
    'ev_102_1',
    'case_102',
    'Suspicious Email — Full SMTP Headers',
    'network',
    'Return-Path: <noreply@valio-bankportal.com>
Received: from smtp.valio-bankportal.com (smtp.valio-bankportal.com [91.108.56.201])
  by mx.valiobank.com with ESMTP id h3sm8201240wrp.16.2026.09.21.09.02.11
  for <employees@valiobank.com>
Date: Mon, 21 Sep 2026 09:01:47 -0000
From: "Valio Bank Security Team" <noreply@valio-bankportal.com>
To: employees@valiobank.com
Subject: [ACTION REQUIRED] Mandatory Security Verification — Deadline 48hrs
Message-ID: <20260921.090147.noreply@valio-bankportal.com>
X-Mailer: PHPMailer 6.5.1
Content-Type: text/html; charset=UTF-8
Authentication-Results: mx.valiobank.com;
   spf=fail (domain of valio-bankportal.com does not designate 91.108.56.201)
   dkim=none
   dmarc=fail',
    '{"Sending Domain": "valio-bankportal.com (SPOOFED — not valio-bank.com)", "Sender IP": "91.108.56.201", "IP ASN": "AS62240 - Clouvider Limited (Bulletproof Host)", "SPF": "FAIL", "DKIM": "NONE", "DMARC": "FAIL", "SHA-256": "d9e4a2b17c03f85a6d1b9e423c5f8a01"}',
    '2026-09-21 09:02:11 UTC'
),
(
    'ev_102_2',
    'case_102',
    'Payload URL Analysis',
    'network',
    'Embedded URL extracted from email HTML body:
https://valio-bankportal.com/verify?token=YWNjb3VudA&redirect=https://valiobank.com

Redirect Chain:
1. https://valio-bankportal.com/verify?token=... → 302 → 
2. https://valio-bankportal.com/signin (credential harvester page — form POST to /collect)
3. POST /collect → 200 OK (credentials stored server-side)
4. → 302 redirect to real https://valiobank.com (to avoid suspicion)

Credential harvester page title: "Valio Bank — Secure Login"
Page TLS cert: Let''s Encrypt (issued 2026-09-19, 2 days before campaign)',
    '{"Domain Registered": "2026-09-17 (4 days before campaign)", "Registrar": "NameSilo LLC", "Registrant": "PRIVACY PROTECTED", "Hosting IP": "91.108.56.201", "Certificate Issuer": "Let''s Encrypt", "Cert Valid From": "2026-09-19", "SHA-256": "e1f5b38d2a97c4061e2d8f593b1a2c04"}',
    '2026-09-21 09:01:47 UTC'
),
(
    'ev_102_3',
    'case_102',
    'Affected User Click Logs',
    'log',
    '2026-09-21 09:14:22 UTC | user=p.reeves@valiobank.com | url=https://valio-bankportal.com/verify?token=YWNjb3VudA | action=CLICK | result=CREDENTIALS_ENTERED
2026-09-21 09:19:57 UTC | user=k.walsh@valiobank.com  | url=https://valio-bankportal.com/verify?token=YWNjb3VudA | action=CLICK | result=CREDENTIALS_ENTERED
2026-09-21 09:33:11 UTC | user=m.chen@valiobank.com   | url=https://valio-bankportal.com/verify?token=YWNjb3VudA | action=CLICK | result=PAGE_BLOCKED (Gateway intervention)',
    '{"Source": "Valio Bank Web Proxy", "Total Clicks": "3", "Credentials Submitted": "2", "Blocked": "1", "Time Window": "09:14 to 09:33 UTC", "SHA-256": "f3a6c09e1b84d27f450e71b8c2d39a05"}',
    '2026-09-21 09:14:22 UTC'
)
ON CONFLICT (id) DO UPDATE SET
    title              = EXCLUDED.title,
    evidence_type      = EXCLUDED.evidence_type,
    content_text       = EXCLUDED.content_text,
    metadata_map       = EXCLUDED.metadata_map,
    evidence_timestamp = EXCLUDED.evidence_timestamp;

INSERT INTO case_timeline (id, case_id, title, description, timeline_timestamp, category, severity) VALUES
('tl_102_1', 'case_102', 'Domain Registered', 'Attacker registered valio-bankportal.com (typosquat of valio-bank.com) via NameSilo with privacy protection.', '2026-09-17 14:20 UTC', 'Infrastructure Setup', 'Medium'),
('tl_102_2', 'case_102', 'TLS Certificate Issued', 'Let''s Encrypt certificate obtained for valio-bankportal.com — providing HTTPS to increase victim trust.', '2026-09-19 08:15 UTC', 'Infrastructure Setup', 'Medium'),
('tl_102_3', 'case_102', 'Phishing Campaign Launched', '847 employees received the phishing email via bulletproof host 91.108.56.201. SPF/DMARC failures were not enforced by Valio Bank mail gateway.', '2026-09-21 09:01 UTC', 'Email Attack', 'High'),
('tl_102_4', 'case_102', 'First Employee Credential Captured', 'p.reeves@valiobank.com submitted credentials to harvester form within 12 minutes of email delivery.', '2026-09-21 09:14 UTC', 'Credential Theft', 'Critical'),
('tl_102_5', 'case_102', 'Second Employee Credential Captured', 'k.walsh@valiobank.com submitted credentials 5 minutes later.', '2026-09-21 09:19 UTC', 'Credential Theft', 'Critical'),
('tl_102_6', 'case_102', 'Gateway Blocked Third Attempt', 'Security gateway blocked m.chen@valiobank.com before credential submission. Alert triggered.', '2026-09-21 09:33 UTC', 'Defense', 'Low')
ON CONFLICT (id) DO UPDATE SET
    title              = EXCLUDED.title,
    description        = EXCLUDED.description,
    timeline_timestamp = EXCLUDED.timeline_timestamp,
    category           = EXCLUDED.category,
    severity           = EXCLUDED.severity;

INSERT INTO verdicts (id, case_id, summary_text, options, correct_option_index, explanation_text, xp_reward)
VALUES (
    'vd_102',
    'case_102',
    'After analyzing SMTP headers, the payload URL redirect chain, and victim click logs, classify the phishing campaign and identify the primary threat actor objective.',
    '["Credential harvesting phishing campaign using a typosquatted domain", "Business Email Compromise (BEC) targeting wire transfer authorization", "Malware delivery campaign embedding a macro-enabled document", "Spear-phishing against C-suite executives only"]',
    0,
    'Evidence clearly shows a credential harvesting operation: the attacker registered a typosquatted domain (valio-bankportal.com), deployed a fake login page, and redirected victims to the real bank site post-capture to avoid suspicion. All three click events confirm a credential theft objective, not malware delivery or BEC targeting.',
    600
) ON CONFLICT (id) DO UPDATE SET
    summary_text        = EXCLUDED.summary_text,
    options             = EXCLUDED.options,
    correct_option_index = EXCLUDED.correct_option_index,
    explanation_text    = EXCLUDED.explanation_text,
    xp_reward           = EXCLUDED.xp_reward;


-- ── CASE 3: QR Payment Fraud Investigation ──────────────────────────────────

INSERT INTO cases (id, case_code, title, description, priority, difficulty, status, assigned_date, notes, objectives)
VALUES (
    'case_103',
    'FSC-103',
    'QR Payment Fraud Investigation',
    'Multiple customers of Meridian Retail reported unauthorized transactions after scanning what appeared to be legitimate QR codes at self-checkout kiosks. Three kiosk terminals at different store locations were involved. Analyze the QR redirect logs, tampered physical hardware photos, and payment network alerts to determine the attack vector.',
    'Critical',
    'Advanced',
    'Open',
    '2026-09-25',
    'This is a physical-digital hybrid attack. Document the QR redirect chain and payment interception method.',
    '["Analyze QR code redirect chains from affected kiosks", "Identify the payment interception method (redirect vs skimmer)", "Determine which kiosk terminals were tampered", "Trace transaction funds destination where possible"]'
) ON CONFLICT (id) DO UPDATE SET
    case_code    = EXCLUDED.case_code,
    title        = EXCLUDED.title,
    description  = EXCLUDED.description,
    priority     = EXCLUDED.priority,
    difficulty   = EXCLUDED.difficulty,
    status       = EXCLUDED.status,
    assigned_date = EXCLUDED.assigned_date,
    notes        = EXCLUDED.notes,
    objectives   = EXCLUDED.objectives;

INSERT INTO evidence (id, case_id, title, evidence_type, content_text, metadata_map, evidence_timestamp) VALUES
(
    'ev_103_1',
    'case_103',
    'QR Code Redirect Log — Kiosk 7B',
    'log',
    '2026-09-24 14:22:51 UTC | kiosk=STORE_04_7B | qr_scan | original_url=https://pay.meridian-retail.com/checkout?order=88291 | redirect_to=https://pay.m3ridian-retail.com/checkout?order=88291 | customer_device=Samsung Galaxy S23
2026-09-24 14:23:05 UTC | kiosk=STORE_04_7B | payment_page_loaded | url=https://pay.m3ridian-retail.com | ssl_valid=YES (Let''s Encrypt) | amount_displayed=47.80
2026-09-24 14:23:44 UTC | kiosk=STORE_04_7B | payment_submitted | card_last4=9204 | result=CAPTURED_BY_GATEWAY_m3ridian | NOT_FORWARDED_TO_MERIDIAN_PROCESSOR',
    '{"Affected Kiosks": "STORE_04_7B, STORE_11_3A, STORE_07_1C", "Legitimate Domain": "pay.meridian-retail.com", "Fraudulent Domain": "pay.m3ridian-retail.com (substituting 3 for e)", "Fraudulent Domain Registered": "2026-09-20", "SSL Certificate": "Let''s Encrypt (auto-issued)", "SHA-256": "a7b9c12d3e04f561728a93b4c5d6e701"}',
    '2026-09-24 14:22:51 UTC'
),
(
    'ev_103_2',
    'case_103',
    'Physical Kiosk Inspection Report',
    'file',
    'MERIDIAN RETAIL — INCIDENT RESPONSE FIELD REPORT
Inspected by: Physical Security Team, 2026-09-24 18:30 UTC

STORE_04_7B: QR sticker overlaid on original kiosk-printed QR. Adhesive sticker approximately 62x62mm. Sticker QR encodes fraudulent URL. Original QR beneath still intact.
STORE_11_3A: Same method. Sticker discovered after customer complaint.
STORE_07_1C: Same method. Discovered during routine inspection triggered by this incident.
Unaffected kiosks (12 stores): QR codes checked — no overlays detected.

Sticker material: matte vinyl (widely available). No fingerprints recoverable. CCTV review pending.',
    '{"Report Author": "Marcus Webb, Physical Security Lead", "Terminals Inspected": "47 kiosk terminals across 15 store locations", "Tampered Terminals": "3", "Method": "Physical QR sticker overlay", "Forensic Evidence": "Stickers collected for analysis", "SHA-256": "b8c0d2e3f14a56781930b4c5d6e78201"}',
    '2026-09-24 18:30:00 UTC'
),
(
    'ev_103_3',
    'case_103',
    'Payment Network Fraud Alert',
    'network',
    'ALERT: Meridian Payment Gateway Fraud Detection
Timestamp: 2026-09-24 16:45:00 UTC
Alert Type: PAYMENT_REDIRECT_ANOMALY

Transactions identified as potentially fraudulent:
  TXN#88291 | $47.80 | Card ending 9204 | Routed to UNKNOWN_GATEWAY | NOT in Meridian processor
  TXN#88319 | $122.40 | Card ending 4471 | Same anomaly
  TXN#88334 | $38.95 | Card ending 8802 | Same anomaly

Destination payment processor: UNKNOWN — not affiliated with Meridian Retail.
Total exposure: $209.15 across 3 transactions.
Chargeback requests initiated by 2 of 3 customers.',
    '{"Alert Source": "Meridian Payment Gateway Anomaly Engine", "Transactions Affected": "3", "Total Value": "$209.15 USD", "Cards Compromised": "3", "Issuer Banks Notified": "YES", "SHA-256": "c9d1e3f402b57891a041c5d6e78f9301"}',
    '2026-09-24 16:45:00 UTC'
)
ON CONFLICT (id) DO UPDATE SET
    title              = EXCLUDED.title,
    evidence_type      = EXCLUDED.evidence_type,
    content_text       = EXCLUDED.content_text,
    metadata_map       = EXCLUDED.metadata_map,
    evidence_timestamp = EXCLUDED.evidence_timestamp;

INSERT INTO case_timeline (id, case_id, title, description, timeline_timestamp, category, severity) VALUES
('tl_103_1', 'case_103', 'Fraudulent Domain Registered', 'Attacker registered pay.m3ridian-retail.com (replacing e with 3) and obtained Let''s Encrypt SSL.', '2026-09-20 10:00 UTC', 'Infrastructure Setup', 'Medium'),
('tl_103_2', 'case_103', 'QR Stickers Placed on Kiosks', 'Attacker physically placed matte vinyl QR sticker overlays on 3 kiosk terminals across 3 store locations.', '2026-09-23 22:00 UTC', 'Physical Attack', 'Critical'),
('tl_103_3', 'case_103', 'First Fraudulent Payment Captured', 'Customer at STORE_04_7B scanned tampered QR, submitted payment to fraudulent gateway. $47.80 captured.', '2026-09-24 14:22 UTC', 'Financial Fraud', 'Critical'),
('tl_103_4', 'case_103', 'Additional Fraudulent Payments', 'Two more transactions at STORE_11_3A and STORE_07_1C. Total $209.15 diverted.', '2026-09-24 15:10 UTC', 'Financial Fraud', 'Critical'),
('tl_103_5', 'case_103', 'Fraud Alert Triggered', 'Meridian payment gateway anomaly engine flagged unrecognized payment processor routing.', '2026-09-24 16:45 UTC', 'Detection', 'High'),
('tl_103_6', 'case_103', 'Physical Inspection Confirms Tamper', 'All 47 kiosk terminals inspected. 3 confirmed tampered with physical QR sticker overlays.', '2026-09-24 18:30 UTC', 'Investigation', 'Medium')
ON CONFLICT (id) DO UPDATE SET
    title              = EXCLUDED.title,
    description        = EXCLUDED.description,
    timeline_timestamp = EXCLUDED.timeline_timestamp,
    category           = EXCLUDED.category,
    severity           = EXCLUDED.severity;

INSERT INTO verdicts (id, case_id, summary_text, options, correct_option_index, explanation_text, xp_reward)
VALUES (
    'vd_103',
    'case_103',
    'After reviewing QR redirect logs, physical inspection reports, and the payment fraud alert, determine the primary attack technique used in the Meridian Retail kiosk fraud.',
    '["Physical QR code sticker overlay redirecting payments to a typosquatted fraudulent domain", "Malware installed on kiosk POS terminals intercepting payment card data", "Man-in-the-middle attack on the kiosk WiFi network", "Insider threat — a store employee modified kiosk firmware"]',
    0,
    'The physical inspection confirmed matte vinyl QR sticker overlays were placed on 3 kiosk terminals. The QR codes encoded a typosquatted URL (pay.m3ridian-retail.com) that presented a convincing HTTPS payment page. This is a hybrid physical-digital attack — no malware or network interception was required. The simplicity of the sticker overlay method made it difficult to detect without close visual inspection.',
    800
) ON CONFLICT (id) DO UPDATE SET
    summary_text        = EXCLUDED.summary_text,
    options             = EXCLUDED.options,
    correct_option_index = EXCLUDED.correct_option_index,
    explanation_text    = EXCLUDED.explanation_text,
    xp_reward           = EXCLUDED.xp_reward;


-- ── CASE 4: Fake Online Store Investigation ──────────────────────────────────

INSERT INTO cases (id, case_code, title, description, priority, difficulty, status, assigned_date, notes, objectives)
VALUES (
    'case_104',
    'FSC-104',
    'Fake Online Store Investigation',
    'Consumer protection authorities referred a complaint from 14 individuals who purchased electronics from "TechVault Online" (techvault-shop.net) but never received goods. Investigate the website infrastructure, payment flow, and communication artifacts to classify the fraud type and establish the operator''s methods.',
    'High',
    'Intermediate',
    'Open',
    '2026-09-28',
    'Digital storefronts used for advance-fee fraud are common. Document the deceptive techniques used.',
    '["Analyze domain registration and hosting infrastructure", "Examine website payment processing setup", "Review victim communication transcripts", "Classify the online fraud type and operator method"]'
) ON CONFLICT (id) DO UPDATE SET
    case_code    = EXCLUDED.case_code,
    title        = EXCLUDED.title,
    description  = EXCLUDED.description,
    priority     = EXCLUDED.priority,
    difficulty   = EXCLUDED.difficulty,
    status       = EXCLUDED.status,
    assigned_date = EXCLUDED.assigned_date,
    notes        = EXCLUDED.notes,
    objectives   = EXCLUDED.objectives;

INSERT INTO evidence (id, case_id, title, evidence_type, content_text, metadata_map, evidence_timestamp) VALUES
(
    'ev_104_1',
    'case_104',
    'Domain WHOIS & Hosting Intelligence',
    'network',
    'Domain: techvault-shop.net
Registered: 2026-08-02 (52 days before complaints filed)
Registrar: Namecheap Inc.
Registrant: PRIVACY PROTECTED via WhoisGuard

Hosting IP: 167.99.224.73
ASN: AS14061 DigitalOcean LLC
Reverse DNS: ubuntu-s-1vcpu-1gb-fra1-01.example.com (default DigitalOcean droplet hostname)
TLS Certificate: Let''s Encrypt (issued 2026-08-03)
Alexa Rank: Not ranked (minimal legitimate traffic)
Wayback Machine Snapshots: 3 (first captured 2026-08-04)',
    '{"Domain Age": "52 days at time of first complaint", "Registrar": "Namecheap — WhoisGuard privacy", "Hosting Provider": "DigitalOcean (consumer-grade VPS)", "SSL": "Let''s Encrypt (free — automated)", "WHOIS Privacy": "YES — operator identity concealed", "SHA-256": "d0e2f415a6b7c8091132d4e5f67a8b02"}',
    '2026-09-28 10:00:00 UTC'
),
(
    'ev_104_2',
    'case_104',
    'Payment Gateway Analysis',
    'network',
    'TechVault Online payment page review (archived 2026-09-10):

Payment processors accepted:
  - Stripe (embedded checkout): Stripe Account ID: acct_1Px7fakeXXXXABC
  - Bitcoin wallet displayed: bc1q9fakewalletaddress0000000000000
  - "PayShield Escrow" (unverified third-party): payshield-secure.net

PayShield-secure.net analysis:
  Registered: 2026-08-01 (same operator suspected)
  Hosting: 167.99.224.81 (same /24 subnet as techvault-shop.net)
  No regulatory registration found in any jurisdiction
  Stripe account acct_1Px7fakeXXXXABC: SUSPENDED by Stripe on 2026-09-15 for fraud violations',
    '{"Stripe Account Status": "SUSPENDED — Stripe Fraud Policy Violation", "Bitcoin Wallet Transactions": "14 inbound (approx $4,200 total)", "PayShield Domain Owner": "Likely same operator — same hosting subnet", "Total Victim Payments": "$8,740 estimated", "SHA-256": "e1f306b5c7d8e9102243e5f6780b9c03"}',
    '2026-09-28 10:30:00 UTC'
),
(
    'ev_104_3',
    'case_104',
    'Victim Communication Transcripts',
    'file',
    'COMPLAINT #7 — Email chain (victim: Robin Ashford):
FROM: support@techvault-shop.net
"Thank you for your order #TVS-4471. Your Lenovo ThinkPad X1 Carbon (2026) will ship within 5-7 business days."
[14 days later — victim chases]
"Unfortunately there is a customs clearance delay. Please pay a $89 clearance fee to release your parcel."
[Victim paid fee — item never arrived]

COMPLAINT #12 — Email chain (victim: Dana Kruger):
"Your MacBook Pro order #TVS-5903 requires additional insurance payment of $110 before dispatch."
[Victim declined — item never shipped]

Pattern across 14 complaints: items never dispatched, advance fee requests made after initial payment.',
    '{"Total Complaints": "14", "Advance Fee Requests": "9 of 14 victims", "Average Order Value": "$624", "Total Advance Fees Collected": "$890", "Goods Delivered": "0", "SHA-256": "f2a417c6d8e9f0213354f607891c0d04"}',
    '2026-09-28 11:00:00 UTC'
)
ON CONFLICT (id) DO UPDATE SET
    title              = EXCLUDED.title,
    evidence_type      = EXCLUDED.evidence_type,
    content_text       = EXCLUDED.content_text,
    metadata_map       = EXCLUDED.metadata_map,
    evidence_timestamp = EXCLUDED.evidence_timestamp;

INSERT INTO case_timeline (id, case_id, title, description, timeline_timestamp, category, severity) VALUES
('tl_104_1', 'case_104', 'Fraudulent Infrastructure Created', 'techvault-shop.net and payshield-secure.net registered on same day. Hosted on same /24 subnet.', '2026-08-01 14:00 UTC', 'Infrastructure Setup', 'Medium'),
('tl_104_2', 'case_104', 'Store Launched', 'Fake electronics store went live with stolen product images and professional-looking storefront.', '2026-08-04 09:00 UTC', 'Fraud Execution', 'High'),
('tl_104_3', 'case_104', 'First Victim Orders', 'First 3 victims placed orders for high-value electronics. Payments received via Stripe and Bitcoin.', '2026-08-10 00:00 UTC', 'Fraud Execution', 'High'),
('tl_104_4', 'case_104', 'Advance Fee Requests Begin', 'Operator began requesting additional clearance/insurance fees from victims awaiting orders.', '2026-08-24 00:00 UTC', 'Fraud Escalation', 'Critical'),
('tl_104_5', 'case_104', 'Stripe Account Suspended', 'Stripe suspended merchant account acct_1Px7fakeXXXXABC for fraud policy violations after chargebacks.', '2026-09-15 00:00 UTC', 'Detection', 'High'),
('tl_104_6', 'case_104', 'Consumer Authority Referral', '14 complaints filed. Consumer protection authority referred case for digital forensic investigation.', '2026-09-28 09:00 UTC', 'Investigation', 'Medium')
ON CONFLICT (id) DO UPDATE SET
    title              = EXCLUDED.title,
    description        = EXCLUDED.description,
    timeline_timestamp = EXCLUDED.timeline_timestamp,
    category           = EXCLUDED.category,
    severity           = EXCLUDED.severity;

INSERT INTO verdicts (id, case_id, summary_text, options, correct_option_index, explanation_text, xp_reward)
VALUES (
    'vd_104',
    'case_104',
    'After analyzing the TechVault Online domain infrastructure, payment gateway setup, and victim communication transcripts, classify the fraud scheme and primary operational method.',
    '["Advance-fee fraud (419 scam variant) combined with non-delivery e-commerce fraud", "Credit card skimming operation embedded in the checkout page", "Ransomware delivery disguised as a retail checkout flow", "Business Email Compromise targeting TechVault''s real supplier"]',
    0,
    'TechVault Online operated a fake e-commerce store collecting payments for electronics that were never dispatched. After initial payment, the operator escalated to advance-fee fraud by requesting additional clearance/insurance fees. The consistent pattern across 14 victims, zero deliveries, suspended payment accounts, and same-subnet infrastructure all confirm a deliberate non-delivery and advance-fee fraud operation.',
    600
) ON CONFLICT (id) DO UPDATE SET
    summary_text        = EXCLUDED.summary_text,
    options             = EXCLUDED.options,
    correct_option_index = EXCLUDED.correct_option_index,
    explanation_text    = EXCLUDED.explanation_text,
    xp_reward           = EXCLUDED.xp_reward;


-- ── DONE ────────────────────────────────────────────────────────────────────
-- All fictional. No real people, organizations, IPs, or domains represented.
