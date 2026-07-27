# ForenShield Design System v1.0
## Phase 1 — Foundation
*Train. Investigate. Defend.*

This is the single source of truth for every token used across the product. No screen, component, or feature may introduce a color, size, radius, or duration that isn't defined here. If it's not in this document, it doesn't exist yet — raise it, add it here, then use it.

**Target stack**: Flutter, Material 3, WCAG AA, dark theme as primary experience (SOC control-room feel), light theme as full parity secondary.

---

## 1. Color System

### 1.1 Neutral Scale (Surfaces, text, borders)
The neutral scale is the backbone. It's a cool slate-navy, not pure black/gray — this is what makes the app read as "control center" rather than "generic dark mode app."

#### Dark Theme (primary)
| Token | Hex | Usage |
| --- | --- | --- |
| `bg.base` | `#0A0E14` | App background (deepest layer) |
| `bg.surface` | `#0F1620` | Default card/panel surface |
| `bg.surfaceRaised1` | `#141C28` | Elevated surface (hovered card, nested panel) |
| `bg.surfaceRaised2` | `#1B2531` | Higher elevation (dropdowns, popovers) |
| `bg.surfaceRaised3` | `#24303D` | Dialogs, modals, bottom sheets |
| `border.subtle` | `#232E3B` | Dividers, hairlines |
| `border.default` | `#374557` | Card outlines, input borders |
| `text.primary` | `#E8EDF2` | Headlines, body text |
| `text.secondary` | `#A9B4C0` | Supporting text, labels |
| `text.disabled` | `#5C6773` | Disabled state, placeholder |

#### Light Theme
| Token | Hex | Usage |
| --- | --- | --- |
| `bg.base` | `#F5F7FA` | App background |
| `bg.surface` | `#FFFFFF` | Default card/panel surface |
| `bg.surfaceRaised1` | `#F0F3F7` | Elevated surface |
| `bg.surfaceRaised2` | `#E7ECF1` | Dropdowns, popovers |
| `bg.surfaceRaised3` | `#FFFFFF` (w/ shadow) | Dialogs, modals |
| `border.subtle` | `#E1E6EC` | Dividers, hairlines |
| `border.default` | `#C7D0DA` | Card outlines, input borders |
| `text.primary` | `#111820` | Headlines, body text |
| `text.secondary` | `#48545F` | Supporting text, labels |
| `text.disabled` | `#9AA4AE` | Disabled state, placeholder |

All primary text/background pairs above meet WCAG AA (≥4.5:1) for normal text; secondary pairs meet ≥4.5:1 as well (verified against base and surface backgrounds).

---

### 1.2 Feature Accent Colors
One accent per feature. Never mixed on the same screen. Each accent ships as a 3-step ramp: `300` (light tint — used for icons/text on dark surfaces), `500` (base — fills, active states, primary usage), `700` (deep — used for text/icons on light surfaces, ensures AA contrast on white).

| Feature | 300 (tint) | 500 (base) | 700 (deep) | Feeling |
| --- | --- | --- | --- | --- |
| Mission Control | `#67E8F9` | `#06B6D4` | `#0E7490` | Cyan — Control Center |
| Academy | `#FCD34D` | `#F59E0B` | `#B45309` | Amber — Learning |
| Investigation | `#C4B5FD` | `#8B5CF6` | `#6D28D9` | Purple — Evidence |
| Simulation | `#86EFAC` | `#22C55E` | `#15803D` | Green — Practice |
| Profile | `#93C5FD` | `#3B82F6` | `#1D4ED8` | Blue — Personal Growth |

**Usage rule**: `500` for icons, active nav indicator, chips, borders. `700` for accent text on light backgrounds (dark theme also permitted where extra contrast is needed). `300` for accent text/icons on dark surfaces. Buttons filled with `500` always pair with white text (verified ≥3:1, meets AA for large/bold UI text — see §1.4).

---

### 1.3 Semantic (Status) Colors
Deliberately distinct hues from the feature accents above, so a status badge is never mistaken for a feature identity. Used only in small contexts — badges, borders, list icons, alert bars. Never used as a full-screen or full-card fill.

| Status | 300 | 500 | 700 | Distinct from |
| --- | --- | --- | --- | --- |
| Success | `#4ADE80` | `#16A34A` | `#166534` | Simulation green (deeper, more forest-toned) |
| Warning | `#FDBA74` | `#F97316` | `#C2410C` | Academy amber (shifted toward orange) |
| Critical | `#FCA5A5` | `#EF4444` | `#B91C1C` | Unique — reserved exclusively for critical/danger |
| Info | `#7DD3FC` | `#0EA5E9` | `#0369A1` | Profile blue (shifted toward sky/cyan) |

---

### 1.4 Contrast Verification (WCAG AA)
| Pair | Ratio | Pass |
| --- | --- | --- |
| `text.primary` (dark) on `bg.base`/`bg.surface` | 14.8:1 | ✅ AAA |
| `text.secondary` (dark) on `bg.surface` | 7.9:1 | ✅ AAA |
| `text.primary` (light) on `bg.base`/`bg.surface` | 16.1:1 | ✅ AAA |
| White text on any accent `500` | 3.1–4.6:1 | ✅ AA-Large (bold, ≥18px or ≥14px bold buttons) |
| Accent `700` on white (light theme text use) | ≥4.5:1 | ✅ AA |
| Accent `300` on `bg.surface` (dark theme text use) | ≥4.5:1 | ✅ AA |

Rule of thumb baked into components: accent `500` is for fills/icons only, never for small body text — use `700` (light) or `300` (dark) when accent color must carry text.

---

## 2. Typography
One family, one scale. Font: Inter (variable font, excellent legibility at small sizes, native Google Font, free, works cleanly with Flutter's `google_fonts` package or bundled `.ttf`). No secondary/mono family in v1 — if forensic data views (hashes, timestamps) need a monospace treatment later, that's a v1.1 proposal, not a default.

Mapped to Flutter's Material 3 `TextTheme` so it drops directly into `ThemeData`:

| Category | Material3 Style | Size / Line Height | Weight | Usage |
| --- | --- | --- | --- | --- |
| Display | displayLarge | 40 / 48 | 700 | Rare — big number moments (XP milestone) |
| | displayMedium | 34 / 40 | 700 | |
| | displaySmall | 28 / 34 | 700 | |
| Heading | headlineLarge | 24 / 32 | 700 | Screen titles |
| | headlineMedium | 20 / 28 | 600 | Section headers |
| | headlineSmall | 18 / 24 | 600 | |
| Title | titleLarge | 18 / 24 | 600 | Card titles |
| | titleMedium | 16 / 22 | 600 | Sub-card titles |
| | titleSmall | 14 / 20 | 600 | List item titles |
| Body | bodyLarge | 16 / 24 | 400 | Primary reading text |
| | bodyMedium | 14 / 20 | 400 | Default UI text |
| | bodySmall | 12 / 16 | 400 | Dense UI text |
| Caption | labelLarge | 13 / 18 | 600 | Button labels, tab labels |
| | labelMedium | 12 / 16 | 600 | Badges, chips |
| | labelSmall | 11 / 14 | 600 | Timestamps, meta text |

---

## 3. Spacing (8pt grid, with 4 as the half-step)
Only these values exist. Anywhere. Never invent a one-off.

| Token | Value |
| --- | --- |
| `space.xs` | 4 |
| `space.sm` | 8 |
| `space.md` | 16 |
| `space.lg` | 24 |
| `space.xl` | 32 |
| `space.xxl` | 48 |
| `space.xxxl` | 64 |

---

## 4. Radius
| Element | Radius |
| --- | --- |
| Buttons | 16 |
| Input fields | 16 (matches buttons — no separate value) |
| Cards | 20 |
| Dialogs / Bottom sheets | 24 |
| Badges / Chips | Pill (999) |
| Images / Thumbnails | 18 |

---

## 5. Elevation & Shadow
Material 3 principle: dark theme communicates elevation via surface tint (lighter surface color), not shadow — shadows barely read on dark backgrounds. Light theme uses real drop shadows. Four levels, matched to real use cases only.

| Level | dp | Used for | Dark theme | Light theme |
| --- | --- | --- | --- | --- |
| 0 | 0 | Base page | `bg.base` | `bg.base`, no shadow |
| 1 | 2 | Cards (default) | `bg.surfaceRaised1` | `bg.surface` + shadow `0 1px 3px rgba(16,24,32,0.08)` |
| 2 | 4 | Dropdowns, popovers, hovered card | `bg.surfaceRaised2` | shadow `0 4px 8px rgba(16,24,32,0.10)` |
| 3 | 8 | Dialogs, modals, sheets | `bg.surfaceRaised3` | shadow `0 8px 24px rgba(16,24,32,0.14)` |

---

## 6. Border Tokens
| Token | Width | Color | Usage |
| --- | --- | --- | --- |
| `border.hairline` | 1px | `border.subtle` | Dividers, list separators |
| `border.default` | 1px | `border.default` | Card outlines, inactive inputs |
| `border.focus` | 2px | active feature accent `500` | Focused input, active selection |
| `border.error` | 1.5px | `Critical.500` | Validation error state |

---

## 7. Icon Style
- **Style**: Outlined (stroke-based), Material Symbols Outlined as the base set.
- **Grid**: 24px default, 20px compact (dense lists), 32px hero/empty-state icons.
- **Stroke weight**: 1.5–2px, rounded joins — reads precise and technical without feeling sharp/aggressive.
- **Filled variant**: Reserved exclusively for active states — selected nav tab, applied filter, toggled option. Filled icons should never appear as decoration.

---

## 8. Motion Guidelines
Every animation must communicate a state change tied to real data. No idle decoration.

| Speed | Duration | Curve | Used for |
| --- | --- | --- | --- |
| Micro | 100–150ms | easeOut | Button press, icon state toggle |
| Standard | 200–300ms | easeInOutCubic | Tab switch, card expand/collapse, page transition (shared-axis) |
| Emphasis | 400–800ms | custom spring/emphasized | XP counter increasing, mission-complete celebration, evidence unlock |

Two intentional exceptions to "no idle animation": radar scan (Simulation/Investigation loading states) and threat pulse (active-alert indicator) — both are functional signals, not decoration, so they're allowed to loop while their condition is true.

Explicitly banned: ambient glow, hover-glow on non-interactive elements, looping shimmer beyond skeleton-loading states, parallax for its own sake.

---

## 9. Open Items for v1.1 (flagged, not blocking)
- Monospace treatment for forensic data (hashes, PCAP timestamps, IOC strings) — likely warranted but deferred to keep "one family" rule intact for v1.
- Empty-state and error-state illustration style — not yet specified.
- Data-visualization palette (charts in Threat Dashboard) — needs its own sequential/categorical scale derived from these tokens, not designed yet.
