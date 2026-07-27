# ForenShield Web Component Library — Usage Reference

Load order: `tokens.css` then `components.css`. Set `data-theme="dark"` on `<html>` or `<body>` to switch themes — everything else is automatic via CSS custom properties.

## Scope Note

This library covers the Landing Website only — Nav header, Buttons, and a curated set of showcase Cards/Badges used to demonstrate the product visually. It does not include Dialogs, Lists, or Inputs from the full component spec, because those are in-app workflow components (Mission Brief, Evidence List, in-product Search) that only make sense once someone is inside the Flutter app. If the landing site later needs a real interactive demo of those, that's a deliberate follow-up scope decision, not an oversight.

Every color, spacing, and radius value in `tokens.css` is numerically identical to `lib/core/theme/app_tokens.dart` — this is what keeps the marketing site and the app feeling like one product.

## Navigation

```html
<header class="foren-nav">
  <div class="foren-nav__title">ForenShield</div>
  <ul class="foren-nav__links">
    <li><a href="#academy">Academy</a></li>
    <li><a href="#investigation">Investigation</a></li>
    <li><a href="#pricing">Pricing</a></li>
  </ul>
  <button class="foren-btn foren-btn--primary">Start Training</button>
</header>
```

## Buttons

```html
<button class="foren-btn foren-btn--primary">Begin Investigation</button>
<button class="foren-btn foren-btn--primary foren-accent-academy">Enroll Now</button>
<button class="foren-btn foren-btn--secondary">Learn More</button>
<button class="foren-btn foren-btn--ghost">Skip</button>
<button class="foren-btn foren-btn--danger">Delete Account</button>
<button class="foren-icon-btn" aria-label="Menu">☰</button>
```

`foren-btn--primary` defaults to Mission Control cyan. Add one of `foren-accent-academy`, `foren-accent-investigation`, `foren-accent-simulation`, `foren-accent-profile` to retint for context — never combine two accent classes on one button (Rule 4: one accent per feature).

## Cards

```html
<div class="foren-card foren-card--investigation">
  <div class="foren-card__eyebrow">Investigation Lab</div>
  <div class="foren-card__title">Analyze real phishing incidents</div>
  <p class="foren-card__body">
    Work a live case file: headers, attachments, and IOCs — exactly
    like the in-app Investigation Lab.
  </p>
</div>

<div class="foren-card">
  <div class="foren-stat">
    <span class="foren-stat__label">Cases Solved (community)</span>
    <span class="foren-stat__value">42,801</span>
  </div>
</div>
```

## Badges

```html
<span class="foren-badge foren-badge--critical">CRITICAL</span>
<span class="foren-badge foren-badge--warning">MEDIUM</span>
<span class="foren-badge foren-badge--success">LOW</span>
<span class="foren-badge foren-badge--xp">+250 XP</span>
```
