<?php
/**
 * ForenShield — Investigation Cases Seeder (Parametric)
 * Uses PDO parameterized queries — no SQL injection issues.
 * DELETE or PROTECT this file after running in production.
 */
require_once __DIR__ . '/config.php';

$db = getDb();
$errors = [];
$seeded = [];

function upsertCase(PDO $db, array $c): void {
    $db->prepare("
        INSERT INTO cases (id, case_code, title, description, priority, difficulty, status, assigned_date, notes, objectives)
        VALUES (:id, :cc, :title, :desc, :pri, :diff, :status, :date, :notes, :obj)
        ON CONFLICT (id) DO UPDATE SET
            case_code=EXCLUDED.case_code, title=EXCLUDED.title, description=EXCLUDED.description,
            priority=EXCLUDED.priority, difficulty=EXCLUDED.difficulty, status=EXCLUDED.status,
            assigned_date=EXCLUDED.assigned_date, notes=EXCLUDED.notes, objectives=EXCLUDED.objectives
    ")->execute([
        'id'=>$c['id'],'cc'=>$c['case_code'],'title'=>$c['title'],'desc'=>$c['description'],
        'pri'=>$c['priority'],'diff'=>$c['difficulty'],'status'=>$c['status'],
        'date'=>$c['assigned_date'],'notes'=>$c['notes'],
        'obj'=>json_encode($c['objectives'])
    ]);
}

function upsertEvidence(PDO $db, array $e): void {
    $db->prepare("
        INSERT INTO evidence (id, case_id, title, evidence_type, content_text, metadata_map, evidence_timestamp)
        VALUES (:id, :cid, :title, :type, :content, :meta, :ts)
        ON CONFLICT (id) DO UPDATE SET
            title=EXCLUDED.title, evidence_type=EXCLUDED.evidence_type,
            content_text=EXCLUDED.content_text, metadata_map=EXCLUDED.metadata_map,
            evidence_timestamp=EXCLUDED.evidence_timestamp
    ")->execute([
        'id'=>$e['id'],'cid'=>$e['case_id'],'title'=>$e['title'],'type'=>$e['type'],
        'content'=>$e['content'],'meta'=>json_encode($e['metadata']),'ts'=>$e['timestamp']
    ]);
}

function upsertTimeline(PDO $db, array $t): void {
    $db->prepare("
        INSERT INTO case_timeline (id, case_id, title, description, timeline_timestamp, category, severity)
        VALUES (:id, :cid, :title, :desc, :ts, :cat, :sev)
        ON CONFLICT (id) DO UPDATE SET
            title=EXCLUDED.title, description=EXCLUDED.description,
            timeline_timestamp=EXCLUDED.timeline_timestamp,
            category=EXCLUDED.category, severity=EXCLUDED.severity
    ")->execute([
        'id'=>$t['id'],'cid'=>$t['case_id'],'title'=>$t['title'],'desc'=>$t['description'],
        'ts'=>$t['timestamp'],'cat'=>$t['category'],'sev'=>$t['severity']
    ]);
}

function upsertVerdict(PDO $db, array $v): void {
    $db->prepare("
        INSERT INTO verdicts (id, case_id, summary_text, options, correct_option_index, explanation_text, xp_reward)
        VALUES (:id, :cid, :summary, :options, :correct, :explanation, :xp)
        ON CONFLICT (id) DO UPDATE SET
            summary_text=EXCLUDED.summary_text, options=EXCLUDED.options,
            correct_option_index=EXCLUDED.correct_option_index,
            explanation_text=EXCLUDED.explanation_text, xp_reward=EXCLUDED.xp_reward
    ")->execute([
        'id'=>$v['id'],'cid'=>$v['case_id'],'summary'=>$v['summary'],
        'options'=>json_encode($v['options']),'correct'=>$v['correct'],
        'explanation'=>$v['explanation'],'xp'=>$v['xp']
    ]);
}

// ── CASE 1: Suspicious Account Login ─────────────────────────────────────────
try {
    upsertCase($db, [
        'id'=>'case_101','case_code'=>'FSC-101','title'=>'Suspicious Account Login',
        'description'=>'A corporate helpdesk received an alert that the employee account of "Jamie Doren" at Novex Corp was logged into from an unfamiliar location in the middle of the night. Investigate the login event logs and determine whether this was a credential-based attack.',
        'priority'=>'Medium','difficulty'=>'Beginner','status'=>'Open',
        'assigned_date'=>'2026-09-20',
        'notes'=>'Focus on authentication logs and IP geolocation anomalies.',
        'objectives'=>['Analyze authentication event logs','Identify the suspicious login source IP','Determine if multi-factor authentication was bypassed','Formulate the most likely attack vector']
    ]);
    $seeded[] = 'case_101';
} catch(Exception $e){ $errors[] = 'case_101: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_101_1','case_id'=>'case_101','title'=>'Authentication Log Extract','type'=>'log',
        'content'=>"2026-09-19 02:47:13 UTC [AUTH] LOGIN_SUCCESS user=j.doren@novexcorp.internal src_ip=185.220.101.47 device=Unknown-Linux user_agent=Mozilla/5.0 mfa_used=false\n2026-09-19 02:47:51 UTC [AUTH] PASSWORD_CHANGE user=j.doren@novexcorp.internal initiated_from=185.220.101.47\n2026-09-19 02:49:02 UTC [AUTH] EMAIL_CHANGED user=j.doren@novexcorp.internal new=j.doren.recovr@protonmail.com",
        'metadata'=>['Source'=>'Novex SIEM Platform','Log Type'=>'Authentication Events','Time Range'=>'2026-09-19 02:45 to 02:55 UTC','SHA-256'=>'a3f8d1b2c9e74f6180a21c4e5b9d7f3a','Analyst Note'=>'IP 185.220.101.47 is a known Tor exit node'],
        'timestamp'=>'2026-09-19 02:47:13 UTC'
    ]);
    $seeded[] = 'ev_101_1';
} catch(Exception $e){ $errors[] = 'ev_101_1: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_101_2','case_id'=>'case_101','title'=>'Phishing Email Headers','type'=>'network',
        'content'=>"From: \"Novex IT Security\" <security-alert@n0vex-corp.com>\nTo: j.doren@novexcorp.internal\nSubject: [URGENT] Your account requires immediate verification\nDate: 2026-09-18 23:31:05 UTC\n\nReceived: from mail.n0vex-corp.com (185.220.101.47)\nX-Originating-IP: 185.220.101.47\nSPF: FAIL | DKIM: NONE | DMARC: FAIL\n\nBody contains link: http://novex-verify.suspicious-domain.net/login?token=AbC123XyZ",
        'metadata'=>['Domain'=>'n0vex-corp.com (TYPOSQUATTED)','Sender IP'=>'185.220.101.47','SPF Check'=>'FAIL','DKIM'=>'NOT PRESENT','DMARC'=>'FAIL','SHA-256'=>'b8c221a9d04e7b3f91a55e8d2c106473'],
        'timestamp'=>'2026-09-18 23:31:05 UTC'
    ]);
    $seeded[] = 'ev_101_2';
} catch(Exception $e){ $errors[] = 'ev_101_2: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_101_3','case_id'=>'case_101','title'=>'Employee Credential Database Entry','type'=>'file',
        'content'=>"User Record:\n  Username:    j.doren\n  Full Name:   Jamie Doren\n  Department:  Finance - Accounts Payable\n  MFA Status:  DISABLED (opt-out requested 2026-07-14)\n  Last Normal Login: 2026-09-18 09:12 UTC from 10.2.4.88 (Corporate VPN)\n  Last Password Reset: 2026-09-19 02:47 UTC FROM UNKNOWN EXTERNAL IP",
        'metadata'=>['Source'=>'Novex HR Identity Platform','Record Type'=>'User Profile','Access Level'=>'Finance Internal','SHA-256'=>'c7d33e4a12b891f0234a6b7c8d9e1f02'],
        'timestamp'=>'2026-09-18 09:12:00 UTC'
    ]);
    $seeded[] = 'ev_101_3';
} catch(Exception $e){ $errors[] = 'ev_101_3: '.$e->getMessage(); }

$timeline101 = [
    ['id'=>'tl_101_1','case_id'=>'case_101','title'=>'Phishing Email Delivered','description'=>'Typosquatted domain email delivered to j.doren@novexcorp.internal bypassing spam filter.','timestamp'=>'2026-09-18 23:31 UTC','category'=>'Email Attack','severity'=>'High'],
    ['id'=>'tl_101_2','case_id'=>'case_101','title'=>'Employee Clicked Link','description'=>'Analyst estimate: user clicked phishing link within 15 minutes of email receipt.','timestamp'=>'2026-09-18 23:46 UTC','category'=>'User Action','severity'=>'Critical'],
    ['id'=>'tl_101_3','case_id'=>'case_101','title'=>'Credentials Harvested','description'=>'Phishing page captured username and password via fake Novex login form.','timestamp'=>'2026-09-18 23:47 UTC','category'=>'Credential Theft','severity'=>'Critical'],
    ['id'=>'tl_101_4','case_id'=>'case_101','title'=>'Attacker Login from Tor Exit Node','description'=>'Successful login at 02:47 UTC from IP 185.220.101.47 (Tor exit node, Latvia). MFA was disabled.','timestamp'=>'2026-09-19 02:47 UTC','category'=>'Unauthorized Access','severity'=>'Critical'],
    ['id'=>'tl_101_5','case_id'=>'case_101','title'=>'Password Changed','description'=>'Attacker changed account password 38 seconds after login.','timestamp'=>'2026-09-19 02:47 UTC','category'=>'Account Manipulation','severity'=>'Critical'],
    ['id'=>'tl_101_6','case_id'=>'case_101','title'=>'Recovery Email Hijacked','description'=>'Recovery email redirected to attacker-controlled ProtonMail address.','timestamp'=>'2026-09-19 02:49 UTC','category'=>'Account Manipulation','severity'=>'Critical'],
];
foreach($timeline101 as $t){ try{ upsertTimeline($db,$t); $seeded[]=$t['id']; }catch(Exception $e){ $errors[]=$t['id'].': '.$e->getMessage(); } }

try {
    upsertVerdict($db, [
        'id'=>'vd_101','case_id'=>'case_101',
        'summary'=>'Based on authentication logs, phishing email headers, and MFA status, identify the primary attack vector that led to the account compromise of Jamie Doren at Novex Corp.',
        'options'=>['Credential phishing via typosquatted domain with MFA disabled','Brute-force password attack from multiple IPs','Insider threat - employee voluntarily shared credentials','SIM-swap attack bypassing SMS 2FA'],
        'correct'=>0,
        'explanation'=>'The attacker sent a phishing email from n0vex-corp.com (a typosquatted look-alike). Because the target had disabled MFA, once credentials were captured via the fake login page, the attacker logged in from a Tor exit node without any second-factor challenge.',
        'xp'=>400
    ]);
    $seeded[] = 'vd_101';
} catch(Exception $e){ $errors[] = 'vd_101: '.$e->getMessage(); }

// ── CASE 2: Phishing Email Investigation ─────────────────────────────────────
try {
    upsertCase($db, [
        'id'=>'case_102','case_code'=>'FSC-102','title'=>'Phishing Email Investigation',
        'description'=>'A threat alert was triggered when the Valio Bank security gateway flagged an inbound email campaign targeting 847 employees. Three employees clicked embedded links before the alert. Analyze the email artifacts and identify the campaign type and threat actor objective.',
        'priority'=>'High','difficulty'=>'Intermediate','status'=>'Open',
        'assigned_date'=>'2026-09-22',
        'notes'=>'Focus on email headers, payload URL, and domain registration intelligence.',
        'objectives'=>['Extract and analyze full SMTP headers','Identify the malicious payload delivery URL','Determine threat actor objective (credential theft vs malware delivery)','Classify the phishing campaign type']
    ]);
    $seeded[] = 'case_102';
} catch(Exception $e){ $errors[] = 'case_102: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_102_1','case_id'=>'case_102','title'=>'Suspicious Email - Full SMTP Headers','type'=>'network',
        'content'=>"Return-Path: <noreply@valio-bankportal.com>\nReceived: from smtp.valio-bankportal.com [91.108.56.201]\n  by mx.valiobank.com with ESMTP\nDate: Mon, 21 Sep 2026 09:01:47 -0000\nFrom: \"Valio Bank Security Team\" <noreply@valio-bankportal.com>\nTo: employees@valiobank.com\nSubject: [ACTION REQUIRED] Mandatory Security Verification - Deadline 48hrs\nX-Mailer: PHPMailer 6.5.1\nAuthentication-Results: mx.valiobank.com;\n   spf=fail\n   dkim=none\n   dmarc=fail",
        'metadata'=>['Sending Domain'=>'valio-bankportal.com (SPOOFED)','Sender IP'=>'91.108.56.201','IP ASN'=>'AS62240 - Clouvider Limited (Bulletproof Host)','SPF'=>'FAIL','DKIM'=>'NONE','DMARC'=>'FAIL','SHA-256'=>'d9e4a2b17c03f85a6d1b9e423c5f8a01'],
        'timestamp'=>'2026-09-21 09:02:11 UTC'
    ]);
    $seeded[] = 'ev_102_1';
} catch(Exception $e){ $errors[] = 'ev_102_1: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_102_2','case_id'=>'case_102','title'=>'Payload URL Analysis','type'=>'network',
        'content'=>"Embedded URL from email HTML body:\nhttps://valio-bankportal.com/verify?token=YWNjb3VudA&redirect=https://valiobank.com\n\nRedirect Chain:\n1. /verify?token=... -> 302 ->\n2. /signin (credential harvester, POST to /collect)\n3. Credentials stored server-side\n4. 302 redirect to real valiobank.com (to avoid suspicion)\n\nPage TLS cert: Let's Encrypt (issued 2026-09-19, 2 days before campaign)",
        'metadata'=>['Domain Registered'=>'2026-09-17 (4 days before campaign)','Registrar'=>'NameSilo LLC','Registrant'=>'PRIVACY PROTECTED','Hosting IP'=>'91.108.56.201','Certificate Issuer'=>"Let's Encrypt",'SHA-256'=>'e1f5b38d2a97c4061e2d8f593b1a2c04'],
        'timestamp'=>'2026-09-21 09:01:47 UTC'
    ]);
    $seeded[] = 'ev_102_2';
} catch(Exception $e){ $errors[] = 'ev_102_2: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_102_3','case_id'=>'case_102','title'=>'Affected User Click Logs','type'=>'log',
        'content'=>"2026-09-21 09:14:22 UTC | user=p.reeves@valiobank.com | action=CLICK | result=CREDENTIALS_ENTERED\n2026-09-21 09:19:57 UTC | user=k.walsh@valiobank.com | action=CLICK | result=CREDENTIALS_ENTERED\n2026-09-21 09:33:11 UTC | user=m.chen@valiobank.com | action=CLICK | result=PAGE_BLOCKED (Gateway intervention)",
        'metadata'=>['Source'=>'Valio Bank Web Proxy','Total Clicks'=>'3','Credentials Submitted'=>'2','Blocked'=>'1','Time Window'=>'09:14 to 09:33 UTC','SHA-256'=>'f3a6c09e1b84d27f450e71b8c2d39a05'],
        'timestamp'=>'2026-09-21 09:14:22 UTC'
    ]);
    $seeded[] = 'ev_102_3';
} catch(Exception $e){ $errors[] = 'ev_102_3: '.$e->getMessage(); }

$timeline102 = [
    ['id'=>'tl_102_1','case_id'=>'case_102','title'=>'Domain Registered','description'=>'Attacker registered valio-bankportal.com (typosquat) via NameSilo with privacy protection.','timestamp'=>'2026-09-17 14:20 UTC','category'=>'Infrastructure Setup','severity'=>'Medium'],
    ['id'=>'tl_102_2','case_id'=>'case_102','title'=>'TLS Certificate Issued','description'=> "Let's Encrypt certificate obtained for valio-bankportal.com to increase victim trust.",'timestamp'=>'2026-09-19 08:15 UTC','category'=>'Infrastructure Setup','severity'=>'Medium'],
    ['id'=>'tl_102_3','case_id'=>'case_102','title'=>'Phishing Campaign Launched','description'=>'847 employees received the phishing email via bulletproof host 91.108.56.201.','timestamp'=>'2026-09-21 09:01 UTC','category'=>'Email Attack','severity'=>'High'],
    ['id'=>'tl_102_4','case_id'=>'case_102','title'=>'First Employee Credential Captured','description'=>'p.reeves@valiobank.com submitted credentials within 12 minutes of email delivery.','timestamp'=>'2026-09-21 09:14 UTC','category'=>'Credential Theft','severity'=>'Critical'],
    ['id'=>'tl_102_5','case_id'=>'case_102','title'=>'Second Employee Credential Captured','description'=>'k.walsh@valiobank.com submitted credentials 5 minutes later.','timestamp'=>'2026-09-21 09:19 UTC','category'=>'Credential Theft','severity'=>'Critical'],
    ['id'=>'tl_102_6','case_id'=>'case_102','title'=>'Gateway Blocked Third Attempt','description'=>'Security gateway blocked m.chen@valiobank.com before credential submission. Alert triggered.','timestamp'=>'2026-09-21 09:33 UTC','category'=>'Defense','severity'=>'Low'],
];
foreach($timeline102 as $t){ try{ upsertTimeline($db,$t); $seeded[]=$t['id']; }catch(Exception $e){ $errors[]=$t['id'].': '.$e->getMessage(); } }

try {
    upsertVerdict($db, [
        'id'=>'vd_102','case_id'=>'case_102',
        'summary'=>'After analyzing SMTP headers, the payload URL redirect chain, and victim click logs, classify the phishing campaign and identify the primary threat actor objective.',
        'options'=>['Credential harvesting phishing campaign using a typosquatted domain','Business Email Compromise (BEC) targeting wire transfer authorization','Malware delivery campaign embedding a macro-enabled document','Spear-phishing against C-suite executives only'],
        'correct'=>0,
        'explanation'=>'Evidence clearly shows a credential harvesting operation: the attacker registered a typosquatted domain, deployed a fake login page, and redirected victims to the real bank site post-capture to avoid suspicion. All three click events confirm a credential theft objective, not malware delivery or BEC targeting.',
        'xp'=>600
    ]);
    $seeded[] = 'vd_102';
} catch(Exception $e){ $errors[] = 'vd_102: '.$e->getMessage(); }

// ── CASE 3: QR Payment Fraud ──────────────────────────────────────────────────
try {
    upsertCase($db, [
        'id'=>'case_103','case_code'=>'FSC-103','title'=>'QR Payment Fraud Investigation',
        'description'=>'Multiple customers of Meridian Retail reported unauthorized transactions after scanning QR codes at self-checkout kiosks. Three kiosk terminals at different store locations were involved. Analyze QR redirect logs, tampered physical hardware reports, and payment network alerts.',
        'priority'=>'Critical','difficulty'=>'Advanced','status'=>'Open',
        'assigned_date'=>'2026-09-25',
        'notes'=>'This is a physical-digital hybrid attack. Document the QR redirect chain and payment interception method.',
        'objectives'=>['Analyze QR code redirect chains from affected kiosks','Identify the payment interception method','Determine which kiosk terminals were tampered','Trace transaction funds destination where possible']
    ]);
    $seeded[] = 'case_103';
} catch(Exception $e){ $errors[] = 'case_103: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_103_1','case_id'=>'case_103','title'=>'QR Code Redirect Log - Kiosk 7B','type'=>'log',
        'content'=>"2026-09-24 14:22:51 UTC | kiosk=STORE_04_7B | qr_scan | original_url=https://pay.meridian-retail.com/checkout?order=88291 | redirect_to=https://pay.m3ridian-retail.com/checkout?order=88291\n2026-09-24 14:23:05 UTC | payment_page_loaded | url=https://pay.m3ridian-retail.com | ssl_valid=YES | amount_displayed=47.80\n2026-09-24 14:23:44 UTC | payment_submitted | card_last4=9204 | result=CAPTURED_BY_GATEWAY_m3ridian | NOT_FORWARDED_TO_MERIDIAN_PROCESSOR",
        'metadata'=>['Affected Kiosks'=>'STORE_04_7B, STORE_11_3A, STORE_07_1C','Legitimate Domain'=>'pay.meridian-retail.com','Fraudulent Domain'=>'pay.m3ridian-retail.com (substituting 3 for e)','Fraudulent Domain Registered'=>'2026-09-20','SSL Certificate'=>"Let's Encrypt (auto-issued)",'SHA-256'=>'a7b9c12d3e04f561728a93b4c5d6e701'],
        'timestamp'=>'2026-09-24 14:22:51 UTC'
    ]);
    $seeded[] = 'ev_103_1';
} catch(Exception $e){ $errors[] = 'ev_103_1: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_103_2','case_id'=>'case_103','title'=>'Physical Kiosk Inspection Report','type'=>'file',
        'content'=>"MERIDIAN RETAIL - INCIDENT RESPONSE FIELD REPORT\nInspected by: Physical Security Team, 2026-09-24 18:30 UTC\n\nSTORE_04_7B: QR sticker overlaid on original kiosk-printed QR. Adhesive sticker approximately 62x62mm. Sticker QR encodes fraudulent URL.\nSTORE_11_3A: Same method. Sticker discovered after customer complaint.\nSTORE_07_1C: Same method. Discovered during routine inspection triggered by this incident.\nUnaffected kiosks (12 stores): QR codes checked - no overlays detected.\n\nSticker material: matte vinyl (widely available). No fingerprints recoverable. CCTV review pending.",
        'metadata'=>['Report Author'=>'Marcus Webb, Physical Security Lead','Terminals Inspected'=>'47 kiosk terminals across 15 store locations','Tampered Terminals'=>'3','Method'=>'Physical QR sticker overlay','Forensic Evidence'=>'Stickers collected for analysis','SHA-256'=>'b8c0d2e3f14a56781930b4c5d6e78201'],
        'timestamp'=>'2026-09-24 18:30:00 UTC'
    ]);
    $seeded[] = 'ev_103_2';
} catch(Exception $e){ $errors[] = 'ev_103_2: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_103_3','case_id'=>'case_103','title'=>'Payment Network Fraud Alert','type'=>'network',
        'content'=>"ALERT: Meridian Payment Gateway Fraud Detection\nTimestamp: 2026-09-24 16:45:00 UTC\nAlert Type: PAYMENT_REDIRECT_ANOMALY\n\nTransactions identified as potentially fraudulent:\n  TXN#88291 | \$47.80 | Card ending 9204 | Routed to UNKNOWN_GATEWAY\n  TXN#88319 | \$122.40 | Card ending 4471 | Same anomaly\n  TXN#88334 | \$38.95 | Card ending 8802 | Same anomaly\n\nTotal exposure: \$209.15 across 3 transactions.",
        'metadata'=>['Alert Source'=>'Meridian Payment Gateway Anomaly Engine','Transactions Affected'=>'3','Total Value'=>'$209.15 USD','Cards Compromised'=>'3','Issuer Banks Notified'=>'YES','SHA-256'=>'c9d1e3f402b57891a041c5d6e78f9301'],
        'timestamp'=>'2026-09-24 16:45:00 UTC'
    ]);
    $seeded[] = 'ev_103_3';
} catch(Exception $e){ $errors[] = 'ev_103_3: '.$e->getMessage(); }

$timeline103 = [
    ['id'=>'tl_103_1','case_id'=>'case_103','title'=>'Fraudulent Domain Registered','description'=>"Attacker registered pay.m3ridian-retail.com (replacing e with 3) and obtained Let's Encrypt SSL.",'timestamp'=>'2026-09-20 10:00 UTC','category'=>'Infrastructure Setup','severity'=>'Medium'],
    ['id'=>'tl_103_2','case_id'=>'case_103','title'=>'QR Stickers Placed on Kiosks','description'=>'Attacker physically placed matte vinyl QR sticker overlays on 3 kiosk terminals across 3 store locations.','timestamp'=>'2026-09-23 22:00 UTC','category'=>'Physical Attack','severity'=>'Critical'],
    ['id'=>'tl_103_3','case_id'=>'case_103','title'=>'First Fraudulent Payment Captured','description'=>'Customer at STORE_04_7B scanned tampered QR, submitted payment to fraudulent gateway. $47.80 captured.','timestamp'=>'2026-09-24 14:22 UTC','category'=>'Financial Fraud','severity'=>'Critical'],
    ['id'=>'tl_103_4','case_id'=>'case_103','title'=>'Additional Fraudulent Payments','description'=>'Two more transactions at STORE_11_3A and STORE_07_1C. Total $209.15 diverted.','timestamp'=>'2026-09-24 15:10 UTC','category'=>'Financial Fraud','severity'=>'Critical'],
    ['id'=>'tl_103_5','case_id'=>'case_103','title'=>'Fraud Alert Triggered','description'=>'Meridian payment gateway anomaly engine flagged unrecognized payment processor routing.','timestamp'=>'2026-09-24 16:45 UTC','category'=>'Detection','severity'=>'High'],
    ['id'=>'tl_103_6','case_id'=>'case_103','title'=>'Physical Inspection Confirms Tamper','description'=>'All 47 kiosk terminals inspected. 3 confirmed tampered with physical QR sticker overlays.','timestamp'=>'2026-09-24 18:30 UTC','category'=>'Investigation','severity'=>'Medium'],
];
foreach($timeline103 as $t){ try{ upsertTimeline($db,$t); $seeded[]=$t['id']; }catch(Exception $e){ $errors[]=$t['id'].': '.$e->getMessage(); } }

try {
    upsertVerdict($db, [
        'id'=>'vd_103','case_id'=>'case_103',
        'summary'=>'After reviewing QR redirect logs, physical inspection reports, and the payment fraud alert, determine the primary attack technique used in the Meridian Retail kiosk fraud.',
        'options'=>['Physical QR code sticker overlay redirecting payments to a typosquatted fraudulent domain','Malware installed on kiosk POS terminals intercepting payment card data','Man-in-the-middle attack on the kiosk WiFi network','Insider threat - a store employee modified kiosk firmware'],
        'correct'=>0,
        'explanation'=>'The physical inspection confirmed matte vinyl QR sticker overlays were placed on 3 kiosk terminals. The QR codes encoded a typosquatted URL (pay.m3ridian-retail.com) presenting a convincing HTTPS payment page. This is a hybrid physical-digital attack - no malware or network interception was required.',
        'xp'=>800
    ]);
    $seeded[] = 'vd_103';
} catch(Exception $e){ $errors[] = 'vd_103: '.$e->getMessage(); }

// ── CASE 4: Fake Online Store ─────────────────────────────────────────────────
try {
    upsertCase($db, [
        'id'=>'case_104','case_code'=>'FSC-104','title'=>'Fake Online Store Investigation',
        'description'=>"Consumer protection authorities referred a complaint from 14 individuals who purchased electronics from \"TechVault Online\" (techvault-shop.net) but never received goods. Investigate the website infrastructure, payment flow, and communication artifacts to classify the fraud type.",
        'priority'=>'High','difficulty'=>'Intermediate','status'=>'Open',
        'assigned_date'=>'2026-09-28',
        'notes'=>'Digital storefronts used for advance-fee fraud are common. Document the deceptive techniques used.',
        'objectives'=>['Analyze domain registration and hosting infrastructure','Examine website payment processing setup','Review victim communication transcripts','Classify the online fraud type and operator method']
    ]);
    $seeded[] = 'case_104';
} catch(Exception $e){ $errors[] = 'case_104: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_104_1','case_id'=>'case_104','title'=>'Domain WHOIS and Hosting Intelligence','type'=>'network',
        'content'=>"Domain: techvault-shop.net\nRegistered: 2026-08-02 (52 days before complaints filed)\nRegistrar: Namecheap Inc.\nRegistrant: PRIVACY PROTECTED via WhoisGuard\n\nHosting IP: 167.99.224.73\nASN: AS14061 DigitalOcean LLC\nReverse DNS: ubuntu-s-1vcpu-1gb-fra1-01.example.com (default DigitalOcean hostname)\nTLS Certificate: Let's Encrypt (issued 2026-08-03)\nAlexa Rank: Not ranked (minimal legitimate traffic)\nWayback Machine Snapshots: 3 (first captured 2026-08-04)",
        'metadata'=>['Domain Age'=>'52 days at time of first complaint','Registrar'=>'Namecheap - WhoisGuard privacy','Hosting Provider'=>'DigitalOcean (consumer-grade VPS)','SSL'=>"Let's Encrypt (free - automated)",'WHOIS Privacy'=>'YES - operator identity concealed','SHA-256'=>'d0e2f415a6b7c8091132d4e5f67a8b02'],
        'timestamp'=>'2026-09-28 10:00:00 UTC'
    ]);
    $seeded[] = 'ev_104_1';
} catch(Exception $e){ $errors[] = 'ev_104_1: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_104_2','case_id'=>'case_104','title'=>'Payment Gateway Analysis','type'=>'network',
        'content'=>"TechVault Online payment page review (archived 2026-09-10):\n\nPayment processors accepted:\n  - Stripe (embedded checkout): Stripe Account ID: acct_1Px7fakeXXXXABC\n  - Bitcoin wallet: bc1q9fakewalletaddress0000000000000\n  - PayShield Escrow (unverified): payshield-secure.net\n\nPayShield-secure.net analysis:\n  Registered: 2026-08-01 (same operator suspected)\n  Hosting: 167.99.224.81 (same /24 subnet as techvault-shop.net)\n  No regulatory registration found in any jurisdiction\n\nStripe account SUSPENDED on 2026-09-15 for fraud violations",
        'metadata'=>['Stripe Account Status'=>'SUSPENDED - Stripe Fraud Policy Violation','Bitcoin Wallet Transactions'=>'14 inbound (approx $4,200 total)','PayShield Domain Owner'=>'Likely same operator - same hosting subnet','Total Victim Payments'=>'$8,740 estimated','SHA-256'=>'e1f306b5c7d8e9102243e5f6780b9c03'],
        'timestamp'=>'2026-09-28 10:30:00 UTC'
    ]);
    $seeded[] = 'ev_104_2';
} catch(Exception $e){ $errors[] = 'ev_104_2: '.$e->getMessage(); }

try {
    upsertEvidence($db, [
        'id'=>'ev_104_3','case_id'=>'case_104','title'=>'Victim Communication Transcripts','type'=>'file',
        'content'=>"COMPLAINT #7 - Email chain (victim: Robin Ashford):\nFROM: support@techvault-shop.net\n\"Your Lenovo ThinkPad X1 Carbon order will ship within 5-7 business days.\"\n[14 days later - victim chases]\n\"Unfortunately there is a customs clearance delay. Please pay a \$89 clearance fee.\"\n[Victim paid fee - item never arrived]\n\nCOMPLAINT #12 - Email chain (victim: Dana Kruger):\n\"Your MacBook Pro order requires additional insurance payment of \$110 before dispatch.\"\n[Victim declined - item never shipped]\n\nPattern across 14 complaints: items never dispatched, advance fee requests made after initial payment.",
        'metadata'=>['Total Complaints'=>'14','Advance Fee Requests'=>'9 of 14 victims','Average Order Value'=>'$624','Total Advance Fees Collected'=>'$890','Goods Delivered'=>'0','SHA-256'=>'f2a417c6d8e9f0213354f607891c0d04'],
        'timestamp'=>'2026-09-28 11:00:00 UTC'
    ]);
    $seeded[] = 'ev_104_3';
} catch(Exception $e){ $errors[] = 'ev_104_3: '.$e->getMessage(); }

$timeline104 = [
    ['id'=>'tl_104_1','case_id'=>'case_104','title'=>'Fraudulent Infrastructure Created','description'=>'techvault-shop.net and payshield-secure.net registered on same day, hosted on same /24 subnet.','timestamp'=>'2026-08-01 14:00 UTC','category'=>'Infrastructure Setup','severity'=>'Medium'],
    ['id'=>'tl_104_2','case_id'=>'case_104','title'=>'Store Launched','description'=>'Fake electronics store went live with stolen product images and professional-looking storefront.','timestamp'=>'2026-08-04 09:00 UTC','category'=>'Fraud Execution','severity'=>'High'],
    ['id'=>'tl_104_3','case_id'=>'case_104','title'=>'First Victim Orders','description'=>'First 3 victims placed orders for high-value electronics. Payments received via Stripe and Bitcoin.','timestamp'=>'2026-08-10 00:00 UTC','category'=>'Fraud Execution','severity'=>'High'],
    ['id'=>'tl_104_4','case_id'=>'case_104','title'=>'Advance Fee Requests Begin','description'=>'Operator began requesting additional clearance/insurance fees from victims awaiting orders.','timestamp'=>'2026-08-24 00:00 UTC','category'=>'Fraud Escalation','severity'=>'Critical'],
    ['id'=>'tl_104_5','case_id'=>'case_104','title'=>'Stripe Account Suspended','description'=>'Stripe suspended merchant account acct_1Px7fakeXXXXABC for fraud policy violations after chargebacks.','timestamp'=>'2026-09-15 00:00 UTC','category'=>'Detection','severity'=>'High'],
    ['id'=>'tl_104_6','case_id'=>'case_104','title'=>'Consumer Authority Referral','description'=>'14 complaints filed. Consumer protection authority referred case for digital forensic investigation.','timestamp'=>'2026-09-28 09:00 UTC','category'=>'Investigation','severity'=>'Medium'],
];
foreach($timeline104 as $t){ try{ upsertTimeline($db,$t); $seeded[]=$t['id']; }catch(Exception $e){ $errors[]=$t['id'].': '.$e->getMessage(); } }

try {
    upsertVerdict($db, [
        'id'=>'vd_104','case_id'=>'case_104',
        'summary'=>"After analyzing TechVault Online's domain infrastructure, payment gateway setup, and victim communication transcripts, classify the fraud scheme and primary operational method.",
        'options'=>['Advance-fee fraud (419 scam variant) combined with non-delivery e-commerce fraud','Credit card skimming operation embedded in the checkout page','Ransomware delivery disguised as a retail checkout flow',"Business Email Compromise targeting TechVault's real supplier"],
        'correct'=>0,
        'explanation'=>"TechVault Online operated a fake e-commerce store collecting payments for electronics that were never dispatched. After initial payment, the operator escalated to advance-fee fraud by requesting additional clearance/insurance fees. The consistent pattern across 14 victims, zero deliveries, and suspended payment accounts confirm a deliberate non-delivery and advance-fee fraud operation.",
        'xp'=>600
    ]);
    $seeded[] = 'vd_104';
} catch(Exception $e){ $errors[] = 'vd_104: '.$e->getMessage(); }

// ── Summary ───────────────────────────────────────────────────────────────────
header('Content-Type: application/json');
echo json_encode([
    'status'    => empty($errors) ? 'success' : 'partial',
    'seeded'    => $seeded,
    'seeded_count' => count($seeded),
    'errors'    => $errors,
    'error_count' => count($errors),
    'message'   => empty($errors)
        ? 'All investigation cases seeded successfully.'
        : count($errors).' errors encountered. Check error details.'
], JSON_PRETTY_PRINT);
