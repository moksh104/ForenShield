# ForenShield
**Learn. Investigate. Defend.**

ForenShield is a cybersecurity training and investigation platform built with Flutter, Riverpod, and a stateless PHP/PostgreSQL backend. It integrates live threat intelligence from CISA, MITRE ATT&CK, NVD, and VirusTotal, providing a gamified learning experience alongside real-world forensic tools.

## Features
- **Mission Control**: Live dashboard for tracking global cyber threats.
- **Cyber Academy**: Interactive modules tracking user progression through security fundamentals.
- **Simulation Lab**: Hands-on network traffic analysis and forensic response scenarios.
- **Investigation Lab**: OSINT tools featuring URL, hash, and domain lookups via VirusTotal.
- **Leaderboard & Achievements**: PostgreSQL-backed XP engine awarding dynamic badges and ranks.

## Architecture
ForenShield uses a modern tech stack focused on scalability and performance:
- **Frontend**: Flutter, Riverpod (State Management), GoRouter (Navigation), Material 3.
- **Backend**: Stateless PHP 8, PostgreSQL, JWT Authentication.
- **Services**: Firebase Cloud Messaging (Push Notifications), Cloudinary (Image Hosting).

## Documentation
Please refer to the `/docs` directory for complete technical references:
- [API Reference](docs/api_reference.md)
- [Architecture Overview](docs/architecture.md)
- [Database Schema](docs/database_schema.md)
- [Backend Setup](docs/backend_setup.md)
- [Firebase Setup](docs/firebase_setup.md)
- [Cloudinary Setup](docs/cloudinary_setup.md)
- [Testing & QA Checklist](docs/testing_checklist.md)
- [Release Notes](docs/release_notes.md)

## Development
To run ForenShield locally:
1. Ensure the PHP backend is running (see [Backend Setup](docs/backend_setup.md)).
2. Configure `.env` in the `mobile/` directory with `API_BASE_URL`.
3. Run `flutter pub get`.
4. Run `flutter run`.

## License
Proprietary / Closed Source.
