# ForenShield — Premium Polish Pass (UI-Only) Migration Report

**Date:** August 2, 2026
**Scope:** Screen-level polish across all 7 features. Design tokens, theme, providers, repositories, models, entities, routes, and business logic were **not** modified.

---

## Objective

Transform ForenShield from a cyberpunk-flavoured concept UI into a believable, premium cybersecurity product that reads like Linear, GitHub, Notion, Stripe, or Apple — trustworthy, intentional, and production-ready. The design-system foundation (Cobalt `#2563EB`, slate neutrals, Outfit/Inter typography) was already committed and was treated as the source of truth.

## Cross-cutting changes (all screens)

1. **Entrance-animation policy** — collapsed 5–20 per-widget `.animate().fadeIn(400ms).slideY()` stagger chains (some with delays to 750ms) into a single container-level fade/slide at 250ms. Kept one *hero* animation per screen (score ring, count-up bars, success icon spring) and hover micro-interactions (160–200ms).
2. **Surface hygiene** — removed dead `blurX:`/`blurY:`/`opacity:` args from `GlassEffect` and dead `animate:`/glow args from `GlowEffect` at ~50 call-sites. These render as plain bordered surfaces / soft shadows; the wrappers themselves were kept (no rename/architectural change).
3. **Token replacement** — inline `TextStyle(fontSize:…)` → `theme.textTheme.*`; hardcoded `BoxShadow(Colors.black…)` → `AppShadows.forBrightness(...)`; `fontFamily: 'Geist'/'monospace'` (not in the type system) → Outfit/Inter; `AppColors.logoGold/logoTeal` (aliases of primary) → `AppColors.primary`.
4. **Animated `BackgroundGrid`** (a continuously-moving grid painter, `..repeat()` 22s) removed as a background layer from **every** screen — this was the single largest "futuristic for its own sake" element.
5. **Dead config** (`enableAdvancedEffects` / `particleCount` feeding a no-op `ParticleBackground`) removed from profile, reports, simulation, investigation.
6. **Microcopy de-cyberpunked** — ALL-CAPS monospace labels ("INITIALIZING FORENSIC SANDBOX & SCANNERS…", "LAUNCH FEATURED SIMULATION LAB", "SOC FORENSIC WORKSTATION · ACTIVE", "INPUT ACTIVE", "UPLINK CONNECTION ERROR") rewritten as plain English in the app's Inter/Outfit faces.

## Scanner policy outcome (per instruction)

| Screen | Policy | Result |
| --- | --- | --- |
| Splash | Keep | No scanner present (trivially satisfied); perpetual orbit removed |
| Mission Control | Keep | No scanner present |
| Authentication | Remove | `ScannerEffect` + glow hero removed from forgot-password success → static success badge |
| Investigation Lab | Reduce | Kept as a small 72px loading accent in case list only; deep pages → clean spinners |
| Simulation Lab | Reduce | No scanner present |
| Profile | Remove | `ScannerEffect` loading → plain spinner |
| Reports | Remove | `ScannerEffect` not-found → plain empty state |
| Settings | Remove | No scanner present |

## Per-screen work

### 1. Splash
- `splash_logo.dart`: removed the **perpetual orbital rotation** (`_orbitController..repeat()`, 20s). Emblem is now static; entrance is a one-shot sequence: fade 200ms → spring scale 250ms → tagline 250ms → progress → transition. Tagline → **"Investigate. Analyze. Simulate."** (with supporting subline). Shadow tokenized.
- `loading_bar.dart`: duration 1800 → 1200ms so the whole splash lands ~1.6s.
- Routing logic in `splash_screen.dart` untouched.

### 2. Mission Control
- `mission_control_screen.dart`: ~20 sliver stagger chains → one 250ms fade/slide on the header+hero group; removed no-op `ParticleBackground` wrapper. All `notifier.*` and `context.push(...)` calls preserved.
- `dashboard_header.dart`: rebuilt from nested `GlassEffect(GlowEffect(GlassEffect()))` soup → flat bordered surfaces; dropped `GlowEffect`s, `animate:` params, monospace timestamps; kept hover micro-interactions and callbacks.
- 6 content cards: hardcoded `BoxShadow` → `AppShadows.forBrightness(low)`; kept count-up hero animations (score ring, progress bars).

### 3. Authentication
- login/register/forgot_password: per-field staggers → single card entrance; card shadow → `AppShadows.medium`; error banners tokenized (kept fade, removed `.shake()`).
- `auth_logo.dart`: removed the **perpetual 4s float** → static shield mark.
- `auth_text_field.dart` / `auth_otp_field.dart`: removed dead glass args, "INPUT ACTIVE" microcopy, and monospace labels.
- `forgot_password_success_screen.dart`: `ScannerEffect` + `GlowEffect` hero → static success badge; ALL-CAPS → normal-case copy.
- All `authStateProvider`, validator, OTP, and navigation logic preserved.

### 4. Investigation Lab
- Loading states on all 5 pages: 140–160px radar scanner + ALL-CAPS monospace → one small scanner accent (case list) / clean spinners (deep pages).
- `investigation_dashboard_header.dart`: flat surface; removed gold monospace "SOC FORENSIC WORKSTATION", GlowEffect dot, `Geist` metrics.
- `case_card.dart`: flat surface; removed GlowEffect hover; case code/status/risk labels tokenized.
- error/empty states + filter bar de-cyberpunked; removed `BackgroundGrid` + `ParticleBackground` + dead consts.
- `enableAdvancedEffects`/`particleCount` (now unused) removed. All `notifier.*`, route pushes, `_calculateRiskScore` preserved.

### 5. Simulation Lab
- Removed `BackgroundGrid`, `ParticleBackground`, dead flags.
- Hero banner: `GlassEffect(blurX:16)` → plain bordered surface; Geist/monospace/ALL-CAPS → tokens ("Launch featured simulation").
- Scenario cards: flat surfaces, no GlowEffect hover, "Start lab", "N objectives".
- `terminal_console_widget.dart`: removed GlowEffect dot + dead glass args; terminal **kept** its monospace (thematically correct).
- `scenario_debrief_screen.dart`: "Mission accomplished" + static success badge; kept the single success-icon spring; removed BackgroundGrid/ParticleBackground.
- `scenario_runner_screen.dart`: removed BackgroundGrid/ParticleBackground; normal-case title + button.
- All scenario/filter/runner/debrief logic and route pushes preserved.

### 6. Profile
- `profile_screen.dart`: `ScannerEffect` loading → spinner; removed BackgroundGrid + ParticleBackground + dead flags; collapsed the worst stagger (150–750ms); error/empty states flattened; nav tiles → flat surfaces; avatar/image-picker flow preserved.
- `analyst_banner.dart`: removed the `_BannerGridPainter` overlay + avatar `GlowEffect` + monospace badges ("ONLINE · ACTIVE OPERATIVE" → "Active"); XP bar glow removed.
- `analyst_stats_grid.dart`, `activity_timeline.dart`, `skill_badges_section.dart`: flat surfaces, no glow hovers, count-up values tokenized.
- `achievements_screen.dart` / `profile_statistics_screen.dart`: removed BackgroundGrid, glow hovers, Geist values, list staggers; section copy normal-case.
- `account_edit_screen.dart` intentionally untouched (already clean, logic-heavy).

### 7. Reports
- `reports_dashboard_header.dart`: flat surface; removed gold monospace microcopy + GlowEffect dot; trimmed the 8-metric telemetry cluster to 4 clear KPIs; `Geist` values tokenized.
- `reports_list_screen.dart`: removed BackgroundGrid + ParticleBackground + dead flags; single entrance; report cards flattened (no glow hover, tokenized labels).
- `report_detail_screen.dart`: `ScannerEffect` not-found → plain empty state; export bar glow removed; "Export report" normal-case.
- `security_heat_map_widget.dart`: plain surface; normal-case header/day labels; data cells preserved (the hero).

## Verification

- `flutter analyze --no-pub` → **No issues found!** (0 errors, 0 warnings, 0 lints)
- `flutter test` → **All tests passed!** (`widget_test.dart`, SplashScreen render)
- Scanner distribution re-checked via grep: `ScannerEffect` now exists only in Investigation Lab (case list loading accent), per the "reduce, not remove" policy.
- `BackgroundGrid` no longer used anywhere outside its own file.

## Files NOT modified (compliance)

- `lib/routes/*` (router, guards, route constants)
- All `data/`, `domain/`, `repositories/`, `models/`, `DTOs/`, `entities/`, and Riverpod providers
- `lib/core/theme/*` design tokens (already compliant)
- Effect wrapper definitions (`glass_effect.dart`, `glow_effect.dart`, `particle_background.dart`, `scanner_effect.dart`) — kept in place per instruction
- Feature `screens/*.dart` re-export barrels and legacy duplicate `widgets/` folders

## Remaining follow-up (out of scope for this pass)

- **Screenshots**: run the app (`flutter run -d windows` or a device) and capture each screen for the visual acceptance review.
- Deep-page microcopy in report detail / evidence viewer still contains some monospace data labels (e.g. timestamps, case codes) — thematically acceptable for forensic data, but can be normalized further if desired.
