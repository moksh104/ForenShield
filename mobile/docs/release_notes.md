# ForenShield Release Notes

## RC-1 (Release Candidate 1)

**Date**: 2026-08-07

This is the first Release Candidate for ForenShield. The application is functionally complete and has undergone extensive hardening and optimization to meet production standards.

### Features Included
- **Authentication**: JWT-based login, registration, and OTP flows. Device session tracking and login history logging enabled.
- **Mission Control**: Integrated CISA Live KEV feed with offline caching.
- **Cyber Academy**: Interactive learning modules with MITRE ATT&CK integration.
- **Simulation Lab**: Hands-on network traffic and forensic analysis simulations.
- **Investigation Lab**: Live URL, Hash, and Domain analysis via VirusTotal API.
- **Achievements Engine**: Dynamic badge unlocks and synchronized XP transactions.
- **Global Leaderboard**: Live, dynamically calculated leaderboard using PostgreSQL ranking algorithms.
- **Settings**: Comprehensive user preferences with persistent local caching and customizable notifications.

### Hardening & Security
- Complete removal of stack traces from API responses (`config.php`).
- Enforcement of PDO Prepared Statements across all queries.
- Strict File Upload restrictions (5MB limit, PNG/JPG MIME validation).
- Improved widget cleanup and reduced memory leaks with Riverpod `autoDispose`.

### Known Limitations
- The iOS build requires manual push notification certificates via Apple Developer Program before Firebase FCM will operate properly on iPhones.

### Next Steps
- Final User Acceptance Testing (UAT).
- Play Store & App Store deployments.
