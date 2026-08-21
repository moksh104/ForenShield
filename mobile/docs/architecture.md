# Architecture Overview

ForenShield is built using a modern, scalable, and decoupled architecture separating the Flutter mobile client from the PHP/PostgreSQL backend services. 

## Client (Mobile) Architecture
The mobile application is built with **Flutter 3.x** and relies on **Riverpod** for robust state management and **GoRouter** for declarative navigation.

- **Presentation Layer**: Widgets and Screens using Material 3 and custom `ForenTheme` tokens for responsive UI.
- **Provider/State Layer**: Notifiers (e.g., `AutoDisposeAsyncNotifierFamily`) handle dynamic caching and state orchestration.
- **Repository/Data Layer**: Abstracts `ApiClient` (built over `Dio`) to parse JSON into strongly typed immutable Dart models.

## Backend Architecture
The backend is powered by lightweight, stateless PHP scripts acting as RESTful API endpoints, connected to a **PostgreSQL (Neon)** database.

- **Authentication**: JWT-based stateless authentication (HS256).
- **Database Access**: Direct PDO using Prepared Statements exclusively to prevent SQL injection.
- **File Storage**: Direct integration with Cloudinary for scalable image delivery, bypassing local storage constraints.
- **Live Intelligence Integration**: The backend caches MITRE ATT&CK, NVD, and VirusTotal data via proxy scripts (e.g. `api/virustotal.php`) preventing exposure of sensitive API keys to the client application.

## High-Level Data Flow
1. User interacts with Flutter Client.
2. Riverpod Notifier dispatches event to Repository.
3. Repository invokes `ApiClient` adding `Bearer` JWT automatically.
4. PHP Backend validates JWT payload, performs Database transaction using PDO, and returns JSON.
5. Client UI reactively updates via Riverpod state change.
