<?php
require_once __DIR__ . '/config.php';

try {
    $db = getDb();

    // 1. Phishing Incident
    $scenarios = [
        [
            'id' => 'phishing-incident',
            'title' => 'Executive Phishing & Credential Harvest',
            'description' => 'A spear-phishing campaign targets corporate finance with urgent invoice alerts. Analyze SMTP headers, prevent credential compromise, and execute perimeter containment.',
            'category' => 'webSec',
            'difficulty' => 'medium',
            'duration_minutes' => 12,
            'xp_reward' => 250,
            'passing_score' => 70,
            'entry_node_id' => 'phish_node_start',
            'investigation_case_id' => 'case_102',
            'objectives' => json_encode([
                ['id' => 'obj_1', 'title' => 'Verify Header Integrity', 'description' => 'Determine whether email spoofing or DMARC failure occurred.'],
                ['id' => 'obj_2', 'title' => 'Isolate Malicious Payload', 'description' => 'Analyze destination URL and prevent credential harvesting.'],
                ['id' => 'obj_3', 'title' => 'Perimeter Containment', 'description' => 'Block malicious domain and purge affected inboxes.']
            ]),
            'initial_state' => json_encode([
                'active_threat' => 'Spear-Phishing Infiltration',
                'target_department' => 'Corporate Finance',
                'alert_level' => 'Elevated'
            ]),
            'nodes' => json_encode([
                'phish_node_start' => [
                    'id' => 'phish_node_start',
                    'type' => 'incident_start',
                    'title' => 'Urgent Invoice Alert Received',
                    'narrative' => 'Assistant Controller Mark Vance received an email marked HIGH IMPORTANCE claiming Amazon Web Services cloud infrastructure payment is overdue by 72 hours. The email threatens immediate termination of all production servers unless a payment link is confirmed within 60 minutes.',
                    'context_data' => [
                        'Sender' => 'AWS Billing Support <billing-support@aws-cloud-verify.net>',
                        'Subject' => 'URGENT: AWS Production Infrastructure Deletion Notice',
                        'Recipient' => 'mvance@cyberguard.corp',
                        'Payload URL' => 'https://login.aws-cloud-verify.net/auth/portal?sess=94021',
                        'Reported By' => 'Mark Vance (via Security Slack Bot)'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_inspect_headers',
                            'label' => 'Inspect Raw SMTP Headers & Authentication Records',
                            'description' => 'Analyze RFC 5322 header trail, DKIM signature verification, and SPF alignment in sandbox.',
                            'action_type' => 'investigate',
                            'safety' => 'safe',
                            'score_delta' => 10,
                            'consequence_summary' => 'Header inspection reveals SPF fail and DMARC fail. The sending MTA IP (194.26.29.112) is an unauthenticated relay in Eastern Europe masquerading as Amazon Web Services.',
                            'state_flags_set' => ['headers_analyzed' => true],
                            'unlocks_evidence_ids' => ['ev_102_1'],
                            'next_node_id' => 'phish_node_header_analysis'
                        ],
                        [
                            'id' => 'act_open_link_browser',
                            'label' => 'Directly Open URL on Local Workstation to Verify',
                            'description' => 'Open the invoice link in an unisolated workstation browser to inspect the portal.',
                            'action_type' => 'investigate',
                            'safety' => 'critical',
                            'score_delta' => -30,
                            'consequence_summary' => 'CRITICAL SECURITY BREACH: The malicious page executes an OAuth device code skimmer and logs Mark Vance’s Active Directory session token to a remote C2!',
                            'state_flags_set' => ['workstation_compromised' => true, 'link_clicked' => true],
                            'unlocks_evidence_ids' => ['ev_102_3'],
                            'next_node_id' => 'phish_node_credential_compromise'
                        ],
                        [
                            'id' => 'act_forward_all_staff',
                            'label' => 'Forward Email to All Staff Warning Them',
                            'description' => 'Forward the raw email to the company-wide announcement list with a caution warning.',
                            'action_type' => 'escalate',
                            'safety' => 'caution',
                            'score_delta' => -15,
                            'consequence_summary' => 'Broadcasting live phishing links to 400 employees triggered accidental clicks and overwhelmed the SOC helpline with false panic.',
                            'state_flags_set' => ['mass_alerted' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'phish_node_containment'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'phish_node_header_analysis' => [
                    'id' => 'phish_node_header_analysis',
                    'type' => 'investigation',
                    'title' => 'Spoofed Header Evidence Confirmed',
                    'narrative' => 'SMTP headers confirm the email is an active spoofing attack. The domain aws-cloud-verify.net was registered 18 hours ago and resolves to a shared bulletproof VPS. You now need to analyze the payload link safely and determine impact.',
                    'context_data' => [
                        'Originating IP' => '194.26.29.112 (AS48031 - Bulletproof VPS)',
                        'SPF Status' => 'FAIL (sender IP not in Amazon SPF record)',
                        'DKIM Status' => 'FAIL (no signature matching header from)',
                        'Domain Age' => '18 hours old'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_sandbox_url',
                            'label' => 'Detonate URL in Sandboxed Browser Environment',
                            'description' => 'Render URL inside ForenShield cloud sandbox to capture DOM, JavaScript redirects, and form actions.',
                            'action_type' => 'investigate',
                            'safety' => 'safe',
                            'score_delta' => 15,
                            'consequence_summary' => 'Sandbox capture reveals an exact replica of the AWS Single Sign-On login screen submitting credentials to https://194.26.29.112/harvest.php.',
                            'state_flags_set' => ['payload_analyzed' => true],
                            'unlocks_evidence_ids' => ['ev_102_2'],
                            'next_node_id' => 'phish_node_containment'
                        ],
                        [
                            'id' => 'act_reply_to_scammer',
                            'label' => 'Reply to Scammer Demanding Identity Proof',
                            'description' => 'Send a message back to the sender address asking for an official contract number.',
                            'action_type' => 'contain',
                            'safety' => 'caution',
                            'score_delta' => -10,
                            'consequence_summary' => 'Replying to the attacker validates the corporate email address as active and triggers automated secondary spear-phishing payloads.',
                            'state_flags_set' => ['adversary_notified' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'phish_node_containment'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => ['ev_102_1'],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'phish_node_credential_compromise' => [
                    'id' => 'phish_node_credential_compromise',
                    'type' => 'consequence',
                    'title' => 'Active Session Compromise Detected',
                    'narrative' => 'Because the link was loaded on an unhardened endpoint, malicious JavaScript captured active session cookies. The endpoint security telemetry shows outbound HTTPS beacons to the attacker IP.',
                    'context_data' => [
                        'Compromised Host' => 'WS-FIN-04 (Mark Vance)',
                        'Status' => 'Active C2 Beaconing Detected',
                        'Exfiltrated Data' => 'Okta SSO Session Token',
                        'Urgency' => 'CRITICAL'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_emergency_session_revoke',
                            'label' => 'Execute Emergency Host Isolation & Revoke SSO Sessions',
                            'description' => 'Immediately sever workstation network connection and invalidate all user Okta tokens.',
                            'action_type' => 'contain',
                            'safety' => 'safe',
                            'score_delta' => 15,
                            'consequence_summary' => 'Rapid isolation prevents lateral movement into internal financial ledgers. Attacker tokens invalidated.',
                            'state_flags_set' => ['endpoint_isolated' => true, 'tokens_revoked' => true],
                            'unlocks_evidence_ids' => ['ev_102_3'],
                            'next_node_id' => 'phish_node_containment'
                        ],
                        [
                            'id' => 'act_ignore_endpoint',
                            'label' => 'Only Close Browser and Hope Antivirus Catches It',
                            'description' => 'Assume endpoint antivirus will handle any residual threats automatically.',
                            'action_type' => 'ignore',
                            'safety' => 'critical',
                            'score_delta' => -35,
                            'consequence_summary' => 'The attacker uses the active token to pivot into the AWS corporate management console!',
                            'state_flags_set' => ['lateral_compromise' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'phish_node_failed'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => ['ev_102_3'],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'phish_node_containment' => [
                    'id' => 'phish_node_containment',
                    'type' => 'containment',
                    'title' => 'Enterprise Perimeter Containment',
                    'narrative' => 'The phishing campaign parameters have been identified. You must now select the appropriate containment and remediation strategy to protect the entire organization.',
                    'context_data' => [
                        'Identified Threat Domains' => 'aws-cloud-verify.net, login.aws-cloud-verify.net',
                        'Threat Actor IP' => '194.26.29.112',
                        'Inboxes Exposed' => '17 users in Finance received identical lure'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_perimeter_block_and_purge',
                            'label' => 'Firewall Domain Block + Tenant-Wide Email Hard Purge',
                            'description' => 'Block domain and IP at edge firewalls, and execute an automated M365 hard-delete query across all tenant mailboxes.',
                            'action_type' => 'remediate',
                            'safety' => 'safe',
                            'score_delta' => 20,
                            'consequence_summary' => 'Firewalls actively drop all DNS and HTTP requests to the attacker server. All 17 malicious emails purged before any further staff could interact.',
                            'state_flags_set' => ['full_containment' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'phish_node_success'
                        ],
                        [
                            'id' => 'act_delete_single_email',
                            'label' => 'Delete Only Mark Vance’s Single Email',
                            'description' => 'Remove the email from Mark Vance’s inbox and close the ticket.',
                            'action_type' => 'remediate',
                            'safety' => 'caution',
                            'score_delta' => -20,
                            'consequence_summary' => 'Failing to purge tenant-wide left 16 other employees exposed. Another accountant clicked the link 2 hours later.',
                            'state_flags_set' => ['partial_containment' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'phish_node_partial'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'phish_node_success' => [
                    'id' => 'phish_node_success',
                    'type' => 'resolution',
                    'title' => 'Threat Completely Neutralized',
                    'narrative' => 'Exemplary incident response! By analyzing SMTP headers, detonating the phishing URL in sandbox, and executing enterprise-wide domain blocking and email purging, the campaign was neutralized without any data loss or corporate compromise.',
                    'context_data' => [
                        'Incident Status' => 'CONTAINED & RESOLVED',
                        'Data Loss' => '0 bytes',
                        'Attacker Access' => 'Completely Severed',
                        'Forensic Artifacts' => 'Preserved for Investigation Lab'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => true,
                    'is_success' => true
                ],
                'phish_node_partial' => [
                    'id' => 'phish_node_partial',
                    'type' => 'resolution',
                    'title' => 'Incomplete Containment Resolution',
                    'narrative' => 'The immediate attack was halted, but failing to execute tenant-wide remediation allowed the campaign to persist and target other staff members. Security policies require exhaustive tenant-level containment.',
                    'context_data' => [
                        'Incident Status' => 'PARTIALLY RESOLVED',
                        'Residual Risk' => 'High (Active in other inboxes)',
                        'Corrective Action' => 'Tenant-wide M365 script required'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => true,
                    'is_success' => false
                ],
                'phish_node_failed' => [
                    'id' => 'phish_node_failed',
                    'type' => 'failure',
                    'title' => 'Incident Escalated: Corporate Breach',
                    'narrative' => 'CRITICAL INCIDENT FAILURE: Due to unmitigated session hijacking and failure to isolate the endpoint, the attacker gained persistent administrative access to AWS production accounts and initiated unauthorized database snapshots.',
                    'context_data' => [
                        'Incident Status' => 'FAILED - BREACH DECLARED',
                        'Breach Level' => 'Tier 1 Enterprise Breach',
                        'Legal Escalation' => 'Mandatory regulatory reporting required'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => true,
                    'is_success' => false
                ]
            ])
        ],

        // 2. QR Payment Scam
        [
            'id' => 'qr-payment-scam',
            'title' => 'Physical QR Payment Tampering Fraud',
            'description' => 'Fraudulent payment stickers placed over retail POS terminals redirect customer funds. Inspect physical evidence, decode embedded URI schemes, and coordinate merchant gateway blacklisting.',
            'category' => 'network',
            'difficulty' => 'hard',
            'duration_minutes' => 15,
            'xp_reward' => 300,
            'passing_score' => 70,
            'entry_node_id' => 'qr_node_start',
            'investigation_case_id' => 'case_103',
            'objectives' => json_encode([
                ['id' => 'obj_1', 'title' => 'Physical & Digital Inspection', 'description' => 'Inspect tampered terminal and decode malicious QR payload safely.'],
                ['id' => 'obj_2', 'title' => 'Gateway Flow Analysis', 'description' => 'Trace fraudulent transaction routing across payment gateway logs.'],
                ['id' => 'obj_3', 'title' => 'Financial Blacklist', 'description' => 'Coordinate merchant freeze and initiate law enforcement fraud alert.']
            ]),
            'initial_state' => json_encode([
                'active_threat' => 'Physical POS Tampering / Quishing',
                'affected_venue' => 'Metro Kiosk Terminal 7B',
                'alert_level' => 'High'
            ]),
            'nodes' => json_encode([
                'qr_node_start' => [
                    'id' => 'qr_node_start',
                    'type' => 'incident_start',
                    'title' => 'Payment Diverted at Kiosk 7B',
                    'narrative' => 'A customer at Metro Kiosk 7B scanned the counter payment code to purchase transit passes. The customer’s bank deducted $85.00, but the kiosk screen indicated "Transaction Timeout - No Payment Received". The store manager observed a slightly raised sticker covering the official payment plate.',
                    'context_data' => [
                        'Location' => 'Grand Central Metro Terminal - Kiosk 7B',
                        'Victim Amount' => '$85.00 USD',
                        'Reported Plate' => 'Countertop QR Display Stand',
                        'Official Merchant VPA' => 'metro-transit-official@icici'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_inspect_physical_sticker',
                            'label' => 'Perform Forensic Inspection of Physical Sticker Overlay',
                            'description' => 'Photograph physical sticker under forensic lighting, examine adhesive wear, and interview the cashier on duty.',
                            'action_type' => 'investigate',
                            'safety' => 'safe',
                            'score_delta' => 10,
                            'consequence_summary' => 'Inspection confirms a vinyl sticker was layered over the official laser-etched plate. Cashier logs show the terminal was left unattended between 14:10 and 14:25 during a shift handover.',
                            'state_flags_set' => ['physical_tamper_verified' => true],
                            'unlocks_evidence_ids' => ['ev_103_2'],
                            'next_node_id' => 'qr_node_tamper_analysis'
                        ],
                        [
                            'id' => 'act_test_with_real_funds',
                            'label' => 'Scan QR Code with Personal Phone to Test Payment',
                            'description' => 'Send a test transfer using personal banking app to see which name appears on screen.',
                            'action_type' => 'investigate',
                            'safety' => 'critical',
                            'score_delta' => -25,
                            'consequence_summary' => 'UNSAFE PRACTICE: Personal banking credentials and funds were transferred directly to fraudulent mules, without producing forensic logs.',
                            'state_flags_set' => ['funds_drained' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'qr_node_tamper_analysis'
                        ],
                        [
                            'id' => 'act_peel_and_trash',
                            'label' => 'Immediately Peel Sticker Off and Discard It',
                            'description' => 'Rip off the fraudulent sticker and throw it in the trash can to protect shoppers.',
                            'action_type' => 'contain',
                            'safety' => 'critical',
                            'score_delta' => -20,
                            'consequence_summary' => 'CRITICAL EVIDENCE SPOILAGE: Destroying the sticker eliminated finger-mark forensics and the only copy of the scammer’s QR destination code!',
                            'state_flags_set' => ['evidence_destroyed' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'qr_node_gateway_analysis'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'qr_node_tamper_analysis' => [
                    'id' => 'qr_node_tamper_analysis',
                    'type' => 'investigation',
                    'title' => 'QR Code Payload Extraction',
                    'narrative' => 'The physical sticker was preserved. Using the ForenShield barcode analysis sandbox, the matrix was decoded to extract the underlying intent schema and transaction parameters.',
                    'context_data' => [
                        'Decoded URI' => 'upi://pay?pa=metro-transit-settlement@oksbi&pn=TransitDirect&mc=5411&tid=TX998241',
                        'Official VPA' => 'metro-transit-official@icici',
                        'Fraudulent VPA' => 'metro-transit-settlement@oksbi',
                        'Scheme' => 'Typosquatting Merchant VPA'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_query_gateway_logs',
                            'label' => 'Query Payment Switch Network Logs for Fraudulent VPA',
                            'description' => 'Cross-reference settlement logs for metro-transit-settlement@oksbi across the payment gateway API.',
                            'action_type' => 'investigate',
                            'safety' => 'safe',
                            'score_delta' => 15,
                            'consequence_summary' => 'Gateway query uncovers 42 diverted transactions over 48 hours totaling $3,570. All routed to an aggregator account with immediate ATM cash-outs in Queens.',
                            'state_flags_set' => ['gateway_logs_extracted' => true],
                            'unlocks_evidence_ids' => ['ev_103_1'],
                            'next_node_id' => 'qr_node_gateway_analysis'
                        ],
                        [
                            'id' => 'act_call_bank_generic',
                            'label' => 'Call Generic Bank Hotline Without Evidence File',
                            'description' => 'Place a call to retail bank customer support without transaction references.',
                            'action_type' => 'escalate',
                            'safety' => 'caution',
                            'score_delta' => -5,
                            'consequence_summary' => 'Without structured payment network identifiers (TID/RRN), support placed the request in standard 14-day dispute queue.',
                            'state_flags_set' => ['delayed_response' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'qr_node_gateway_analysis'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => ['ev_103_2'],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'qr_node_gateway_analysis' => [
                    'id' => 'qr_node_gateway_analysis',
                    'type' => 'containment',
                    'title' => 'Payment Gateway Interdiction',
                    'narrative' => 'Fraudulent flow confirmed. 42 victims identified. The destination aggregator wallet is still actively draining incoming merchant payments. You must execute immediate mitigation.',
                    'context_data' => [
                        'Target VPA' => 'metro-transit-settlement@oksbi',
                        'Active Inflow' => 'Approx. $400/hour',
                        'Affected Kiosks' => 'Kiosk 7B, potentially Kiosk 8A and 9C'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_gateway_freeze_and_audit',
                            'label' => 'Execute Rapid Merchant Blacklist + System-Wide Kiosk Tamper Audit',
                            'description' => 'Submit formal emergency fraud alert to payment switch network to freeze VPA, and deploy security teams to inspect all 48 transit station kiosks.',
                            'action_type' => 'contain',
                            'safety' => 'safe',
                            'score_delta' => 20,
                            'consequence_summary' => 'Switch authority immediately blacklists the VPA and places a hold on $2,100 in unsettled funds. On-site sweep discovers and removes 2 additional tampered stickers at Kiosk 8A.',
                            'state_flags_set' => ['systemic_mitigation' => true],
                            'unlocks_evidence_ids' => ['ev_103_3'],
                            'next_node_id' => 'qr_node_success'
                        ],
                        [
                            'id' => 'act_only_replace_kiosk_7b',
                            'label' => 'Only Place Out-of-Order Sign on Kiosk 7B',
                            'description' => 'Turn off terminal 7B and report the single register to store management.',
                            'action_type' => 'contain',
                            'safety' => 'caution',
                            'score_delta' => -15,
                            'consequence_summary' => 'Failing to alert the payment switch network allowed the scammers to continue siphoning payments from Kiosk 8A for the rest of the day.',
                            'state_flags_set' => ['isolated_to_single_kiosk' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'qr_node_partial'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => ['ev_103_1'],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'qr_node_success' => [
                    'id' => 'qr_node_success',
                    'type' => 'resolution',
                    'title' => 'Payment Fraud Network Dismantled',
                    'narrative' => 'Decisive investigation! By systematically analyzing physical adhesive evidence, decoding the malicious URI schema, and escalating to the payment switch network with verified TID records, you froze criminal funds and protected thousands of daily commuters.',
                    'context_data' => [
                        'Incident Status' => 'CONTAINED & RESOLVED',
                        'Funds Frozen' => '$2,100.00 Recovered',
                        'Additional Threats Found' => '2 stickers removed from Terminal 8A',
                        'Investigation Status' => 'Ready for Law Enforcement Case Handoff'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => ['ev_103_3'],
                    'is_terminal' => true,
                    'is_success' => true
                ],
                'qr_node_partial' => [
                    'id' => 'qr_node_partial',
                    'type' => 'resolution',
                    'title' => 'Incomplete Fraud Containment',
                    'narrative' => 'Kiosk 7B was secured, but because the payment network VPA was not blacklisted and sister terminals were not audited, the criminal operation continued unabated elsewhere in the transit station.',
                    'context_data' => [
                        'Incident Status' => 'PARTIALLY RESOLVED',
                        'Loss Exposure' => 'Ongoing at other terminals',
                        'Required Action' => 'Full station forensic sweep'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => true,
                    'is_success' => false
                ]
            ])
        ],

        // 3. Account Takeover
        [
            'id' => 'account-takeover',
            'title' => 'Corporate Account Takeover & MFA Fatigue',
            'description' => 'Unusual midnight authentication from a foreign IP triggers repeated push notifications on an employee smartphone. Investigate authentication logs, contain compromised credentials, and remediate identity access.',
            'category' => 'dfir',
            'difficulty' => 'intermediate',
            'duration_minutes' => 14,
            'xp_reward' => 275,
            'passing_score' => 70,
            'entry_node_id' => 'ato_node_start',
            'investigation_case_id' => 'case_101',
            'objectives' => json_encode([
                ['id' => 'obj_1', 'title' => 'Authenticate Anomaly Triage', 'description' => 'Analyze SIEM authentication events, geolocations, and client user-agents.'],
                ['id' => 'obj_2', 'title' => 'Identity Isolation', 'description' => 'Terminate active adversary sessions and enforce credential invalidation.'],
                ['id' => 'obj_3', 'title' => 'Credential Hygiene Audit', 'description' => 'Identify credential source and transition to phishing-resistant MFA.']
            ]),
            'initial_state' => json_encode([
                'active_threat' => 'MFA Bombing / Account Takeover',
                'target_account' => 'sjenkins@defense-tech.org',
                'alert_level' => 'High'
            ]),
            'nodes' => json_encode([
                'ato_node_start' => [
                    'id' => 'ato_node_start',
                    'type' => 'incident_start',
                    'title' => 'Anomalous Midnight Authentication Alert',
                    'narrative' => 'At 03:14 AM, SIEM alerts trigger for Lead Aerospace Engineer Sarah Jenkins. 38 rapid consecutive MFA push notifications were sent to her mobile device within 6 minutes, followed by a single successful authentication from an IP address in Bucharest, Romania. Sarah is based in Seattle.',
                    'context_data' => [
                        'Target User' => 'Sarah Jenkins (Senior Systems Architect)',
                        'Normal Location' => 'Seattle, WA, USA',
                        'Alert Location' => 'Bucharest, Romania (IP: 89.44.9.231)',
                        'SIEM Severity' => 'HIGH - Impossible Travel & Push Fatigue'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_triage_auth_logs',
                            'label' => 'Extract and Analyze Full Identity Provider Auth Logs',
                            'description' => 'Inspect authentication logs, device fingerprint, client user-agent, and conditional access policies.',
                            'action_type' => 'investigate',
                            'safety' => 'safe',
                            'score_delta' => 15,
                            'consequence_summary' => 'Log extraction reveals client user-agent is python-requests/2.28 using a datacenter proxy. 38 push denials preceded an approval, indicating Sarah approved the push to silence her buzzing phone.',
                            'state_flags_set' => ['auth_logs_triaged' => true],
                            'unlocks_evidence_ids' => ['ev_101_1'],
                            'next_node_id' => 'ato_node_investigation'
                        ],
                        [
                            'id' => 'act_dismiss_as_vpn',
                            'label' => 'Dismiss Alert as Likely Travel or VPN Usage',
                            'description' => 'Close alert without verifying with user or checking security token timestamps.',
                            'action_type' => 'ignore',
                            'safety' => 'critical',
                            'score_delta' => -35,
                            'consequence_summary' => 'CATASTROPHIC OMISSION: The attacker maintains persistent access to defense project repositories for 6 hours!',
                            'state_flags_set' => ['attacker_uninhibited' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'ato_node_failed'
                        ],
                        [
                            'id' => 'act_email_user_directly',
                            'label' => 'Send Verification Email to Sarah’s Account',
                            'description' => 'Email Sarah at her corporate inbox asking if she is currently traveling in Romania.',
                            'action_type' => 'escalate',
                            'safety' => 'caution',
                            'score_delta' => -10,
                            'consequence_summary' => 'Because the attacker was already inside Sarah’s mailbox, the attacker saw your email, marked it as read, and created a forward rule to evade detection!',
                            'state_flags_set' => ['attacker_warned' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'ato_node_investigation'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'ato_node_investigation' => [
                    'id' => 'ato_node_investigation',
                    'type' => 'investigation',
                    'title' => 'Compromised Session & Credential Source Audit',
                    'narrative' => 'The attacker is actively logged into the identity portal. Threat intelligence searches show Sarah’s password appeared in an infostealer malware dump from 14 days ago (RedLine Stealer). The attacker possesses valid primary credentials and bypassed SMS/Push.',
                    'context_data' => [
                        'Credential Breach Source' => 'RedLine Stealer Dump - Russian Market',
                        'Password Last Changed' => '118 days ago (Exposed password used)',
                        'Active Session Duration' => '24 minutes active',
                        'Privileges' => 'GitLab Admin, Azure DevOps Contributor'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_emergency_identity_kill',
                            'label' => 'Execute Global Token Revocation + Disable Account + Reset Password',
                            'description' => 'Invoke Graph API RevokeSignInSessions, disable Active Directory account, and trigger emergency password reset.',
                            'action_type' => 'contain',
                            'safety' => 'safe',
                            'score_delta' => 20,
                            'consequence_summary' => 'All active sessions globally severed within 4 seconds. Attacker’s open browser connections immediately terminated with HTTP 401 Unauthorized.',
                            'state_flags_set' => ['tokens_revoked' => true, 'account_secured' => true],
                            'unlocks_evidence_ids' => ['ev_101_2'],
                            'next_node_id' => 'ato_node_hardening'
                        ],
                        [
                            'id' => 'act_only_send_password_reset',
                            'label' => 'Send Standard Password Reset Link Without Invalidation',
                            'description' => 'Trigger a password reset email without terminating active refresh tokens.',
                            'action_type' => 'contain',
                            'safety' => 'critical',
                            'score_delta' => -20,
                            'consequence_summary' => 'Existing OAuth session tokens remained valid for 24 hours, allowing the attacker to clone repository source code despite the password change!',
                            'state_flags_set' => ['tokens_unrevoked' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'ato_node_hardening'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => ['ev_101_1'],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'ato_node_hardening' => [
                    'id' => 'ato_node_hardening',
                    'type' => 'containment',
                    'title' => 'Identity Hardening & Anti-Fatigue Architecture',
                    'narrative' => 'The adversary was expelled. To prevent recurrences of MFA push fatigue and infostealer credential reuse, security architecture must enforce policy upgrades across all privileged engineering accounts.',
                    'context_data' => [
                        'Previous MFA Method' => 'Standard Push Notification (Accept/Deny)',
                        'Policy Vulnerability' => 'No number-matching, no geographic lock',
                        'Required Standards' => 'FIDO2 / WebAuthn Hardware Keys'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_enforce_fido2_number_matching',
                            'label' => 'Enforce FIDO2 Hardware Keys + Context-Aware Number Matching',
                            'description' => 'Mandate hardware security keys (YubiKey) for engineering, enforce number-matching for mobile push, and block logins from high-risk VPN/datacenter ranges.',
                            'action_type' => 'remediate',
                            'safety' => 'safe',
                            'score_delta' => 20,
                            'consequence_summary' => 'Conditional access policies updated organization-wide. Push fatigue attacks rendered technically impossible via mandatory number matching.',
                            'state_flags_set' => ['policy_hardened' => true],
                            'unlocks_evidence_ids' => ['ev_101_3'],
                            'next_node_id' => 'ato_node_success'
                        ],
                        [
                            'id' => 'act_advise_user_be_careful',
                            'label' => 'Send Sarah an Email Telling Her Not to Accept Strange Pushes',
                            'description' => 'Rely solely on user awareness without technical policy enforcement.',
                            'action_type' => 'remediate',
                            'safety' => 'caution',
                            'score_delta' => -15,
                            'consequence_summary' => 'Human-only safeguards fail under sleep deprivation. The fundamental vulnerability remains exploitable.',
                            'state_flags_set' => ['no_policy_change' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'ato_node_partial'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => ['ev_101_2'],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'ato_node_success' => [
                    'id' => 'ato_node_success',
                    'type' => 'resolution',
                    'title' => 'Identity Compromise Neutralized & Architecture Hardened',
                    'narrative' => 'Outstanding response! You quickly diagnosed the MFA push fatigue assault through auth log forensics, terminated active OAuth tokens before sensitive defense schematics were accessed, and instituted FIDO2 phishing-resistant authentication.',
                    'context_data' => [
                        'Incident Status' => 'RESOLVED - ZERO INTEL EXFILTRATION',
                        'Account Status' => 'Secured with FIDO2 Hardware Key',
                        'Forensic Record' => 'Exported to Investigation Case FSC-101'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => ['ev_101_3'],
                    'is_terminal' => true,
                    'is_success' => true
                ],
                'ato_node_partial' => [
                    'id' => 'ato_node_partial',
                    'type' => 'resolution',
                    'title' => 'Remediation Incomplete: Systemic Risk Persists',
                    'narrative' => 'Sarah’s account was recovered, but failing to upgrade corporate MFA to number-matching leaves the rest of the company exposed to identical fatigue tactics.',
                    'context_data' => [
                        'Incident Status' => 'PARTIALLY RESOLVED',
                        'Organizational Risk' => 'High (Push fatigue still possible)'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => true,
                    'is_success' => false
                ],
                'ato_node_failed' => [
                    'id' => 'ato_node_failed',
                    'type' => 'failure',
                    'title' => 'Critical Failure: Defense Repository Exfiltrated',
                    'narrative' => 'CRITICAL SECURITY BREACH: Because the foreign authentication alert was dismissed, the threat actor cloned 12 proprietary engineering repositories and established a persistent webshell in production staging.',
                    'context_data' => [
                        'Incident Status' => 'FAILED - INTELLECTUAL PROPERTY COMPROMISED',
                        'Exfiltrated Assets' => '12 Git Repositories (Classified)',
                        'Action' => 'Emergency FBI Cyber Division engagement'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => true,
                    'is_success' => false
                ]
            ])
        ],

        // 4. Fake Online Store
        [
            'id' => 'fake-online-store',
            'title' => 'E-Commerce Brand Impersonation & Card Skimmer',
            'description' => 'A fraudulent online shop clones an authorized apparel brand to harvest customer payment cards. Analyze domain WHOIS, inspect malicious client-side JavaScript skimmers, and coordinate registrar takedowns.',
            'category' => 'webSec',
            'difficulty' => 'intermediate',
            'duration_minutes' => 12,
            'xp_reward' => 250,
            'passing_score' => 70,
            'entry_node_id' => 'store_node_start',
            'investigation_case_id' => 'case_104',
            'objectives' => json_encode([
                ['id' => 'obj_1', 'title' => 'Domain Infrastructure Recon', 'description' => 'Analyze WHOIS, SSL certificates, and offshore hosting infrastructure.'],
                ['id' => 'obj_2', 'title' => 'Skimmer Code Analysis', 'description' => 'Reverse engineer client-side JavaScript payment interception logic.'],
                ['id' => 'obj_3', 'title' => 'Brand & Consumer Protection', 'description' => 'Execute global registrar takedown and notify card brand fraud networks.']
            ]),
            'initial_state' => json_encode([
                'active_threat' => 'E-Commerce Phishing / Magecart Skimmer',
                'infringing_domain' => 'mega-deals-direct-store.com',
                'alert_level' => 'Elevated'
            ]),
            'nodes' => json_encode([
                'store_node_start' => [
                    'id' => 'store_node_start',
                    'type' => 'incident_start',
                    'title' => 'Brand Impersonation Report',
                    'narrative' => 'Customer service received complaints from 14 shoppers who purchased discounted jackets on "mega-deals-direct-store.com". Shoppers never received orders, and several reported fraudulent $500 charges on their credit cards 24 hours later. The store mimics our authentic corporate trademark.',
                    'context_data' => [
                        'Infringing URL' => 'https://mega-deals-direct-store.com/checkout',
                        'Legitimate Brand' => 'Apex Athletics (apex-athletics.com)',
                        'Discount Advertised' => '90% Off All Inventory',
                        'Reported By' => '14 Victim Shoppers'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_investigate_whois_dns',
                            'label' => 'Perform Forensic WHOIS, Passive DNS & Certificate Analysis',
                            'description' => 'Query domain registration dates, nameservers, ASN ownership, and SSL certificate history.',
                            'action_type' => 'investigate',
                            'safety' => 'safe',
                            'score_delta' => 15,
                            'consequence_summary' => 'Analysis confirms the domain was registered 72 hours ago via privacy proxy in Panama, hosted on bulletproof server IP 45.154.255.88 in Moldova. Free Let’s Encrypt cert issued yesterday.',
                            'state_flags_set' => ['infrastructure_mapped' => true],
                            'unlocks_evidence_ids' => ['ev_104_1'],
                            'next_node_id' => 'store_node_code_analysis'
                        ],
                        [
                            'id' => 'act_buy_item_personal_card',
                            'label' => 'Make a Real Test Purchase with Corporate Credit Card',
                            'description' => 'Place an order using a real card to see where the merchant statement routes.',
                            'action_type' => 'investigate',
                            'safety' => 'critical',
                            'score_delta' => -30,
                            'consequence_summary' => 'UNSAFE FORENSIC PRACTICE: The corporate credit card number and CVV were captured by scammers and used for unauthorized cryptocurrency purchases!',
                            'state_flags_set' => ['corp_card_stolen' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'store_node_code_analysis'
                        ],
                        [
                            'id' => 'act_post_angry_warning_comment',
                            'label' => 'Post Public Warning Comments on the Fake Store Reviews',
                            'description' => 'Write a comment on the product page telling shoppers it is a scam.',
                            'action_type' => 'escalate',
                            'safety' => 'caution',
                            'score_delta' => -10,
                            'consequence_summary' => 'The fake store uses custom PHP moderation; the site admin instantly deleted your comment and IP-blocked your workstation from viewing the site.',
                            'state_flags_set' => ['ip_blocked_by_scammer' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'store_node_code_analysis'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'store_node_code_analysis' => [
                    'id' => 'store_node_code_analysis',
                    'type' => 'investigation',
                    'title' => 'Client-Side Checkout Skimmer Extraction',
                    'narrative' => 'Using an isolated browser debugger, you inspect the checkout page source code. The credit card input fields are not connected to a legitimate Stripe or PayPal payment processor.',
                    'context_data' => [
                        'Checkout Form Action' => 'https://mega-deals-direct-store.com/api/process-card',
                        'Obfuscated Script' => 'assets/js/analytics-tracker-min.js',
                        'Script Behavior' => 'Intercepts onsubmit event, encodes PAN+CVV to Base64, and POSTs to a Telegram Bot webhook'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_deobfuscate_skimmer',
                            'label' => 'Deobfuscate Payment JavaScript & Extract Exfiltration Channels',
                            'description' => 'Reverse engineer the client script to extract the Telegram Bot API token and drop-server endpoint.',
                            'action_type' => 'investigate',
                            'safety' => 'safe',
                            'score_delta' => 15,
                            'consequence_summary' => 'Deobfuscation recovers Bot Token (bot6192...:AAFH) and Chat ID (-1001849201948). The script silently captures credit cards and displays a fake "Bank Gateway Timeout" message to victims.',
                            'state_flags_set' => ['skimmer_decoded' => true],
                            'unlocks_evidence_ids' => ['ev_104_2'],
                            'next_node_id' => 'store_node_containment'
                        ],
                        [
                            'id' => 'act_ddos_fake_store',
                            'label' => 'Launch a Counter Denial-of-Service Attack Against the Fake Store',
                            'description' => 'Flood the Moldovan server with HTTP requests to take it offline.',
                            'action_type' => 'contain',
                            'safety' => 'critical',
                            'score_delta' => -35,
                            'consequence_summary' => 'ILLEGAL ACTION: Launching unauthorized cyberattacks against external infrastructure violates cybercrime statutes and exposes the enterprise to liability.',
                            'state_flags_set' => ['unauthorized_counterstrike' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'store_node_containment'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => ['ev_104_1'],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'store_node_containment' => [
                    'id' => 'store_node_containment',
                    'type' => 'containment',
                    'title' => 'Coordinated Takedown & Consumer Protection',
                    'narrative' => 'You hold verified forensic proof of trademark infringement, fraudulent credit card skimming, and bot exfiltration. You must execute legal and technical interdiction to protect the public.',
                    'context_data' => [
                        'Target Domain' => 'mega-deals-direct-store.com',
                        'Hosting Provider' => 'Alexhost SRL (Moldova)',
                        'Registrar' => 'NameSilo LLC',
                        'Victim Evidence' => '14 complaints, verified skimmer code'
                    ],
                    'available_actions' => [
                        [
                            'id' => 'act_coordinated_registrar_takedown',
                            'label' => 'File Formal Registrar Takedown + Submit Google SafeBrowsing Blacklist + Alert Card Brands',
                            'description' => 'Submit cryptographic forensic package to registrar abuse contact, report to Google/Microsoft SafeBrowsing to display red phishing interstitial, and send IIN BIN alerts to Visa/Mastercard fraud divisions.',
                            'action_type' => 'remediate',
                            'safety' => 'safe',
                            'score_delta' => 20,
                            'consequence_summary' => 'Google SafeBrowsing immediately blocks site access for 98% of web browsers worldwide. Registrar locks domain DNS within 3 hours. Card brands flag compromised card numbers for proactive reissuance.',
                            'state_flags_set' => ['full_takedown' => true],
                            'unlocks_evidence_ids' => ['ev_104_3'],
                            'next_node_id' => 'store_node_success'
                        ],
                        [
                            'id' => 'act_only_send_cease_desist',
                            'label' => 'Only Send an Email Cease & Desist to admin@mega-deals-direct-store.com',
                            'description' => 'Email the scam operator asking them politely to cease using our logo.',
                            'action_type' => 'remediate',
                            'safety' => 'caution',
                            'score_delta' => -20,
                            'consequence_summary' => 'The scam operators ignored the email and harvested another 120 customer credit cards before the weekend.',
                            'state_flags_set' => ['ineffective_remediation' => true],
                            'unlocks_evidence_ids' => [],
                            'next_node_id' => 'store_node_partial'
                        ]
                    ],
                    'evidence_unlocked_on_enter' => ['ev_104_2'],
                    'is_terminal' => false,
                    'is_success' => false
                ],
                'store_node_success' => [
                    'id' => 'store_node_success',
                    'type' => 'resolution',
                    'title' => 'Scam Infrastructure Dismantled & Brand Defended',
                    'narrative' => 'Decisive victory! By combining infrastructure reconnaissance, JavaScript skimmer reverse engineering, and multi-agency takedown filings, you shielded thousands of consumers and protected corporate brand equity.',
                    'context_data' => [
                        'Incident Status' => 'DOMAIN SEIZED & BLACKLISTED',
                        'SafeBrowsing Status' => 'Active Interstitial Warning Deployed',
                        'Victim Cardholder Accounts' => 'Flagged for protection',
                        'Forensic Package' => 'Saved to Investigation Case FSC-104'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => ['ev_104_3'],
                    'is_terminal' => true,
                    'is_success' => true
                ],
                'store_node_partial' => [
                    'id' => 'store_node_partial',
                    'type' => 'resolution',
                    'title' => 'Partial Mitigation: Scam Still Operates',
                    'narrative' => 'Failing to leverage multi-channel registrar takedowns and browser reputation engines allowed the fraudulent site to continue duping online shoppers.',
                    'context_data' => [
                        'Incident Status' => 'PARTIALLY RESOLVED',
                        'Residual Public Threat' => 'High (Site still live)'
                    ],
                    'available_actions' => [],
                    'evidence_unlocked_on_enter' => [],
                    'is_terminal' => true,
                    'is_success' => false
                ]
            ])
        ]
    ];

    $stmt = $db->prepare("
        INSERT INTO scenarios (
            id, title, description, category, difficulty, duration_minutes,
            xp_reward, passing_score, entry_node_id, investigation_case_id,
            objectives, initial_state, nodes
        ) VALUES (
            :id, :title, :description, :category, :difficulty, :duration_minutes,
            :xp_reward, :passing_score, :entry_node_id, :investigation_case_id,
            :objectives, :initial_state, :nodes
        )
        ON CONFLICT (id) DO UPDATE SET
            title = EXCLUDED.title,
            description = EXCLUDED.description,
            category = EXCLUDED.category,
            difficulty = EXCLUDED.difficulty,
            duration_minutes = EXCLUDED.duration_minutes,
            xp_reward = EXCLUDED.xp_reward,
            passing_score = EXCLUDED.passing_score,
            entry_node_id = EXCLUDED.entry_node_id,
            investigation_case_id = EXCLUDED.investigation_case_id,
            objectives = EXCLUDED.objectives,
            initial_state = EXCLUDED.initial_state,
            nodes = EXCLUDED.nodes
    ");

    $count = 0;
    foreach ($scenarios as $s) {
        $stmt->execute($s);
        $count++;
    }

    echo json_encode([
        'success' => true,
        'message' => "Successfully seeded {$count} production branching scenarios into PostgreSQL.",
        'scenarios' => array_column($scenarios, 'id')
    ], JSON_PRETTY_PRINT);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ], JSON_PRETTY_PRINT);
}
