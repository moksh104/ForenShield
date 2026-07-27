# ForenShield — Mobile Application

> **Learn. Investigate. Defend.**

A Flutter-based cybersecurity training platform delivering interactive lessons,
real-world attack simulations, and digital evidence investigations.

---

## Tech Stack

| Layer              | Technology                          |
|--------------------|-------------------------------------|
| **UI Framework**   | Flutter (Material 3)                |
| **State Management** | Riverpod 2.x (Notifier / Provider)|
| **Navigation**     | GoRouter (declarative, typed routes)|
| **Networking**     | Dio + JWT Auth Interceptor          |
| **Backend**        | PHP REST API                        |
| **Authentication** | JWT (access token + refresh token)  |
| **Database**       | PostgreSQL (managed by backend)     |
| **Media Storage**  | Cloudinary (managed by backend)     |
| **Notifications**  | Firebase Cloud Messaging (FCM)      |
| **Local Storage**  | SharedPreferences                   |

---

## Architecture

**Feature-First Modular Architecture**

```
lib/
├── core/                        # Shared infrastructure
│   ├── constants/               # App, route, and storage key constants
│   ├── network/                 # Dio API client + interceptors
│   ├── providers/               # Global Riverpod providers
│   ├── storage/                 # SharedPreferences wrapper
│   ├── theme/                   # Design tokens (colors, typography, spacing…)
│   ├── utils/                   # Logging and utilities
│   └── widgets/                 # Reusable UI components
│
├── features/                    # Product features (feature-first)
│   ├── authentication/          # JWT login / register flow
│   ├── onboarding/              # First-launch onboarding (4 screens)
│   ├── mission_control/         # Dashboard — home screen
│   ├── academy/                 # Cyber Academy — interactive lessons
│   ├── simulation/              # Simulation Lab — attack scenario player
│   ├── investigation/           # Investigation Lab — digital forensics cases
│   ├── reports/                 # Case reports and PDF export
│   ├── profile/                 # User profile, XP, rank, achievements
│   └── settings/                # App settings and preferences
│
├── developer/                   # Internal developer tooling (not shipped)
│   └── catalog/                 # Component Catalog for design system review
│
├── models/                      # Shared data models (User, AuthResponse)
├── routes/                      # GoRouter configuration and route constants
└── shared/                      # Cross-feature shared utilities
```

---

## Modules

| Module               | Description                                                |
|----------------------|------------------------------------------------------------|
| **Mission Control**  | User dashboard — XP progress, active missions, daily challenges |
| **Cyber Academy**    | Interactive cybersecurity lessons with quizzes             |
| **Simulation Lab**   | Real-world attack scenario player (phishing, social eng.)  |
| **Investigation Lab**| Digital evidence analysis — emails, logs, transactions     |
| **Reports**          | Exportable PDF case reports with evidence summaries        |
| **Gamification**     | XP system, ranks, streaks, badges, achievements            |
| **Profile**          | User profile, achievement wall, settings                   |

---

## Environment Configuration

All sensitive values are injected at build time via `--dart-define`:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.forenshield.com/api/v1
```

| Variable        | Description                       | Default (dev)                        |
|-----------------|-----------------------------------|--------------------------------------|
| `API_BASE_URL`  | PHP REST API base URL             | `http://10.0.2.2:8000/api/v1`       |

---

## Development Sprint Status

| Sprint | Name                          | Status      |
|--------|-------------------------------|-------------|
| 1      | Foundation                    | ✅ Complete |
| 2      | Design System                 | ✅ Complete |
| 3      | Application Shell             | ✅ Complete |
| 4      | Premium Splash Screen         | ✅ Complete |
| 5      | Reusable UI System            | ✅ Complete |
| 5.5    | Developer Component Catalog   | ✅ Complete |
| 6      | Project Foundation Stabilization | ✅ Complete |
| 7      | Sprint 7 — Mission Access (Onboarding) | 🔄 In Progress |

### Sprint 7 Progress

| Batch | Task                    | Status         |
|-------|-------------------------|----------------|
| 1     | Architecture & Routing  | ✅ Complete    |
| 2     | Onboarding Shell        | ✅ Complete    |
| 3     | Screen 1 — Welcome      | ✅ Complete    |
| 4     | Screen 2 — Cyber Academy | ✅ Complete   |
| 5     | Screen 3 — Investigation Lab | ⬜ Pending |
| 6     | Screen 4 — Mission Begins | ⬜ Pending  |

---

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on a connected device
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1

# Open the internal component catalog
# Navigate to /catalog in the running app
```

---

## Design System

All design tokens live in `lib/core/theme/`:

| File                | Purpose                            |
|---------------------|------------------------------------|
| `app_colors.dart`   | Brand palette (Electric Blue, Cyber Cyan, Amber) |
| `app_typography.dart` | Text styles (Geist font family)  |
| `app_spacing.dart`  | Spacing scale                      |
| `app_radius.dart`   | Border radius tokens               |
| `app_shadows.dart`  | Shadow / glow definitions          |
| `app_motion.dart`   | Animation durations and curves     |
